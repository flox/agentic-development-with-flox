#!/usr/bin/env bash
# test-vllm-model.sh — End-to-end test of phi4_mini_instruct via Triton + vLLM
#
# Usage:
#   # From inside flox activate:
#   ./tests/test-vllm-model.sh
#
#   # Or launch the server and test in one shot:
#   ./tests/test-vllm-model.sh --start-server
#
# Prerequisites:
#   - flox activate (sets up backends, models, env vars)
#   - tritonserver running (or use --start-server)

set -euo pipefail

MODEL="${TRITON_MODEL:-phi4_mini_instruct}"
HOST="127.0.0.1"
PORT="${TRITON_HTTP_PORT:-8000}"
BASE="http://${HOST}:${PORT}"
MAX_WAIT=120  # seconds to wait for server readiness
SERVER_PID=""

cleanup() {
  if [[ -n "$SERVER_PID" ]]; then
    echo "Stopping tritonserver (pid $SERVER_PID)..."
    kill "$SERVER_PID" 2>/dev/null || true
    wait "$SERVER_PID" 2>/dev/null || true
  fi
}
trap cleanup EXIT

# ── Start server if requested ────────────────────────────────────────
if [[ "${1:-}" == "--start-server" ]]; then
  echo "Starting tritonserver with --model-control-mode=explicit --load-model=${MODEL} ..."

  tritonserver \
    --model-repository="${TRITON_MODEL_REPOSITORY}" \
    --backend-directory="${TRITON_BACKEND_DIR}" \
    --model-control-mode=explicit \
    --load-model="${MODEL}" \
    --http-port="${PORT}" \
    --grpc-port="${TRITON_GRPC_PORT:-8001}" \
    --metrics-port="${TRITON_METRICS_PORT:-8002}" \
    --log-verbose=0 &
  SERVER_PID=$!
  echo "tritonserver pid: $SERVER_PID"
fi

# ── Wait for readiness ───────────────────────────────────────────────
echo "Waiting for server at ${BASE} ..."
elapsed=0
while ! curl -sf "${BASE}/v2/health/ready" >/dev/null 2>&1; do
  if [[ $elapsed -ge $MAX_WAIT ]]; then
    echo "FAIL: server not ready after ${MAX_WAIT}s"
    exit 1
  fi
  sleep 2
  elapsed=$((elapsed + 2))
  printf "  %ds ...\r" "$elapsed"
done
echo "Server ready (${elapsed}s)."

# ── Verify model is loaded ───────────────────────────────────────────
echo ""
echo "=== Model metadata ==="
model_meta=$(curl -sf "${BASE}/v2/models/${MODEL}" || true)
if [[ -z "$model_meta" ]]; then
  echo "FAIL: model ${MODEL} not found. Available models:"
  curl -sf "${BASE}/v2/models" | python3 -m json.tool 2>/dev/null || echo "(could not list models)"
  exit 1
fi
echo "$model_meta" | python3 -m json.tool

# ── Send inference request ───────────────────────────────────────────
echo ""
echo "=== Inference test ==="

python3 - "${BASE}" "${MODEL}" <<'PYEOF'
import json, sys, urllib.request

base_url, model = sys.argv[1], sys.argv[2]

prompt = "The capital of France is"

# vLLM uses Triton's decoupled mode — use the /generate endpoint
request_body = {
    "text_input": prompt,
    "parameters": {
        "stream": False,
        "max_tokens": 32,
        "temperature": 0.0,
    },
}

url = f"{base_url}/v2/models/{model}/generate"
print(f"Prompt: {prompt!r}")
print(f"POST {url}")

req = urllib.request.Request(
    url,
    data=json.dumps(request_body).encode(),
    headers={"Content-Type": "application/json"},
)
try:
    with urllib.request.urlopen(req, timeout=60) as resp:
        result = json.loads(resp.read())
except urllib.error.HTTPError as e:
    body = e.read().decode()
    print(f"FAIL: HTTP {e.code}")
    print(body[:2000])
    sys.exit(1)
except Exception as e:
    print(f"FAIL: {e}")
    sys.exit(1)

text_output = result.get("text_output", "")

print(f"\nGenerated: {text_output}")

if not text_output or len(text_output.strip()) == 0:
    print("FAIL: empty output")
    sys.exit(1)

print("\nPASS")
PYEOF

echo ""
echo "=== Server metrics sample ==="
curl -sf "${BASE//$PORT/${TRITON_METRICS_PORT:-8002}}/metrics" \
  | grep -E "^nv_inference_(count|request_success)" \
  | head -5

echo ""
echo "Done."

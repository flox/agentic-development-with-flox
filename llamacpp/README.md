# llama.cpp Runtime

llama.cpp inference server as a Flox environment. Serves GGUF models via `llama-server` with GPU offload, continuous batching, and an OpenAI-compatible API.

- **Linux (x86_64, aarch64)**: `flox-cuda/llama-cpp`, built with CUDA (needs an NVIDIA GPU and driver)
- **macOS (Apple Silicon)**: `llama-cpp` from nixpkgs, built with Metal
- **Default model**: `unsloth/Phi-4-mini-instruct-GGUF:Q8_0` (~4.1 GB), downloaded from Hugging Face on first start

Unlike vLLM (which serves HuggingFace model directories), llama.cpp serves GGUF files: single files or split shard sets. Quantized models run out of the box with no torch dependency, and the whole runtime is one compiled binary.

## Quick start

```bash
# Activate and start the llama-server service
flox activate --start-services

# Use a different model: any GGUF repo on Hugging Face, with an optional quant
LLAMACPP_MODEL=bartowski/Qwen2.5-7B-Instruct-GGUF:Q4_K_M flox activate --start-services

# Or a GGUF file you already have
LLAMACPP_MODEL=/path/to/model.gguf flox activate --start-services
```

The first start downloads the model, so `/health` doesn't report `ok` until the download finishes and the model loads. Follow along with `flox services logs llamacpp --follow`.

### Verify it's running

```bash
# Health check (no auth required)
curl http://127.0.0.1:8080/health

# Chat completion
curl http://127.0.0.1:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [{"role": "user", "content": "Hello!"}],
    "max_tokens": 256
  }'
```

No API key is required by default. Set `LLAMACPP_API_KEY` to require a bearer token.

### Local dev vs production

| Setting | Local dev | Production |
|---------|-----------|------------|
| `LLAMACPP_HOST` | `127.0.0.1` for local-only access | `0.0.0.0` (default) |
| `LLAMACPP_API_KEY` | _(unset, no auth)_ | Set a strong token |
| `LLAMACPP_PARALLEL` | `4` (default) | Tune to expected concurrency |
| `LLAMACPP_CTX_SIZE` | `0` (model default) | Set explicitly for memory planning |
| `LLAMACPP_WEBUI` | `true` for interactive testing | `false` (default) in production |
| `LLAMACPP_METRICS` | `true` (default) | `true` (default) for observability |
| `LLAMACPP_N_GPU_LAYERS` | `99` (offload everything) | Same, or tune for partial offload |

Production example:

```bash
LLAMACPP_API_KEY=sk-prod-secret-token \
LLAMACPP_PARALLEL=16 \
LLAMACPP_CTX_SIZE=8192 \
LLAMACPP_WEBUI=false \
  flox activate --start-services
```

## How it works

The `llamacpp` service runs `llamacpp-serve`, a script the activation hook writes to `$FLOX_ENV_CACHE/bin`. It turns the `LLAMACPP_*` variables into a `llama-server` command line and `exec`s it:

- `LLAMACPP_MODEL` set to `org/repo[:quant]` becomes `-hf org/repo[:quant]`. llama-server downloads the file itself into `$LLAMA_CACHE` and reuses it on later starts.
- `LLAMACPP_MODEL` ending in `.gguf` becomes `-m <file>`. A relative name is also looked up in `$LLAMACPP_MODELS_DIR`.

`llamacpp-serve` prints the command it runs, so the first lines of `flox services logs llamacpp` show exactly what was started. You can also run it yourself in an activated shell; arguments you give it go to `llama-server`:

```bash
flox services stop llamacpp
llamacpp-serve --verbose
```

### Hugging Face tokens

Public, non-gated repos (most GGUF repos, including the default) download without a token. For gated models, log in once with `hf auth login`, or set `HF_TOKEN`; llama-server reads it from the environment.

## API reference

llama-server exposes an OpenAI-compatible API. When `LLAMACPP_API_KEY` is set, authenticated endpoints require the `Authorization: Bearer <key>` header.

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/health` | `GET` | Health check. Returns `200 OK` when ready |
| `/v1/chat/completions` | `POST` | Chat completions (streaming supported) |
| `/v1/completions` | `POST` | Text completions (streaming supported) |
| `/v1/models` | `GET` | List loaded models |
| `/v1/embeddings` | `POST` | Embeddings (when `LLAMACPP_EMBEDDING=true`) |
| `/metrics` | `GET` | Prometheus metrics (when `LLAMACPP_METRICS=true`) |
| `/slots` | `GET` | Slot status (for debugging batch scheduling) |

### Chat completion

```bash
curl http://127.0.0.1:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {"role": "system", "content": "You are a helpful assistant."},
      {"role": "user", "content": "Explain TCP in one paragraph."}
    ],
    "max_tokens": 256,
    "temperature": 0.7
  }'
```

### Streaming

```bash
curl --no-buffer http://127.0.0.1:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [{"role": "user", "content": "Write a haiku about CUDA."}],
    "max_tokens": 64,
    "stream": true
  }'
```

### Text completion

```bash
curl http://127.0.0.1:8080/v1/completions \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "The capital of France is",
    "max_tokens": 32
  }'
```

### Embeddings

Requires `LLAMACPP_EMBEDDING=true` in the activation:

```bash
curl http://127.0.0.1:8080/v1/embeddings \
  -H "Content-Type: application/json" \
  -d '{"input": "The quick brown fox"}'
```

## Configuration reference

All settings are runtime environment variables set in the on-activate hook with `${VAR:-default}` fallbacks. Override any of them at activation time:

```bash
LLAMACPP_CTX_SIZE=8192 LLAMACPP_PARALLEL=8 flox activate --start-services
```

Variables left empty add no flag, so llama-server uses its own default.

### Model settings

| Variable | Default | Description |
|----------|---------|-------------|
| `LLAMACPP_MODEL` | `unsloth/Phi-4-mini-instruct-GGUF:Q8_0` | Hugging Face GGUF repo as `org/repo[:quant]` (`-hf`), or a path to a `.gguf` file (`-m`) |
| `LLAMACPP_MODELS_DIR` | `$FLOX_ENV_PROJECT/models` | Where relative `.gguf` names are looked up. Created on activation |
| `LLAMA_CACHE` | `$LLAMACPP_MODELS_DIR` | Where llama-server keeps Hugging Face downloads |

### Server settings

| Variable | Default | CLI flag | Description |
|----------|---------|----------|-------------|
| `LLAMACPP_HOST` | `0.0.0.0` | `--host` | Bind address. Use `127.0.0.1` for local-only access |
| `LLAMACPP_PORT` | `8080` | `--port` | Listen port |

### Engine tuning

| Variable | Default | CLI flag | Description |
|----------|---------|----------|-------------|
| `LLAMACPP_N_GPU_LAYERS` | `99` | `-ngl` | Layers to offload to the GPU. `99` offloads everything; `0` for CPU only |
| `LLAMACPP_CTX_SIZE` | `0` | `-c` | Context window in tokens. `0` uses the model's default |
| `LLAMACPP_PARALLEL` | `4` | `-np` | Parallel inference slots (concurrent requests). `-1` for auto |
| `LLAMACPP_BATCH_SIZE` | _(unset)_ | `-b` | Logical batch size for prompt processing |
| `LLAMACPP_UBATCH_SIZE` | _(unset)_ | `-ub` | Physical batch size (micro-batch) |
| `LLAMACPP_FLASH_ATTN` | `true` | `-fa on` / `-fa off` | Flash attention |
| `LLAMACPP_CONT_BATCHING` | `true` | `--cont-batching` / `--no-cont-batching` | Continuous batching |
| `LLAMACPP_THREADS` | _(unset)_ | `-t` | CPU threads. llama-server auto-detects when unset |
| `LLAMACPP_TIMEOUT` | _(unset)_ | `-to` | Server timeout in seconds |

On/off variables accept `true`/`false`, `1`/`0`, `yes`/`no`, and `on`/`off`.

### KV cache

| Variable | Default | CLI flag | Description |
|----------|---------|----------|-------------|
| `LLAMACPP_CACHE_TYPE_K` | _(unset)_ | `-ctk` | KV cache key type (e.g. `f16`, `q8_0`, `q4_0`) |
| `LLAMACPP_CACHE_TYPE_V` | _(unset)_ | `-ctv` | KV cache value type |

### Multi-GPU

| Variable | Default | CLI flag | Description |
|----------|---------|----------|-------------|
| `LLAMACPP_SPLIT_MODE` | _(unset)_ | `-sm` | `none`, `layer` (split layers across GPUs), or `row` (tensor parallelism) |
| `LLAMACPP_TENSOR_SPLIT` | _(unset)_ | `-ts` | Proportions per GPU, e.g. `3,7` for 30%/70% |
| `LLAMACPP_MAIN_GPU` | _(unset)_ | `-mg` | Index of the main GPU |

### Serving

| Variable | Default | CLI flag | Description |
|----------|---------|----------|-------------|
| `LLAMACPP_ALIAS` | _(unset)_ | `-a` | Model name in API responses |
| `LLAMACPP_API_KEY` | _(unset)_ | _(env var)_ | Bearer token. Passed as `LLAMA_API_KEY`, never on the command line |
| `LLAMACPP_API_KEY_FILE` | _(unset)_ | `--api-key-file` | File of API keys |
| `LLAMACPP_METRICS` | `true` | `--metrics` | Prometheus metrics at `/metrics` |
| `LLAMACPP_JINJA` | `true` | `--jinja` / `--no-jinja` | Jinja chat template rendering |
| `LLAMACPP_CHAT_TEMPLATE` | _(unset)_ | `--chat-template` | Override the model's chat template |
| `LLAMACPP_EMBEDDING` | _(unset)_ | `--embedding` | Enable `/v1/embeddings` |
| `LLAMACPP_WEBUI` | `false` | `--webui` / `--no-webui` | Built-in web UI |
| `LLAMACPP_REASONING_FORMAT` | _(unset)_ | `--reasoning-format` | Reasoning format for chain-of-thought models |
| `LLAMACPP_EXTRA_ARGS` | _(unset)_ | _(as given)_ | More llama-server arguments, split on whitespace |

## Multi-GPU

```bash
# Split layers across 2 GPUs (default layer split)
LLAMACPP_SPLIT_MODE=layer flox activate --start-services

# Row split (tensor parallelism) across 2 GPUs
LLAMACPP_SPLIT_MODE=row flox activate --start-services

# Uneven split: give 30% to GPU 0, 70% to GPU 1
LLAMACPP_TENSOR_SPLIT=3,7 flox activate --start-services

# Use GPU 1 as the main GPU
LLAMACPP_MAIN_GPU=1 flox activate --start-services
```

## Swapping models

```bash
# Override at activation time
LLAMACPP_MODEL=Qwen/Qwen2.5-7B-Instruct-GGUF:Q4_K_M flox activate --start-services

# Or change the default in manifest.toml, then restart
flox services restart llamacpp
```

Most GGUF repos on Hugging Face hold several quantizations of one model, in a repo named `<org>/<ModelName>-GGUF`. The part after `:` picks one (`Q4_K_M`, `Q8_0`, ...); without it, llama-server picks `Q4_K_M`, or the repo's first file if there's no `Q4_K_M`.

## Service management

```bash
flox services status              # check service state
flox services logs llamacpp       # service logs
flox services logs llamacpp -f    # follow logs
flox services restart llamacpp    # restart the llama-server service
flox services stop                # stop all services
flox activate --start-services    # activate and start in one step
```

## Kubernetes deployment

> **Note:** the manifests in `k8s/` deploy the FloxHub environment `flox/llamacpp-runtime`, the earlier version of this environment, which serves through the `llamacpp-preflight`, `llamacpp-resolve-model`, and `llamacpp-serve` scripts of the `flox/llamacpp-flox-runtime` package and pins them in its lockfile. They don't deploy this directory, and the variables they set (`LLAMACPP_MODEL_ORG`, `LLAMACPP_MODEL_ID`, ...) belong to that version.

Deploy llama.cpp to Kubernetes using the Flox "Imageless Kubernetes" (uncontained) pattern. The Flox containerd shim pulls the environment from FloxHub at pod startup, replacing the need for a container image.

### Prerequisites

- A Kubernetes cluster with the [Flox containerd shim](https://flox.dev/docs/tutorials/kubernetes/) installed on GPU nodes
- NVIDIA GPU operator or device plugin configured
- A StorageClass that supports `ReadWriteOnce` PVCs

### Deploy

```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/pvc.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

### What the manifests do

| File | Purpose |
|------|---------|
| `k8s/namespace.yaml` | Creates the `llamacpp` namespace |
| `k8s/pvc.yaml` | 30 Gi `ReadWriteOnce` volume for GGUF model storage at `/models` |
| `k8s/deployment.yaml` | Single-replica pod with Flox shim, GPU resources, health probes |
| `k8s/service.yaml` | ClusterIP service on port 8080 |

The deployment uses `runtimeClassName: flox` and `image: flox/empty:1.0.0` — the Flox shim intercepts pod creation, pulls `flox/llamacpp-runtime` from FloxHub, activates the environment, then runs the entrypoint (`llamacpp-preflight && llamacpp-resolve-model && llamacpp-serve`).

### Storage

GGUF model files are stored on the PVC mounted at `/models`. The pod sets `LLAMACPP_MODELS_DIR=/models` to override the local default (`$FLOX_ENV_PROJECT/models`). The default Phi-4-mini-instruct-Q8_0 model (~3.9 GB) is downloaded from GitHub Releases on first startup; subsequent restarts use the cached copy.

Set the `storageClassName` in `k8s/pvc.yaml` to match your cluster:

```yaml
storageClassName: gp3  # AWS EBS
storageClassName: standard-rwo  # GKE
storageClassName: managed-premium  # AKS
```

### Secrets

llama-server requires no API key by default. To enable authentication, create a Kubernetes Secret and uncomment the `secretKeyRef` blocks in the deployment:

```bash
kubectl -n llamacpp create secret generic llamacpp-secrets \
  --from-literal=api-key='your-production-api-key' \
  --from-literal=hf-token='hf_...'
```

### Customizing the model

Override the model via pod environment variables:

```yaml
env:
  - name: LLAMACPP_MODEL
    value: "DeepSeek-R1-Distill-Qwen-7B-Q4_K_M"
  - name: LLAMACPP_MODEL_ORG
    value: "bartowski"
  - name: LLAMACPP_MODEL_ID
    value: "bartowski/DeepSeek-R1-Distill-Qwen-7B-GGUF"
  - name: LLAMACPP_QUANT
    value: "Q4_K_M"
```

For multi-GPU inference, set `LLAMACPP_SPLIT_MODE` and request additional GPUs:

```yaml
env:
  - name: LLAMACPP_SPLIT_MODE
    value: "layer"
  - name: LLAMACPP_TENSOR_SPLIT
    value: "1,1"
resources:
  limits:
    nvidia.com/gpu: 2
```

### Startup timing

The `startupProbe` allows 5 minutes (30 failures x 10s) for warm starts with a cached model on the PVC. For cold starts (first-time model download), increase the threshold:

```yaml
startupProbe:
  failureThreshold: 60  # 10 minutes for cold start
```

Liveness and readiness probes are gated behind the startup probe and will not kill slow-starting pods.

### Verifying the deployment

```bash
# Watch pod startup
kubectl -n llamacpp get pods -w

# Check logs
kubectl -n llamacpp logs -f deployment/llamacpp

# Health check (from within the cluster)
kubectl -n llamacpp run curl --rm -it --image=curlimages/curl -- \
  curl http://llamacpp:8080/health

# Port-forward for local access
kubectl -n llamacpp port-forward svc/llamacpp 8080:8080
curl http://localhost:8080/health
```

### Exposing externally

The service defaults to `ClusterIP`. For external access, change the type or add an Ingress:

```bash
# Quick LoadBalancer
kubectl -n llamacpp patch svc llamacpp -p '{"spec":{"type":"LoadBalancer"}}'

# Or use port-forward for development
kubectl -n llamacpp port-forward svc/llamacpp 8080:8080
```

## Troubleshooting

### `libcuda.so.1: cannot open shared object file`

The Linux build uses CUDA and needs an NVIDIA GPU with its driver installed. Check with `nvidia-smi`.

### Gated model 401

The repo needs a Hugging Face token: run `hf auth login`, or set `HF_TOKEN`, then restart the service.

### Out of memory (OOM)

The model and its context don't fit in GPU memory. Use a smaller quantization (`:Q4_K_M` or `:Q3_K_M`), lower `LLAMACPP_CTX_SIZE`, lower `LLAMACPP_PARALLEL` (each slot reserves context), or offload fewer layers with `LLAMACPP_N_GPU_LAYERS`.

### Port already in use

Another process holds `LLAMACPP_PORT`. Find it with `lsof -i :8080`, or pick another port: `LLAMACPP_PORT=8090 flox activate --start-services`.

### Inspecting the generated command

The service log starts with the full `llama-server` command line:

```bash
flox services logs llamacpp | head
```

### Passing extra llama-server flags

```bash
LLAMACPP_EXTRA_ARGS="--seed 42 --temp 0.2" flox activate --start-services
```

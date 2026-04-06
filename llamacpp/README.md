# llama.cpp Runtime

Production llama.cpp inference server as a Flox environment. Serves GGUF models via `llama-server` with GPU offload, continuous batching, and an OpenAI-compatible API.

- **llama.cpp**: latest (via `flox-cuda/llama-cpp`)
- **CUDA**: 12.9 (requires NVIDIA driver 575+)
- **Default model**: `bartowski/Meta-Llama-3.1-8B-Instruct-GGUF` (Q4_K_M, ~4.9 GB)

Unlike vLLM (which serves HuggingFace model directories), llama.cpp serves GGUF files — single files or split shard sets. This means quantized models run out of the box with no torch dependency, and the entire runtime is a single compiled binary.

## Quick start

```bash
# Activate and start the llama-server service
flox activate --start-services

# Override the model at activation time
LLAMACPP_MODEL=DeepSeek-R1-Distill-Qwen-7B-Q4_K_M \
LLAMACPP_MODEL_ORG=bartowski \
LLAMACPP_MODEL_ID=bartowski/DeepSeek-R1-Distill-Qwen-7B-GGUF \
LLAMACPP_QUANT=Q4_K_M \
  flox activate --start-services
```

### Verify it's running

```bash
# Health check (no auth required)
curl http://127.0.0.1:8080/health

# Chat completion
curl http://127.0.0.1:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "Meta-Llama-3.1-8B-Instruct-Q4_K_M",
    "messages": [{"role": "user", "content": "Hello!"}],
    "max_tokens": 256
  }'
```

No API key is required by default. Set `LLAMACPP_API_KEY` to enable bearer token auth.

### Local dev vs production

This environment works for both local development and production serving. Key differences:

| Setting | Local dev | Production |
|---------|-----------|------------|
| `LLAMACPP_HOST` | `127.0.0.1` for local-only access | `0.0.0.0` (default) |
| `LLAMACPP_API_KEY` | _(unset, no auth)_ | Set a strong token |
| `LLAMACPP_PARALLEL` | `4` (default) | Tune to expected concurrency |
| `LLAMACPP_CTX_SIZE` | `0` (model default) | Set explicitly for memory planning |
| `LLAMACPP_WEBUI` | `true` for interactive testing | `false` (default) in production |
| `LLAMACPP_METRICS` | `true` (default) | `true` (default) for observability |
| `LLAMACPP_N_GPU_LAYERS` | `99` (offload everything) | Same, or tune for partial offload |
| Model integrity | Optional | `LLAMACPP_EXPECTED_SHA256` or manifest |

Production example:

```bash
LLAMACPP_API_KEY=sk-prod-secret-token \
LLAMACPP_PARALLEL=16 \
LLAMACPP_CTX_SIZE=8192 \
LLAMACPP_WEBUI=false \
LLAMACPP_EXPECTED_SHA256=7b064f584... \
  flox activate --start-services
```

## Architecture

The service command chains three scripts in a pipeline:

```
llamacpp-preflight && llamacpp-resolve-model && llamacpp-serve
```

```
┌──────────────────────────────────────────────────────────┐
│  Consuming Environment (.flox/env/manifest.toml)         │
│                                                          │
│  [install]                                               │
│    flox-cuda/llama-cpp            # llama-server binary  │
│    flox/llamacpp-flox-runtime     # 3-script pipeline    │
│    python312Packages.huggingface-hub  # HF downloads     │
│                                                          │
│  [services]                                              │
│    llamacpp → llamacpp-preflight                         │
│              && llamacpp-resolve-model                   │
│              && llamacpp-serve                           │
│                                                          │
│  ┌────────────────────────────────────────────────────┐  │
│  │  llamacpp-preflight                                │  │
│  │    Port reclaim ← /proc/net/tcp + /proc/<pid>/     │  │
│  │    GPU health   ← CUDA driver / NVML / nvidia-smi   │  │
│  ├────────────────────────────────────────────────────┤  │
│  │  llamacpp-resolve-model                            │  │
│  │    Sources: local → hf-cache → r2 → hf-hub        │  │
│  │    GGUF validation: magic bytes + header parse     │  │
│  │    Integrity: sha256 checksums + manifests         │  │
│  │    Output: per-model .env file (mode 600)          │  │
│  ├────────────────────────────────────────────────────┤  │
│  │  llamacpp-serve                                    │  │
│  │    Loads .env → validate → lock → exec llama-server│  │
│  └────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────┘
```

1. **llamacpp-preflight** — Reclaims the port if occupied by a stale llama-server process, checks GPU health via a 3-tier cascade (CUDA driver → NVML → nvidia-smi), optionally executes a downstream command.
2. **llamacpp-resolve-model** — Provisions the GGUF model from configured sources with locking, staging, atomic swaps, and sha256 integrity verification. Writes a per-model env file.
3. **llamacpp-serve** — Loads the env file (safe or trusted mode), validates all required vars, acquires a singleton lock, builds the `llama-server` argv from env vars (with secret redaction), and `exec`s. Supports TCP and unix socket modes.

Scripts are provided by the `flox/llamacpp-flox-runtime` package and available on `PATH` after activation.

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
    "model": "Meta-Llama-3.1-8B-Instruct-Q4_K_M",
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
    "model": "Meta-Llama-3.1-8B-Instruct-Q4_K_M",
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
    "model": "Meta-Llama-3.1-8B-Instruct-Q4_K_M",
    "prompt": "The capital of France is",
    "max_tokens": 32
  }'
```

### Embeddings

Requires `LLAMACPP_EMBEDDING=true` in the activation:

```bash
curl http://127.0.0.1:8080/v1/embeddings \
  -H "Content-Type: application/json" \
  -d '{
    "model": "Meta-Llama-3.1-8B-Instruct-Q4_K_M",
    "input": "The quick brown fox"
  }'
```

## Configuration reference

All settings are runtime environment variables set in the on-activate hook with `${VAR:-default}` fallbacks. Override any var at activation time:

```bash
LLAMACPP_CTX_SIZE=8192 LLAMACPP_PARALLEL=8 flox activate --start-services
```

### Model settings

| Variable | Default | Description |
|----------|---------|-------------|
| `LLAMACPP_MODEL` | `Meta-Llama-3.1-8B-Instruct-Q4_K_M` | Model name/slug. Used as the local directory name. Must match `^[A-Za-z0-9._-]+(\.gguf)?$` (override with `LLAMACPP_ALLOW_UNSAFE_NAME=1`) |
| `LLAMACPP_MODEL_ORG` | `bartowski` | HuggingFace org. Used to derive model ID as `$LLAMACPP_MODEL_ORG/$LLAMACPP_MODEL` |
| `LLAMACPP_MODEL_ID` | `bartowski/Meta-Llama-3.1-8B-Instruct-GGUF` | Explicit HF repo ID (`org/repo`). Note: GGUF repos on HF typically have `-GGUF` suffix and contain multiple quant variants |
| `LLAMACPP_MODEL_FILE` | `Meta-Llama-3.1-8B-Instruct-Q4_K_M.gguf` | Explicit GGUF filename inside the repo/directory. When overridden to empty, auto-detected via quant hint or single-file heuristic |
| `LLAMACPP_QUANT` | `Q4_K_M` | Quant hint for auto-selecting a GGUF when multiple exist (case-insensitive substring match) |
| `LLAMACPP_MODEL_SOURCES` | `local,hf-cache,hf-hub` | Comma-separated source order. Available: `local`, `hf-cache`, `r2`, `hf-hub` |
| `LLAMACPP_MODELS_DIR` | `$FLOX_ENV_PROJECT/models` | Root directory for model storage. Created automatically on activation |

### Server settings

| Variable | Default | Description |
|----------|---------|-------------|
| `LLAMACPP_HOST` | `0.0.0.0` | Server bind address, or unix socket path ending in `.sock`. Use `127.0.0.1` for local-only TCP access |
| `LLAMACPP_PORT` | `8080` | Server listen port (TCP mode). Ports < 1024 rejected. Optional in unix socket mode |

### Engine tuning

| Variable | Default | CLI flag | Description |
|----------|---------|----------|-------------|
| `LLAMACPP_N_GPU_LAYERS` | `99` | `-ngl` | Number of layers to offload to GPU. `99` offloads everything (capped at model layer count). `0` for CPU-only |
| `LLAMACPP_CTX_SIZE` | `0` | `-c` | Context window size in tokens. `0` uses the model's default. Non-negative integer |
| `LLAMACPP_PARALLEL` | `4` | `-np` | Number of parallel inference slots (concurrent requests). `-1` for auto, or any positive integer |
| `LLAMACPP_BATCH_SIZE` | _(unset)_ | `-b` | Logical batch size for prompt processing. When unset, llama-server uses its default |
| `LLAMACPP_UBATCH_SIZE` | _(unset)_ | `-ub` | Physical batch size (micro-batch). Controls GPU memory during prompt eval |
| `LLAMACPP_FLASH_ATTN` | `true` | `-fa` | Flash attention. Accepts `true`/`false`/`1`/`0`/`yes`/`no`. Maps to `-fa on` or `-fa off` |
| `LLAMACPP_CONT_BATCHING` | `true` | `--cont-batching` / `--no-cont-batching` | Continuous batching (serve multiple requests simultaneously) |
| `LLAMACPP_THREADS` | _(unset)_ | `-t` | CPU thread count. When unset, llama-server auto-detects |
| `LLAMACPP_TIMEOUT` | _(unset)_ | `-to` | Server timeout in seconds |

### KV cache

| Variable | Default | CLI flag | Description |
|----------|---------|----------|-------------|
| `LLAMACPP_CACHE_TYPE_K` | _(unset)_ | `-ctk` | KV cache key type (e.g., `f16`, `q8_0`, `q4_0`). Lower precision reduces memory at potential quality cost |
| `LLAMACPP_CACHE_TYPE_V` | _(unset)_ | `-ctv` | KV cache value type (e.g., `f16`, `q8_0`, `q4_0`) |

### Multi-GPU

| Variable | Default | CLI flag | Description |
|----------|---------|----------|-------------|
| `LLAMACPP_SPLIT_MODE` | _(unset)_ | `-sm` | Split mode: `none` (single GPU), `layer` (split layers across GPUs), `row` (split rows — tensor parallelism) |
| `LLAMACPP_TENSOR_SPLIT` | _(unset)_ | `-ts` | Comma-separated proportions for splitting across GPUs (e.g., `3,7` for 30%/70%) |
| `LLAMACPP_MAIN_GPU` | _(unset)_ | `-mg` | Index of the main GPU (used for scratch buffers in split mode) |

### Serving

| Variable | Default | CLI flag | Description |
|----------|---------|----------|-------------|
| `LLAMACPP_ALIAS` | _(unset)_ | `-a` | Model alias in API responses. When unset, llama-server uses the filename |
| `LLAMACPP_API_KEY` | _(unset)_ | _(env var)_ | Bearer token for API authentication. Exported as `LLAMA_API_KEY` (not on argv). When unset, no auth is required |
| `LLAMACPP_API_KEY_FILE` | _(unset)_ | `--api-key-file` | Path to API key file. Mutually exclusive with `LLAMACPP_API_KEY` |
| `LLAMACPP_METRICS` | `true` | `--metrics` | Enable Prometheus metrics endpoint at `/metrics` |
| `LLAMACPP_JINJA` | `true` | `--jinja` / `--no-jinja` | Jinja2 chat template rendering |
| `LLAMACPP_CHAT_TEMPLATE` | _(unset)_ | `--chat-template` | Override the model's built-in chat template |
| `LLAMACPP_EMBEDDING` | _(unset)_ | `--embedding` | Enable the `/v1/embeddings` endpoint |
| `LLAMACPP_WEBUI` | `false` | `--webui` / `--no-webui` | Built-in web UI |
| `LLAMACPP_REASONING_FORMAT` | _(unset)_ | `--reasoning-format` | Reasoning format for chain-of-thought models (e.g., DeepSeek-R1) |

## Model provisioning (`llamacpp-resolve-model`)

Searches configured sources in order, validates the GGUF file(s), and writes an env file that `llamacpp-serve` loads. The first source that produces a valid GGUF wins.

### Source table

Sources are tried in the order specified by `LLAMACPP_MODEL_SOURCES`. The script's internal default is `local,hf-cache,r2,hf-hub`; the manifest overrides this to `local,hf-cache,hf-hub`.

| Source | What it checks | Skip condition | Resolution |
|--------|---------------|----------------|------------|
| `local` | Direct file `$LLAMACPP_MODELS_DIR/$MODEL.gguf` or directory `$LLAMACPP_MODELS_DIR/$MODEL/` | Missing or fails GGUF validation | Sets `_LLAMACPP_RESOLVED_MODEL_PATH` to the GGUF file path |
| `hf-cache` | HF hub cache at `$HF_HOME/hub/models--<slug>/snapshots/` | No usable snapshot found | Sets path to the cached GGUF |
| `r2` | Downloads from `s3://$R2_BUCKET/$R2_MODELS_PREFIX/$MODEL/` | `aws` CLI missing, R2 vars not set | Stages to temp dir, validates GGUF, atomic-swaps into `$LLAMACPP_MODELS_DIR/$MODEL/` |
| `hf-hub` | Downloads from HuggingFace Hub | No org/repo in model ID, no download tool | Stages to temp dir, validates GGUF, atomic-swaps into `$LLAMACPP_MODELS_DIR/$MODEL/` |

### GGUF file selection

When the source provides a directory containing multiple `.gguf` files, the script selects one using this cascade:

1. **Explicit file** (`LLAMACPP_MODEL_FILE`): Use this exact filename. Fail if missing or invalid.
2. **Quant hint** (`LLAMACPP_QUANT`): Case-insensitive substring match against filenames. Must match exactly one file. Fail if ambiguous.
3. **Single-file auto**: If only one non-split GGUF exists, use it.
4. **Disambiguation error**: Multiple files found — print candidates and ask user to set `LLAMACPP_MODEL_FILE` or `LLAMACPP_QUANT`.

Split GGUF sets (`*-00001-of-NNNNN.gguf`) are recognized automatically. When the selected file is a split-first shard, all N shards must be present.

### GGUF validation

Every candidate GGUF file is validated:

- **Basic** (always): file exists, is readable, is non-empty, and starts with magic bytes `47 47 55 46` (`GGUF`).
- **Strict** (when python3 available, `LLAMACPP_STRICT_GGUF_VALIDATE=1`): Parses the GGUF header — validates version (1-100), tensor count, KV count, and walks the KV pairs to verify the header is structurally sound. Detects truncated downloads.

### Integrity verification

Optional sha256 checksums prevent serving corrupted or tampered files.

| Variable | Description |
|----------|-------------|
| `LLAMACPP_EXPECTED_SHA256` | Expected sha256 for a single (non-split) GGUF. Fails if mismatch |
| `LLAMACPP_MANIFEST_PATH` | Path to a sha256 manifest file (`<sha>  <file>` or `<sha> *<file>` format) |
| `LLAMACPP_SHA256_MANIFEST_NAME` | Manifest filename to look for inside the model dir (default: `manifest.sha256`) |
| `LLAMACPP_REQUIRE_MANIFEST` | `1` to fail if no manifest is found |
| `LLAMACPP_INTEGRITY_STRICT` | `1` to require a manifest entry for every selected file (including all shards) |

After verification, a per-model sha256 file is written next to the env file for downstream auditing.

### Environment variables

**Required:**

| Variable | Description |
|----------|-------------|
| `LLAMACPP_MODEL` | Model name/slug |
| `LLAMACPP_MODELS_DIR` | Base directory for model storage |

**Optional:**

| Variable | Default | Description |
|----------|---------|-------------|
| `LLAMACPP_MODEL_ID` | Derived from org + model | Explicit HF repo ID (`org/repo`) |
| `LLAMACPP_MODEL_ORG` | _(none; manifest sets `bartowski`)_ | HF org for deriving model ID |
| `LLAMACPP_MODEL_REVISION` | _(none)_ | HF revision (commit hash or tag) for hf-hub/hf-cache. Pins the exact snapshot |
| `LLAMACPP_MODEL_FILE` | _(auto-detected)_ | Explicit GGUF filename in the repo/directory |
| `LLAMACPP_QUANT` | _(none; manifest sets `Q4_K_M`)_ | Quant hint for file selection |
| `LLAMACPP_MODEL_SOURCES` | `local,hf-cache,r2,hf-hub` | Comma-separated source order (manifest overrides to `local,hf-cache,hf-hub`) |
| `FLOX_ENV_CACHE` | _(set by Flox)_ | Cache directory for env files. Required when `LLAMACPP_MODEL_ENV_FILE` is not set |
| `LLAMACPP_MODEL_ENV_FILE` | `$FLOX_ENV_CACHE/llamacpp-model.<slug>.<hash>.env` | Override env file output path |
| `R2_BUCKET` | _(none)_ | Cloudflare R2 bucket name |
| `R2_MODELS_PREFIX` | _(none)_ | R2 key prefix for models |
| `R2_ENDPOINT_URL` | _(none)_ | AWS CLI endpoint URL for R2 |
| `LLAMACPP_RESOLVE_LOCK_TIMEOUT` | `300` | Seconds to wait for the per-model lock |
| `LLAMACPP_KEEP_LOGS` | `0` | `1` to keep download logs on success (always kept on failure) |
| `LLAMACPP_RETRY_COUNT` | `3` | Download retry attempts (r2 and hf-hub) |
| `LLAMACPP_RETRY_BASE_DELAY` | `1` | Initial retry delay in seconds (doubles each attempt) |
| `LLAMACPP_BACKUP_KEEP` | `2` | Number of backup directories to keep during atomic swap. `0` disables backups |
| `LLAMACPP_ALLOW_UNSAFE_NAME` | `0` | `1` to allow model names outside the safe charset |
| `LLAMACPP_STRICT_GGUF_VALIDATE` | `1` (when python3 available) | `0` to use basic magic-byte check only |
| `LLAMACPP_ALLOW_SYMLINKS` | `0` | `1` to allow symlinks in staged dirs (hf-hub) |
| `LLAMACPP_DEREFERENCE_SYMLINKS` | `0` | `1` to dereference symlinks via tar copy (hf-hub) |
| `LLAMACPP_REQUIRE_REVISION_FOR_HF` | `0` | `1` to require `LLAMACPP_MODEL_REVISION` when hf-hub is used |
| `LLAMACPP_REQUIRE_IMMUTABLE_REVISION` | `0` | `1` to require 40-hex commit hash for revision |
| `HF_TOKEN` | _(none)_ | HuggingFace token for gated model access |
| `HUGGINGFACE_HUB_CACHE` | _(none)_ | Override HF hub cache directory. Falls back to `$HF_HOME/hub`, then `$LLAMACPP_MODELS_DIR/hub` |
| `HF_HOME` | _(none)_ | HuggingFace home directory. Used to derive hub cache as `$HF_HOME/hub` when `HUGGINGFACE_HUB_CACHE` is not set |
| `LLAMACPP_SHA256_FILE_PATH` | `<env_file>.sha256` | Override path for the per-model sha256 output file |

### Env file output

Written atomically (mktemp + mv) with mode `600` (umask `077`). Contains:

```bash
# generated by llamacpp-resolve-model
export LLAMACPP_MODEL='Meta-Llama-3.1-8B-Instruct-Q4_K_M'
export LLAMACPP_MODEL_ID='bartowski/Meta-Llama-3.1-8B-Instruct-GGUF'
export _LLAMACPP_RESOLVED_MODEL_PATH='/path/to/models/Meta-Llama-3.1-8B-Instruct-Q4_K_M/Meta-Llama-3.1-8B-Instruct-Q4_K_M.gguf'
export _LLAMACPP_RESOLVED_VIA='hf-hub'
export _LLAMACPP_RESOLVED_REVISION=''
export _LLAMACPP_RESOLVED_SHA256='7b064f58...'
export _LLAMACPP_RESOLVED_SHA256_FILE='/path/to/cache/llamacpp-model.slug.hash.env.sha256'
```

A companion `.env.sha256` file is also written containing `<sha256>  <filename>` lines for all selected GGUF files.

### Offline operation

Restrict sources to avoid network access:

```bash
LLAMACPP_MODEL_SOURCES=local flox activate --start-services           # local only
LLAMACPP_MODEL_SOURCES=local,hf-cache flox activate --start-services  # local + cached
```

### Revision pinning

Pin a specific HuggingFace commit for reproducible deployments:

```bash
LLAMACPP_MODEL_REVISION=abc123def456... flox activate --start-services
```

For strict reproducibility, require a 40-hex commit hash:

```bash
LLAMACPP_REQUIRE_IMMUTABLE_REVISION=1 \
LLAMACPP_MODEL_REVISION=abc123def456789012345678901234567890abcd \
  flox activate --start-services
```

### Locking and atomic swap

- **Per-model lock**: acquired before any source search. Uses `flock` if available, falls back to `mkdir`-based locking with stale PID/age detection. Timeout: `LLAMACPP_RESOLVE_LOCK_TIMEOUT` seconds (default 300). Lock files stored under `$LLAMACPP_MODELS_DIR/.locks/`.
- **Atomic swap** (r2 and hf-hub only): downloads stage into a temp directory under `$LLAMACPP_MODELS_DIR/.staging/`. After GGUF validation and integrity checks, the staged directory replaces the target via backup+rename. Old backups are pruned to `LLAMACPP_BACKUP_KEEP` (default 2).

## Pre-flight (`llamacpp-preflight`)

Pre-flight validation: reclaims the llama-server port if occupied, checks GPU health, and optionally executes a downstream command.

**Platform**: Linux only (requires `/proc`).

### Usage

```bash
llamacpp-preflight                              # checks only
llamacpp-preflight ./start.sh arg1 arg2         # checks, then exec command
llamacpp-preflight -- llama-server -m model.gguf # checks, then exec command (after --)
```

### Exit codes

Stable contract — safe to match on programmatically.

| Code | Meaning | When |
|------|---------|------|
| `0` | Success | Port free (or reclaimed), GPU OK, downstream command exec'd |
| `1` | Validation error | Bad env var, GPU hard failure, bad config, `python3` not found |
| `2` | Port owned by non-llama-server process | A non-llama-server listener holds the port. Will not kill |
| `3` | Different UID | llama-server on the port belongs to another user. Will not kill (unless `LLAMACPP_ALLOW_KILL_OTHER_UID=1`) |
| `4` | Not attributable | Listener found but cannot map socket inodes to PIDs (permissions / hidepid) |
| `5` | Stop failed | Sent SIGTERM/SIGKILL but port is still listening after timeout |

In dry-run mode (`LLAMACPP_DRY_RUN=1`), exit codes are `0`/`2`/`3`/`4` only (never `5`, since nothing is killed).

### Environment variables

| Variable | Default | Validation | Description |
|----------|---------|------------|-------------|
| `LLAMACPP_HOST` | `0.0.0.0` | — | Bind address to check |
| `LLAMACPP_PORT` | `8080` | Integer, 1-65535 | Port to check and reclaim |
| `LLAMACPP_OWNER_REGEX` | _(built-in heuristic)_ | Valid regex | Regex to identify llama-server processes. Matched against comm, cmdline, and exe. See example below |
| `LLAMACPP_OWNER_EXE_ALLOWLIST` | _(none)_ | Colon-separated paths | Exact exe paths treated as llama-server (e.g., `/opt/llama/bin/llama-server:/usr/bin/llama-server`) |
| `LLAMACPP_DRY_RUN` | `0` | `0` or `1` | Report what would happen without sending signals |
| `LLAMACPP_GPU_WARN_PCT` | `50` | Numeric, 0-100 | Warn if GPU memory usage exceeds this percentage |
| `LLAMACPP_GPU_FAIL_PCT` | _(unset)_ | Numeric, 0-100 | Fail (exit 1) if GPU usage exceeds this. Enables hard mode |
| `LLAMACPP_GPU_MIN_FREE_MIB` | _(unset)_ | Integer, >= 0 | Fail (exit 1) if free VRAM is below this. Enables hard mode |
| `LLAMACPP_SKIP_GPU_CHECK` | `0` | `0` or `1` | Skip all GPU checks |
| `LLAMACPP_ALLOW_KILL_OTHER_UID` | `0` | `0` or `1` | Allow killing llama-server owned by other UIDs |
| `LLAMACPP_KILL_PG` | `0` | `0` or `1` | Prefer signaling the process group when root is a group leader |
| `LLAMACPP_PREFLIGHT_LOCKDIR` | `XDG_RUNTIME_DIR` → `/run/user/<uid>` → `/tmp` (root: `/run/llamacpp-preflight`) | — | Base directory for lock files. When running as root, `/tmp` is refused — must use `/run` or `/var/lock` |
| `LLAMACPP_PREFLIGHT_LOCKFILE` | `<lockdir>/llamacpp-preflight.<port>.lock` | — | Lock file path (overrides `LLAMACPP_PREFLIGHT_LOCKDIR`; per-port by default) |
| `LLAMACPP_HOLD_LOCK` | `0` | `0` or `1` | Keep lock held for downstream process lifetime (requires flock) |
| `LLAMACPP_TERM_GRACE` | `3` | Numeric, >= 0 | Seconds to wait after SIGTERM before SIGKILL |
| `LLAMACPP_PORT_FREE_TIMEOUT` | `10` | Numeric, >= 0 | Seconds to wait for port to free after killing |
| `LLAMACPP_PORT_FREE_POLL` | `0.5` | Numeric, > 0 | Poll interval (seconds) while waiting for port to free |
| `LLAMACPP_PREFLIGHT_JSON` | `0` | `0` or `1` | Print a single JSON object on stdout. Incompatible with downstream command exec |

`LLAMACPP_OWNER_REGEX` example for unusual launchers:

```bash
LLAMACPP_OWNER_REGEX='llama[-_]?server'
```

### Port reclaim behavior

1. Parses `/proc/net/tcp` and `/proc/net/tcp6` for LISTEN-state sockets matching the configured host and port (including wildcard `0.0.0.0`/`::` catchall).
2. Maps socket inodes to PIDs via `/proc/<pid>/fd/` symlink scanning. If unmapped, rescans to handle listeners that exit mid-scan. When `/proc/<pid>/fd` mapping fails even after rescan, falls back to `ss -ltnp` and `lsof -Fp` for PID discovery before giving up (exit 4).
3. Reads `/proc/<pid>/comm`, `/proc/<pid>/cmdline`, and `/proc/<pid>/exe` to classify each listener as llama-server or non-llama-server:
   - **Built-in heuristic**: matches `llama-server` or `llama_server` in comm, exe basename, or first 5 cmdline tokens; also whole-word regex scan of cmdline.
   - **Custom regex**: set `LLAMACPP_OWNER_REGEX`.
   - **Exe allowlist**: set `LLAMACPP_OWNER_EXE_ALLOWLIST` with colon-separated absolute paths.
4. **Non-llama-server listener** → exit 2 (refuses to kill). Includes systemd socket activation detection with actionable hints.
5. **Different UID** → exit 3 (unless `LLAMACPP_ALLOW_KILL_OTHER_UID=1`).
6. **Unmappable inodes** (after rescan and ss/lsof fallback) → exit 4.
7. **Own llama-server** → kills via process tree walk (default) or process group (`LLAMACPP_KILL_PG=1`). PID start times are recorded before signaling and verified before every kill call (PID reuse guard). Sends SIGTERM, waits `LLAMACPP_TERM_GRACE` seconds, refreshes the tree, then SIGKILL any survivors.
8. Polls until port is free or `LLAMACPP_PORT_FREE_TIMEOUT` expires. On timeout, runs `ss` and `lsof` diagnostics, then → exit 5.

### GPU health check

Container-friendly 3-tier cascade (no torch dependency). Runs after port reclaim.

1. **CUDA driver probe** (`libcuda.so.1` via ctypes): `cuInit` → `cuDeviceGetCount` → optional `cuDriverGetVersion`. Most robust indicator inside containers where `nvidia-smi` may not exist but the CUDA driver library is bind-mounted.
2. **Memory metrics via NVML** (`libnvidia-ml.so.1` via ctypes): `nvmlInit` → `nvmlDeviceGetCount` → per-device `nvmlDeviceGetName` + `nvmlDeviceGetMemoryInfo`. Container-friendly.
3. **Fallback: nvidia-smi** — only when NVML is unavailable. Subprocess call with `--query-gpu` parsing.

Behavior:
- If the CUDA probe fails (driver library not found or `cuInit` error) → warning, or exit 1 in hard mode.
- If CUDA reports 0 devices → specific message: "container likely not started with GPU access."
- If memory metrics are unavailable from both NVML and nvidia-smi → warning, or exit 1 in hard mode.
- Reports per-GPU name, free/total VRAM, usage percentage.
- Warns if usage exceeds `LLAMACPP_GPU_WARN_PCT`.
- **Hard mode** (when `LLAMACPP_GPU_FAIL_PCT` or `LLAMACPP_GPU_MIN_FREE_MIB` is set): exits 1 if thresholds are breached. In hard mode, GPU is checked *before* killing an existing llama-server to avoid stopping it when a new one cannot start.

### JSON output mode

When `LLAMACPP_PREFLIGHT_JSON=1`, a single JSON object is printed to stdout. Human-readable logs still go to stderr. Incompatible with downstream command execution.

Examples:

```json
{"status":"ok","action":"noop","host":"0.0.0.0","port":8080,"dry_run":false,"gpu":{"checked":true,"available":true,"gpus":[{"index":0,"name":"NVIDIA GeForce RTX 5090","total_mib":32614,"free_mib":31774,"used_pct":2.6}],"warned":false,"probe":{"method":"cuda_dlopen","driver_present":true,"device_count":1,"driver_version":12090,"error":null},"memory":{"method":"nvml","error":null}}}
{"status":"ok","action":"stopped","host":"0.0.0.0","port":8080,"dry_run":false,"pids":[12345],"gpu":{...}}
{"status":"error","code":2,"reason":"port_owned_by_other_process","host":"0.0.0.0","port":8080,"dry_run":false,"pids":[5678]}
{"status":"error","code":2,"reason":"systemd_socket_activation","host":"0.0.0.0","port":8080,"dry_run":false,"pids":[1],"socket_units":["llama.socket"]}
```

### Locking

Prevents two concurrent preflight runs from racing on the same port.

**Lock directory resolution** (`LLAMACPP_PREFLIGHT_LOCKDIR`):

1. Explicit `LLAMACPP_PREFLIGHT_LOCKFILE` → use that path as-is (overrides everything).
2. Explicit `LLAMACPP_PREFLIGHT_LOCKDIR` → use that directory.
3. Root (`EUID=0`) → `/run/llamacpp-preflight` (created with mode 755).
4. `XDG_RUNTIME_DIR` exists and writable → use it.
5. `/run/user/<uid>` exists and writable → use it.
6. Fallback → `/tmp`.

**Root safety**: refuses `/tmp` when `EUID=0` — the script dies with an error directing you to set `LLAMACPP_PREFLIGHT_LOCKFILE` or `LLAMACPP_PREFLIGHT_LOCKDIR` to a path under `/run` or `/var/lock`. The lock parent directory must not be a symlink; when root, the parent must not be group/other-writable.

**flock** (preferred): Opens the lockfile with `umask 077`, re-checks for symlink after open, then acquires with `flock -n`. If the lockfile already exists, it must be a regular file (not a symlink or special file).

**mkdir fallback**: Creates `$LLAMACPP_PREFLIGHT_LOCKFILE.d/` with `mkdir -m 700`. Writes PID + `/proc/<pid>/stat` start time. Stale detection: if the recorded PID is dead OR the PID exists but its start time doesn't match the recorded value → the stale lock is reclaimed. This is immune to PID reuse (unlike the old age-based approach).

Lock is **per-port** by default (`<lockdir>/llamacpp-preflight.<port>.lock`).

`LLAMACPP_HOLD_LOCK=1`: keeps the flock held across the downstream command's lifetime (FD inheritance). Requires flock.

## Serving (`llamacpp-serve`)

Loads the resolved model env file and executes `llama-server` with validated arguments.

### Usage

```bash
llamacpp-serve                           # standard launch
llamacpp-serve --print-cmd               # print the llama-server argv to stderr, then exec
llamacpp-serve --dry-run                 # print the argv and exit 0 (no exec)
llamacpp-serve --check                   # validate config + model + lock/bind, print argv, exit 0
llamacpp-serve -h                        # show help
llamacpp-serve -- --extra-flag val       # pass extra args through to llama-server
```

### Required environment variables

**Always required:**

| Variable | Validation | Description |
|----------|------------|-------------|
| `LLAMACPP_HOST` | Non-empty | Server bind address or unix socket path (must end in `.sock` for socket mode) |
| `LLAMACPP_N_GPU_LAYERS` | Non-empty | GPU layers (`99`, `0`, or any non-negative integer) |
| `LLAMACPP_CTX_SIZE` | Non-negative integer | Context size (`0` for model default) |
| `LLAMACPP_PARALLEL` | Integer: `-1` or > 0 | Parallel inference slots (`-1` for auto, or any positive integer) |
| `LLAMACPP_PORT` | Integer, 1024-65535 | Server listen port. Ports < 1024 rejected. Required in TCP mode; optional (but validated if set) in unix socket mode |

**Required when `LLAMACPP_MODEL_ENV_FILE` is not set** (the standard case):

| Variable | Description |
|----------|-------------|
| `FLOX_ENV_CACHE` | Cache directory. Must exist as a directory |
| `LLAMACPP_MODEL_ID` | Full model ID, OR `LLAMACPP_MODEL_ORG` + `LLAMACPP_MODEL` must both be set |

### Optional environment variables

| Variable | Default | Description |
|----------|---------|-------------|
| `LLAMACPP_MODEL_ENV_FILE` | Derived from `FLOX_ENV_CACHE` + model ID | Explicit env file path |
| `LLAMACPP_ENV_FILE_TRUSTED` | `false` | Skip safe-mode parsing and `source` the file directly. Accepts `true`/`false`/`1`/`0`/`yes`/`no` |
| `LLAMACPP_API_KEY_FILE` | _(empty)_ | Path to API key file. Mutually exclusive with `LLAMACPP_API_KEY`. Must exist and be readable |
| `LLAMACPP_SINGLETON` | `true` | Acquire a per-host:port flock to prevent duplicate instances. `true`/`false`/`1`/`0`/`yes`/`no` |
| `LLAMACPP_LOCK_DIR` | Cascade (see Locking) | Lock directory for singleton lock. Matches preflight cascade |
| `LLAMACPP_ENV_FILE_ALLOW_PREFIXES` | `_LLAMACPP_,LLAMACPP_` | Comma-separated key prefixes allowed through safe-mode env file parsing |
| `LLAMACPP_SOCKET_STALE_POLICY` | `external` | Unix socket stale policy: `external` (refuse), `safe-cleanup` (remove), `move-aside` (rename) |

All optional engine/serving vars from the configuration reference tables above are also read by `llamacpp-serve` and mapped to CLI flags when non-empty.

### Env file loading

Two modes, identical to the vLLM runtime:

**Safe mode** (default): Parsed by a Python script enforcing a restricted `.env` subset — `KEY=VALUE` or `export KEY=VALUE`, optional quotes, no interpolation or command substitution. Requires `python3` on PATH.

**Key filtering** (safe mode only): Only keys matching `LLAMACPP_ENV_FILE_ALLOW_PREFIXES` (default: `_LLAMACPP_,LLAMACPP_`) are exported. All other keys are silently skipped (logged as `# skipped <key>` in the intermediate file). This prevents the env file from overriding unrelated environment. Override with `LLAMACPP_ENV_FILE_ALLOW_PREFIXES` if your env file uses custom prefixes.

**Trusted mode** (`LLAMACPP_ENV_FILE_TRUSTED=true`): `source`d directly as shell code.

The env file must define `_LLAMACPP_RESOLVED_MODEL_PATH` or `llamacpp-serve` exits with an error. The GGUF file at that path must still exist.

### Command construction

`llamacpp-serve` builds the final argv as:

API keys are never placed on the command line. `LLAMACPP_API_KEY` is exported as `LLAMA_API_KEY` (llama-server reads this natively). `LLAMACPP_API_KEY_FILE` maps to `--api-key-file`.

```bash
llama-server \
  -m <_LLAMACPP_RESOLVED_MODEL_PATH> \
  --host <LLAMACPP_HOST> \
  [--port <LLAMACPP_PORT>]               # TCP mode only
  -ngl <LLAMACPP_N_GPU_LAYERS> \
  -c <LLAMACPP_CTX_SIZE> \
  -np <LLAMACPP_PARALLEL> \
  [-b <LLAMACPP_BATCH_SIZE>]             # if set
  [-ub <LLAMACPP_UBATCH_SIZE>]           # if set
  [-fa on|off]                           # if LLAMACPP_FLASH_ATTN set
  [-ctk <LLAMACPP_CACHE_TYPE_K>]         # if set
  [-ctv <LLAMACPP_CACHE_TYPE_V>]         # if set
  [-sm <LLAMACPP_SPLIT_MODE>]            # if set
  [-ts <LLAMACPP_TENSOR_SPLIT>]          # if set
  [-mg <LLAMACPP_MAIN_GPU>]              # if set
  [-a <LLAMACPP_ALIAS>]                  # if set
  [--api-key-file <LLAMACPP_API_KEY_FILE>]  # if set (mutually exclusive with LLAMACPP_API_KEY)
  [--metrics]                            # if LLAMACPP_METRICS truthy
  [--jinja | --no-jinja]                 # if LLAMACPP_JINJA set
  [--chat-template <LLAMACPP_CHAT_TEMPLATE>]  # if set
  [--embedding]                          # if LLAMACPP_EMBEDDING truthy
  [--cont-batching | --no-cont-batching] # if LLAMACPP_CONT_BATCHING set
  [--webui | --no-webui]                 # if LLAMACPP_WEBUI set
  [-to <LLAMACPP_TIMEOUT>]              # if set
  [-t <LLAMACPP_THREADS>]               # if set
  [--reasoning-format <LLAMACPP_REASONING_FORMAT>]  # if set
  [extra args...]                        # anything after -- on the llamacpp-serve command line
```

The env var to llama-server CLI flag mapping:

| Env var | CLI flag | Condition |
|---------|----------|-----------|
| `_LLAMACPP_RESOLVED_MODEL_PATH` | `-m` | Always |
| `LLAMACPP_HOST` | `--host` | Always |
| `LLAMACPP_PORT` | `--port` | TCP mode only (always when set) |
| `LLAMACPP_N_GPU_LAYERS` | `-ngl` | Always |
| `LLAMACPP_CTX_SIZE` | `-c` | Always |
| `LLAMACPP_PARALLEL` | `-np` | Always (accepts `-1` for auto) |
| `LLAMACPP_BATCH_SIZE` | `-b` | When set |
| `LLAMACPP_UBATCH_SIZE` | `-ub` | When set |
| `LLAMACPP_FLASH_ATTN` | `-fa on` / `-fa off` | When set |
| `LLAMACPP_CACHE_TYPE_K` | `-ctk` | When set |
| `LLAMACPP_CACHE_TYPE_V` | `-ctv` | When set |
| `LLAMACPP_SPLIT_MODE` | `-sm` | When set |
| `LLAMACPP_TENSOR_SPLIT` | `-ts` | When set |
| `LLAMACPP_MAIN_GPU` | `-mg` | When set |
| `LLAMACPP_ALIAS` | `-a` | When set |
| `LLAMACPP_API_KEY` | _(no CLI flag)_ | Exported as `LLAMA_API_KEY` env var when set |
| `LLAMACPP_API_KEY_FILE` | `--api-key-file` | When set (mutually exclusive with `LLAMACPP_API_KEY`) |
| `LLAMACPP_METRICS` | `--metrics` | When truthy |
| `LLAMACPP_JINJA` | `--jinja` / `--no-jinja` | When set |
| `LLAMACPP_CHAT_TEMPLATE` | `--chat-template` | When set |
| `LLAMACPP_EMBEDDING` | `--embedding` | When truthy |
| `LLAMACPP_CONT_BATCHING` | `--cont-batching` / `--no-cont-batching` | When set |
| `LLAMACPP_WEBUI` | `--webui` / `--no-webui` | When set |
| `LLAMACPP_TIMEOUT` | `-to` | When set |
| `LLAMACPP_THREADS` | `-t` | When set |
| `LLAMACPP_REASONING_FORMAT` | `--reasoning-format` | When set |

## Multi-GPU

llama.cpp supports splitting a model across GPUs via layer splitting or row splitting (tensor parallelism):

```bash
# Split layers across 2 GPUs (default layer split)
LLAMACPP_SPLIT_MODE=layer flox activate --start-services

# Row split (tensor parallelism) across 2 GPUs
LLAMACPP_SPLIT_MODE=row flox activate --start-services

# Uneven split: give 30% to GPU 0, 70% to GPU 1
LLAMACPP_SPLIT_MODE=layer \
LLAMACPP_TENSOR_SPLIT=3,7 \
  flox activate --start-services

# Use GPU 1 as the main GPU
LLAMACPP_MAIN_GPU=1 flox activate --start-services
```

**Layer split** distributes layers sequentially (simpler, works with any model). **Row split** shards weight matrices (lower latency, higher inter-GPU bandwidth required). Unlike vLLM, llama.cpp does not require TP x PP = GPU count — it auto-discovers available GPUs and splits proportionally.

## Swapping models

```bash
# Override at activation time (typical GGUF repo pattern)
LLAMACPP_MODEL=Qwen2.5-7B-Instruct-Q4_K_M \
LLAMACPP_MODEL_ORG=Qwen \
LLAMACPP_MODEL_ID=Qwen/Qwen2.5-7B-Instruct-GGUF \
LLAMACPP_QUANT=Q4_K_M \
  flox activate --start-services

# Or edit the on-activate defaults in manifest.toml and restart
flox services restart llamacpp
```

### GGUF repo naming convention

Most GGUF repos on HuggingFace follow this pattern:
- **Repo**: `<org>/<ModelName>-GGUF` (contains all quant variants)
- **Files**: `<ModelName>-<Quant>.gguf` (e.g., `Llama-3.1-8B-Instruct-Q4_K_M.gguf`)

Set `LLAMACPP_MODEL_ID` to the repo and `LLAMACPP_QUANT` to select the variant, or set `LLAMACPP_MODEL_FILE` for the exact filename.

## Service management

```bash
flox services status              # check service state
flox services logs llamacpp       # tail service logs
flox services logs llamacpp -f    # follow logs
flox services restart llamacpp    # restart the llama-server service
flox services stop                # stop all services
flox activate --start-services    # activate and start in one step
```

## Kubernetes deployment

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

Common issues and their solutions. Exit codes refer to `llamacpp-preflight`.

### Port conflict (exit code 2)

`llamacpp-preflight` automatically reclaims the port from stale llama-server processes. If it exits with code 2, a non-llama-server process is using the port.

```bash
# Find what's on the port
ss -tlnp | grep :8080

# Either stop that process or change the port
LLAMACPP_PORT=8081 flox activate --start-services
```

If the listener is a systemd socket unit, the error message includes the unit name and `systemctl stop` commands.

### Different UID (exit code 3)

Another user's llama-server holds the port:

```bash
LLAMACPP_ALLOW_KILL_OTHER_UID=1 flox activate --start-services
```

### GPU not detected

GPU detection uses a 3-tier cascade: CUDA driver probe → NVML → nvidia-smi. It works even without `nvidia-smi` installed, as long as the CUDA driver library (`libcuda.so.1`) is available. In containers, ensure the NVIDIA container runtime mounts the GPU device (e.g., `--gpus all` with Docker, or the NVIDIA device plugin in Kubernetes).

If the CUDA probe reports 0 devices, the container was likely not started with GPU access.

To skip the GPU check entirely:

```bash
LLAMACPP_SKIP_GPU_CHECK=1 flox activate --start-services
```

For CPU-only inference, also set `LLAMACPP_N_GPU_LAYERS=0`.

### GPU memory threshold (hard mode)

Fail early if the GPU doesn't have enough free memory to load the model:

```bash
LLAMACPP_GPU_MIN_FREE_MIB=5000 flox activate --start-services  # need 5GB free
LLAMACPP_GPU_FAIL_PCT=90 flox activate --start-services         # fail if >90% used
```

### Gated model 401

Gated models require a HuggingFace token:

```bash
HF_TOKEN=hf_... flox activate --start-services
```

### Multiple GGUFs in repo (disambiguation error)

When a repo contains multiple quant variants and neither `LLAMACPP_MODEL_FILE` nor `LLAMACPP_QUANT` is set:

```bash
# Option 1: use a quant hint
LLAMACPP_QUANT=Q4_K_M flox activate --start-services

# Option 2: specify the exact file
LLAMACPP_MODEL_FILE=Meta-Llama-3.1-8B-Instruct-Q4_K_M.gguf flox activate --start-services
```

### Out of memory (OOM)

Reduce memory pressure:

1. Use a smaller quantization (Q4_K_M → Q3_K_S → IQ3_XS).
2. Reduce `LLAMACPP_CTX_SIZE`.
3. Reduce `LLAMACPP_PARALLEL` (fewer concurrent slots).
4. Use quantized KV cache: `LLAMACPP_CACHE_TYPE_K=q8_0 LLAMACPP_CACHE_TYPE_V=q8_0`.
5. Use `LLAMACPP_N_GPU_LAYERS` to partially offload (keep some layers on CPU).
6. Split across multiple GPUs with `LLAMACPP_SPLIT_MODE=layer`.

### Stale lock

If a previous run was killed mid-operation:

```bash
# For llamacpp-preflight (per-port lock — path depends on LOCKDIR resolution;
# check XDG_RUNTIME_DIR, /run/user/<uid>, or /tmp)
rm -f "${XDG_RUNTIME_DIR:-/tmp}"/llamacpp-preflight.8080.lock

# For llamacpp-resolve-model (per-model lock)
rm -f "$LLAMACPP_MODELS_DIR"/.locks/llamacpp-resolve.*.lock

# For llamacpp-serve (per host:port singleton lock — path depends on LOCK_DIR resolution)
rm -f "${XDG_RUNTIME_DIR:-/tmp}"/llamacpp-serve.*.lock
```

The mkdir-based fallback includes stale detection via PID start time comparison (`/proc/<pid>/stat` field 22). If the recorded PID is dead or has a different start time, the lock is automatically reclaimed.

### Inspecting the generated command

```bash
llamacpp-serve --print-cmd   # print the llama-server argv to stderr, then run it
llamacpp-serve --dry-run     # print the argv and exit without running
llamacpp-serve --check       # validate config + model + lock/bind, print argv, exit 0
```

Printed argv is redacted — API keys, tokens, and auth headers are replaced with `<redacted>`.

### Passing extra llama-server flags

Any flags not covered by env vars can be passed through:

```bash
llamacpp-serve -- --mlock --numa distribute
```

## File structure

```
llamacpp-runtime/
  .flox/env/manifest.toml      # Flox manifest (packages, on-activate hook, service)
  .cache/                       # Env files and sha256 records (created at runtime)
  k8s/                          # Kubernetes manifests (Flox uncontained pattern)
  models/                       # Model storage (created on activation)
    Meta-Llama-3.1-8B-Instruct-Q4_K_M/
      Meta-Llama-3.1-8B-Instruct-Q4_K_M.gguf
    .locks/                     # Per-model lock files
    .staging/                   # Temp dirs during downloads (cleaned up)
  README.md
```

Scripts (`llamacpp-preflight`, `llamacpp-resolve-model`, `llamacpp-serve`) are provided by the `flox/llamacpp-flox-runtime` package and available on `PATH` after activation. They are not stored in this directory.

## Security notes

The runtime scripts handle untrusted input (model names, env files, lock files) and apply defense-in-depth.

### Env file trust model

The model env file is a trust boundary. In safe mode (default), `llamacpp-serve` parses the file with a restrictive Python parser that rejects shell interpolation and command substitution. In trusted mode, the file is `source`d directly — only enable this for env files you control.

Even in safe mode, protect the env file location. In safe mode, key filtering (default prefix allowlist: `_LLAMACPP_,LLAMACPP_`) prevents the env file from setting arbitrary environment variables. Only keys matching the allowed prefixes are exported; all others are dropped.

### File permissions

- **Env files**: written with `umask 077` and `chmod 600` — readable only by the owning user.
- **SHA256 files**: same permissions as env files.
- **Lock files**: created with `umask 077`. Symlink safety is checked before opening and re-checked after open. When running as root, the lock parent directory is verified to not be group/other-writable. Root is refused `/tmp` locks entirely.
- **Staging directories**: created under `$LLAMACPP_MODELS_DIR/.staging/` with `umask 077`.

### API key handling

`LLAMACPP_API_KEY` is never placed on the `llama-server` command line. It is exported as the `LLAMA_API_KEY` environment variable, which `llama-server` reads natively. This prevents leakage via `/proc/<pid>/cmdline`. When using `--print-cmd` or `--dry-run`, all secret-bearing flags (`--api-key`, `--token`, auth headers) are redacted in the printed output.

`LLAMACPP_API_KEY_FILE` maps to `--api-key-file <path>` (the file path itself is not secret). The two options are mutually exclusive.

### Model name validation

`LLAMACPP_MODEL` must match `^[A-Za-z0-9._-]+(\.gguf)?$` by default. This prevents path traversal (`../`), null bytes, and control characters. Override with `LLAMACPP_ALLOW_UNSAFE_NAME=1` only when necessary.

### Integrity verification

The sha256 checksum system provides:
- **Single-file pin**: `LLAMACPP_EXPECTED_SHA256` for quick single-GGUF verification.
- **Manifest-based**: `manifest.sha256` files for multi-file/split-shard verification.
- **Strict mode**: `LLAMACPP_INTEGRITY_STRICT=1` requires every selected file to have a manifest entry.
- **Audit trail**: per-model `.env.sha256` files record checksums of resolved files.

# SGLang Runtime

Production SGLang inference server as a Flox environment.

- **SGLang** with Python 3.12
- **CUDA 12.8** (driver 550+)
- **SM75–SM120** (T4, A10, A100, L40, H100, B200, RTX 3090/4090/5090)
- **AVX2** CPU instructions, x86_64-linux only

> To target a specific GPU family instead of the all-SM build, swap the
> package in `.flox/env/manifest.toml` — e.g.
> `flox/sglang-python312-cuda12_8-sm89-avx2` for Ada Lovelace only.

## Quick start

```bash
# Start the server with the default bundled model (Phi-4-mini-instruct-FP8-TORCHAO)
flox activate --start-services

# Or override the model at activation time
SGLANG_MODEL=deepseek-ai/DeepSeek-R1-Distill-Qwen-7B flox activate -s

# Phi-3.5 on T4 (needs triton attention)
SGLANG_MODEL=microsoft/Phi-3.5-mini-instruct-AWQ \
SGLANG_ATTENTION_BACKEND=triton SGLANG_DISABLE_CUDA_GRAPH=1 \
SGLANG_DTYPE=float16 flox activate -s

# 70B model across 4 GPUs
SGLANG_MODEL=meta-llama/Llama-3.1-70B-Instruct \
SGLANG_TP_SIZE=4 flox activate -s
```

### Verify it's running

```bash
# Health check
curl http://127.0.0.1:30000/health

# List loaded models
curl http://127.0.0.1:30000/v1/models

# Chat completion
curl http://127.0.0.1:30000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "microsoft/Phi-4-mini-instruct-FP8-TORCHAO",
    "messages": [{"role": "user", "content": "Hello!"}],
    "max_tokens": 256
  }'
```

## Architecture

```
manifest.toml
  ├─ [install]   sglang + sglang-flox-runtime + model bundle
  ├─ [vars]      SGLANG_HOST, SGLANG_PORT, SGLANG_SERVED_NAME
  ├─ [hook]      on-activate: model default, sampling params, Python/CUDA env
  └─ [services]  sglang: sglang-resolve-model && sglang-serve
```

The environment uses two packages working together — `sglang` (the Python/CUDA inference engine) and `sglang-flox-runtime` (runtime scripts for model resolution and server launch):

```
┌──────────────────────────────────────────────────────┐
│  Consuming Environment (manifest.toml)               │
│                                                      │
│  [install]                                           │
│    flox/sglang-python312-cuda12_8-*  # inference     │
│    flox/sglang-flox-runtime          # scripts       │
│    flox/phi-4-mini-instruct-fp8-*    # model bundle  │
│                                                      │
│  [hook] on-activate                                  │
│    Set SGLANG_MODEL default + sampling params         │
│    Resolve Python/PYTHONPATH from closure             │
│    Export CUDA_HOME, CPATH, LIBRARY_PATH              │
│    Create FLASHINFER_JIT_DIR                          │
│                                                      │
│  [services]                                          │
│    sglang → sglang-resolve-model && sglang-serve     │
│                                                      │
│  ┌─────────────────────────────────────────────────┐ │
│  │  sglang-resolve-model                           │ │
│  │    HF cache lookup in $FLOX_ENV/share/models/   │ │
│  │    Tokenizer compat shim (transformers <4.58)   │ │
│  │    Output: per-model .env file                  │ │
│  ├─────────────────────────────────────────────────┤ │
│  │  sglang-serve                                   │ │
│  │    Loads .env → builds argv → exec launch_server│ │
│  └─────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────┘
```

1. **Install** — the `[install]` section pulls the SGLang package from the
   Flox catalog (`flox/sglang-python312-cuda12_8-all-avx2`), the runtime
   scripts (`flox/sglang-flox-runtime`), and optionally a bundled model
   package.

2. **Hook (on-activate)** — runs at activation time and sets up:
   - `SGLANG_MODEL` default and sampling params (user-overridable)
   - Python isolation (`unset PYTHONPATH PYTHONHOME`) and `PYTHONPATH`
     from the full Nix closure
   - CUDA JIT environment (`CUDA_HOME`, `CPATH`, `LIBRARY_PATH`)
   - Writable `FLASHINFER_JIT_DIR` (Nix store is read-only)

3. **Service** — `[services.sglang]` runs
   `sglang-resolve-model && sglang-serve`. The first script resolves
   bundled models; the second builds the full `launch_server` argv from
   environment variables and `exec`s it.

> **Why `launch_server` instead of `sglang serve`?** The `sglang serve`
> entry point eagerly imports multimodal/diffusion modules (`remote_pdb`,
> `diffusers`, etc.) that are not included in this build. Using
> `launch_server` directly avoids those imports.

## API reference

SGLang exposes an OpenAI-compatible API plus its own native endpoints.

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/health` | `GET` | Health check — returns 200 when the server is ready |
| `/get_model_info` | `GET` | Model metadata (architecture, context length, etc.) |
| `/v1/models` | `GET` | OpenAI-compatible model list |
| `/v1/chat/completions` | `POST` | OpenAI-compatible chat completion |
| `/v1/completions` | `POST` | OpenAI-compatible text completion |
| `/generate` | `POST` | SGLang native generation endpoint |

### Chat completion

```bash
curl http://127.0.0.1:30000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "microsoft/Phi-4-mini-instruct-FP8-TORCHAO",
    "messages": [
      {"role": "system", "content": "You are a helpful assistant."},
      {"role": "user", "content": "Explain tensor parallelism in two sentences."}
    ],
    "max_tokens": 256,
    "temperature": 0.7
  }'
```

### Streaming

```bash
curl --no-buffer http://127.0.0.1:30000/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "microsoft/Phi-4-mini-instruct-FP8-TORCHAO",
    "messages": [{"role": "user", "content": "Write a haiku about GPUs."}],
    "max_tokens": 128,
    "stream": true
  }'
```

### Text completion

```bash
curl http://127.0.0.1:30000/v1/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "microsoft/Phi-4-mini-instruct-FP8-TORCHAO",
    "prompt": "The capital of France is",
    "max_tokens": 32
  }'
```

### Native generate

```bash
curl http://127.0.0.1:30000/generate \
  -H "Content-Type: application/json" \
  -d '{
    "text": "The meaning of life is",
    "sampling_params": {
      "max_new_tokens": 128,
      "temperature": 0.8
    }
  }'
```

## Configuration reference

### Runtime environment variables

All server behavior is controlled through environment variables. Set them
at activation time — no manifest edits needed for common configuration.

| Variable | Default | Description |
|----------|---------|-------------|
| `SGLANG_MODEL` | `microsoft/Phi-4-mini-instruct-FP8-TORCHAO` | HF model ID or local path |
| `SGLANG_HOST` | `0.0.0.0` | Bind address |
| `SGLANG_PORT` | `30000` | Listen port |
| `SGLANG_SERVED_NAME` | `$SGLANG_BUNDLED_FROM` or `default` | Served model name |
| `SGLANG_ATTENTION_BACKEND` | *(unset)* | Attention backend (e.g., `triton` for Phi-3.5) |
| `SGLANG_DISABLE_CUDA_GRAPH` | *(unset)* | Set `1` to disable CUDA graph capture |
| `SGLANG_DTYPE` | *(unset)* | Model dtype (e.g., `float16` for AWQ) |
| `SGLANG_TP_SIZE` | *(unset)* | Tensor parallel GPUs |
| `SGLANG_PREFERRED_SAMPLING_PARAMS` | *(JSON)* | Default sampling params |
| `SGLANG_EXTRA_ARGS` | *(unset)* | Additional sglang args (word-split) |
| `SGLANG_PREFLIGHT` | *(unset)* | Set `1` to check port before launch |

Override any variable at activation time:

```bash
SGLANG_MODEL=mistralai/Mistral-7B-Instruct-v0.3 \
SGLANG_PORT=8080 \
  flox activate --start-services
```

### Engine tuning

Engine behavior is configured via environment variables — the `sglang-serve`
script translates them to `launch_server` flags.

Example — serve a 70B model across 4 GPUs:

```bash
SGLANG_MODEL=meta-llama/Llama-3.1-70B-Instruct \
SGLANG_TP_SIZE=4 flox activate -s
```

Example — Phi-3.5-AWQ on T4 (needs triton attention, float16):

```bash
SGLANG_MODEL=microsoft/Phi-3.5-mini-instruct-AWQ \
SGLANG_ATTENTION_BACKEND=triton SGLANG_DISABLE_CUDA_GRAPH=1 \
SGLANG_DTYPE=float16 flox activate -s
```

For flags not covered by dedicated env vars, use `SGLANG_EXTRA_ARGS`:

```bash
SGLANG_EXTRA_ARGS="--mem-fraction-static 0.80 --context-length 4096" \
  flox activate -s
```

Common SGLang flags for reference:

| Flag | Default | Description |
|------|---------|-------------|
| `--mem-fraction-static` | `0.88` | Fraction of GPU memory reserved for KV cache |
| `--context-length` | model default | Override maximum context length |
| `--chunked-prefill-size` | `8192` | Chunk size for prefill phase |
| `--max-running-requests` | auto | Cap on concurrent requests |
| `--quantization` | none | Quantization method (`awq`, `gptq`, `fp8`, etc.) |
| `--schedule-policy` | `lpm` | Scheduling policy (`lpm`, `random`, `fcfs`, `dfs-weight`) |

### Hook-managed variables

These are set automatically by the on-activate hook. They do not need to be
configured manually but are documented for reference.

| Variable | Source | Purpose |
|----------|--------|---------|
| `PYTHONPATH` | Nix closure walk | All `site-packages` from transitive deps |
| `CUDA_HOME` | `cuda_nvcc` store path | `nvcc` location for deep_gemm JIT |
| `CPATH` | `cuda12.8-*` store paths | CUDA headers for JIT compilation |
| `LIBRARY_PATH` | `cuda12.8-*` store paths | CUDA libraries for JIT linking |
| `FLASHINFER_JIT_DIR` | `$FLOX_ENV_CACHE/flashinfer-jit` | Writable cache for FlashInfer JIT kernels |

## Multi-GPU

SGLang supports tensor parallelism for serving large models across multiple
GPUs. Set `SGLANG_TP_SIZE` to the number of GPUs:

```bash
SGLANG_TP_SIZE=4 flox activate -s
```

Common configurations:

| Model size | `SGLANG_TP_SIZE` | GPUs |
|-----------|-------------|------|
| 7–8B | `1` | 1x (any 16 GB+ GPU) |
| 13–14B | `1` or `2` | 1x 24 GB or 2x 16 GB |
| 30–34B | `2` | 2x 24 GB+ |
| 70B | `4` | 4x 24 GB+ or 2x 80 GB |
| 405B | `8` | 8x 80 GB |

All GPUs must be visible to the process. SGLang uses NCCL for cross-GPU
communication.

## Swapping models

Override the model at activation time without editing the manifest:

```bash
# Community model
SGLANG_MODEL=mistralai/Mistral-7B-Instruct-v0.3 flox activate -s

# Local path
SGLANG_MODEL=/data/models/my-fine-tune flox activate -s
```

## Bundled models

Model packages from the Flox catalog (or a custom catalog) can be installed
alongside SGLang so that model weights are included in the Nix closure. When
a bundled model is detected, `sglang-resolve-model` rewrites `SGLANG_MODEL`
to the local snapshot path and sets `HF_HUB_OFFLINE=1` — no network access
is needed at startup.

### How it works

The `sglang-resolve-model` script supports the HF cache model package layout
(used by `build-hf-models`):

```
$FLOX_ENV/share/models/hub/
  models--meta-llama--Llama-3.1-8B-Instruct/
    refs/main                    # commit hash
    snapshots/<hash>/
      config.json
      model-00001-of-00004.safetensors
      ...
```

The script converts `SGLANG_MODEL` (e.g.
`meta-llama/Llama-3.1-8B-Instruct`) to the HF cache slug and checks for
a matching snapshot directory. The snapshot is validated by checking for
`config.json`.

### Installing a model bundle

Add the model package to `[install]` in `manifest.toml`:

```toml
[install]
sglang.pkg-path = "flox/sglang-python312-cuda12_8-all-avx2"
sglang.systems = ["x86_64-linux"]
sglang.pkg-group = "sglang"
sglang.outputs = "all"

sglang-flox-runtime.pkg-path = "flox/sglang-flox-runtime"
sglang-flox-runtime.systems = ["x86_64-linux"]

phi-4-mini-instruct-fp8-sglang.pkg-path = "flox/phi-4-mini-instruct-fp8-sglang"
phi-4-mini-instruct-fp8-sglang.systems = ["x86_64-linux"]
```

Then activate with the matching HF model ID:

```bash
SGLANG_MODEL=microsoft/Phi-4-mini-instruct-FP8-TORCHAO flox activate -s
```

No other configuration is needed — the script auto-detects the bundled model.
The profile banner will show `(bundled)` instead of `(will download from HF)`.

### Tokenizer compatibility shim

Models quantized with transformers >=4.58 write `"tokenizer_class": "TokenizersBackend"` into
`tokenizer_config.json`. SGLang 0.5.9's bundled transformers 4.57.6 does not recognize this
class. The `sglang-resolve-model` script detects this and creates a shadow directory under
`$FLOX_ENV_CACHE/sglang-compat/` containing symlinks to all model files plus a patched
`tokenizer_config.json` with `"PreTrainedTokenizerFast"` as the tokenizer class.

This runs automatically — no configuration needed. The shadow directory is cached and
only rebuilt when the model changes.

**Removal**: This shim should be removed once SGLang ships transformers >=4.58. Track
the SGLang version in `[install]` and the transformers version in the sglang Nix package.

### Gated models

Some HuggingFace models (Llama, Gemma, etc.) require accepting a license
agreement and providing an access token:

```bash
HF_TOKEN=hf_xxxxxxxxxxxxxxxxxxxxx \
SGLANG_MODEL=meta-llama/Llama-3.1-70B-Instruct \
  flox activate --start-services
```

## Service management

```bash
# Check service status
flox services status

# View logs (follow mode)
flox services logs sglang -f

# View recent logs
flox services logs sglang

# Restart after configuration changes
flox services restart sglang

# Stop all services
flox services stop

# Start fresh
flox activate --start-services
```

## Kubernetes deployment

Deploy SGLang to Kubernetes using the Flox "Imageless Kubernetes" (uncontained) pattern. The Flox containerd shim pulls the environment from FloxHub at pod startup, replacing the need for a container image.

### Prerequisites

- A Kubernetes cluster with the [Flox containerd shim](https://flox.dev/docs/tutorials/kubernetes/) installed on GPU nodes
- NVIDIA GPU operator or device plugin configured
- A StorageClass that supports `ReadWriteOnce` PVCs (only needed for non-bundled models)

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
| `k8s/namespace.yaml` | Creates the `sglang` namespace |
| `k8s/pvc.yaml` | 50 Gi `ReadWriteOnce` volume for model storage at `/models` |
| `k8s/deployment.yaml` | Single-replica pod with Flox shim, GPU resources, health probes |
| `k8s/service.yaml` | ClusterIP service on port 30000 |

The deployment uses `runtimeClassName: flox` and `image: flox/empty:1.0.0` — the Flox shim intercepts pod creation, pulls `flox/sglang-runtime` from FloxHub, activates the environment, then runs the entrypoint (`sglang-resolve-model && sglang-serve`).

### Storage

The default model (Phi-4-mini-instruct-FP8-TORCHAO, ~2 GB) is **installed from the Flox catalog** (`flox/phi-4-mini-instruct-fp8-sglang`) and bundled in the Nix closure — no download or persistent storage is required. The PVC mounted at `/models` with `HF_HUB_CACHE=/models` is only needed when overriding `SGLANG_MODEL` to a non-bundled HuggingFace model.

Set the `storageClassName` in `k8s/pvc.yaml` to match your cluster:

```yaml
storageClassName: gp3  # AWS EBS
storageClassName: standard-rwo  # GKE
storageClassName: managed-premium  # AKS
```

### Secrets

SGLang has no built-in API key. The only secret needed is `HF_TOKEN` for downloading gated HuggingFace models (Llama, Gemma, etc.):

```bash
kubectl -n sglang create secret generic sglang-secrets \
  --from-literal=hf-token='hf_...'
```

Then uncomment the `secretKeyRef` block in `k8s/deployment.yaml`.

### Customizing the model

Override the model via pod environment variables:

```yaml
env:
  - name: SGLANG_MODEL
    value: "mistralai/Mistral-7B-Instruct-v0.3"
```

For multi-GPU tensor parallelism, set `SGLANG_TP_SIZE` and request additional GPUs:

```yaml
env:
  - name: SGLANG_TP_SIZE
    value: "4"
resources:
  limits:
    nvidia.com/gpu: 4
```

### Startup timing

The `startupProbe` allows 10 minutes (60 failures x 10s) for warm starts with the bundled model — this covers FlashInfer JIT compilation and CUDA warmup. For cold starts with non-bundled models (add download time), increase the threshold:

```yaml
startupProbe:
  failureThreshold: 120  # 20 minutes for cold start
```

Liveness and readiness probes are gated behind the startup probe and will not kill slow-starting pods.

### Verifying the deployment

```bash
# Watch pod startup
kubectl -n sglang get pods -w

# Check logs
kubectl -n sglang logs -f deployment/sglang

# Health check (from within the cluster)
kubectl -n sglang run curl --rm -it --image=curlimages/curl -- \
  curl http://sglang:30000/health

# Port-forward for local access
kubectl -n sglang port-forward svc/sglang 30000:30000
curl http://localhost:30000/health
```

### Exposing externally

The service defaults to `ClusterIP`. For external access, change the type or add an Ingress:

```bash
# Quick LoadBalancer
kubectl -n sglang patch svc sglang -p '{"spec":{"type":"LoadBalancer"}}'

# Or use port-forward for development
kubectl -n sglang port-forward svc/sglang 30000:30000
```

## How it works

The environment splits work between the on-activate hook and two runtime
scripts:

### Hook (on-activate)

The hook runs at activation time and sets up the Python/CUDA environment:

1. **Set model default** — exports `SGLANG_MODEL` (defaulting to
   `microsoft/Phi-4-mini-instruct-FP8-TORCHAO`) and
   `SGLANG_PREFERRED_SAMPLING_PARAMS`.

2. **Isolate from outer Python** — unsets `PYTHONPATH` and `PYTHONHOME` to
   prevent any system or virtualenv Python packages from leaking into the
   environment.

3. **Resolve the sglang store path** — follows the `sglang` binary
   (`which sglang -> readlink`) back to its Nix store path. This is the
   root from which all transitive dependencies are discovered.

4. **Discover Python 3.12** — runs `nix-store -qR` on the sglang store
   path and finds the `python3-3.12` derivation. Adds its `bin/` to
   `PATH` so `python3.12` is available interactively.

5. **Build PYTHONPATH** — walks the full Nix closure and collects every
   `lib/python3.12/site-packages` directory into `PYTHONPATH`. This gives
   interactive Python access to the entire SGLang dependency tree (torch,
   transformers, flashinfer, etc.).

6. **Set up CUDA JIT environment** — exports:
   - `CUDA_HOME` -> the `cuda_nvcc` store path (deep_gemm needs `nvcc`)
   - `CPATH` -> all `cuda12.8-*/include` directories (`cuda_runtime.h`,
     `nv/target`, etc.)
   - `LIBRARY_PATH` -> all `cuda12.8-*/lib` and `lib64` directories
     (`libcudart.so`, etc.)

7. **Create FlashInfer JIT cache** — sets `FLASHINFER_JIT_DIR` to a
   writable directory under `$FLOX_ENV_CACHE` (the Nix store is read-only,
   so JIT-compiled kernels need a mutable location).

### `sglang-resolve-model`

Runs at service start, before the server. If `SGLANG_MODEL` is a
HuggingFace model ID (contains `/`), checks for a matching model package
in `$FLOX_ENV/share/models/hub/` (HF cache layout). If found, rewrites
`SGLANG_MODEL` to the local snapshot path and sets `HF_HUB_OFFLINE=1`.
Also applies the tokenizer compatibility shim if needed. Writes results
to an env file loaded by `sglang-serve`.

### `sglang-serve`

Loads the env file from `sglang-resolve-model`, builds the full
`python3.12 -m sglang.launch_server` argv from environment variables
(`SGLANG_MODEL`, `SGLANG_HOST`, `SGLANG_PORT`, `SGLANG_TP_SIZE`, etc.),
and `exec`s the server. Supports `--dry-run` for debugging the final
command without launching.

## Troubleshooting

### HuggingFace download fails with xet/CAS errors

HuggingFace's newer xet download backend may fail in Nix-built
environments. Disable it:

```bash
HF_HUB_ENABLE_HF_TRANSFER=0 flox activate --start-services
```

### Gated model returns 401 Unauthorized

The model requires a HuggingFace access token:

```bash
HF_TOKEN=hf_xxxxxxxxxxxxxxxxxxxxx flox activate --start-services
```

Accept the model's license at `https://huggingface.co/<model>` before
downloading.

### Out of memory (OOM)

Reduce memory pressure with one or more of:

```bash
# Lower KV cache fraction
SGLANG_EXTRA_ARGS="--mem-fraction-static 0.70" flox activate -s

# Reduce context length
SGLANG_EXTRA_ARGS="--context-length 4096" flox activate -s

# Use tensor parallelism to spread across GPUs
SGLANG_TP_SIZE=2 flox activate -s
```

### `sglang serve` crashes on import

This is expected. The `sglang serve` entry point imports multimodal
dependencies (`diffusers`, `remote_pdb`) not included in this build. The
service uses `python3.12 -m sglang.launch_server` (via `sglang-serve`)
which avoids these imports.

### Debugging the launch command

Use `sglang-serve --dry-run` to print the full `launch_server` argv
without starting the server:

```bash
flox activate
sglang-serve --dry-run
```

### JIT compilation fails

Verify CUDA JIT environment variables are set:

```bash
flox activate
echo $CUDA_HOME      # Should point to cuda_nvcc store path
echo $CPATH          # Should contain cuda12.8-*/include paths
echo $LIBRARY_PATH   # Should contain cuda12.8-*/lib paths
```

If any are empty, the hook may have failed to resolve the Nix closure.
Check that `which sglang` returns a valid store path.

### GPU not detected

```bash
# Check driver
nvidia-smi

# Check CUDA visibility inside the environment
flox activate
python3.12 -c "import torch; print(torch.cuda.is_available(), torch.cuda.get_device_name(0))"
```

Requires NVIDIA driver 550+ with CUDA 12.8 support.

### Port conflict

Use `SGLANG_PREFLIGHT=1` to have `sglang-serve` check and report port
conflicts before launch:

```bash
SGLANG_PREFLIGHT=1 flox activate -s
```

Or change the port:

```bash
SGLANG_PORT=30001 flox activate --start-services
```

Or check what's using port 30000:

```bash
ss -tlnp | grep 30000
```

### FlashInfer JIT cache errors

If FlashInfer fails to compile kernels, clear the JIT cache:

```bash
rm -rf "${FLOX_ENV_CACHE:-$HOME/.cache/flox}/flashinfer-jit"
flox services restart sglang
```

## File structure

```
sglang-runtime/
  .flox/
    env/
      manifest.toml    # Environment definition: packages, hook, service, vars
  k8s/
    namespace.yaml     # Kubernetes namespace
    pvc.yaml           # PersistentVolumeClaim for model storage
    deployment.yaml    # Pod spec with Flox shim, GPU resources, probes
    service.yaml       # ClusterIP service on port 30000
  README.md            # This file
```

## Known limitations

- **`sglang serve` is not usable** — eagerly imports multimodal/diffusion
  dependencies not included in this build. The service uses
  `python3.12 -m sglang.launch_server` (via `sglang-serve`) instead.
- **x86_64-linux only** — built with AVX2 CPU instructions. No macOS or
  aarch64 support.
- **Single-node only** — tensor parallelism works across GPUs on the same
  machine. Distributed multi-node serving is not configured.

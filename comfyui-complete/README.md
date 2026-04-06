# ComfyUI Runtime

ComfyUI 0.15.0 image generation as a Flox environment. Automated setup, CUDA GPU acceleration, and managed service lifecycle.

- **ComfyUI 0.15.0** with 22 custom nodes and 40+ Python packages
- **Platform**: Linux (CUDA GPU), macOS (MPS/CPU)
- **Automated setup** on first activation (venv, pip packages, runtime directory, workflows)
- **Managed as a Flox service** with health checks and browser launch

## Quick start

```bash
# Enter the environment (runs setup on first use)
flox activate

# Enter the environment and auto-start ComfyUI
flox activate --start-services

# From within the environment: start ComfyUI and open browser
start
```

### Service management

```bash
flox services start comfyui
flox services logs comfyui --follow
flox services stop comfyui
flox services restart comfyui
```

## Verify it is running

```bash
curl http://localhost:8188/
```

Open `http://localhost:8188` in a browser. Check service logs with `flox services logs comfyui --follow`.

## What happens on first activation

The `[hook] on-activate` runs every time you enter the environment:

1. **File descriptor limit** raised to 10240 (macOS defaults to 256, too low for ComfyUI)
2. **Model download** (Flox internal only) -- if `get-models` is available and models are missing, downloads SDXL + FLUX (~59 GB). External users must download models manually (see [Model downloads](#model-downloads)).
3. **`comfyui-setup`** runs and performs the following (skipped on subsequent activations if cache is intact):
   - Creates a Python venv with `--system-site-packages` at `$FLOX_ENV_CACHE/venv`
   - Installs pip packages: comfyui-manager, comfyui-frontend-package, comfyui-workflow-templates, comfyui-embedded-docs, safetensors, comfy-kitchen, matrix-nio, kornia (on non-x86_64-linux platforms)
   - Creates the runtime directory at `$FLOX_ENV_CACHE/comfyui-runtime` (symlinks read-only store files, copies `web/` and `custom_nodes/` for writability)
   - Copies bundled custom nodes to `~/comfyui-work/custom_nodes/` (only if not already present)
   - Copies bundled workflows to `~/comfyui-work/user/default/workflows/`
   - Creates `extra_model_paths.yaml` with model directory mappings

The `[profile]` section (bash/zsh/fish) prepends `$FLOX_ENV_CACHE/venv/bin` to PATH so pip-installed packages are available.

To force a full reset: `COMFYUI_RESET=1 flox activate`

## Architecture

```
+---------------------------------------------------------+
|  Manifest (this repo)                                   |
|  manifest.toml: vars, hooks, service, GPU pkg selection |
+---------------------------------------------------------+
        |  consumes via store-path or pkg-path
        v
+---------------------------------------------------------+
|  comfyui-complete (Nix package from build-comfyui)      |
|  ComfyUI source + pythonEnv + custom nodes + scripts    |
|  Immutable, lives in /nix/store                         |
+---------------------------------------------------------+
        |  torch from pythonEnv is CPU-only (nixpkgs)
        v
+---------------------------------------------------------+
|  CUDA torch (flox-cuda catalog)                         |
|  torchvision, torchaudio, kornia                        |
|  Platform-specific; CPU fallback on macOS/other         |
+---------------------------------------------------------+
```

**Data flow**: `flox activate` -> on-activate hook -> `comfyui-setup` (creates venv, runtime dir, installs pip deps) -> `flox services start comfyui` -> `comfyui-start` (builds PYTHONPATH, detects GPU, launches `main.py`)

## Directory layout

### Mutable user data: `~/comfyui-work/`

```
~/comfyui-work/
  models/              Checkpoints, LoRAs, VAEs, CLIP, UNet, etc.
  custom_nodes/        Writable copy of bundled nodes + user-added nodes
  output/              Generated images
  input/               Input images for img2img, inpainting
  user/                User settings and saved workflows
    default/workflows/   Bundled example workflows
    comfyui.db           SQLite database
  extra_model_paths.yaml   Model directory mappings
```

### Environment cache: `$FLOX_ENV_CACHE/`

```
$FLOX_ENV_CACHE/
  venv/                Python virtual environment (--system-site-packages)
  comfyui-runtime/     Runtime mirror of store (symlinks + writable copies)
  .flox-pkgs/          Selective PYTHONPATH (CUDA torch + bundled scipy/numpy)
  temp/                ComfyUI temp files
  uv/                  uv package cache
  pip/                 pip package cache
```

## GPU support

The manifest uses Flox **pkg-groups** to select platform-appropriate packages. Only one package per group is installed -- the lowest priority number wins.

| Platform | torchvision | torchaudio | kornia |
|---|---|---|---|
| x86_64-linux | flox-cuda (priority 0) | flox-cuda (priority 3) | flox-cuda (priority 33) |
| aarch64-linux | flox-cuda (priority 0) | flox-cuda (priority 3) | -- |
| aarch64-darwin | nixpkgs (priority 6) | nixpkgs (priority 7) | -- |
| x86_64-darwin | nixpkgs (priority 6) | nixpkgs (priority 7) | -- |

**torch itself** is bundled inside `comfyui-complete` (CPU, from nixpkgs). The `comfyui-start` script builds a selective PYTHONPATH that places the Flox environment's CUDA torch *before* the bundled CPU torch, so GPU acceleration works without wrapping.

**`cuda-detection = true`** is set in `[options]`, enabling automatic CUDA library detection on Linux.

**Why kornia is x86_64-linux only**: kornia depends on kornia-rs which requires a Rust toolchain build. On other platforms it is installed via pip during setup.

## Model downloads

Models are not redistributable. External users must download them manually using the bundled scripts:

| Script | Model | Size | HF Token |
|---|---|---|---|
| `comfyui-download-sd15.py` | Stable Diffusion 1.5 | ~4.3 GB | No |
| `comfyui-download-sdxl.py` | Stable Diffusion XL 1.0 | ~6.9 GB | No |
| `comfyui-download-sd35.py` | Stable Diffusion 3.5 Large | ~23 GB | Yes |
| `comfyui-download-flux.py` | FLUX.1-dev | ~22 GB | Yes |

For gated models (SD 3.5, FLUX), set `HF_TOKEN` with a HuggingFace access token:

```bash
HF_TOKEN=hf_... comfyui-download-flux.py
```

All scripts respect `COMFYUI_MODELS_DIR` and `COMFYUI_WORK_DIR` for download location. Use `--dry-run` to preview.

Flox-internal environments auto-download SDXL + FLUX (~59 GB) on first activation via `get-models`.

## Configuration reference

All variables are defined in `[vars]` unless noted otherwise.

### Virtual environment

| Variable | Value | Description |
|---|---|---|
| `VIRTUAL_ENV` | `$FLOX_ENV_CACHE/venv` | Venv path |
| `VIRTUAL_ENV_DISABLE_PROMPT` | `1` | Suppress venv prompt prefix |

### Source and runtime locations

| Variable | Value | Description |
|---|---|---|
| `COMFYUI_SOURCE` | `$FLOX_ENV/share/comfyui` | Read-only store source |
| `COMFYUI_RUNTIME` | `$FLOX_ENV_CACHE/comfyui-runtime` | Writable runtime mirror |
| `COMFYUI_BASE_DIR` | `$FLOX_ENV_CACHE/comfyui-runtime` | `--base-directory` for ComfyUI |

### Mutable data directories

| Variable | Value | Description |
|---|---|---|
| `COMFYUI_WORK_DIR` | `$HOME/comfyui-work` | Base mutable data directory |
| `COMFYUI_MODELS_DIR` | `$HOME/comfyui-work/models` | Model files |
| `COMFYUI_OUTPUT_DIR` | `$HOME/comfyui-work/output` | Generated images |
| `COMFYUI_INPUT_DIR` | `$HOME/comfyui-work/input` | Input images |
| `COMFYUI_USER_DIR` | `$HOME/comfyui-work/user` | User settings and workflows |

### Server

| Variable | Value | Description |
|---|---|---|
| `COMFYUI_LISTEN` | `0.0.0.0` | Listen address |
| `COMFYUI_PORT` | `8188` | Listen port |

### Database

| Variable | Value | Description |
|---|---|---|
| `COMFYUI_DATABASE_URL` | `sqlite:///$HOME/comfyui-work/user/comfyui.db` | SQLite database path |

### Model configuration

| Variable | Value | Description |
|---|---|---|
| `COMFYUI_EXTRA_MODEL_PATHS` | `$HOME/comfyui-work/extra_model_paths.yaml` | Model path mappings file |

### Caches

| Variable | Value | Description |
|---|---|---|
| `COMFYUI_TEMP_DIR` | `$FLOX_ENV_CACHE/temp` | ComfyUI temp directory |
| `COMFYUI_VENV_DIR` | `$FLOX_ENV_CACHE/venv` | Venv directory |
| `UV_CACHE_DIR` | `$FLOX_ENV_CACHE/uv` | uv package cache |
| `PIP_CACHE_DIR` | `$FLOX_ENV_CACHE/pip` | pip package cache |

### Warnings

| Variable | Value | Description |
|---|---|---|
| `PYTHONWARNINGS` | `ignore::requests.exceptions.RequestsDependencyWarning` | Suppress upstream warning |

### Runtime overrides (set by user, not in `[vars]`)

| Variable | Default | Description |
|---|---|---|
| `COMFYUI_DEVICE` | `auto` | Force device: `auto`, `cpu`, `gpu` |
| `COMFYUI_ENABLE_MANAGER` | `1` | Toggle ComfyUI-Manager (`0` to disable) |
| `COMFYUI_RESET` | `0` | Force full cache reset on activation |
| `HF_TOKEN` | -- | HuggingFace token for gated model downloads |

## Installed packages

| Name | Source | Details | Purpose |
|---|---|---|---|
| comfyui | flox/comfyui-complete | 0.15.0+f04d744 | ComfyUI + all deps + custom nodes + scripts |
| python | python313Full | priority 5 | Python 3.13 runtime |
| uv | uv | priority 5 | Fast Python package installer |
| curl | curl | -- | HTTP utility |
| gcc-unwrapped | gcc-unwrapped | priority 6 | Build tools (needed by some pip packages) |
| cuda-torchvision | flox-cuda/python3Packages.torchvision | 0.25.0, priority 0 | CUDA torchvision (x86_64/aarch64-linux) |
| cuda-torchaudio | flox-cuda/python3Packages.torchaudio | 2.10.0, priority 3 | CUDA torchaudio (x86_64/aarch64-linux) |
| torchvision | python313Packages.torchvision | priority 6 | CPU torchvision (aarch64-linux, macOS) |
| torchaudio | python313Packages.torchaudio | priority 7 | CPU torchaudio (aarch64-linux, macOS) |
| torchsde | store-path | 0.2.6 | SDE sampler support (not in nixpkgs) |
| kornia | flox-cuda/python3Packages.kornia | priority 33 | GPU computer vision (x86_64-linux only) |
| awscli2 | awscli2 | -- | AWS CLI for model downloads |

## Service

The manifest defines a single service:

```toml
[services.comfyui]
command = "comfyui-start"
```

### What `comfyui-start` does

1. Builds a selective PYTHONPATH at `$FLOX_ENV_CACHE/.flox-pkgs/` -- symlinks all Flox env site-packages (including CUDA torch) but substitutes scipy and numpy with the bundled pythonEnv versions to avoid Frankenstein merges
2. Detects GPU via `torch.accelerator.current_accelerator()` (falls back to CUDA/MPS checks for older torch)
3. Launches `$FLOX_ENV_CACHE/comfyui-runtime/main.py` with all configured flags (`--listen`, `--port`, `--base-directory`, `--extra-model-paths-config`, `--enable-manager`, etc.)

### The `start` convenience script

Running `start` from within the environment:

1. Starts the comfyui service (if not already running)
2. Polls `http://localhost:$COMFYUI_PORT` until the server responds (up to 30 seconds)
3. Opens the URL in the default browser (supports Linux, macOS, and WSL)

## Bundled content

The `comfyui-complete` package bundles 22 custom node packages and example workflows. See the [build-comfyui README](https://github.com/barstoolbluz/build-comfyui) for the full custom node inventory, patches, and build architecture.

Custom node categories included:
- **Core**: Impact Pack, Impact Subpack
- **Workflow**: rgthree, efficiency-nodes, Comfyroll, KJNodes, essentials, Custom-Scripts
- **Image**: WAS Node Suite, Image Saver, images-grid, UltimateSDUpscale, mxToolkit, LayerForge, SafeCLIP-SDXL
- **IP Adapter**: IPAdapter Plus, IPAdapter Flux
- **ControlNet**: comfyui_controlnet_aux (Canny, HED, depth, pose, segmentation, etc.)
- **Video**: AnimateDiff Evolved, VideoHelperSuite, LTXVideo, WanVideoWrapper

## Known issues

- **Do NOT add flox-cuda scipy/numpy to the manifest.** The bundled versions from comfyui-complete's pythonEnv are correct. Adding flox-cuda scipy/numpy causes Frankenstein merges where files from different versions coexist in the same merged directory, breaking imports. See the [build-comfyui README](https://github.com/barstoolbluz/build-comfyui) for the full explanation.
- **comfyui-start is intentionally not wrapped.** It sets PYTHONPATH at runtime to prioritize Flox env CUDA torch over the bundled CPU torch. Wrapping with `--prefix PYTHONPATH` would put CPU torch first, breaking GPU detection.
- **torchaudio version gap.** nixpkgs has torchaudio 2.10.0 which is incompatible with the bundled torch 2.9.1 (`torch/csrc/stable/device.h` missing). The manifest provides torchaudio separately for all platforms.
- **macOS file descriptors.** The on-activate hook raises the limit from the macOS default of 256 to 10240 to prevent "too many open files" errors.

## Local development

### Testing a local build

```bash
# 1. Build comfyui-complete
cd ~/dev/builds/build-comfyui && flox build comfyui-complete

# 2. Get the store path
readlink -f result-comfyui-complete

# 3. Edit manifest.toml: update the store-path
comfyui.store-path = "/nix/store/<hash>-comfyui-complete-0.15.0+<rev>"

# 4. Test
flox activate
```

### Switching back to a published package

If you switched to a store-path for testing, revert to the published package:

```toml
# comfyui.store-path = "/nix/store/..."
comfyui.pkg-path = "flox/comfyui-complete"
comfyui.pkg-group = "comfyui"
comfyui.priority = 0
comfyui.version = "0.15.0+f04d744"
```

## Kubernetes (Imageless / Uncontained)

Starter manifests for deploying ComfyUI on Kubernetes using the Flox Imageless Kubernetes pattern are in `k8s/`. No container image build is needed -- the Flox containerd shim pulls the environment from FloxHub at pod startup.

**Prerequisites**: Flox containerd shim installed on nodes, `RuntimeClass "flox"` applied to the cluster, NVIDIA GPU device plugin. See the [Flox Imageless Kubernetes docs](https://flox.dev/docs/kubernetes/) for cluster setup.

```bash
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/pvc.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

Before deploying, review the manifests and adjust:
- **`k8s/pvc.yaml`**: Set `storageClassName` for your cluster
- **`k8s/deployment.yaml`**: CPU/memory requests, HF_TOKEN secret (for gated models), PVC mount path if not running as root
- **`k8s/service.yaml`**: Change to `LoadBalancer`/`NodePort` or add an Ingress for external access

Models must be pre-loaded onto the PVC or downloaded after the pod starts. First activation takes several minutes (venv creation, pip installs).

## Related repositories

- [build-comfyui](https://github.com/barstoolbluz/build-comfyui) -- Build repo: Nix derivation, custom nodes, patches, Python deps, build versioning
- [build-torchsde](https://github.com/barstoolbluz/build-torchsde) -- torchsde without scipy/numpy dependencies (prevents profile merge conflicts)
- [build-comfyui-packages](https://github.com/barstoolbluz/build-comfyui-packages) -- Torch-agnostic Python packages (ultralytics, timm, open-clip, etc.)
- [ComfyUI](https://github.com/comfyanonymous/ComfyUI) -- Upstream application

## License

ComfyUI is licensed under GPL-3.0. Packaging infrastructure is MIT.

# whichllm

Find the best open LLM that runs on your hardware. `whichllm` detects your GPU, CPU, and RAM, pulls the current list of popular models from Hugging Face, and ranks them by benchmark quality, by whether they fit in VRAM (or RAM), and by estimated speed. It also answers the reverse question: what hardware a given model needs.

- **Hardware detection** - NVIDIA (NVML or `nvidia-smi`), AMD (`rocm-smi` or sysfs), Apple Silicon, and Intel GPUs, plus CPU features and RAM
- **Quantization-aware** - Picks a GGUF quantization (Q4_K_M, Q6_K, Q8_0, ...) per model and estimates its memory use for your context length
- **Benchmark-ranked** - Quality scores from a curated snapshot, merged with live leaderboard data when it can be fetched
- **What-if** - Rank for a GPU you don't have, or compare your machine against possible upgrades
- **No account** - No sign-up or API key
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd whichllm
flox activate
```

### 2. Rank Models for This Machine

```bash
whichllm                     # top 10 models
whichllm hardware            # what was detected
```

The first run fetches model and benchmark data, which takes from about 20 seconds to a minute, depending on the network; later runs use the cache.

### 3. Ask Other Questions

```bash
whichllm --profile coding -c 32k          # rank for coding, sized for a 32k context
whichllm --gpu "RTX 4090"                 # rank for a GPU you don't have (also "2x RTX 4090")
whichllm plan "Qwen/Qwen3-8B"             # VRAM needed per quantization
whichllm upgrade "RTX 5090" "RTX 4090"    # compare this machine with other GPUs
whichllm --json                           # machine-readable: "hardware" plus ranked "models"
```

## Hardware Detection

On Linux, NVIDIA GPUs are found through NVML, falling back to `nvidia-smi` on your `PATH`; AMD GPUs through `rocm-smi` or `/sys/class/drm`; Intel GPUs through `/sys/class/drm`. On macOS, `system_profiler` reports the Apple Silicon chip and its unified memory. Run `whichllm hardware` to see what it found.

This environment was tested on a Linux machine with an Intel integrated GPU, where detection worked from inside the environment. It was not tested with an NVIDIA or AMD GPU, or on macOS. If your GPU is missing, `--gpu "<name>"` (with `--vram <GB>` if needed) ranks for it anyway.

On a machine whose only GPU is an Intel integrated one, whichllm counts the shared memory as VRAM and reports models as "Full GPU" at 0.0 tok/s. Use `--cpu-only` there for realistic speed estimates.

## Running a Model

whichllm recommends; it doesn't serve models. To run a pick, use one of this repository's local inference environments with the model and quantization from the ranking: [ollama](../ollama), [llamacpp](../llamacpp), or [lmstudio](../lmstudio) (e.g. `lms get <repo>`).

whichllm has its own `whichllm run`, which downloads a model and starts a chat, and `whichllm snippet`, which prints a script that does the same. Both use `uv` to install `llama-cpp-python` or `torch` on the fly, and `uv` isn't part of this environment; layer an environment that provides it if you want to use them.

## Network Access and Cache

whichllm reads public data: the Hugging Face model API (`huggingface.co`, or `HF_ENDPOINT`) and leaderboard data from Hugging Face datasets, Artificial Analysis, LiveBench, and Aider's GitHub repository. It sends no API key or Hugging Face token, and has no telemetry.

Results are cached in `~/.cache/whichllm` (or `$XDG_CACHE_HOME/whichllm`), about 1 MB: model data for 6 hours, benchmark data for 24 hours. `--refresh` ignores the cache.

## Python on PATH

The package is a Python virtual environment, and its `bin/` directory is linked into the environment as a whole. Besides `whichllm`, the environment puts `python`, `python3` (3.13), `activate`, and a few library commands (`httpx`, `typer`, `markdown-it`, `pygmentize`, `dbgpu`) on your `PATH`. If you layer this environment on top of a Python project's environment, `python3` comes from whichllm's virtual environment; activate whichllm first, or run it with `flox activate -d /path/to/whichllm -- whichllm`.

## Configuration

| Variable | Default | Effect |
|----------|---------|--------|
| `HF_ENDPOINT` | `https://huggingface.co` | Hugging Face API endpoint (e.g. a mirror) |
| `XDG_CACHE_HOME` | `~/.cache` | Base directory for the `whichllm` cache |

## Helper Commands

```bash
whichllm-info    # Show version, cache location, and command reference
```

## Resources

- [whichllm GitHub](https://github.com/Andyyyy64/whichllm)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For whichllm-specific issues:
- [whichllm GitHub Issues](https://github.com/Andyyyy64/whichllm/issues)

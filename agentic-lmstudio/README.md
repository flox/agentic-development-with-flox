# Agentic LM Studio

Local LLM inference paired with agentic CLI coding tools. Run models on your own hardware with LM Studio and use them as the backend for Claude Code, Codex, and OpenCode.

LM Studio exposes OpenAI-compatible and Anthropic-compatible API endpoints. This environment provides `lms-launch`, a helper that configures each agentic tool to use the local LM Studio server instead of cloud providers.

## Features

- **Local LLM Inference** - Run models locally with llama.cpp (all platforms) or MLX (Apple Silicon)
- **GPU Acceleration** - NVIDIA CUDA on Linux (auto-detected), Metal on macOS (native)
- **Agentic CLI Tools** - Claude Code, Codex, and OpenCode pre-installed
- **`lms-launch` Helper** - One command to download, load, and launch any agentic tool
- **OpenAI-Compatible API** - Local server on port 1234, drop-in replacement for OpenAI SDK clients
- **Anthropic-Compatible API** - `/v1/messages` endpoint for Claude Code compatibility
- **Context Window Control** - Set context length per model at load time
- **Model Discovery** - Search and download models from Hugging Face with quantization selection
- **Tool Calling** - Function calling and structured output (JSON schema) support
- **MCP Support** - Flox MCP server for environment management from AI agents
- **Headless Service** - Runs as a Flox-managed service via `lms-service`
- **Cross-Platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd agentic-lmstudio
flox activate -s
```

### 2. Launch an Agentic Tool

```bash
lms-launch claude --model zai-org/glm-4.7-flash
```

That's it. `lms-launch` automatically downloads the model (if needed), loads it with a 131072 context window (if not already loaded), and launches the tool.

Other tools work the same way:

```bash
lms-launch codex --model zai-org/glm-4.7-flash
lms-launch opencode --model zai-org/glm-4.7-flash
```

### Options

```bash
# Custom context window (default: 131072, or set LMS_CONTEXT_LENGTH)
lms-launch claude --model zai-org/glm-4.7-flash --context-length 65536

# Explicit GPU offload (auto-detected on CUDA systems)
lms-launch claude --model zai-org/glm-4.7-flash --gpu max

# Extra arguments pass through to the tool
lms-launch claude --model zai-org/glm-4.7-flash --verbose
```

Use `lms ls` or `lms-models` to see which models are currently loaded.

## GPU Support

### Linux (NVIDIA CUDA)

The lmstudio package automatically detects and passes through NVIDIA GPU drivers into its sandbox. No extra configuration needed -- if `nvidia-smi` works on your host, LM Studio will use your GPU.

On first run, LM Studio may default to CPU inference. If this happens, the CUDA backend can be selected via LM Studio's backend preferences (`~/.lmstudio/.internal/backend-preferences-v1.json`).

Use `--gpu max` when loading to offload all layers to GPU:

```bash
lms load zai-org/glm-4.7-flash --context-length 65536 --gpu max
```

### macOS (Metal)

Metal acceleration is native on Apple Silicon. All inference runs on GPU by default -- no configuration needed.

## Recommended Models

Models with strong tool-use / function-calling support work best for agentic workflows.

| Model | Sizes | Strengths |
|-------|-------|-----------|
| GLM-4.7-Flash | 9B | Fast tool calling, large context, strong reasoning |
| Gemma 4 E4B | 4B | Efficient, good for constrained hardware |
| Qwen 2.5 Coder Instruct | 7B, 14B, 32B | Purpose-built for code generation and tool calling |
| Llama 3.1 Instruct | 8B, 70B | Strong tool use, large context, general purpose |
| DeepSeek Coder V2 | 16B, 236B | Code generation specialist with function calling |
| Mistral Instruct | 7B | Fast, general purpose, good tool support |

Download with:
```bash
lms get zai-org/glm-4.7-flash
lms get bartowski/Qwen2.5-Coder-14B-Instruct-GGUF
lms get bartowski/Meta-Llama-3.1-8B-Instruct-GGUF
```

## The `lms-launch` Command

`lms-launch` is a one-command workflow that downloads, loads, and launches an agentic CLI tool against a local LM Studio model.

### Usage

```bash
lms-launch <tool> --model <model> [options] [extra args...]
```

### Supported Tools

| Tool | Command | API Used |
|------|---------|----------|
| Claude Code | `lms-launch claude --model <m>` | Anthropic-compatible (`/v1/messages`) |
| Codex | `lms-launch codex --model <m>` | OpenAI-compatible (`/v1/chat/completions`) |
| OpenCode | `lms-launch opencode --model <m>` | OpenAI-compatible (`/v1/chat/completions`) |

### Options

| Option | Default | Description |
|--------|---------|-------------|
| `--model <model>` | _(required)_ | Model to use |
| `--context-length <n>` | `131072` | Context window size (override with `LMS_CONTEXT_LENGTH`) |
| `--gpu <mode>` | `max` if CUDA detected | GPU offload mode (`max`, `off`, etc.) |

Extra arguments are passed through to the tool.

### How It Works

1. **Health check** -- verifies the LM Studio API server is running
2. **Model check** -- queries `/v1/models` to see if the model is already loaded
3. **Auto-load** -- if not loaded, runs `lms load` with the specified context length and GPU settings
4. **Auto-download** -- if `lms load` fails (model not on disk), runs `lms get` to download it, then retries the load
5. **Launch** -- sets the provider environment variables and launches the tool

Provider environment variables set per tool:

- **Claude Code**: `ANTHROPIC_BASE_URL=http://localhost:1234` + `ANTHROPIC_AUTH_TOKEN=lmstudio`
- **Codex**: `OPENAI_BASE_URL=http://localhost:1234/v1` + `OPENAI_API_KEY=lm-studio`
- **OpenCode**: `OPENAI_BASE_URL=http://localhost:1234/v1` + `OPENAI_API_KEY=lm-studio`

### Examples

```bash
# One command: download, load, and launch
lms-launch claude --model zai-org/glm-4.7-flash

# Custom context window
lms-launch codex --model zai-org/glm-4.7-flash --context-length 65536

# Explicit GPU offload
lms-launch opencode --model zai-org/glm-4.7-flash --gpu max

# Pass extra arguments through to the tool
lms-launch claude --model zai-org/glm-4.7-flash --verbose
```

### First-Run Setup

**Codex**: On first launch, Codex prompts you to choose an API key provider. Select **"Provide your own API key"** and enter `lm-studio` (the default key set by `lms-launch`). This only needs to be done once -- Codex remembers the choice for subsequent runs.

**Claude Code**: No first-run setup needed. `lms-launch` sets the environment variables automatically.

**OpenCode**: No first-run setup needed. `lms-launch` sets the environment variables automatically.

## Environment Variables

All configuration via environment variables with sensible defaults. Override at activation time.

| Variable | Default | Description |
|----------|---------|-------------|
| `LMS_PORT` | `1234` | API server port |
| `LMS_HOST` | `127.0.0.1` | API server bind address |
| `LMS_GUI` | `false` | Launch GUI on activation (`true`/`false`) |
| `LMS_CORS_ORIGIN` | `*` | CORS allowed origins |
| `LMS_CONTEXT_LENGTH` | `131072` | Default context window for `lms-launch` auto-load |

## Usage Examples

### Headless Server (Default)

```bash
flox activate -s
# Service starts LM Studio + API server on 127.0.0.1:1234
```

### Network Accessible

```bash
LMS_HOST=0.0.0.0 flox activate -s
# API server listens on all interfaces
```

### Custom Port

```bash
LMS_PORT=8080 flox activate -s
```

### With GUI

```bash
LMS_GUI=true flox activate
# GUI launches in background; use flox activate -s to also start the API server
```

### Full Agentic Workflow

```bash
# Start the environment with services
cd agentic-lmstudio && flox activate -s

# Download, load, and launch — all in one command
lms-launch claude --model zai-org/glm-4.7-flash
```

## Commands

### Agentic Tool Launcher

```bash
lms-launch <tool> --model <m> [opts]   # Download, load, and launch tool
lms-launch                              # Show usage and supported tools
```

### Helper Commands

```bash
lmstudio-info              # Show current configuration and available commands
lmstudio-health            # Test API endpoint and list loaded models
lms-models                 # List currently loaded models
helpf                      # View full README documentation
```

### Model Management

```bash
lms get <model>                           # Download a model from Hugging Face
lms load <model> --context-length 65536   # Load a model with context window
lms load <model> --gpu max                # Load with full GPU offload (Linux)
lms ps                                    # Show loaded models and their status
lms chat                                  # Interactive terminal chat
```

### Service Management

```bash
flox services start        # Start LM Studio service
flox services status       # Check service status
flox services logs         # View service logs
flox services stop         # Stop all services
flox services restart      # Restart all services
```

## How the Service Works

The `lms-service` script (shipped with the lmstudio package) handles headless operation:

**Linux:**
1. Starts a virtual framebuffer (Xvfb) since Electron requires X11 even headless
2. Passes through NVIDIA GPU drivers into the bubblewrap sandbox
3. Launches `lm-studio --run-as-service` in the background
4. Waits for initialization, then starts the API server via `lms server start`
5. Keeps the process alive for Flox service management

**macOS:**
1. Launches `lm-studio --run-as-service` in the background
2. Waits for initialization, then starts the API server via `lms server start`
3. Keeps the process alive for Flox service management

No Xvfb or GPU driver passthrough is needed on macOS -- Metal acceleration is native.

## API Endpoints

The local server (default port 1234) exposes:

| Endpoint | Compatibility | Description |
|----------|---------------|-------------|
| `/v1/chat/completions` | OpenAI | Chat completions (streaming, tool calling) |
| `/v1/completions` | OpenAI | Text completions |
| `/v1/embeddings` | OpenAI | Generate embeddings |
| `/v1/models` | OpenAI | List loaded models |
| `/v1/messages` | Anthropic | Anthropic-compatible messages API |

## Composition Examples

### As an Inference Backend for Another Project

```toml
[include]
environments = [
  { dir = "../agentic-lmstudio" },
]
```

### With PostgreSQL for RAG

```toml
[include]
environments = [
  { dir = "../agentic-lmstudio" },
  { dir = "../postgres" },
]
```

## Inference Backends

- **llama.cpp** - Default on all platforms. GGUF model format, continuous batching, speculative decoding, structured output
- **Apple MLX** - Optimized for Apple Silicon (M1-M4+). Metal acceleration, vision model support via mlx-vlm

## Supported Platforms

| Platform | GPU | Status |
|----------|-----|--------|
| Linux x86_64 | NVIDIA CUDA (auto-detected) | Supported |
| Linux aarch64 | NVIDIA CUDA (auto-detected) | Supported |
| macOS Apple Silicon | Metal (native) | Supported |
| macOS Intel | N/A | Not available |

## Troubleshooting

### Server Not Responding

```bash
flox services status
flox services logs lm-studio
flox services restart
```

### No Models Loaded

```bash
# Check what's loaded
lms-models

# lms-launch auto-downloads and loads, so just run:
lms-launch claude --model zai-org/glm-4.7-flash

# Or load manually:
lms load zai-org/glm-4.7-flash --context-length 65536
```

### `lms-launch` Says API Not Responding

The LM Studio server must be running before launching an agentic tool:

```bash
# Start the server first
flox activate -s

# Wait for startup (service logs will show "API server started")
flox services logs lm-studio

# Then launch
lms-launch claude --model zai-org/glm-4.7-flash
```

### Tool Uses Cloud Provider Instead of Local Model

`--model` is required. Without it, `lms-launch` shows an error:

```bash
# Error -- --model is required
lms-launch claude

# Correct -- Claude Code uses the local model via LM Studio
lms-launch claude --model zai-org/glm-4.7-flash
```

### GPU Not Detected (Linux)

If LM Studio defaults to CPU on a system with an NVIDIA GPU:

1. Verify the GPU is visible: `nvidia-smi`
2. Check that the CUDA backend is selected in `~/.lmstudio/.internal/backend-preferences-v1.json`
3. Load with explicit GPU offload: `lms load <model> --gpu max`

### Daemon Failed to Start

```bash
# Check if another instance is running
lms status

# Check logs
cat ~/.lmstudio/logs/lm-studio.log
```

## Resources

- [LM Studio](https://lmstudio.ai/)
- [LM Studio Documentation](https://lmstudio.ai/docs/app)
- [Developer / API Docs](https://lmstudio.ai/docs/developer)
- [OpenAI Compatibility](https://lmstudio.ai/docs/developer/openai-compat)
- [Headless Mode](https://lmstudio.ai/docs/developer/core/headless)
- [Changelog](https://lmstudio.ai/changelog)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For LM Studio-specific issues:
- [LM Studio Documentation](https://lmstudio.ai/docs/app)
- [LM Studio Discord](https://discord.gg/lmstudio)

# LM Studio

Desktop application and local inference server for discovering, downloading, and running large language models on your own hardware.

Runs as a Flox-managed headless service by default. The GUI can be optionally launched via `LMS_GUI=true`.

For a batteries-included environment that bundles Claude Code, Codex, and OpenCode with the `lms-launch` helper, see [agentic-lmstudio](../agentic-lmstudio).

## Features

- **Local LLM Inference** - Run models locally with llama.cpp (all platforms) or MLX (Apple Silicon)
- **GPU Acceleration** - NVIDIA CUDA on Linux (auto-detected), Metal on macOS (native)
- **Model Discovery** - Search and download models from Hugging Face with quantization selection
- **Context Window Control** - Set context length per model at load time
- **OpenAI-Compatible API** - Local server on port 1234, drop-in replacement for OpenAI SDK clients
- **Anthropic-Compatible API** - `/v1/messages` endpoint for Anthropic SDK compatibility
- **Headless Service** - Runs as a Flox-managed service via `lms-service`
- **CLI Control** - `lms` CLI for model management, chat, and server control
- **Tool Calling** - Function calling and structured output (JSON schema) support
- **Composable** - Designed to be included in other Flox environments
- **Cross-Platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate and Start the Service

```bash
cd lmstudio
flox activate -s
```

The headless service starts automatically and the API server listens on `http://localhost:1234`.

### 2. Download a Model

```bash
lms get zai-org/glm-4.7-flash
```

Or browse interactively: `lms get` (no arguments)

### 3. Load a Model with Context Window

```bash
lms load zai-org/glm-4.7-flash --context-length 65536
```

The `--context-length` flag sets the maximum context window. Larger values use more VRAM/RAM. Common values: `4096`, `8192`, `32768`, `65536`, `131072`.

### 4. Query the API

```bash
curl http://localhost:1234/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "zai-org/glm-4.7-flash",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

## GPU Support

### Linux (NVIDIA CUDA)

The lmstudio package automatically detects and passes through NVIDIA GPU drivers into its sandbox. No extra configuration needed -- if `nvidia-smi` works on your host, LM Studio will use your GPU.

Use `--gpu max` when loading to offload all layers to GPU:

```bash
lms load zai-org/glm-4.7-flash --context-length 65536 --gpu max
```

### macOS (Metal)

Metal acceleration is native on Apple Silicon. All inference runs on GPU by default -- no configuration needed.

## Using with AI Coding Tools

This environment provides LM Studio as an inference server. You can point any OpenAI- or Anthropic-compatible tool at it:

### Claude Code

```bash
ANTHROPIC_BASE_URL=http://localhost:1234 \
ANTHROPIC_AUTH_TOKEN=lmstudio \
ANTHROPIC_API_KEY= \
  claude --model zai-org/glm-4.7-flash
```

### Codex

```bash
OPENAI_BASE_URL=http://localhost:1234/v1 \
OPENAI_API_KEY=lm-studio \
  codex --model zai-org/glm-4.7-flash
```

### OpenCode

```bash
OPENAI_BASE_URL=http://localhost:1234/v1 \
OPENAI_API_KEY=lm-studio \
  opencode --model zai-org/glm-4.7-flash
```

**Always pass `--model`** -- without it, tools default to their cloud provider instead of the local model.

For an environment that bundles these tools with the `lms-launch` helper, see [agentic-lmstudio](../agentic-lmstudio).

## Recommended Models

Models with strong tool-use / function-calling support work best with AI coding tools.

| Model | Sizes | Strengths |
|-------|-------|-----------|
| GLM-4.7-Flash | 9B | Fast tool calling, large context, strong reasoning |
| Gemma 4 E4B | 4B | Efficient, good for constrained hardware |
| Qwen 2.5 Coder Instruct | 7B, 14B, 32B | Purpose-built for code generation and tool calling |
| Llama 3.1 Instruct | 8B, 70B | Strong tool use, large context, general purpose |

Download with:
```bash
lms get zai-org/glm-4.7-flash
lms get bartowski/Qwen2.5-Coder-14B-Instruct-GGUF
```

## Environment Variables

All configuration via environment variables with sensible defaults. Override at activation time.

| Variable | Default | Description |
|----------|---------|-------------|
| `LMS_PORT` | `1234` | API server port |
| `LMS_HOST` | `127.0.0.1` | API server bind address |
| `LMS_GUI` | `false` | Launch GUI on activation (`true`/`false`) |
| `LMS_CORS_ORIGIN` | `*` | CORS allowed origins |

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

## Commands

### Helper Commands

```bash
lmstudio-info              # Show current configuration and available commands
lmstudio-health            # Test API endpoint and list loaded models
lms-models                 # List currently loaded models
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
  { dir = "../lmstudio" },
]
```

### With Open WebUI

```toml
[include]
environments = [
  { dir = "../lmstudio" },
  { dir = "../open-webui" },
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
lms-models
lms load zai-org/glm-4.7-flash --context-length 65536
```

### GPU Not Detected (Linux)

1. Verify the GPU is visible: `nvidia-smi`
2. Check backend preferences: `~/.lmstudio/.internal/backend-preferences-v1.json`
3. Load with explicit GPU offload: `lms load <model> --gpu max`

### Daemon Failed to Start

```bash
lms status
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

# Agentic LM Studio

Local LLM inference paired with agentic CLI coding tools. Run models on your own hardware with LM Studio and use them as the backend for Claude Code, Codex, and OpenCode.

Unlike Ollama's built-in `ollama launch` integration, LM Studio exposes OpenAI-compatible and Anthropic-compatible API endpoints. This environment provides `lms-launch`, a helper that configures each agentic tool to use the local LM Studio server automatically.

## Features

- **Local LLM Inference** - Run models locally with llama.cpp (all platforms) or MLX (Apple Silicon)
- **Agentic CLI Tools** - Claude Code, Codex, and OpenCode pre-installed and ready to connect
- **`lms-launch` Helper** - One command to wire any agentic tool to your local LM Studio server
- **OpenAI-Compatible API** - Local server on port 1234 with drop-in replacement for OpenAI SDK clients
- **Anthropic-Compatible API** - `/v1/messages` endpoint for Claude Code compatibility
- **Model Discovery** - Search and download models from Hugging Face with quantization selection
- **Tool Calling** - Function calling and structured output (JSON schema) support
- **MCP Support** - Flox MCP server for environment management from AI agents
- **Headless Service** - Runs as a Flox-managed service via `lms daemon` + `lms server`
- **Cross-Platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd agentic-lmstudio
flox activate
```

### 2. Download a Model

```bash
lms get bartowski/Meta-Llama-3.1-8B-Instruct-GGUF
```

Or use the GUI: `LMS_GUI=true flox activate`

### 3. Start the Server and Load a Model

```bash
flox activate -s
lms load llama-3.1-8b-instruct
```

### 4. Launch an Agentic Tool

```bash
lms-launch claude
lms-launch codex
lms-launch opencode
```

## Recommended Models

Models with strong tool-use / function-calling support work best for agentic workflows.

| Model | Sizes | Strengths |
|-------|-------|-----------|
| Llama 3.1 Instruct | 8B, 70B | Strong tool use, large context, general purpose |
| Qwen 2.5 Coder Instruct | 7B, 14B, 32B | Purpose-built for code generation and tool calling |
| DeepSeek Coder V2 | 16B, 236B | Code generation specialist with function calling |
| Mistral Instruct | 7B | Fast, general purpose, good tool support |
| Gemma 2 Instruct | 9B, 27B | Efficient reasoning with tool use |
| Phi-3.5 Mini Instruct | 3.8B | Small but capable, runs on limited hardware |

Download with:
```bash
lms get bartowski/Meta-Llama-3.1-8B-Instruct-GGUF
lms get bartowski/Qwen2.5-Coder-14B-Instruct-GGUF
```

## The `lms-launch` Command

`lms-launch` is the core helper that bridges LM Studio with agentic CLI tools. It sets the correct environment variables for each tool and launches it against the local server.

### Usage

```bash
lms-launch <tool> [--model <model>] [extra args...]
```

### Supported Tools

| Tool | Command | API Used |
|------|---------|----------|
| Claude Code | `lms-launch claude` | Anthropic-compatible (`/v1/messages`) |
| Codex | `lms-launch codex` | OpenAI-compatible (`/v1/chat/completions`) |
| OpenCode | `lms-launch opencode` | OpenAI-compatible (`/v1/chat/completions`) |

### How It Works

For each tool, `lms-launch` sets the provider environment variables to point at the local LM Studio server:

- **Claude Code**: `ANTHROPIC_API_BASE_URL=http://localhost:1234` + `ANTHROPIC_API_KEY=lm-studio`
- **Codex**: `OPENAI_BASE_URL=http://localhost:1234/v1` + `OPENAI_API_KEY=lm-studio`
- **OpenCode**: `OPENAI_BASE_URL=http://localhost:1234/v1` + `OPENAI_API_KEY=lm-studio`

Before launching, it performs a health check to verify the server is running and provides helpful diagnostics if not.

### Examples

```bash
# Launch Claude Code with default settings
lms-launch claude

# Launch Claude Code and pass a model flag through
lms-launch claude --model llama-3.1-8b-instruct

# Launch Codex
lms-launch codex

# Launch OpenCode
lms-launch opencode

# Pass extra arguments through to the tool
lms-launch claude --verbose
```

## Environment Variables

All configuration is done via environment variables with sensible defaults. Override at activation time.

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
# Daemon + API server start, listening on 127.0.0.1:1234
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

### Agentic Development Workflow

```bash
# Terminal 1: Start the server
cd agentic-lmstudio && flox activate -s

# Terminal 2: Download and load a model, then launch an agent
flox activate
lms get bartowski/Qwen2.5-Coder-14B-Instruct-GGUF
lms load qwen2.5-coder-14b-instruct
lms-launch claude --model qwen2.5-coder-14b-instruct
```

## Commands

### Agentic Tool Launcher

```bash
lms-launch <tool> [args]   # Launch an agentic tool via LM Studio
lms-launch                  # Show usage and supported tools
```

### Helper Functions

```bash
lmstudio-info              # Show current configuration and available commands
lmstudio-health            # Test API endpoint and list loaded models
lms-models                 # List currently loaded models
helpf                      # View full README documentation
```

### Model Management

```bash
lms get <model>            # Download a model from Hugging Face
lms load <model>           # Load a model into memory
lms chat                   # Interactive terminal chat
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
| `/api/v1/` | Native | Stateful chat and model management |

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

| Platform | Status |
|----------|--------|
| Linux x86_64 | Supported |
| Linux aarch64 | Supported |
| macOS Apple Silicon | Supported |
| macOS Intel | Not available |

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

# Load a model
lms load llama-3.1-8b-instruct
```

### `lms-launch` Says API Not Responding

The LM Studio server must be running before launching an agentic tool:

```bash
# Start the server first
flox activate -s

# Wait a moment for startup, then launch
lms-launch claude
```

### Daemon Failed to Start

```bash
# Check if another instance is running
lms status

# Check logs
cat $FLOX_ENV_CACHE/logs/lm-studio.log
```

### Tool Fails to Connect

If an agentic tool launches but fails to connect to the model:

1. Verify a model is loaded: `lms-models`
2. Test the API directly: `lmstudio-health`
3. Check that the model supports tool/function calling
4. Try a different model known for good tool support (e.g., Llama 3.1 Instruct, Qwen 2.5 Coder)

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

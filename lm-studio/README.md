# LM Studio

Desktop application and local inference server for discovering, downloading, and running large language models on your own hardware. Version 0.4.9.

Runs as a Flox-managed headless service by default. The GUI can be optionally launched via `LMS_GUI=true`.

## Features

- **Local LLM Inference** - Run models locally with llama.cpp (all platforms) or MLX (Apple Silicon)
- **Model Discovery** - Search and download models from Hugging Face with quantization selection
- **OpenAI-Compatible API** - Local server on port 1234 with drop-in replacement for OpenAI SDK clients
- **Anthropic-Compatible API** - `/v1/messages` endpoint for Anthropic SDK compatibility
- **Headless Service** - Runs as a Flox-managed service via `lms daemon` + `lms server`
- **CLI Control** - `lms` CLI for model management, chat, and server control
- **Tool Calling** - Function calling and structured output (JSON schema) support
- **MCP Support** - Model Context Protocol server integration for local agents
- **Parallel Requests** - Configurable concurrent inference slots (default 4)
- **Composable** - Designed to be included in other Flox environments
- **Cross-Platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate and Start the Service

```bash
cd lm-studio
flox activate -s
```

The headless daemon starts automatically and the API server listens on `http://localhost:1234`.

### 2. Download a Model

```bash
lms get bartowski/Meta-Llama-3.1-8B-Instruct-GGUF
```

Or use the GUI: `LMS_GUI=true flox activate`

### 3. Load and Query

```bash
# Load a model
lms load llama-3.1-8b-instruct

# Query the API
curl http://localhost:1234/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "llama-3.1-8b-instruct",
    "messages": [{"role": "user", "content": "Hello!"}]
  }'
```

## Environment Variables

All configuration is done via environment variables with sensible defaults.

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

### Multiple Overrides

```bash
LMS_HOST=0.0.0.0 LMS_PORT=8080 flox activate -s
```

## Commands

### Helper Functions

```bash
lmstudio-info              # Show current configuration
lmstudio-health            # Test API endpoint and list loaded models
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

## CLI Reference

The `lms` CLI provides full control:

| Command | Description |
|---------|-------------|
| `lms daemon up` | Start the headless daemon (managed by Flox service) |
| `lms get <model>` | Download a model from Hugging Face |
| `lms load <model>` | Load a model into memory |
| `lms server start` | Start the API server (managed by Flox service) |
| `lms server status` | Check server status |
| `lms chat` | Interactive terminal chat session |
| `lms status` | Show daemon status |
| `lms push` / `lms clone` | Publish or clone models to/from Hub |

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

### As an Inference Backend for Open WebUI

```toml
[include]
environments = [
  { dir = "../lm-studio" },
  { dir = "../open-webui" },
]

[vars]
BACKEND = "llamacpp"
BACKEND_PORT = "1234"
```

### With an AI Coding Tool

```toml
[include]
environments = [
  { dir = "../lm-studio" },
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

### Check Service Status

```bash
flox services status
```

### View Logs

```bash
flox services logs lm-studio
# or directly:
cat $FLOX_ENV_CACHE/logs/lm-studio.log
```

### Test API Health

```bash
lmstudio-health
# or
curl http://localhost:1234/v1/models
```

### Common Issues

**"LM Studio API is not responding"**
```bash
flox services status
flox services logs lm-studio
flox services restart
```

**"Daemon failed to start"**
```bash
# Check if another instance is running
lms status
# Check logs
cat $FLOX_ENV_CACHE/logs/lm-studio.log
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

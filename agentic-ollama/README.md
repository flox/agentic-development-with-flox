# Agentic Ollama - Local LLMs for Agentic Development

A Flox environment that pairs Ollama's local LLM inference with CLI-based agentic coding tools. Run models locally and launch them directly with Claude Code, Codex, OpenCode, or OpenClaw using Ollama's built-in `ollama launch` integration.

## What's Included

**Ollama** - Local LLM inference server with CUDA/GPU support

**Agentic CLI Tools** (via `ollama launch`):
- **Claude Code** - Anthropic's CLI coding agent
- **Codex** - OpenAI's CLI coding agent
- **OpenCode** - Open-source AI coding agent with TUI
- **OpenClaw** - Self-hosted AI assistant/agent (optional, uncomment in manifest)

**Supporting Tools:**
- **Flox MCP Server** - Model Context Protocol server for AI agent environment management

## Quick Start

### 1. Activate the Environment

```bash
cd agentic-ollama
flox activate
```

### 2. Pull a Model

```bash
ollama pull gemma4
# or any model with tool-use support:
ollama pull qwen3
ollama pull devstral
ollama pull llama4
```

### 3. Start the Ollama Service

```bash
flox activate -s
```

### 4. Launch an Agentic Coding Tool

Use `ollama launch` to run any of the bundled CLI coding tools against your local model:

```bash
# Claude Code
ollama launch claude --model gemma4

# Codex
ollama launch codex --model gemma4

# OpenCode
ollama launch opencode --model gemma4

# OpenClaw
ollama launch openclaw --model gemma4
```

## Recommended Models

Models with tool/function-calling support work best for agentic workflows:

| Model | Size | Strengths |
|-------|------|-----------|
| `gemma4` | 12B-31B | Frontier-level reasoning, agentic workflows, coding, multimodal |
| `qwen3` | 0.6B-235B | Strong reasoning and tool use, multiple sizes |
| `devstral` | 24B | Purpose-built for agentic coding tasks |
| `llama4` | 109B+ | Meta's latest with strong tool-use capabilities |
| `mistral` | 7B | Fast, high quality general purpose |
| `codellama` | 7B-70B | Code generation specialist |

## Environment Variables

All Ollama configuration is done via environment variables with sensible defaults.

### Server Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `OLLAMA_HOST` | `127.0.0.1:11434` | Server bind address |
| `OLLAMA_MODELS` | `$HOME/.ollama/models` | Model storage directory |
| `OLLAMA_ORIGINS` | *(Ollama defaults)* | CORS allowed origins |

### Performance & Memory

| Variable | Default | Description |
|----------|---------|-------------|
| `OLLAMA_CONTEXT_LENGTH` | `4096` | Default context window size (tokens) |
| `OLLAMA_KEEP_ALIVE` | `5m` | How long models stay loaded in memory |
| `OLLAMA_MAX_LOADED_MODELS` | *auto* | Max concurrent loaded models (3 x GPU count) |
| `OLLAMA_NUM_PARALLEL` | `1` | Max parallel requests per model |
| `OLLAMA_MAX_QUEUE` | `512` | Max queued requests before rejection |
| `OLLAMA_LOAD_TIMEOUT` | `5m` | Timeout for model loading |

### GPU Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `OLLAMA_FLASH_ATTENTION` | *disabled* | Enable Flash Attention (experimental) |
| `OLLAMA_KV_CACHE_TYPE` | `f16` | K/V cache quantization (`f16`, `q8_0`, `q4_0`) |
| `OLLAMA_GPU_OVERHEAD` | `0` | Reserve VRAM per GPU (bytes) |
| `CUDA_VISIBLE_DEVICES` | *all* | Limit visible GPUs (e.g., `0,1`) |

### Advanced / Experimental

| Variable | Default | Description |
|----------|---------|-------------|
| `OLLAMA_DEBUG` | `0` | Enable debug logging (`1` = enabled) |
| `OLLAMA_SCHED_SPREAD` | *disabled* | Schedule models across all GPUs |
| `OLLAMA_NOPRUNE` | *disabled* | Don't prune model blobs on startup |
| `OLLAMA_LLM_LIBRARY` | *auto* | Bypass LLM library autodetection |
| `OLLAMA_AUTH` | *disabled* | Enable client-server authentication (experimental) |

## Usage Examples

### Agentic Development Workflow

```bash
# Start Ollama service in the background
flox activate -s

# Pull a model with tool-use support
ollama pull gemma4

# Launch your preferred coding agent
ollama launch claude --model gemma4
```

### Network Accessible

```bash
OLLAMA_HOST=0.0.0.0:11434 flox activate -s
```

### High Performance

```bash
OLLAMA_NUM_PARALLEL=4 OLLAMA_KEEP_ALIVE=30m flox activate -s
```

### Multiple Overrides

```bash
OLLAMA_HOST=0.0.0.0:8080 \
OLLAMA_NUM_PARALLEL=4 \
OLLAMA_CONTEXT_LENGTH=8192 \
flox activate -s
```

## Commands

### Configuration

```bash
ollama-info              # Show current configuration
ollama-health            # Test API endpoint health
```

### Model Management

```bash
ollama pull <model>      # Download a model
ollama list              # List local models
ollama ps                # List running models
ollama rm <model>        # Remove a model
ollama show <model>      # Show model information
```

### Service Management

```bash
flox services start              # Start Ollama service
flox services status             # Check service status
flox services logs ollama        # View Ollama logs
flox services stop               # Stop all services
flox services restart            # Restart all services
```

## Composition Examples

### With PostgreSQL for RAG

```toml
# .flox/env/manifest.toml
[include]
environments = [
  { dir = "../agentic-ollama" },
  { dir = "../postgres-headless" },
]
```

### With Redis for Agent State

```toml
[include]
environments = [
  { dir = "../agentic-ollama" },
  { dir = "../redis-headless" },
]
```

## Performance Tuning

### For Maximum Throughput

```bash
OLLAMA_NUM_PARALLEL=8 \
OLLAMA_KEEP_ALIVE=1h \
OLLAMA_FLASH_ATTENTION=1 \
flox activate -s
```

### For Low Memory

```bash
OLLAMA_CONTEXT_LENGTH=2048 \
OLLAMA_KV_CACHE_TYPE=q8_0 \
OLLAMA_KEEP_ALIVE=1m \
flox activate -s
```

### For Multi-GPU

```bash
OLLAMA_SCHED_SPREAD=1 \
OLLAMA_MAX_LOADED_MODELS=6 \
flox activate -s
```

## Platform-Specific Notes

### Linux (CUDA)

- Uses `ollama-cuda` custom flake for RTX 5090 (Blackwell) support
- Auto-detects CUDA GPUs
- Supports CUDA 12.5+

### macOS

- Uses standard `ollama` package from nixpkgs
- Metal GPU acceleration (automatic)

## Troubleshooting

### Check Service Status

```bash
flox services status
```

### View Logs

```bash
flox services logs ollama
```

### Test API Health

```bash
ollama-health
# or
curl http://localhost:11434/
```

### Common Issues

**"Ollama API is not responding"**
```bash
flox services status
flox services logs ollama
flox services restart
```

**"Model not found"**
```bash
ollama list
ollama pull gemma4
```

**"Out of memory"**
```bash
ollama pull tinyllama
OLLAMA_CONTEXT_LENGTH=2048 flox activate -s
OLLAMA_KV_CACHE_TYPE=q8_0 flox activate -s
```

**"CUDA not detected"**
```bash
nvidia-smi
OLLAMA_LLM_LIBRARY=cuda flox activate -s
```

## Resources

- [Ollama Documentation](https://docs.ollama.com/)
- [Ollama GitHub](https://github.com/ollama/ollama)
- [Ollama Models Library](https://ollama.com/library)
- [Ollama API Reference](https://github.com/ollama/ollama/blob/main/docs/api.md)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Ollama-specific issues:
- [Ollama Documentation](https://docs.ollama.com/)
- [Ollama GitHub Issues](https://github.com/ollama/ollama/issues)

# Claw Code

Rust-based CLI for Claude AI with tool execution and session persistence. A terminal coding agent that interfaces with Anthropic's API for interactive development workflows.

- **Rust binary** - Fast startup, single binary, no runtime dependencies
- **Tool execution** - Shell commands, file operations, code editing
- **Session persistence** - Resume conversations across sessions
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Intel, Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd claw-code
flox activate
```

### 2. Set Your API Key

```bash
export ANTHROPIC_API_KEY=sk-ant-...
```

### 3. Start Using

```bash
# Interactive agent
claw

# Single prompt
claw prompt "explain this codebase"

# Health check
claw doctor
```

## CLI Reference

| Command | Description |
|---------|-------------|
| `claw` | Start interactive agent session |
| `claw prompt "<prompt>"` | Run a single prompt |
| `claw doctor` | Health check and diagnostics |

## Requirements

- `ANTHROPIC_API_KEY` environment variable (required)

## Helper Commands

```bash
claw-info    # Show configuration and API key status
```

## Resources

- [Claw Code GitHub](https://github.com/instructkr/claw-code)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Claw Code-specific issues:
- [Claw Code GitHub Issues](https://github.com/instructkr/claw-code/issues)

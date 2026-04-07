# Claurst

Multi-provider terminal coding agent built in Rust. A clean-room reimplementation of Claude Code's CLI with chat forking, memory consolidation, a plugin system, and no telemetry.

- **Multi-provider** - Anthropic, OpenAI, Google, GitHub Copilot, Ollama, DeepSeek, Groq, Mistral, 30+ more
- **Rich TUI** - Terminal user interface with chat forking and conversation branching
- **Memory consolidation** - Short-term session history and long-term markdown files
- **Fast and lightweight** - <100ms startup, ~50MB peak memory
- **No telemetry** - Zero tracking or data collection
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Intel, Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd claurst
flox activate
```

### 2. Configure a Provider

```bash
# Set an API key
export ANTHROPIC_API_KEY=sk-ant-...

# Or configure interactively inside claurst
claurst
# then type: /connect
```

### 3. Start Coding

```bash
# Interactive TUI
claurst

# Headless single query
claurst -p "explain this codebase"
```

## Supported Providers

Configure via environment variables or interactively with `/connect`:

| Provider | Env Var |
|----------|---------|
| Anthropic | `ANTHROPIC_API_KEY` |
| OpenAI | `OPENAI_API_KEY` |
| Google | `GOOGLE_API_KEY` |
| GitHub Copilot | via `/connect` |
| Ollama (local) | via `/connect` |
| DeepSeek | via `/connect` |
| Groq | via `/connect` |
| Mistral | via `/connect` |
| 30+ additional providers | via `/connect` |

## In-App Commands

| Command | Description |
|---------|-------------|
| `/connect` | Interactively configure an LLM provider |
| `/compact` | Compact conversation context |
| `/diff` | Show changes |
| `/plan` | Plan mode |
| `/mcp` | MCP server management |
| `/Rocky` | Experimental Rocky speech mode |
| `/Caveman` | Experimental Caveman speech mode |
| `/Normal` | Reset to normal speech mode |

## Key Features

- **Chat forking** - Branch conversations to explore alternatives
- **Memory consolidation** - Short-term session history + long-term markdown files
- **Plugin system** - Extensible architecture
- **State machine design** - Prompt routing, tool calls, streaming output
- **Headless mode** - `claurst -p "<prompt>"` for scripting and CI/CD

## Helper Commands

```bash
claurst-info    # Show configuration, API key status, and command reference
```

## Resources

- [Claurst Documentation](https://claurst.kuber.studio/docs)
- [Claurst GitHub](https://github.com/Kuberwastaken/claurst)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Claurst-specific issues:
- [Claurst GitHub Issues](https://github.com/Kuberwastaken/claurst/issues)

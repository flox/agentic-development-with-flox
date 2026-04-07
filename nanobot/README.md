# Nanobot

Ultra-lightweight personal AI agent with multi-channel chat integration, persistent memory, scheduled tasks, and 25+ LLM providers. Built by HKUDS.

- **Multi-provider** - OpenRouter, Anthropic, OpenAI, Google Gemini, DeepSeek, Groq, Ollama, GitHub Copilot, 25+ more
- **Multi-channel** - Telegram, Discord, WhatsApp, WeChat, Slack, Matrix, Email, and more
- **Persistent memory** - SOUL.md, USER.md, MEMORY.md with Dream memory consolidation
- **Scheduled tasks** - Natural language and cron-based task scheduling with heartbeat
- **MCP support** - Model Context Protocol for external tool servers
- **OpenAI-compatible API** - Expose a local `/v1/chat/completions` endpoint
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Intel, Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd nanobot
flox activate
```

Nanobot is automatically installed into a Python venv on first activation.

### 2. Run the Setup Wizard

```bash
nanobot onboard --wizard
```

This creates `~/.nanobot/config.json` with your provider keys and preferences.

### 3. Start Chatting

```bash
# Interactive chat
nanobot agent

# Single message
nanobot agent -m "What's the weather like today?"
```

## Modes of Operation

### Interactive CLI

```bash
nanobot agent                    # Interactive chat (agent mode)
nanobot agent -m "<message>"     # Single-message query
nanobot agent -w <workspace>     # Chat against a specific workspace
nanobot agent --no-markdown      # Plain-text output
```

### Channel Gateway (Service)

Long-running process connecting to all enabled chat channels:

```bash
# Start manually
nanobot gateway

# Or as a Flox-managed service
flox activate -s
```

The gateway runs heartbeat tasks every 30 minutes and executes cron-scheduled jobs.

### API Server

```bash
nanobot serve
# OpenAI-compatible API at http://127.0.0.1:8900
```

## Chat Channel Setup

### WhatsApp (requires Node.js)

```bash
nanobot channels login whatsapp
# Scan QR code with WhatsApp (Settings -> Linked Devices)
# Then start the gateway in another terminal:
nanobot gateway
```

### Telegram

```bash
# Add bot token to ~/.nanobot/config.json, then:
nanobot gateway
```

### Other Channels

Discord, WeChat, Slack, Matrix, Email, Feishu, DingTalk, QQ, WeCom, Mochat -- configure in `~/.nanobot/config.json`.

## Memory System

Nanobot uses a layered memory system:

- **SOUL.md** - Agent identity and personality
- **USER.md** - Knowledge about the user
- **MEMORY.md** - Long-term knowledge and facts
- **history.jsonl** - Summarized conversation history

### Dream Consolidation

Memory consolidation runs on schedule or on-demand:

```bash
# In-session:
/dream              # Run memory consolidation
/dream-log          # Inspect changes
/dream-restore <sha> # Roll back changes
```

## In-Session Commands

| Command | Description |
|---------|-------------|
| `/new` | Start a new conversation |
| `/stop` | Stop current task |
| `/restart` | Restart the agent |
| `/status` | Show status |
| `/dream` | Run memory consolidation |
| `/dream-log` | Inspect memory changes |
| `/dream-restore <sha>` | Roll back memory changes |
| `/help` | Show help |

## Configuration

Config file: `~/.nanobot/config.json`

```bash
nanobot onboard --wizard    # Interactive setup
nanobot status              # Show current status
nanobot channels status     # Show channel status
```

### Provider Authentication

```bash
# OAuth-based providers
nanobot provider login openai-codex
nanobot provider login github-copilot

# API key providers - set in config.json or via environment variables
export OPENROUTER_API_KEY=sk-or-...
export ANTHROPIC_API_KEY=sk-ant-...
```

## Service Management

The gateway runs as a Flox-managed service:

```bash
flox services start        # Start nanobot gateway
flox services status       # Check service status
flox services logs         # View service logs
flox services stop         # Stop the gateway
flox services restart      # Restart the gateway
```

## Helper Commands

```bash
nanobot-info    # Show configuration, API key status, and command reference
```

## Technical Notes

- Python 3.12 is used (not 3.13, due to typer/click incompatibility)
- The `nanobot` wrapper unsets `PYTHONPATH` to prevent contamination from other Flox environments
- The venv is cached at `$FLOX_ENV_CACHE/venv` and reused across activations
- Node.js is included for the WhatsApp bridge

## Resources

- [Nanobot GitHub](https://github.com/HKUDS/nanobot)
- [Nanobot Documentation](https://github.com/HKUDS/nanobot#readme)
- [PyPI: nanobot-ai](https://pypi.org/project/nanobot-ai/)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Nanobot-specific issues:
- [Nanobot GitHub Issues](https://github.com/HKUDS/nanobot/issues)

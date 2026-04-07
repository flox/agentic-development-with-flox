# Zeroclaw

Personal AI assistant infrastructure, 100% Rust. Ultra-lightweight single-binary runtime with multi-channel messaging, 70+ tool integrations, multi-agent orchestration, and hardware peripheral support. Runs on anything from microcontrollers to cloud servers.

- **Single binary** - ~8.8 MB, <5 MB RAM, <10 ms startup
- **Multi-provider** - Anthropic, OpenAI, Google Gemini, 20+ additional backends with failover
- **Multi-channel** - WhatsApp, Telegram, Slack, Discord, Signal, Matrix, Email, 20+ platforms
- **70+ tools** - Shell, file I/O, git, browser control, web search, MCP, Jira, Notion, Google Workspace
- **Web dashboard** - React-based UI for chat, memory, config, and cron management
- **Hardware support** - ESP32, STM32, Arduino, Raspberry Pi via Peripheral trait
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd zeroclaw
flox activate
```

### 2. Run the Onboarding Wizard

```bash
zeroclaw onboard
```

This creates `$ZEROCLAW_HOME/config.toml` with your provider keys and preferences.

### 3. Start Chatting

```bash
# Interactive chat
zeroclaw agent

# Single message
zeroclaw agent -m "What's on my calendar today?"
```

## Modes of Operation

### Interactive CLI

```bash
zeroclaw agent                   # Interactive chat
zeroclaw agent -m "<message>"    # Single-message query
```

### Gateway (Web Dashboard)

```bash
zeroclaw gateway
# Webhook server + web dashboard
```

### Full Daemon

Long-running autonomous runtime with gateway, messaging channels, and cron jobs:

```bash
# Start manually
zeroclaw daemon

# Or as a Flox-managed service
flox activate -s
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `ZEROCLAW_HOME` | `$FLOX_ENV_CACHE/zeroclaw` | Configuration and data directory |
| `ANTHROPIC_API_KEY` | *(not set)* | Anthropic API key |
| `OPENAI_API_KEY` | *(not set)* | OpenAI API key |
| `GOOGLE_API_KEY` | *(not set)* | Google Gemini API key |

## CLI Reference

| Command | Description |
|---------|-------------|
| `zeroclaw agent` | Interactive chat or single-message mode |
| `zeroclaw gateway` | Start webhook server and web dashboard |
| `zeroclaw daemon` | Full autonomous runtime (gateway + channels + cron) |
| `zeroclaw status` | System status check |
| `zeroclaw doctor` | Run diagnostics |
| `zeroclaw channel` | Channel configuration |
| `zeroclaw cron` | Scheduled task management |
| `zeroclaw skills` | Skill/tool management |
| `zeroclaw auth` | Authentication management |
| `zeroclaw service` | Service management |
| `zeroclaw migrate openclaw` | Import configuration from OpenClaw |

## Configuration

Config file: `$ZEROCLAW_HOME/config.toml`

Minimal example:
```toml
default_provider = "anthropic"
api_key = "sk-ant-..."
```

## Service Management

The daemon runs as a Flox-managed service:

```bash
flox services start        # Start zeroclaw daemon
flox services status       # Check service status
flox services logs         # View service logs
flox services stop         # Stop the daemon
flox services restart      # Restart the daemon
```

## Security

- DM pairing by default (unknown senders must enter a pairing code)
- Configurable autonomy levels: ReadOnly, Supervised (default), Full
- Workspace sandboxing with path traversal blocking and command allowlists
- Rate limiting with configurable actions/hour and daily cost caps

## Migration from OpenClaw

```bash
# Preview migration
zeroclaw migrate openclaw --dry-run

# Run migration
zeroclaw migrate openclaw
```

## Helper Commands

```bash
zeroclaw-info    # Show configuration, API key status, and command reference
```

## Resources

- [Zeroclaw GitHub](https://github.com/zeroclaw-labs/zeroclaw)
- [Zeroclaw Documentation](https://github.com/zeroclaw-labs/zeroclaw#readme)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Zeroclaw-specific issues:
- [Zeroclaw GitHub Issues](https://github.com/zeroclaw-labs/zeroclaw/issues)

# NullClaw

Ultra-minimal autonomous AI assistant infrastructure written in Zig. Ships as a single static binary (~678 KB) with zero runtime dependencies. Boots in under 2 ms, uses ~1 MB peak RAM, runs on everything from $5 ARM boards to cloud servers.

- **50+ AI providers** - OpenRouter, Anthropic, OpenAI, Gemini, Ollama, Groq, Mistral, xAI, DeepSeek, and more
- **19 messaging channels** - CLI, Telegram, Signal, Discord, Slack, iMessage, Matrix, WhatsApp, IRC, Email, and more
- **10 memory engines** - SQLite (default, hybrid FTS5 + vector), PostgreSQL, Redis, ClickHouse, LanceDB, Markdown, and more
- **35+ built-in tools** - Shell, file I/O, browser, web search, MCP, subagents, voice
- **Zero dependencies** - Single static binary, no runtime/VM overhead
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Intel, Apple Silicon), RISC-V

## Quick Start

### 1. Activate the Environment

```bash
cd nullclaw
flox activate
```

### 2. Configure a Provider

```bash
# Quick setup
nullclaw onboard --api-key sk-or-... --provider openrouter

# Interactive wizard
nullclaw onboard --interactive
```

### 3. Start Chatting

```bash
# Interactive REPL
nullclaw

# Single message
nullclaw agent -m "What's the weather today?"
```

## Gateway

The HTTP gateway provides a pairing-secured API for remote access:

```bash
# Start as a Flox service
flox activate -s

# Or start manually
nullclaw gateway --port 8080
```

On startup, the gateway displays a 6-digit pairing code. POST that code to `/pair` to receive a bearer token for API access.

The gateway port is configurable via `NULLCLAW_GATEWAY_PORT` (default: 8080).

## CLI Reference

| Command | Description |
|---------|-------------|
| `nullclaw` | Interactive REPL |
| `nullclaw agent -m "<msg>"` | Single-message chat |
| `nullclaw onboard` | API key and provider setup |
| `nullclaw gateway` | Start HTTP gateway |
| `nullclaw status` | System status |
| `nullclaw doctor` | Full diagnostics |
| `nullclaw channel start <ch>` | Start a messaging channel |
| `nullclaw channel status` | Channel health check |
| `nullclaw service install` | Register systemd/OpenRC service |
| `nullclaw migrate openclaw` | Migrate memory from OpenClaw |

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `NULLCLAW_HOME` | `$FLOX_ENV_CACHE/nullclaw` | Configuration and data directory |
| `NULLCLAW_GATEWAY_PORT` | `8080` | Gateway HTTP port |
| `ANTHROPIC_API_KEY` | *(not set)* | Anthropic API key |
| `OPENAI_API_KEY` | *(not set)* | OpenAI API key |
| `OPENROUTER_API_KEY` | *(not set)* | OpenRouter API key (recommended, 50+ providers) |

## Messaging Channels

| Channel | Command |
|---------|---------|
| Telegram | `nullclaw channel start telegram` |
| Discord | `nullclaw channel start discord` |
| Signal | `nullclaw channel start signal` |
| Slack | `nullclaw channel start slack` |
| WhatsApp | `nullclaw channel start whatsapp` |
| Matrix | `nullclaw channel start matrix` |
| iMessage | `nullclaw channel start imessage` |
| IRC | `nullclaw channel start irc` |
| Email | `nullclaw channel start email` |

## Memory Engines

NullClaw supports 10 memory backends, configured in `~/.nullclaw/config.json`:

- **SQLite** (default) - Hybrid FTS5 full-text + vector search
- **PostgreSQL** - For larger deployments
- **Redis** - In-memory, low-latency
- **ClickHouse** - Analytics-oriented
- **LanceDB** - Vector-native
- **Markdown** - File-based, human-readable

## Security

- Gateway binds localhost only by default; refuses `0.0.0.0` without a tunnel
- API keys encrypted with ChaCha20-Poly1305
- Filesystem scoped to workspace
- Landlock/Firejail/Bubblewrap sandboxing
- Empty channel allowlists = deny all
- Signed audit trail

## Configuration

Config file: `~/.nullclaw/config.json` (OpenClaw-compatible format)

## Service Management

```bash
flox services start        # Start nullclaw gateway
flox services status       # Check service status
flox services logs nullclaw-gateway  # View gateway logs (pairing code here)
flox services stop         # Stop the gateway
```

## Helper Commands

```bash
nullclaw-info    # Show configuration, API key status, and command reference
```

## Resources

- [NullClaw GitHub](https://github.com/nullclaw/nullclaw)
- [NullClaw Documentation](https://github.com/nullclaw/nullclaw#readme)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For NullClaw-specific issues:
- [NullClaw GitHub Issues](https://github.com/nullclaw/nullclaw/issues)

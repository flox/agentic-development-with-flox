# IronClaw

Secure personal AI assistant built in Rust by NEAR AI. Features WASM-sandboxed tool execution, pgvector persistent memory with hybrid search, multi-channel access, and defense-in-depth security. No telemetry.

- **Multi-provider** - NEAR AI, Anthropic, OpenAI, Google Gemini, GitHub Copilot, Ollama, Mistral, OpenRouter, and more
- **Persistent memory** - PostgreSQL + pgvector with hybrid full-text and vector search (Reciprocal Rank Fusion)
- **WASM sandboxing** - Capability-based permissions, credential leak detection, HTTP allowlisting
- **Multi-channel** - REPL, HTTP webhooks, Web Gateway, Telegram, Slack via WASM channels
- **Routines engine** - Cron schedules, event triggers, webhook handlers, heartbeat system
- **Dynamic tools** - Build new WASM tools from natural language descriptions
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Intel, Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd ironclaw
flox activate
```

IronClaw is provided as a pre-built package from the Flox catalog.

### 2. Choose a Database Mode

**libSQL (default, no setup needed):**
```bash
flox activate
# Embedded SQLite database, zero configuration
```

**PostgreSQL with pgvector (for persistent vector memory):**
```bash
flox activate -s
# PostgreSQL starts as a Flox-managed service
# Database and pgvector extension are created automatically
```

The environment auto-detects which mode to use: if PostgreSQL is running, `DATABASE_URL` is set and IronClaw uses pgvector. Otherwise, it falls back to libSQL.

### 3. Run the Onboarding Wizard

```bash
ironclaw onboard
```

### 4. Start Chatting

```bash
ironclaw
```

## LLM Provider Configuration

Set via environment variables or in `$IRONCLAW_HOME/.env`:

| Provider | `LLM_BACKEND` | Key Variable |
|----------|---------------|-------------|
| NEAR AI | *(default)* | OAuth via browser |
| Anthropic | `anthropic` | `ANTHROPIC_API_KEY` |
| OpenAI | `openai` | `OPENAI_API_KEY` |
| Google Gemini | `gemini_oauth` | OAuth PKCE |
| GitHub Copilot | `github_copilot` | `GITHUB_COPILOT_TOKEN` |
| Ollama (local) | `ollama` | *(none)* |
| Mistral | `mistral` | `MISTRAL_API_KEY` |
| OpenRouter | `openai_compatible` | `LLM_API_KEY` + `LLM_BASE_URL` |

### OpenAI-Compatible Backends

```bash
# OpenRouter
LLM_BACKEND=openai_compatible LLM_BASE_URL=https://openrouter.ai/api/v1 LLM_API_KEY=sk-or-... ironclaw

# LM Studio (local)
LLM_BACKEND=openai_compatible LLM_BASE_URL=http://localhost:1234/v1 ironclaw

# vLLM / Together AI / Fireworks
LLM_BACKEND=openai_compatible LLM_BASE_URL=<endpoint>/v1 LLM_API_KEY=<key> ironclaw
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `IRONCLAW_HOME` | `$FLOX_ENV_CACHE/ironclaw` | Config and data directory |
| `IRONCLAW_BASE_DIR` | *(same as IRONCLAW_HOME)* | IronClaw's native config dir variable |
| `LLM_BACKEND` | *(NEAR AI)* | LLM provider selection |
| `LLM_BASE_URL` | *(provider default)* | Base URL for OpenAI-compatible endpoints |
| `LLM_API_KEY` | *(not set)* | API key for OpenAI-compatible endpoints |
| `LLM_MODEL` | *(provider default)* | Model name override |
| `HTTP_WEBHOOK_SECRET` | *(auto-generated)* | HTTP webhook channel secret (random per activation if not set) |
| `HTTP_PORT` | `8080` | Webhook server port (auto-fallback if in use) |
| `HTTP_HOST` | `127.0.0.1` | Webhook server bind address |
| `KILL` | `0` | Set to `1` to reclaim occupied port |
| `DATABASE_URL` | *(auto)* | PostgreSQL connection string (set automatically) |
| `EMBEDDING_ENABLED` | *(auto)* | Toggle vector embeddings |
| `PGPORT` | `15432` | PostgreSQL port |

## Persistent Memory

IronClaw supports two database backends:

**libSQL (default)** - Embedded SQLite, zero configuration. Works out of the box with `flox activate`.

**PostgreSQL + pgvector** - Hybrid full-text and vector search with Reciprocal Rank Fusion. Enabled automatically with `flox activate -s`:

- **Vector search** - Semantic similarity via embedded document vectors
- **Full-text search** - Standard PostgreSQL full-text search
- **Reciprocal Rank Fusion** - Combines both for higher-quality retrieval
- **Workspace filesystem** - Path-based storage for notes, logs, and context
- **Identity files** - Persistent personality across sessions

PostgreSQL runs on port 15432 (non-standard to avoid conflicts) with socket-only connections. The database and pgvector extension are created automatically on first service start.

## Security

- WASM sandbox with capability-based permissions (HTTP, secrets, tool invocation)
- Credential leak detection on request and response boundaries
- HTTP endpoint allowlisting
- AES-256-GCM encryption for stored secrets
- Per-tool rate limiting and resource constraints
- Prompt injection defense (pattern detection, content sanitization)
- Full audit logging

## Helper Commands

```bash
ironclaw-info    # Show configuration, API key status, and command reference
```

## HTTP Webhook Channel

A random `HTTP_WEBHOOK_SECRET` is generated automatically on each activation if not already set. To use a persistent secret:

```bash
export HTTP_WEBHOOK_SECRET=your-fixed-secret
flox activate
```

## Port Management

IronClaw's webhook server defaults to port 8080. If the port is in use:

```bash
# Automatic: falls back to the next available port
flox activate

# Manual: specify a port
HTTP_PORT=9090 flox activate

# Reclaim: kill whatever is using the port
KILL=1 flox activate
```

## Technical Notes

- IronClaw is installed as a pre-built Flox catalog package (`flox/ironclaw`)
- Bundled helper scripts: `ironclaw-info`, `ironclaw-pg-init`, `ironclaw-pg-start`, `ironclaw-pg-detect`, `ironclaw-port-check`
- `IRONCLAW_BASE_DIR` is set to `$IRONCLAW_HOME` for IronClaw's native config lookup
- PostgreSQL runs on port 15432 (socket-only) as a Flox-managed service via `ironclaw-pg-start`
- Database detection runs in the shell profile (after services start) via `ironclaw-pg-detect`

## Resources

- [IronClaw GitHub](https://github.com/nearai/ironclaw)
- [IronClaw Documentation](https://github.com/nearai/ironclaw#readme)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For IronClaw-specific issues:
- [IronClaw GitHub Issues](https://github.com/nearai/ironclaw/issues)

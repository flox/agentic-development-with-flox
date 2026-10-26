# Honcho

Self-hosted memory for agents. Honcho stores the conversations your agents have, as workspaces, peers, sessions, and messages, and a background worker (the deriver) turns them into what Honcho knows about each peer: facts, preferences, and summaries an agent can ask about later. This environment runs the Honcho API, the deriver, and a local PostgreSQL with pgvector as Flox services, and includes the `honcho-ai` Python SDK.

- **Memory API** - Store and search messages per workspace, peer, and session
- **Reasoning** - Ask what Honcho knows about a peer (`peer.chat(...)`), with any OpenAI, Anthropic, or Gemini key, or an OpenAI-compatible server
- **Local database** - PostgreSQL 17 with pgvector, reachable only through a private Unix socket; no database port is opened
- **Python SDK** - `from honcho import Honcho` works without `pip install`
- **Telemetry off** - Sentry, metrics, and analytics events are all off by default and have no endpoint configured
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate with Services

```bash
cd honcho
flox activate -s
```

The first start creates the database in `$FLOX_ENV_CACHE/honcho` and applies Honcho's migrations, which takes a few seconds. Then:

```bash
curl $HONCHO_URL/health          # {"status":"ok"}
flox services status             # honcho-postgres, honcho-api, honcho-deriver
```

The API listens on http://127.0.0.1:18000.

### 2. Store and Search Memory

```python
import os
from honcho import Honcho

honcho = Honcho(workspace_id="my-app", base_url=os.environ["HONCHO_URL"], api_key="local")
alice = honcho.peer("alice")
assistant = honcho.peer("assistant")
session = honcho.session("session-1")

session.add_messages([
    alice.message("I prefer tabs over spaces and I deploy on Fridays."),
    assistant.message("Noted."),
])
print(session.search("deploy"))
```

Run it with the environment's `python`. Without authentication (the default on loopback), any `api_key` value is accepted.

### 3. Add an LLM for Reasoning

Storing and searching works without any key. The deriver and `peer.chat(...)` need an LLM; by default Honcho uses OpenAI models for reasoning and for message embeddings:

```bash
LLM_OPENAI_API_KEY=sk-... flox activate -s
```

```python
print(alice.chat("What does alice prefer?"))
```

To keep the key out of your shell history, put it in `~/.config/honcho/config.toml` instead (see [Configuration Files](#configuration-files)).

## Without an Embedding Key

Honcho embeds every new message, with OpenAI's `text-embedding-3-small` by default, and when it can't, it rejects the message. So when `honcho-api` and `honcho-deriver` start, they ask Honcho's own settings loader whether an embedding key or server is configured (`LLM_OPENAI_API_KEY`, `LLM_GEMINI_API_KEY` for the `gemini` transport, or an `EMBEDDING_*` override, from the environment, `config.toml`, or `.env`). If none is, and `EMBED_MESSAGES` isn't set anywhere, they set `EMBED_MESSAGES=false`: messages are stored and found by text search, just not embedded. This includes an Anthropic-only setup: Honcho can't embed with Anthropic. The banner and `honcho-info` say when this applies.

Because the check runs at service start, adding a key to `config.toml` takes effect with `flox services restart honcho-api honcho-deriver`. Messages stored before that stay unembedded.

To set it yourself either way, use the environment or `config.toml` (`[app]` section, `embed_messages = true`):

```bash
EMBED_MESSAGES=true flox activate -s
```

## Configuration Files

Honcho reads `config.toml` from its working directory, and the services load a `.env` from there too. The services run in `~/.config/honcho` (or `$HONCHO_CONFIG_DIR`) when that directory exists, so keys and settings can live there, outside this repository; until it exists, settings come only from environment variables:

```bash
mkdir -p ~/.config/honcho
cat > ~/.config/honcho/config.toml << 'EOF'
[llm]
openai_api_key = "sk-..."
EOF
chmod 600 ~/.config/honcho/config.toml
flox services restart honcho-api honcho-deriver
```

Values from environment variables win over `config.toml`; a `.env` in that directory wins over both, and a line with an empty value clears that variable even when it is already set, by you or by this environment (such as `DB_CONNECTION_URI`). The services load `.env` themselves and turn off Honcho's own lookup, which depends on how Honcho is started and can read `.env` files in parent directories. `HONCHO_HOST` and `HONCHO_PORT` are the exception: the environment works out the API's address from them at activation, so set them there, not in `.env`, which ignores them. The banner warns about these, about empty values that clear a variable that is set, about a config directory it can't enter, about names that aren't valid variable names, about lines it can't parse (they are skipped), and about a `.env` it can't read or that isn't UTF-8 text (it is ignored). If `config.toml` isn't valid TOML, Honcho ignores the whole file; the banner warns about that, and the reason is in the service logs. A `.env` anywhere else, such as in a parent directory, is ignored. See Honcho's [configuration reference](https://docs.honcho.dev/v3/contributing/configuration) and [config.toml.example](https://github.com/plastic-labs/honcho/blob/main/config.toml.example) for every setting; section names follow the variable prefixes (`[llm]`, `[deriver]`, `[embedding]`, `[auth]`, ...).

## Other Providers and Local Models

Each component's model can be changed with `__`-nested variables, e.g. for an Anthropic key:

```bash
export LLM_ANTHROPIC_API_KEY=sk-ant-...
export DERIVER_MODEL_CONFIG__TRANSPORT=anthropic
export DERIVER_MODEL_CONFIG__MODEL=claude-haiku-4-5
```

`DIALECTIC_...`, `SUMMARY_...`, and `DREAM_...` work the same way. With only an Anthropic key, messages stay unembedded (see [above](#without-an-embedding-key)). `LLM_OPENAI_BASE_URL` points the OpenAI transport at an OpenAI-compatible server (Ollama, vLLM, LM Studio, ...). It covers chat only: embeddings still go to api.openai.com with `LLM_OPENAI_API_KEY`, so with a local server and a dummy key, Honcho sends message text to OpenAI and rejects the messages when OpenAI refuses the key. Point embeddings at the server too with `EMBEDDING_MODEL_CONFIG__OVERRIDES__BASE_URL` (and an embedding model it serves, `EMBEDDING_MODEL_CONFIG__MODEL`), or set `EMBED_MESSAGES=false`. The banner warns when this applies. Embeddings only support the `openai` and `gemini` transports, and the database stores 1536-dimension vectors by default; an embedding model with a different size needs `EMBEDDING_VECTOR_DIMENSIONS` set before the first start (otherwise wipe `$FLOX_ENV_CACHE/honcho` to start over). Honcho's reasoning relies on tool calls, so small local models often do poorly.

None of this was tested here with a real provider; the storage, search, and health paths were.

## Listening Beyond Localhost

Honcho has no authentication unless you turn it on, so the API refuses to start on a non-loopback address without it:

```bash
mkdir -p ~/.config/honcho
cat >> ~/.config/honcho/config.toml << EOF
[auth]
use_auth = true
jwt_secret = "$(openssl rand -hex 32)"
EOF
chmod 600 ~/.config/honcho/config.toml
HONCHO_HOST=0.0.0.0 flox activate -s
```

Requests then need a JWT signed with that secret (see Honcho's docs); unauthenticated ones get 401.

## Data and Logs

- `$FLOX_ENV_CACHE/honcho/pgdata` - the PostgreSQL cluster
- `$FLOX_ENV_CACHE/logs/honcho-api.log`, `honcho-deriver.log`, `honcho-postgres.log`

To use the database directly:

```bash
psql -h "$HONCHO_PG_SOCKET_DIR" -U honcho honcho
```

The socket lives in `$FLOX_ENV_CACHE/honcho/run`, or in a `honcho-pg-*` directory under `$XDG_RUNTIME_DIR` (or `$TMPDIR`) when the cache path is too long for a socket. PostgreSQL is pinned to version 17 because a new major version can't open an older data directory. The API applies Honcho's migrations every time it starts, so a `flox upgrade` that brings a new Honcho schema needs no extra step.

To use your own PostgreSQL (with pgvector) instead, set `DB_CONNECTION_URI`, e.g. `postgresql+psycopg://user:pass@host:5432/honcho`, and start only `honcho-api` and `honcho-deriver`.

## PATH Note

Honcho ships as a Python virtual environment, so it puts its `python`, `alembic`, `uvicorn`, `fastapi`, and other tools on `PATH`. If you layer this environment over a Python project, activate the project's environment *after* this one, or call the project's interpreter by path.

## Configuration

| Variable | Default | Effect |
|----------|---------|--------|
| `HONCHO_HOST` | `127.0.0.1` | API listen address; anything else requires auth |
| `HONCHO_PORT` | `18000` | API port |
| `HONCHO_URL` | derived | Address for clients, e.g. the SDK's `base_url` |
| `HONCHO_CONFIG_DIR` | `~/.config/honcho` | Working directory for the services: `config.toml` and `.env` |
| `DB_CONNECTION_URI` | bundled PostgreSQL | Database for Honcho |
| `EMBED_MESSAGES` | `false` with no embedding key configured, else Honcho's `true` (checked at service start) | Embed messages as they are stored |
| `LLM_OPENAI_API_KEY`, `LLM_ANTHROPIC_API_KEY`, `LLM_GEMINI_API_KEY` | unset | Provider keys |
| `LLM_OPENAI_BASE_URL` | unset | OpenAI-compatible server |
| `AUTH_USE_AUTH`, `AUTH_JWT_SECRET` | `false`, unset | Require JWTs |

## License

Honcho is licensed under the AGPL-3.0. Running it for yourself is unaffected; if you modify it and offer it to others over a network, the AGPL requires you to share your changes.

## Helper Commands

```bash
honcho-info             # Show the API address and health, database, config, and LLM key options
honcho-migrate current  # Show the database schema revision
```

## Resources

- [Honcho GitHub](https://github.com/plastic-labs/honcho)
- [Honcho documentation](https://docs.honcho.dev)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Honcho-specific issues:
- [Honcho GitHub Issues](https://github.com/plastic-labs/honcho/issues)

# Mux

Parallel agentic development from Coder. Mux lets you plan and execute tasks with multiple AI agents simultaneously, each in its own isolated workspace (git worktree, Docker, SSH, or local). Includes a CLI, browser UI, and desktop app.

- **Multi-provider** - Anthropic, OpenAI, Google, xAI, DeepSeek, OpenRouter, Ollama, AWS Bedrock, GitHub Copilot
- **Isolated workspaces** - Git worktrees, Docker containers, SSH remotes, or local directories
- **Plan/Exec mode** - Agents can plan before executing, with collaborative review
- **Built-in agent loop** - Custom agent with orchestrator sub-agents (exec, explore, plan)

## Quick Start

### 1. Activate the Environment

```bash
cd mux
flox activate
```

### 2. Set an API Key

```bash
export ANTHROPIC_API_KEY=sk-ant-...
# or
export OPENAI_API_KEY=sk-...
```

Or configure providers in `~/.mux/providers.jsonc`.

### 3. Run an Agent Task

```bash
# CLI mode (one-shot)
mux run "Add error handling to the API routes"

# With a specific model
mux run -m anthropic:claude-sonnet-4-5 "Fix the failing tests"

# In an isolated git worktree
mux run -r worktree "Refactor the auth module"
```

### 4. Start the Browser UI

```bash
# As a Flox service
flox activate -s

# Or manually
mux server
```

Open `http://localhost:3000` to manage workspaces and agents.

## Environment Variables

### Server Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `MUX_PORT` | `3000` | Server port |
| `MUX_HOST` | `127.0.0.1` | Server bind address |
| `MUX_AUTH` | `true` | Enable server authentication |

### Provider API Keys

Set in your shell profile or pass at activation time. Mux also reads from `~/.mux/providers.jsonc`.

| Variable | Provider |
|----------|----------|
| `ANTHROPIC_API_KEY` | Anthropic (Claude) |
| `OPENAI_API_KEY` | OpenAI |
| `GOOGLE_GENERATIVE_AI_API_KEY` | Google Gemini |
| `XAI_API_KEY` | xAI (Grok) |
| `DEEPSEEK_API_KEY` | DeepSeek |
| `OPENROUTER_API_KEY` | OpenRouter |

### Runtime Variables (available inside agent sessions)

| Variable | Description |
|----------|-------------|
| `MUX_PROJECT_PATH` | Absolute path to the project root |
| `MUX_RUNTIME` | Runtime type: `local`, `worktree`, `ssh`, `docker` |
| `MUX_WORKSPACE_NAME` | Workspace name (typically branch name) |
| `MUX_MODEL_STRING` | Model identifier |
| `MUX_THINKING_LEVEL` | Reasoning level: `off`/`low`/`medium`/`high`/`xhigh` |
| `MUX_COSTS_USD` | Cumulative session costs in USD |

## CLI Reference

### Commands

| Command | Description |
|---------|-------------|
| `mux run "<prompt>"` | Execute an agent task from CLI |
| `mux server` | Start HTTP/WebSocket server for browser UI |
| `mux desktop` | Launch the desktop application |
| `mux acp` | Start ACP stdio bridge (Zed, Neovim, JetBrains) |
| `mux --version` | Show version info |

### `mux run` Options

| Flag | Short | Description | Default |
|------|-------|-------------|---------|
| `--dir <path>` | `-d` | Project directory | cwd |
| `--model <model>` | `-m` | Model (e.g. `anthropic:claude-sonnet-4-5`) | auto |
| `--runtime <type>` | `-r` | `local`, `worktree`, `ssh <host>`, `docker <image>` | `local` |
| `--mode <mode>` | | `plan` or `exec` | `exec` |
| `--thinking <level>` | `-t` | `OFF`/`LOW`/`MED`/`HIGH`/`MAX` or `0`-`9` | `MED` |
| `--budget <usd>` | `-b` | Spending limit in USD | none |
| `--json` | | NDJSON output for scripting | off |
| `--quiet` | `-q` | Show only final result | off |

### `mux server` Options

| Flag | Description | Default |
|------|-------------|---------|
| `--host <addr>` | Bind address | `127.0.0.1` |
| `--port <port>` | Listen port | `3000` |
| `--auth-token <token>` | Set auth token | auto-generated |
| `--no-auth` | Disable authentication | off |
| `--print-auth-token` | Print auth token to stdout | off |

## Usage Examples

### Parallel Development

```bash
# Open the browser UI
flox activate -s
# http://localhost:3000

# From the UI, create multiple workspaces:
#   - feature-auth (worktree runtime)
#   - feature-dashboard (worktree runtime)
#   - feature-api (worktree runtime)
# Each gets its own git branch and agent session
```

### Plan Before Executing

```bash
mux run --mode plan "Redesign the database schema for multi-tenancy"
# Agent creates a plan for review before making changes
```

### Budget-Controlled Runs

```bash
mux run -b 5.00 "Implement the payment integration"
# Agent stops when $5 budget is reached
```

### CI/CD Integration

```bash
mux run --json --quiet "Fix all linting errors" | jq '.result'
```

### Network Accessible Server

```bash
MUX_HOST=0.0.0.0 flox activate -s
```

### Disable Server Auth (local dev only)

```bash
MUX_AUTH=false flox activate -s
```

## Service Management

The browser UI runs as a Flox-managed service:

```bash
flox services start        # Start mux server
flox services status       # Check service status
flox services logs         # View service logs
flox services stop         # Stop the server
flox services restart      # Restart the server
```

## Configuration

### Provider Configuration

Create `~/.mux/providers.jsonc` for provider API keys and custom endpoints:

```jsonc
{
  "anthropic": {
    "apiKey": "sk-ant-..."
  },
  "openai": {
    "apiKey": "sk-..."
  },
  "ollama": {
    "baseUrl": "http://localhost:11434"
  }
}
```

### Project Secrets

Create `~/.mux/secrets.json` for environment variables injected into agent sessions.

### Instruction Files

Add an `AGENTS.md` file to your project root for agent-specific instructions (similar to `CLAUDE.md`).

## Key Features

- **Workspace forking** - Clone workspaces with conversation history to explore alternatives
- **Best-of-N** - Generate multiple independent solutions in parallel
- **Variants** - Apply one prompt across parallel tracks (e.g., frontend/backend)
- **Orchestrator sub-agents** - `exec` (implementation), `explore` (research), `plan` (complex tasks)
- **Opportunistic compaction** - Automatic context management within model limits
- **MCP server support** - Extend agent capabilities with Model Context Protocol
- **Editor integrations** - VS Code/Cursor extension, ACP for Zed/Neovim/JetBrains
- **Init and tool hooks** - Block dangerous commands, lint after edits
- **Budget controls** - Set spending limits per run
- **Stream resilience** - Streams resume after restarts or connection drops

## Helper Commands

```bash
mux-info    # Show current configuration, API key status, and command reference
```

## Resources

- [Mux Documentation](https://mux.coder.com/)
- [Mux GitHub](https://github.com/coder/mux)
- [CLI Reference](https://mux.coder.com/reference/cli.md)
- [Provider Configuration](https://mux.coder.com/config/providers.md)
- [Models Configuration](https://mux.coder.com/config/models.md)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Mux-specific issues:
- [Mux GitHub Issues](https://github.com/coder/mux/issues)
- [Mux Discord](https://discord.gg/coder)

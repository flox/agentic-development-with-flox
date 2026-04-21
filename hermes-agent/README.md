# Hermes Agent

Self-improving AI agent with persistent learning from Nous Research. Hermes builds skills from experience, improves them during use, and maintains knowledge across sessions.

- **200+ models** via OpenRouter, OpenAI, Anthropic, NVIDIA NIM, Hugging Face, and more
- **Persistent learning** -- skills and memory carry over between sessions
- **Tool calling** -- file operations, shell commands, browser automation, code analysis
- **Messaging gateway** -- Telegram, Discord, Slack, WhatsApp, Signal
- **Plugin system** -- extend with custom skills and integrations
- **MCP support** -- Model Context Protocol for external tool servers

## Quick Start

### 1. Activate the Environment

```bash
cd hermes-agent
flox activate
```

First run clones the repo and installs into a venv (~1-2 min). Subsequent activations are instant.

### 2. Run the Setup Wizard

```bash
hermes setup
```

This walks you through choosing a provider, setting API keys, and configuring tools.

### 3. Start Chatting

```bash
hermes
```

## Supported Providers

| Provider | Setup |
|----------|-------|
| OpenRouter | `hermes login openrouter` |
| OpenAI | `hermes login openai` |
| Anthropic | `hermes login anthropic` |
| Nous Portal | `hermes login nous` |
| NVIDIA NIM | `hermes login nvidia` |
| Hugging Face | `hermes login huggingface` |
| Ollama (local) | `hermes model` and select Ollama |

Switch providers at any time with `hermes model`.

## Commands

| Command | Description |
|---------|-------------|
| `hermes` | Interactive terminal UI |
| `hermes setup` | Full setup wizard |
| `hermes model` | Choose LLM provider/model |
| `hermes tools` | Configure enabled tools |
| `hermes skills` | Manage learned skills |
| `hermes memory` | View persistent memory |
| `hermes gateway` | Start messaging gateway (Telegram, Discord, etc.) |
| `hermes plugins` | Manage plugins |
| `hermes mcp` | Manage MCP servers |
| `hermes doctor` | Diagnose issues |
| `hermes config set` | Set configuration values |
| `hermes status` | Show status of all components |
| `hermes sessions` | Manage chat sessions |
| `hermes --reset` | Force a fresh install of the venv |

## Chat Commands

Use these during an interactive session:

| Command | Description |
|---------|-------------|
| `/new` | Start a new conversation |
| `/reset` | Clear context and start fresh |
| `/model` | Switch model mid-conversation |
| `/retry` | Retry the last message |
| `/skills` | View and manage learned skills |
| `/compress` | Compress conversation context |
| `/usage` | Show token usage stats |

## Usage Examples

### Interactive Agent

```bash
hermes
# Ask it to build, refactor, debug, or explore your codebase
```

### Gateway Mode (Messaging Platforms)

```bash
hermes gateway
# Configure Telegram, Discord, Slack, WhatsApp, or Signal
# Chat with Hermes from your phone
```

### With Local Models via Ollama

```bash
hermes model
# Select Ollama provider, then pick a model
# No API key needed -- runs entirely on your hardware
```

### Import from OpenClaw

```bash
hermes claw migrate
# Brings over your OpenClaw configuration and history
```

## Environment Variables

API keys can be set in the manifest `[vars]` section or via `hermes login`:

| Variable | Provider |
|----------|----------|
| `OPENROUTER_API_KEY` | OpenRouter |
| `OPENAI_API_KEY` | OpenAI |
| `ANTHROPIC_API_KEY` | Anthropic |
| `NOUS_API_KEY` | Nous Portal |

## How It Works

The Flox package provides a bootstrap wrapper that:

1. Creates a Python venv in `.flox/cache/hermes-agent/`
2. Clones the Hermes Agent repo at the pinned version tag
3. Installs all dependencies via `uv`
4. Runs the `hermes` CLI from the venv

The venv is cached and only rebuilt when the version changes. Use `hermes --reset` to force a fresh install.

## Resources

- [Hermes Agent](https://github.com/NousResearch/hermes-agent)
- [Nous Research](https://nousresearch.com/)

## Support

For issues with this Flox environment:
- Check the main README at the repository root

For Hermes Agent-specific issues:
- [GitHub Issues](https://github.com/NousResearch/hermes-agent/issues)

# OpenHands

AI-driven software development agent. Autonomous coding agents that write code, run commands, browse the web, and interact with developer tools -- all inside sandboxed Docker containers. Powered by any LLM via litellm.

- **Autonomous agents** - CodeActAgent writes code, runs tests, browses the web, edits files
- **Sandboxed execution** - Every session runs inside a Docker container
- **Multi-provider** - Anthropic, OpenAI, Google Gemini, Ollama, AWS Bedrock, Mistral, and any litellm-supported provider
- **MCP support** - Connect external tool servers via Model Context Protocol
- **Security** - Confirmation mode with LLM-based or Invariant-based security analysis
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd openhands
flox activate
```

### 2. Ensure Docker is Running

OpenHands requires Docker for sandboxed code execution:

```bash
# Linux
sudo systemctl start docker

# macOS
open -a Docker
```

### 3. Set an API Key

```bash
export ANTHROPIC_API_KEY=sk-ant-...
# or
export OPENAI_API_KEY=sk-...
```

### 4. Start the Agent

```bash
openhands
```

## Supported Providers

OpenHands uses litellm, supporting virtually any LLM provider:

| Provider | Notes |
|----------|-------|
| Anthropic | Claude models |
| OpenAI | GPT-4o default, o-series with reasoning_effort |
| Google Gemini | Via litellm |
| Ollama | Local models |
| AWS Bedrock | IAM/SSO authentication |
| Mistral | Via litellm |
| Any litellm provider | Custom `base_url` and `api_key` |

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `OPENHANDS_HOME` | `$FLOX_ENV_CACHE/openhands` | Configuration and data directory |
| `OPENHANDS_SUPPRESS_BANNER` | `1` | Suppress startup banner |
| `ANTHROPIC_API_KEY` | *(not set)* | Anthropic API key |
| `OPENAI_API_KEY` | *(not set)* | OpenAI API key |

## Agents

- **CodeActAgent** (default) - Full-stack autonomous coding agent
- **RepoExplorerAgent** - Specialized for codebase exploration
- Custom agents configurable via `config.toml`

## Built-in Tools

- Code editing (`str_replace_editor`, LLM draft editor)
- Jupyter/IPython execution
- Shell command execution
- Web browsing (BrowserGym)
- "Think" tool for agent reasoning

## Configuration

Config file: `~/.openhands/config.toml`

Key sections: `[core]` (workspace, iterations, runtime), `[llm]` (model, keys, endpoints), `[agent]` (tools, browsing, jupyter), `[sandbox]` (container image, GPU, volumes), `[security]` (confirmation mode), `[mcp]` (external tool servers).

## Docker Requirements

OpenHands spawns a Docker container per agent session. The default base image is `nikolaik/python-nodejs:python3.12-nodejs22-slim`. Ensure:

- Docker daemon is running
- Your user has permission to run Docker commands (`docker ps`)
- Sufficient disk space for container images

## Helper Commands

```bash
openhands-info    # Show configuration, Docker status, and API key status
```

## Resources

- [OpenHands GitHub](https://github.com/All-Hands-AI/OpenHands)
- [OpenHands Documentation](https://docs.all-hands.dev/)
- [OpenHands CLI](https://github.com/OpenHands/OpenHands-CLI)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For OpenHands-specific issues:
- [OpenHands GitHub Issues](https://github.com/All-Hands-AI/OpenHands/issues)
- [OpenHands Discord](https://discord.gg/ESHStjSjD4)

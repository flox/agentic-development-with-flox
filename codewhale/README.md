# Codewhale

Open-source coding agent that works with any model. Codewhale reads your project, edits files, runs commands, and checks its own work, using a hosted provider or a local model you choose. It is built with open-weight models in mind (DeepSeek by default).

- **Any model** - DeepSeek, OpenAI, Anthropic, OpenRouter, Mistral, xAI, Moonshot, Z.ai, 30+ more
- **Local models** - Ollama, vLLM, SGLang, and LM Studio, with no API key
- **More than chat** - Code review over a git diff, patch apply, sessions with receipts, Agent fleets and workflows
- **Skills and MCP** - Agent Skills from `~/.codewhale/skills`, `.agents/skills`, `.claude/skills`, plus MCP servers
- **Flox skills built in** - flox, floxify, and flox-debug are linked in on activation
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd codewhale
flox activate
```

### 2. Configure a Provider

```bash
# Set an API key (DeepSeek is the default provider)
export DEEPSEEK_API_KEY=sk-...

# Or store it in Codewhale's secret store (prompts; nothing is echoed)
codewhale auth set --provider deepseek

# Or pick a provider inside the TUI
codewhale
# then type: /provider (or press F3)
```

### 3. Start Coding

```bash
# Interactive TUI
codewhale

# Non-interactive prompt
codewhale exec "explain this codebase"

# Review the current git diff
codewhale review
```

## Local Models with Ollama

Codewhale pairs well with the [ollama](../ollama) environment in this repository:

```bash
# Terminal 1: start Ollama
cd ../ollama
flox activate -s
ollama pull <model>

# Terminal 2: point Codewhale at it
cd ../codewhale
flox activate
codewhale --provider ollama --model <model>
```

Codewhale uses `http://localhost:11434/v1` by default; set `OLLAMA_BASE_URL` to use another host.

## Commands

| Command | Description |
|---------|-------------|
| `codewhale` | Interactive TUI |
| `codewhale exec "<prompt>"` | Run a non-interactive prompt |
| `codewhale review` | Code review over a git diff |
| `codewhale sessions` / `resume` / `fork` | Manage saved sessions |
| `codewhale receipts` | Show what a session did: files, commands, approvals |
| `codewhale models` | List models for configured providers |
| `codewhale mcp` | Manage MCP servers |
| `codewhale auth` | Manage provider credentials |
| `codewhale doctor` | Diagnostics for providers, skills, and MCP |

## Flox Skills

The environment installs `flox/skills-flox` and links its skills into `~/.codewhale/skills` (or `$CODEWHALE_HOME/skills`, or `$CODEWHALE_SKILLS_DIR` when you set it):

- **flox** - Create and manage Flox environments, add packages, services
- **floxify** - Add a Flox environment to an existing project
- **flox-debug** - Diagnose package resolution and activation problems

`CODEWHALE_SKILLS_DIR` replaces Codewhale's global skills directory instead of adding to it, so linking is how the environment provides the skills without hiding your own. Links are refreshed on each activation; skills you created yourself, and links pointing anywhere else, are never replaced. Check with `codewhale doctor` or `/skills`.

## Helper Commands

```bash
codewhale-info    # Show configuration, API key status, and command reference
```

## Resources

- [Codewhale Documentation](https://github.com/codewhale-hq/CodeWhale/tree/main/docs)
- [Codewhale GitHub](https://github.com/codewhale-hq/CodeWhale)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Codewhale-specific issues:
- [Codewhale GitHub Issues](https://github.com/codewhale-hq/CodeWhale/issues)

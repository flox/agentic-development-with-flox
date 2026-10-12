# Mistral Vibe

Mistral AI's command-line coding agent, powered by Devstral and other Mistral models. Vibe explores your codebase, edits files, and runs commands in an interactive TUI, or runs a prompt end to end in programmatic mode.

- **Mistral models** - Devstral and the Mistral model family via your Mistral API key
- **Interactive or programmatic** - Full TUI, or `vibe -p` with turn, token, cost, and time limits
- **Editor integration** - `vibe-acp` speaks the Agent Client Protocol
- **Skills and MCP** - Agent Skills from `~/.vibe/skills`, `.vibe/skills`, `.agents/skills`, plus MCP servers
- **Flox skills built in** - flox, floxify, and flox-debug are loaded automatically
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd mistral-vibe
flox activate
```

### 2. Configure a Provider

```bash
# Set an API key
export MISTRAL_API_KEY=...

# Or run the setup wizard
vibe --setup
```

### 3. Start Coding

```bash
# Interactive session
vibe

# Programmatic mode: send a prompt, print the response, exit
vibe -p "explain this codebase"

# Continue the most recent session
vibe -c
```

## Common Options

| Option | Description |
|--------|-------------|
| `-p, --prompt` | Programmatic mode: run a prompt and exit |
| `--max-turns`, `--max-price`, `--max-tokens`, `--time-limit` | Limits for programmatic runs |
| `--auto-approve` | Approve all tool calls |
| `--worktree [NAME]` | Work in a separate git worktree |
| `--add-dir DIR` | Give Vibe access to another directory |
| `-c`, `--resume [ID]` | Continue or resume a session |
| `--setup` | Configure a provider |

## Flox Skills

The environment installs `flox/skills-flox` and sets `VIBE_SKILL_PATHS` to its skills directory:

- **flox** - Create and manage Flox environments, add packages, services
- **floxify** - Add a Flox environment to an existing project
- **flox-debug** - Diagnose package resolution and activation problems

`VIBE_SKILL_PATHS` is a JSON list that Vibe merges with `skill_paths` from `~/.vibe/config.toml`. If you already set `VIBE_SKILL_PATHS`, the Flox path is appended to your list rather than replacing it.

## Helper Commands

```bash
vibe-info    # Show configuration, API key status, and command reference
```

## Resources

- [Mistral Vibe GitHub](https://github.com/mistralai/mistral-vibe)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Vibe-specific issues:
- [Mistral Vibe GitHub Issues](https://github.com/mistralai/mistral-vibe/issues)

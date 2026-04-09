# Claude Squad

TUI for managing multiple AI coding agents in parallel. Each agent runs in its own isolated tmux session and git worktree, so tasks don't conflict. Supports Claude Code, Codex, Gemini CLI, Aider, and any terminal-based agent.

- **Multi-agent TUI** - Run and monitor multiple agent sessions from one terminal
- **Isolated workspaces** - Each task gets its own git worktree and tmux session
- **Agent profiles** - Switch between Claude, Codex, Gemini, Aider, or custom agents
- **Git integration** - Review diffs, commit, push branches, create PRs from the TUI
- **Background execution** - Tasks run in the background with optional auto-accept mode
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Intel, Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd claude-squad
flox activate
```

### 2. Launch

```bash
# Default agent (Claude Code)
cs

# With a specific agent
cs -p "codex"
cs -p "gemini"
cs -p "aider --model sonnet"

# Auto-accept mode
cs -y
```

## Supported Agents

Claude Squad works with any terminal-based AI agent:

| Agent | Command |
|-------|---------|
| Claude Code | `cs` (default) |
| OpenAI Codex | `cs -p "codex"` |
| Google Gemini CLI | `cs -p "gemini"` |
| Aider | `cs -p "aider ..."` |
| Custom | `cs -p "<any command>"` |

## Agent Profiles

Configure named profiles in `~/.claude-squad/config.json`:

```json
{
  "default_program": "claude",
  "profiles": [
    { "name": "claude", "program": "claude" },
    { "name": "codex", "program": "codex" },
    { "name": "aider", "program": "aider --model ollama_chat/gemma3:1b" }
  ]
}
```

When multiple profiles are defined, the TUI shows a profile picker on session creation.

## TUI Keybindings

| Key | Action |
|-----|--------|
| `n` / `N` | New session (with/without prompt) |
| `D` | Kill session |
| `Enter` / `o` | Attach to session |
| `ctrl-q` | Detach from session |
| `s` | Commit and push |
| `c` | Checkout (commit + pause) |
| `r` | Resume paused session |
| `Tab` | Toggle preview/diff view |
| `?` | Help |

## How It Works

- **tmux** provides session isolation -- each agent runs in its own tmux session, persisting across attach/detach cycles
- **git worktrees** give each task its own branch and working copy, preventing file conflicts between concurrent agents
- **gh CLI** enables PR workflows directly from the TUI

## CLI Reference

| Command | Description |
|---------|-------------|
| `cs` | Launch TUI with default agent |
| `cs -p "<agent>"` | Launch with a specific agent/profile |
| `cs -y` | Auto-accept mode (experimental) |
| `cs reset` | Reset all stored instances |
| `cs debug` | Print config paths |
| `cs version` | Print version |

## Helper Commands

```bash
cs-info    # Show configuration, available agents, and TUI keybindings
```

## Troubleshooting

### tmux version mismatch

If you see "error capturing pane content" or "timed out waiting for tmux session", you likely have a tmux version mismatch. This happens when the Flox-provided tmux is a different version than an already-running tmux server.

**Fix:** Comment out the tmux line in the manifest and use your system tmux:

```bash
flox edit
# Comment out: tmux.pkg-path = "tmux"
```

Or kill your existing tmux server before activating (this will close all tmux sessions):

```bash
tmux kill-server
flox activate
cs
```

## Resources

- [Claude Squad GitHub](https://github.com/smtg-ai/claude-squad)
- [Claude Squad Documentation](https://github.com/smtg-ai/claude-squad#readme)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Claude Squad-specific issues:
- [Claude Squad GitHub Issues](https://github.com/smtg-ai/claude-squad/issues)

# Agent Deck

Terminal command center for coding agents. Agent Deck runs each agent session in its own tmux session and shows them all in one TUI: which are working, which are waiting for you, and which are idle. Jump into any of them, fork a conversation, give a session its own git worktree, or attach MCP servers and skills per session.

- **Many agents** - Claude Code, Codex, Gemini CLI, OpenCode, pi, and Hermes, side by side
- **Status at a glance** - Running, waiting, and idle sessions, grouped by project
- **Git worktrees** - Run parallel sessions on separate branches of one repository
- **Per-session MCPs and skills** - Attach and detach them without editing agent configs
- **Web UI** - Optional service that serves the deck in a browser
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate an Agent, Then This Environment

Agent Deck starts agents that are on your `PATH`. Activate one of this repository's agent environments first, then this one on top of it:

```bash
cd claude-code
flox activate
cd ../agent-deck
flox activate
```

The banner lists the agents it found (`claude`, `codex`, `gemini`, `opencode`, `pi`, `hermes`). Agents installed some other way work too. `agent-deck harness list` shows what's installed and signed in.

### 2. Start the Deck

```bash
agent-deck
```

Create sessions from the TUI, or from the command line:

```bash
agent-deck add . -c claude                         # Add a session for this directory
agent-deck launch . -c codex -m "fix the tests"    # Add, start, and send a first prompt
agent-deck list                                    # List sessions
agent-deck session attach <id>                     # Attach to one
```

Sessions live in tmux, so they keep running after you quit the TUI or leave the environment. Stop one with `agent-deck session stop <id>`.

## Agent Permissions

Agent Deck starts Claude Code with `--dangerously-skip-permissions` unless you turn that off. To keep Claude's permission prompts, add this to `~/.config/agent-deck/config.toml`:

```toml
[claude]
dangerous_mode = false
```

Codex and Gemini keep their prompts unless you enable `yolo_mode` for them.

## Keeping Your Own tmux Separate

By default Agent Deck creates its sessions on your default tmux server, next to any sessions of your own. To give it a server of its own:

```toml
[tmux]
socket_name = "agent-deck"
```

Reach that server directly with `tmux -L agent-deck`.

## Web UI

```bash
flox activate -s
```

Then open http://127.0.0.1:8420. The service runs `agent-deck web --no-tui`, which serves the deck in a browser. Change the address with:

```bash
AGENT_DECK_WEB_PORT=9000 flox activate -s
```

The web UI can run commands in your sessions, so Agent Deck only listens on a non-loopback address when you also give it a bearer token. Put the token in a file only you can read:

```bash
mkdir -p ~/.config/agent-deck
(umask 077; openssl rand -hex 32 > ~/.config/agent-deck/web-token)
AGENT_DECK_WEB_HOST=0.0.0.0 AGENT_DECK_WEB_TOKEN_FILE=~/.config/agent-deck/web-token flox activate -s
```

Without the token file, the service exits with an explanation in its log.

```bash
flox services status                  # Check the service
flox services logs agent-deck-web     # Show logs
```

The log is also written to `$FLOX_ENV_CACHE/logs/agent-deck-web.log`. The service stops when the last activation that started it exits; the sessions keep running.

## Updates and Telemetry

Agent Deck normally checks GitHub for releases and installs them itself. The Flox package lives in the read-only Nix store, so that can't work: the environment sets `AGENTDECK_SKIP_UPDATE_CHECK=1`, which stops the checks. Upgrade with `flox upgrade` instead, and ignore any suggestion from `agent-deck update` to run it with sudo.

Agent Deck's usage reports are opt-in, and the Flox build carries no upload key, so it never sends any. The environment sets `AGENTDECK_TELEMETRY=off`, which also skips the consent question on first start. `agent-deck telemetry status` shows the state.

Override either at activation, e.g. `AGENTDECK_SKIP_UPDATE_CHECK=0 flox activate`.

## Custom Commands

A session can run any command, e.g. `agent-deck add . -c "npm run dev"`. Agent Deck runs such commands in a login shell, and on Debian and Ubuntu `/etc/profile` resets `PATH`, so tools from Flox environments aren't found there. Use full paths in custom commands on those systems. Built-in agents (`-c claude`, `-c codex`, ...) keep your `PATH`.

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `AGENT_DECK_WEB_HOST` | `127.0.0.1` | Web UI listen address |
| `AGENT_DECK_WEB_PORT` | `8420` | Web UI port |
| `AGENT_DECK_WEB_TOKEN_FILE` | (none) | File holding the web UI bearer token; required for a non-loopback address |
| `AGENTDECK_SKIP_UPDATE_CHECK` | `1` | Skip Agent Deck's own update checks |
| `AGENTDECK_TELEMETRY` | `off` | Keep usage reports off without asking |

Agent Deck's own settings are in `~/.config/agent-deck/config.toml`; sessions and logs are in `~/.local/share/agent-deck`. See the [configuration reference](https://github.com/asheshgoplani/agent-deck/blob/main/skills/agent-deck/references/config-reference.md).

## Helper Commands

```bash
agent-deck-info    # Show configuration and command reference
```

## Resources

- [Agent Deck GitHub](https://github.com/asheshgoplani/agent-deck)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Agent Deck-specific issues:
- Run `agent-deck doctor`
- [Agent Deck GitHub Issues](https://github.com/asheshgoplani/agent-deck/issues)

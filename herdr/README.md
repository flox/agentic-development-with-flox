# Herdr

Terminal workspace manager for coding agents. Like tmux, Herdr is a multiplexer: a background server owns real terminals, and you attach to it to see them. Unlike tmux, it knows about coding agents. It recognizes the agents running in its panes and shows in a sidebar which ones are working, which are blocked waiting for you, and which are done, across all your projects.

- **Agent-aware** - Claude Code, Codex, Gemini CLI, OpenCode, pi, Hermes, Amp, Copilot, Droid, Qwen, and more, each with its state in the sidebar
- **Persistent** - Panes keep running when you detach, close the terminal, or drop an SSH connection
- **Mouse-first** - Click panes, tabs, and workspaces, drag borders to resize, right-click for menus; no key bindings to learn
- **Scriptable** - A CLI and socket API to create panes, send input, read output, and wait for an agent to finish
- **Remote** - `herdr --remote <host>` attaches to a Herdr server over SSH
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate an Agent, Then This Environment

Herdr runs whatever you start in its panes. Activate one of this repository's agent environments first, then this one on top of it:

```bash
cd claude-code
flox activate
cd ../herdr
flox activate
```

The banner lists the agents it found (`claude`, `codex`, `gemini`, `opencode`, `pi`, ...).

### 2. Start Herdr

```bash
cd ~/my-project
herdr
```

The first start shows a short introduction. Run your agent in the pane (`claude`, `codex`, ...), and Herdr picks it up. Split with a right-click, or with `ctrl+b` then `v` (right) or `-` (down); `ctrl+b` then `c` opens a tab and `ctrl+b` then `?` lists every binding.

### 3. Detach and Come Back

`ctrl+b` then `q` detaches. Everything keeps running; `herdr` attaches again.

```bash
herdr agent list          # agents Herdr sees, and their state
herdr server stop         # stop the server and every pane in it
```

## The Server and Your Environment

The first `herdr` starts the server, and every pane gets the environment of the shell that started it: this environment's tools, plus whatever agent environments were active. Panes in a server started from some other shell don't have them. If the banner says the server is already running and your tools are missing in new panes, stop it and start it again from here:

```bash
herdr server stop
herdr
```

The server is not a Flox service, so it keeps running after you leave the environment, the same way a tmux server would. Stopping it ends every pane; the workspace layout is saved and comes back on the next start.

## Agent Integrations

Herdr tells agents apart by watching their screens. An integration adds hooks to the agent's own configuration, so Herdr can restore an agent's conversation after the server restarts and, for some agents, get state changes from the agent directly:

```bash
herdr integration install claude     # also: codex, pi, opencode, copilot, droid, hermes, qwen, ...
herdr integration status
herdr integration uninstall claude
```

This writes to the agent's config: for Claude Code, a hook script in `~/.claude/hooks/` and a `SessionStart` entry in `~/.claude/settings.json`. `uninstall` removes both. The hooks only act inside Herdr panes and run with `python3`, which this environment provides.

Agents can also drive Herdr themselves (open panes, run commands, wait on another agent) from inside a pane. `herdr --skill` prints the skill that teaches them how.

## Updates and Network Access

Herdr normally checks herdr.dev for new versions and can replace its own binary. The Flox build points that version check at `127.0.0.1`, and Herdr turns off `herdr update` for Nix installs, so upgrade with `flox upgrade` instead. Because the check can't connect, `herdr-server.log` shows `update check failed` each time the server starts; that is expected.

Herdr also checks herdr.dev in the background for updated agent-detection rules, so it can recognize new agents and agent versions. To turn that off, add this to `~/.config/herdr/config.toml`:

```toml
[update]
manifest_check = false
```

We found no telemetry or analytics in the binary.

## Configuration

Herdr works without a config file; after the first-start introduction it writes one containing only `onboarding = false`. Its settings are in `~/.config/herdr/config.toml` (`$XDG_CONFIG_HOME/herdr/config.toml` when `XDG_CONFIG_HOME` is set); set `HERDR_CONFIG_PATH` to use another file. Print every setting with its default with `herdr --default-config`, and apply changes to a running server with `herdr server reload-config`.

Logs (`herdr.log`, `herdr-server.log`, `herdr-client.log`) and saved session state are in that `herdr` directory as well. Named sessions (`herdr session attach work`) keep theirs under `sessions/<name>/`. Agent-detection rules fetched from herdr.dev are cached in `~/.local/state/herdr` (`$XDG_STATE_HOME/herdr`). Herdr treats an `XDG_CONFIG_HOME` or `XDG_STATE_HOME` that is set but empty as the current directory and writes `./herdr` there; `herdr-info` shows where.

| Variable | Default | Description |
|----------|---------|-------------|
| `HERDR_CONFIG_PATH` | `${XDG_CONFIG_HOME:-~/.config}/herdr/config.toml` | Config file to use |

## Helper Commands

```bash
herdr-info    # Show configuration and command reference
```

## License

Herdr is licensed under the AGPL-3.0. Running it for yourself is unaffected; if you modify it and offer it to others over a network, the AGPL requires you to share your changes.

## Resources

- [Herdr documentation](https://herdr.dev/docs/)
- [Herdr GitHub](https://github.com/ogulcancelik/herdr)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Herdr-specific issues:
- Run `herdr status`, and check `~/.config/herdr/herdr-server.log`
- [Herdr GitHub Issues](https://github.com/ogulcancelik/herdr/issues)

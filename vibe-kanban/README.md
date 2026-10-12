# Vibe Kanban

Kanban board for coding agents. Plan work as issues, start a coding agent on each one in its own git worktree, watch it run, review the diff, and open a pull request, all from a web UI. Run several agents in parallel without them stepping on each other.

- **Many agents** - Claude Code, Codex, Gemini CLI, Amp, OpenCode, Qwen Code, Cursor, Copilot, and more
- **Isolated workspaces** - Each attempt runs in its own git worktree and branch
- **Review built in** - Diffs, follow-up prompts, dev server previews, and PR creation
- **MCP server** - Let an agent create and manage issues with `vibe-kanban-mcp`
- **Runs as a service** - Start it with the environment and keep it running in the background
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Start the Service

```bash
cd vibe-kanban
flox activate -s
```

Then open http://127.0.0.1:3210.

Use another address or port with:

```bash
VIBE_KANBAN_PORT=4000 flox activate -s
VIBE_KANBAN_HOST=0.0.0.0 flox activate -s      # reachable from other machines
```

Vibe Kanban has no login of its own; only listen on a non-local address on a network you trust.

The service doesn't open a browser tab when it starts. To have it do so, as `vibe-kanban` does in the foreground:

```bash
VIBE_KANBAN_OPEN_BROWSER=true flox activate -s
```

Or run it in the foreground on a random port. It opens your browser:

```bash
flox activate
vibe-kanban
```

### 2. Add a Repository and an Agent

In the web UI, add a local git repository, then pick a coding agent. Vibe Kanban starts agents with `npx`, which this environment provides, so the agent you choose only needs to be signed in (or have its API key in your environment).

### 3. Create an Issue and Start an Agent

Create an issue, start a workspace for it, and Vibe Kanban runs the agent in a fresh worktree. Review the changes in the UI, send follow-up prompts, and open a pull request when you're happy.

## Agent Permissions

Vibe Kanban's default agent profiles turn off each agent's permission prompts (Claude Code's `dangerously_skip_permissions`, Gemini's `yolo`, Codex's `danger-full-access`, and similar), so agents can work without stopping for approval. Each agent works in its own worktree, but it can still run any command as you.

Change this per agent in the web UI's agent settings.

## Using Agents from This Repository

By default each agent is downloaded with `npx -y <agent>@<version>`. To use an agent from one of this repository's environments instead, set `base_command_override` for that agent's profile (in `profiles.json` in Vibe Kanban's data directory), for example to the full path from `echo "$FLOX_ENV/bin/claude"` inside the claude-code environment.

## MCP Server

`vibe-kanban-mcp` lets an agent list, create, and update issues and start workspaces on a running Vibe Kanban. Register it with your agent, e.g. Claude Code:

```bash
claude mcp add --scope user vibe_kanban -- "$FLOX_ENV/bin/vibe-kanban-mcp" --mode global
```

Run that while this environment is active, so `$FLOX_ENV` expands to the environment's stable path.

## Service Management

```bash
flox services status                # Check the service
flox services logs vibe-kanban      # Show logs
flox services restart vibe-kanban   # Restart
```

The log is also written to `$FLOX_ENV_CACHE/logs/vibe-kanban.log`. The service stops when the last activation that started it exits.

## Privacy

Vibe Kanban sends anonymous usage analytics by default and connects to `api.vibekanban.com` for its optional cloud features (remote access, sharing). To turn analytics off, stop the service and set `"analytics_enabled": false` in `config.json` in its data directory (`~/.local/share/vibe-kanban` on Linux).

The Flox catalog lists Vibe Kanban's license as unfree; `flox install` shows a notice, and the environment needs no extra configuration.

## Helper Commands

```bash
vibe-kanban-info    # Show configuration and command reference
```

## Resources

- [Vibe Kanban Documentation](https://www.vibekanban.com/docs)
- [Vibe Kanban GitHub](https://github.com/BloopAI/vibe-kanban)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Vibe Kanban-specific issues:
- [Vibe Kanban GitHub Issues](https://github.com/BloopAI/vibe-kanban/issues)

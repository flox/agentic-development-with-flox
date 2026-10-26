# mcporter

Command line and TypeScript runtime for the Model Context Protocol. `mcporter` lists and calls the tools of any MCP server from the shell, picks up the servers you already configured for Claude Code, Cursor, Codex, and other agents, and turns a server into a standalone CLI or typed TypeScript client.

- **Call MCP tools from the shell** - `mcporter call server.tool key=value`, with text, Markdown, or JSON output
- **Reuses your agents' MCP configs** - Reads servers from Claude Code, Claude Desktop, Cursor, Codex, OpenCode, Windsurf, and VS Code configs
- **Any server, no config** - Point it at a stdio command or an HTTP URL for one run
- **Generate CLIs and types** - `generate-cli` writes a standalone CLI for a server; `emit-ts` writes TypeScript types or a client
- **Record and replay** - Capture a server's JSON-RPC traffic and replay it for tests
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd mcporter
flox activate
```

The banner lists the agent MCP configs it found in your home directory.

### 2. See Your Servers

```bash
mcporter config list                  # your own servers, and a count of imported ones; starts nothing
mcporter config list --source import  # the servers imported from your agents' configs
mcporter list <server> --schema       # one server's tools, with parameters
```

`mcporter list` with no name connects to *every* server it knows, which starts each stdio server in your agents' configs. Use `config list` to look without starting anything; it shows the servers in mcporter's own config, and those from your agents' configs only with `--source import`.

### 3. Call a Tool

```bash
mcporter call <server>.<tool> key=value
mcporter call <server>.<tool> --args '{"key": "value"}' --output json
```

A server that isn't configured anywhere works too:

```bash
mcporter list --stdio "npx -y some-mcp-server" --name demo --schema
mcporter call --stdio /path/to/server --name demo demo.some_tool key=value
mcporter list https://host/mcp        # an HTTP server
```

Add `--persist config/mcporter.json` to keep such a server.

## What mcporter Reads and Writes

**Reads** (never modifies) the MCP server entries in your agents' configs:

| Agent | Files |
|-------|-------|
| Claude Code | `~/.claude.json`, `~/.claude/settings.json`, `~/.claude/settings.local.json`, `~/.claude/mcp.json` |
| Claude Desktop | `~/.config/Claude/claude_desktop_config.json` (macOS: `~/Library/Application Support/Claude/`) |
| Cursor | `~/.cursor/mcp.json`, `~/.config/Cursor/User/mcp.json` (`$XDG_CONFIG_HOME/Cursor/...` when set), `~/Library/Application Support/Cursor/User/mcp.json` on macOS |
| Codex | `~/.codex/config.toml` |
| OpenCode | `~/.config/opencode/opencode.json[c]` |
| Windsurf | `~/.codeium/windsurf/mcp_config.json` |
| VS Code | `~/.config/Code/User/mcp.json` (macOS: `~/Library/Application Support/Code/User/`) |

It also reads the project-level copies (`.claude/`, `.cursor/mcp.json`, `.codex/config.toml`, `.vscode/mcp.json`, `opencode.json`) in the directory you run it from. To turn imports off, set `"imports": []` in your `mcporter.json`.

**Writes** only its own files:

- `./config/mcporter.json` (or `~/.mcporter/mcporter.json`), when you run `config add`, `config import <kind> --copy`, or `--persist`
- `~/.mcporter/<server>/schema.json`, a cache of each server's tool schemas
- `~/.mcporter/` also holds OAuth tokens (`mcporter auth`) and the daemon's socket and key

`XDG_CONFIG_HOME`, `XDG_CACHE_HOME`, and `XDG_DATA_HOME` move the config, schema cache, and tokens under `<dir>/mcporter`. The daemon's socket and key stay in `~/.mcporter/daemon` regardless (your account's home directory, even if `HOME` points elsewhere); set `MCPORTER_DAEMON_DIR` to move them. With an XDG config directory set, mcporter still falls back to `~/.mcporter/mcporter.json` when there's no config file in it. `mcporter-info` shows where each of these is. mcporter has no telemetry or update checks.

## Configuration File

mcporter reads `./config/mcporter.json` in the current directory, then `~/.mcporter/mcporter.json` (or `$XDG_CONFIG_HOME/mcporter/mcporter.json`). Servers use the same shape as Claude Code's `mcpServers`:

```json
{
  "mcpServers": {
    "docs": {
      "command": "/path/to/server",
      "args": ["--stdio"],
      "env": { "API_KEY": "${DOCS_API_KEY}" }
    },
    "remote": { "url": "https://host/mcp" }
  }
}
```

Keep secrets out of the file: `${VAR}` reads them from the environment at run time. To start from your existing servers, `mcporter config import claude-code --copy` (also `cursor`, `codex`, `opencode`, `vscode`, `windsurf`, `claude-desktop`).

## Standalone CLIs

`generate-cli` turns a server into a CLI with one subcommand per tool:

```bash
mcporter generate-cli <server> --bundle ./docs-cli.js
./docs-cli.js --help
./docs-cli.js some_tool --key value
```

The bundle embeds the server's command and runs on Node.js, which this environment provides (Node 24). `--compile` builds a single binary instead but needs [Bun](https://bun.sh), which isn't included; `flox install bun` adds it.

## Keep-Alive Daemon

Servers that are slow to start (Chrome DevTools, Playwright, mobile-mcp) stay running in a background daemon between calls:

```bash
mcporter daemon start | status | stop
```

The daemon is a separate process: it keeps running after you leave the environment until you stop it. `MCPORTER_DISABLE_KEEPALIVE=*` turns it off for every server.

## Configuration

| Variable | Default | Effect |
|----------|---------|--------|
| `MCPORTER_CONFIG` | (search, above) | Use this `mcporter.json` |
| `MCPORTER_CALL_TIMEOUT` | `60000` | Tool call timeout, in milliseconds |
| `MCPORTER_LIST_TIMEOUT` | `30000` | Per-server timeout for `list`, in milliseconds |
| `MCPORTER_KEEPALIVE` | (none) | Comma-separated servers to keep alive in the daemon |
| `MCPORTER_DISABLE_KEEPALIVE` | (none) | Comma-separated servers (or `*`) never to keep alive |
| `MCPORTER_DAEMON_DIR` | `~/.mcporter` | Base directory for the daemon's socket and key (in `daemon/`) |

Set any of them at activation, e.g. `MCPORTER_CONFIG=~/mcp/mcporter.json flox activate`.

## Helper Commands

```bash
mcporter-info    # Version, config locations, configured and imported servers, commands
```

## Resources

- [mcporter GitHub](https://github.com/openclaw/mcporter)
- [Model Context Protocol](https://modelcontextprotocol.io)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For mcporter-specific issues:
- [mcporter GitHub Issues](https://github.com/openclaw/mcporter/issues)

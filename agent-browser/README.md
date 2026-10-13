# agent-browser

Vercel's headless browser automation CLI for AI agents. An agent opens a page, reads it as a compact accessibility tree with `@e1`-style element refs, and clicks, fills, and screenshots by ref, all through short shell commands or an MCP server.

- **Built for agents** - Accessibility snapshots with element refs instead of raw HTML
- **CLI or MCP** - Shell commands for any agent, or `agent-browser mcp` for MCP clients
- **Browser included on Linux** - The package launches a Nix Chromium; nothing to download
- **Guardrails** - Restrict which domains the browser may visit, or require confirmation for actions
- **No account needed** - Runs locally; cloud browser providers and the `chat` command are optional
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd agent-browser
flox activate
```

### 2. Try It

```bash
agent-browser open https://example.com
agent-browser snapshot -i              # interactive elements, with refs
agent-browser click @e1                # act on an element by ref
agent-browser screenshot page.png
agent-browser close
```

The first command starts a background daemon that keeps the browser open between commands, so commands can be chained with `&&`. `close` shuts the browser down; an idle daemon exits after an hour.

### 3. Give It to Your Agent

Register the MCP server with your agent once:

```bash
agent-browser-register claude-code    # or: codex
```

Or, for any other MCP client, print the command and JSON snippet to paste into its config:

```bash
agent-browser-register print
```

The agent then starts the server itself; you don't need to keep this environment active. The registration points at this environment's directory, so if you move or re-clone the repository, run `agent-browser-register` again; it replaces the existing `agent-browser` entry.

## Using the CLI from an Agent

Instead of MCP, an agent can run the `agent-browser` commands directly when it runs inside this environment (activate it, then start your agent). The package includes a skill that tells the agent to load the usage guide from the CLI:

```bash
agent-browser skills get core          # usage guide written for agents
agent-browser skills list              # specialized guides (electron, dogfood, ...)
```

To install the skill for Claude Code:

```bash
mkdir -p ~/.claude/skills
cp -r "$FLOX_ENV/share/agent-browser/skills/agent-browser" ~/.claude/skills/
```

The skill is a short pointer to `agent-browser skills get core`, so it only works when `agent-browser` is on the agent's `PATH`.

## How the Launcher Works

`agent-browser-register` points your agent at `agent-browser-mcp`, a small launcher in `$FLOX_ENV_CACHE/bin` that runs:

```bash
flox activate -d <this environment> -- agent-browser mcp
```

`flox activate --` sends activation output to stderr, so the MCP protocol on stdout stays clean.

## The Browser

**Linux** - The `flox/agent-browser` package always launches its own Nix Chromium in headless mode. `agent-browser install` is not needed. `agent-browser doctor` may list a Chrome installed on your system, but that is not the browser it starts; `--executable-path` and `AGENT_BROWSER_EXECUTABLE_PATH` are overridden by the package.

**macOS** - agent-browser uses Chrome. If it can't find one, run `agent-browser install` once to download it.

## Configuration

Settings are read from `~/.agent-browser/config.json`, then `./agent-browser.json` in the current directory, then `AGENT_BROWSER_*` environment variables, then command-line flags (highest priority).

| Variable | Effect |
|----------|--------|
| `AGENT_BROWSER_ALLOWED_DOMAINS` | Comma-separated domains the browser may visit; others are refused |
| `AGENT_BROWSER_CONFIRM_ACTIONS` | Action categories that need your confirmation |
| `AGENT_BROWSER_HEADED` | Show the browser window instead of running headless |
| `AGENT_BROWSER_SCREENSHOT_DIR` | Default directory for screenshots |
| `AGENT_BROWSER_IDLE_TIMEOUT_MS` | Shut the daemon down after this much inactivity (default one hour) |

Run `agent-browser --help` for the full list.

## Dashboard

```bash
agent-browser dashboard start    # http://localhost:4848 (loopback only)
agent-browser dashboard stop
```

This is agent-browser's observability dashboard, a local web page for following the browser's activity while an agent works. It needs no account.

## Optional Services

These need accounts and API keys; nothing else does:

- **`agent-browser chat`** and the AI chat panel in the dashboard use the Vercel AI Gateway (`AI_GATEWAY_API_KEY`)
- **Cloud browsers** (`-p browserbase`, `browserless`, `browseruse`, `kernel`, `agentcore`) use that provider's key

Update agent-browser with `flox upgrade` rather than `agent-browser upgrade`.

## Helper Commands

```bash
agent-browser-info    # Show configuration and command reference
agent-browser doctor  # Diagnose the installation
```

## Resources

- [agent-browser GitHub](https://github.com/vercel-labs/agent-browser)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For agent-browser-specific issues:
- [agent-browser GitHub Issues](https://github.com/vercel-labs/agent-browser/issues)

# CodeBurn

A dashboard for what your AI coding agents cost. CodeBurn reads the session logs your agents already write to disk and breaks token usage and spend down by day, model, project, task type, and tool, in an interactive TUI, plain-text reports, JSON, or a local web page.

- **No account, no proxy** - Reads local session files; nothing sits between you and your agent
- **40+ agents** - Claude Code, Codex, Gemini CLI, OpenCode, pi, Mistral Vibe, Codewhale, Crush, Goose, Cursor, Copilot, and more
- **Finds waste** - `codeburn optimize` points out token-heavy habits and suggests fixes
- **Local models count too** - Track an Ollama model as savings against a paid baseline
- **Scriptable** - JSON and CSV output, plus an MCP server so agents can check their own spend
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd codeburn
flox activate
```

### 2. Check What CodeBurn Found

```bash
codeburn doctor
```

This lists every agent CodeBurn knows about, the paths it looked in, and how many sessions it parsed. Nothing to configure: if an agent has written sessions in its default location, CodeBurn finds them.

### 3. Look at Your Spend

```bash
codeburn                   # interactive dashboard
codeburn status            # one line: today and this month
codeburn models            # per-model token and cost table
codeburn optimize          # token waste, with suggested fixes
```

## Commands

| Command | Description |
|---------|-------------|
| `codeburn` | Interactive dashboard (today, or this week when today is empty) |
| `codeburn today` / `month` | Dashboard for today or this month |
| `codeburn report -p 30days` | Dashboard for another period: `today`, `week`, `30days`, `month`, `all` |
| `codeburn status` | Compact summary of today and this month |
| `codeburn models` | Per-model tokens and cost (`--by-task`, `--by-agent`) |
| `codeburn sessions` | Per-session usage report |
| `codeburn optimize` | Find token waste and get fixes |
| `codeburn compare` | Compare two models side by side |
| `codeburn yield` | Spend that shipped vs. spend that was reverted or abandoned (experimental) |
| `codeburn export -f json` | Export usage as CSV (default) or JSON |
| `codeburn web` | Local web dashboard at `http://127.0.0.1:4747` |
| `codeburn doctor` | Which agents were found, where, and parse health |
| `codeburn mcp` | MCP server (stdio) |

Most commands take `--provider <name>` (e.g. `--provider claude`), `--project <name>`, `--from`/`--to` dates, and `--format json`.

## Local Models

Calls to a local model, such as one served by the [ollama](../ollama) environment, cost nothing, so CodeBurn shows them at $0. To see what the same tokens would have cost on a paid model, map the local model to a baseline:

```bash
codeburn model-savings "qwen3:8b" gpt-4o
```

The dashboard then reports those tokens as savings; the cost of the local calls stays $0. For a model CodeBurn has no price for, set one with `codeburn price-override <model> --input <usd> --output <usd>` (USD per million tokens).

## MCP Server

`codeburn mcp` exposes `get_usage` and `get_savings` tools over stdio, so an agent can report its own spend. For example, to register it with Claude Code, run this from this directory (`$PWD` becomes the path to the environment):

```bash
claude mcp add --scope user codeburn -- flox activate -d "$PWD" -- codeburn mcp
```

## Configuration

| Variable | Effect |
|----------|--------|
| `CLAUDE_CONFIG_DIRS` | Colon-separated Claude Code config directories to merge (see below) |
| `CODEBURN_CACHE_DIR` | Cache location (default `~/.cache/codeburn`) |

Pass `CLAUDE_CONFIG_DIRS` at activation, so your shell expands the paths; not every part of CodeBurn expands `~`:

```bash
CLAUDE_CONFIG_DIRS="$HOME/.claude-work:$HOME/.claude-personal" flox activate
```

Settings you change with CodeBurn's own commands (`currency`, `plan`, `budget`, `price-override`, `model-alias`, `model-savings`) are saved in `~/.config/codeburn/config.json`.

## Privacy and Network Use

Reports are built from local files. CodeBurn makes these network requests:

- **Model prices** - Downloads LiteLLM's public price list from GitHub at most once a day, cached in `~/.cache/codeburn`. Offline, it falls back to a price table built into the package.
- **Currency** - `codeburn currency <code>` fetches an exchange rate from frankfurter.app.
- **Opt-in features** - `codeburn quota` asks each signed-in agent's provider for live quota; `codeburn sync` sends usage to an OTLP endpoint you set up; `codeburn share` and `codeburn devices` pair devices over your local network.

## Things That Change Your Files

Both are opt-in:

- `codeburn optimize --apply` applies suggested configuration fixes. They are backed up first, `--dry-run` shows the plan, and `codeburn act` reviews and undoes them.
- `codeburn guard install` adds budget and session hooks to Claude Code's settings; `codeburn guard uninstall` removes them.

Skip `codeburn update` and `codeburn menubar`: they install through npm or download apps. Update CodeBurn with `flox upgrade` instead.

## Related

[ccusage](../ccusage) also reports token usage and costs from local agent logs.

## Helper Commands

```bash
codeburn-info    # Show configuration and command reference
```

## Resources

- [CodeBurn GitHub](https://github.com/getagentseal/codeburn)
- [Provider docs](https://github.com/getagentseal/codeburn/tree/main/docs/providers)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For CodeBurn-specific issues:
- Run `codeburn doctor`
- [CodeBurn GitHub Issues](https://github.com/getagentseal/codeburn/issues)

# ccusage

Token usage and cost reports for coding agents, built from the logs they already keep on disk. `ccusage` finds every supported agent's data, adds up input, output, and cache tokens per day, week, month, or session, and prices them.

- **Many agents** - Claude Code, Codex, OpenCode, Amp, Droid, Codebuff, Hermes, pi, Goose, Kilo, Copilot CLI, Gemini CLI, Kimi, Qwen, OpenClaw, and more
- **Local only** - Reads log files; nothing to sign up for and no API keys
- **Claude Code status line** - Session, daily, and 5-hour block cost under the prompt
- **Billing blocks** - Usage in Claude's 5-hour windows, with time remaining
- **JSON output** - `--json` on every report, for scripts and dashboards
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd ccusage
flox activate
```

### 2. Run a Report

```bash
ccusage                   # daily report, all detected agents
ccusage monthly
ccusage session
ccusage blocks --active   # current Claude 5-hour block
```

The report header lists the agents it found (`Detected: Claude, Codex`).

### 3. Narrow It Down

```bash
ccusage claude daily               # one agent (also: codex, pi, gemini, opencode, ...)
ccusage --since 20261001           # from a date
ccusage --breakdown                # cost per model
ccusage --json                     # machine-readable: "daily" rows plus "totals"
```

## Pricing and Network Access

Costs come from LiteLLM's model price list. By default ccusage downloads the current list and caches it in `~/.cache/ccusage/http-cache` (or `$XDG_CACHE_HOME/ccusage`). A pricing snapshot is also built into the package: `--offline` uses it without touching the network, and ccusage falls back to it when the download fails.

## Claude Code Status Line

The environment writes a launcher, `ccusage-statusline`, into `$FLOX_ENV_CACHE/bin`. It calls this environment's ccusage by absolute path, so Claude Code can run it without activating anything. Add it to `~/.claude/settings.json` (`ccusage-info` prints this snippet with the real path):

```json
{
  "statusLine": {
    "type": "command",
    "command": "/path/to/ccusage/.flox/cache/bin/ccusage-statusline",
    "padding": 0
  }
}
```

It shows the model and the session, daily, and block cost:

```
🤖 Sonnet 4.5 | 💰 $0.05 session / $0.03 today / $0.03 block (4h 51m left) | 🧠 N/A
```

The status line uses the bundled pricing by default. If you move this directory, activate it again and update the path in `settings.json`.

## Where ccusage Looks

Each agent's default location can be overridden with an environment variable; most accept a comma-separated list of directories:

| Agent | Variable | Default |
|-------|----------|---------|
| Claude Code | `CLAUDE_CONFIG_DIR` | `~/.config/claude` and `~/.claude` |
| Codex | `CODEX_HOME` | `~/.codex` |
| OpenCode | `OPENCODE_DATA_DIR` | `~/.local/share/opencode` |
| pi | `PI_AGENT_DIR` | `~/.pi/agent/sessions` |
| Gemini CLI | `GEMINI_DATA_DIR` | `~/.gemini/tmp` |
| Copilot CLI | `COPILOT_HOME` | `~/.copilot` |
| Qwen | `QWEN_DATA_DIR` | `~/.qwen` |

See [the full list](https://github.com/ryoppippi/ccusage/blob/main/docs/guide/environment-variables.md) for the other agents.

## Configuration

Defaults for every command can go in a JSON file. ccusage reads the first one it finds:

1. `.ccusage/ccusage.json` in the current directory
2. `ccusage.json` in `~/.config/claude` or `~/.claude`

```json
{
  "defaults": {
    "timezone": "UTC",
    "offline": true,
    "breakdown": true
  }
}
```

`--config <file>` points at any other file. The upstream docs mention a `CCUSAGE_OFFLINE` variable, but this (Rust) build doesn't read it; use `--offline` or `"offline": true` instead.

## Related

[codeburn](../codeburn) shows the same kind of data as an interactive terminal dashboard.

## Helper Commands

```bash
ccusage-info    # Status line snippet, commands, and config locations
```

## Resources

- [ccusage Documentation](https://ccusage.com)
- [ccusage GitHub](https://github.com/ryoppippi/ccusage)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For ccusage-specific issues:
- [ccusage GitHub Issues](https://github.com/ryoppippi/ccusage/issues)

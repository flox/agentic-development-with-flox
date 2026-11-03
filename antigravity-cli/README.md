# Google Antigravity CLI

Google's terminal coding agent, and the successor to Gemini CLI. Antigravity CLI (`agy`) brings the Antigravity agent harness to the terminal: it reads and edits your code, runs commands, and works with Gemini and Claude models.

Google retired Gemini CLI for personal accounts on June 18, 2026 and moved its terminal experience to Antigravity CLI. This environment replaces the former `gemini-cli` environment.

- **Interactive or headless** - Full TUI, or one-shot prompts with text, JSON, or streaming JSON output
- **Execution modes** - Plan first, auto-accept edits, or run fully autonomously
- **Skills, plugins, hooks, and MCP** - The extension points carried over from Gemini CLI
- **Flox skills** - `flox`, `floxify`, and `flox-debug` agent skills for creating and managing Flox environments
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd antigravity-cli
flox activate
```

### 2. Sign In

```bash
# Sign in with your Google account on first launch
agy

# Or use a Gemini API key
export GEMINI_API_KEY="your-key"   # from https://aistudio.google.com
agy
```

Google Cloud users can sign in with Application Default Credentials by setting `AGY_ADC_AUTH`.

### 3. Start Coding

```bash
# Interactive session in the current directory
agy

# One-shot prompt
agy -p "Explain how the authentication module works"

# JSON output for scripting
agy -p "List all TODO comments" --output-format json
```

## Commands

```bash
agy                          # Interactive mode
agy -p "prompt"              # Non-interactive mode (also --print)
agy -i "prompt"              # Run a prompt, then continue interactively
agy -c                       # Continue the most recent conversation
agy --mode plan              # Execution mode: plan, accept-edits, or auto
agy --model <model>          # Choose a model (see: agy models)
agy --add-dir ../lib         # Add another directory to the workspace
agy --sandbox                # Run with terminal restrictions enabled
agy models                   # List available models
agy mcp list                 # Manage MCP servers
agy plugin list              # Manage plugins
agy changelog                # Release notes
```

## Coming from Gemini CLI

Antigravity CLI keeps its configuration under `~/.gemini`, next to Gemini CLI's:

| What | Where |
|------|-------|
| CLI settings | `~/.gemini/antigravity-cli/settings.json` |
| Global skills | `~/.gemini/config/skills/<name>/SKILL.md` |
| Plugins | `~/.gemini/config/plugins/<name>/` |
| MCP servers | `~/.gemini/config/mcp_config.json` |
| Global context | `~/.gemini/GEMINI.md` |
| Project skills | `<project>/.agents/skills/<name>/SKILL.md` |

To bring over Gemini CLI extensions, run `agy plugin import gemini` (`agy plugin import claude` imports Claude Code plugins).

## Flox Skills

The environment installs `agent-stacks/agent-plugin-flox` and links its skills into `~/.gemini/config/skills`:

- **flox** - Create and manage Flox environments, add packages, services
- **floxify** - Add a Flox environment to an existing project
- **flox-debug** - Diagnose package resolution and activation problems

Antigravity CLI has no environment-scoped skills path, so the links go in your global skills directory. They're refreshed on each activation; skills you created yourself, and links pointing anywhere else, are never replaced.

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `AGY_CLI_DISABLE_AUTO_UPDATE` | `1` | Turns off background auto-updates. agy can't replace the read-only Flox package (`agy update` fails with a not-writable error), so update with `flox upgrade` instead |
| `GEMINI_API_KEY` | (unset) | Use a Gemini API key instead of Google sign-in |
| `AGY_ADC_AUTH` | (unset) | Sign in with Google Cloud Application Default Credentials |

## System Compatibility

| Platform | Supported |
|----------|-----------|
| Linux x86_64 | Yes |
| Linux aarch64 | Yes |
| macOS Apple Silicon | Yes |

Note: macOS Intel (x86_64-darwin) is not supported.

## Resources

- [Antigravity CLI](https://antigravity.google/cli)
- [Documentation](https://antigravity.google/docs/cli)
- [Antigravity CLI on GitHub](https://github.com/google-antigravity/antigravity-cli) (issue tracker)
- [antigravity](../antigravity/) - the Antigravity IDE, as a Flox environment

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Antigravity CLI issues:
- [Antigravity CLI GitHub Issues](https://github.com/google-antigravity/antigravity-cli/issues)

## License

This Flox environment configuration is provided as-is. Antigravity CLI is proprietary software from Google, distributed under Google's terms.

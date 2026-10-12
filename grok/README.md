# Grok Build

xAI's agentic coding tool for the terminal. Grok Build reads your project, edits files, runs commands, and works through tasks in an interactive TUI or headless with `grok agent`.

- **xAI models** - Grok models via your xAI account or an API key
- **Interactive or headless** - Full TUI, or `grok agent` for scripting and CI
- **Git worktrees** - `grok --worktree=<name>` runs a task on its own branch
- **Skills, rules, and plugins** - Reads `~/.grok/skills`, rules files, and plugin marketplaces
- **Flox skills built in** - flox, floxify, and flox-debug are linked in on activation
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd grok
flox activate
```

### 2. Sign In

```bash
# Sign in with your xAI account (browser)
grok login

# Headless or remote machine
grok login --device-auth

# Or use an API key
export XAI_API_KEY=xai-...
```

### 3. Start Coding

```bash
# Interactive TUI
grok

# Start with a prompt
grok "fix the failing test"

# Run without the interactive UI
grok agent
```

## Commands

| Command | Description |
|---------|-------------|
| `grok` | Interactive TUI |
| `grok agent` | Run without the interactive UI |
| `grok inspect` | Show the config, skills, rules, and agents Grok discovers here |
| `grok sessions` | List, search, or restore sessions |
| `grok mcp` | Manage MCP servers |
| `grok plugin` | Manage plugins and marketplace sources |
| `grok worktree` | Manage git worktrees |
| `grok doctor` | Check terminal, clipboard, and input support |
| `grok login` / `grok logout` | Manage your xAI sign-in |

## Flox Skills

The environment installs `flox/skills-flox` and links its skills into `~/.grok/skills` (or `$GROK_HOME/skills`):

- **flox** - Create and manage Flox environments, add packages, services
- **floxify** - Add a Flox environment to an existing project
- **flox-debug** - Diagnose package resolution and activation problems

Grok only reads extra skill paths from `~/.grok/config.toml`, so linking is how the environment provides them without editing your config. Links are refreshed on each activation; skills you created yourself, and links pointing anywhere else, are never replaced. Check with `grok inspect`.

## Linux Note

The `flox/grok` package wraps Grok in bubblewrap on Linux so that Grok's hardcoded `/bin/bash` works on NixOS. On distributions where `/bin` is a symlink to `/usr/bin` (Debian, Ubuntu, Fedora, Arch, and most others), bubblewrap refuses that mount and Grok fails with:

```
bwrap: Can't mount on symlink destination /bin
```

These systems already have `/bin/bash`, so the environment puts small `grok` and `agent` shims in `$FLOX_ENV_CACHE/bin` that run Grok directly. On NixOS (no `/bin/bash`) the package's bubblewrap wrapper is used unchanged.

## Helper Commands

```bash
grok-info    # Show configuration, API key status, and command reference
```

## Resources

- [Grok Build](https://x.ai)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Grok-specific issues:
- Run `grok doctor` and `grok inspect`

# iloom

Control plane for AI-assisted development with Claude Code. iloom turns each issue into a "loom": its own git worktree, branch, and dev-server port, with Claude Code started inside it. The agent's analysis, plan, and decisions are posted to the issue as comments, so you and your team can follow the reasoning, not just the diff.

- **One loom per issue** - Isolated git worktrees, so parallel work never shares a checkout
- **Visible context** - Analysis and plans live in your issue tracker (GitHub, Linear, or Jira)
- **Guided workflow** - `il start` to analyze and plan, `il spin` to work, `il finish` to validate, merge, and clean up
- **Epics and swarms** - `il plan` breaks an epic into child issues; `il start` + `il spin` on the epic runs agents on them in parallel
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate Claude Code, Then This Environment

iloom drives Claude Code, which this environment doesn't include. Activate this repository's claude-code environment first, then this one on top of it:

```bash
cd claude-code
flox activate
cd ../iloom-cli
flox activate
```

The banner shows whether `claude` was found and whether the GitHub CLI is signed in. A Claude Code installed some other way works too.

### 2. Sign In to GitHub

GitHub is iloom's default issue tracker and pull request provider. The environment includes `gh`, which reuses an existing login from `~/.config/gh`. Otherwise:

```bash
gh auth login
```

Linear, Jira, and BitBucket take API tokens instead; `il init` sets them up (see [Secrets](#secrets)).

### 3. Configure a Repository and Start a Loom

```bash
cd ~/src/my-project
il init              # interactive setup wizard (runs Claude)
il start 25          # loom for issue 25: worktree, analysis, plan
il spin              # launch Claude inside the current loom
il finish            # validate, merge, and clean up
```

`il start` also takes a PR number or a branch name. To create just the worktree, with no Claude session, IDE, or terminals:

```bash
il start feat-login --no-claude --no-code --no-dev-server --no-terminal
il list                    # active looms
il cleanup feat-login      # remove it again
```

The first `il start` in a repository shows the settings it will use and asks "Are these defaults OK? [Y/n]"; later starts don't ask. `il cleanup` asks "Remove this worktree? [Y/n]". Both need a terminal: from a script or an agent, with no one to answer, they exit with status 13. Answer the first start once in a terminal (or pipe `y` into it), and pass `--force` to `il cleanup`. Cleaning up the last loom leaves the empty `<repo>-looms/` directory behind.

## Where iloom Writes

Looms are created next to the repository, not inside it: `~/src/my-project` gets its looms in `~/src/my-project-looms/<branch>`. Change this with `worktreePrefix` in `.iloom/settings.json`.

Outside the repository, iloom also changes some of your own files:

- **`~/.claude.json`** - Each new loom is marked as trusted, so Claude Code doesn't ask about the folder; `il cleanup` removes the entry again.
- **Your global git ignore file** (`~/.config/git/ignore` unless `core.excludesFile` says otherwise) - On first run iloom adds patterns for its local files (`.iloom/settings.local.json`, `.claude/agents/iloom-*`, `.env.local`, and similar).
- **`~/.config/iloom-ai/`** - Settings, loom metadata, and telemetry state.

## Terminals

`il start` and `il spin` open new terminal windows for Claude, the dev server, and a shell. On macOS iloom uses Terminal or iTerm. On Linux it uses gnome-terminal, konsole, or xterm when there is a display (`DISPLAY` or `WAYLAND_DISPLAY`); without one, such as over SSH, it opens the windows in tmux, which the environment provides on Linux. Attach with the `tmux attach -t ...` command iloom prints.

Two things to know about the tmux windows:

- **They don't run in this environment.** tmux starts each window from its server, in a login shell (`bash -lic`), so the window gets the environment of whichever shell started the tmux server, not of the shell where you ran `il`. If you already have a tmux server running, the windows get its `HOME` and `PATH`. On Debian and Ubuntu, `/etc/profile` also resets `PATH` in every login shell, so tools from Flox environments aren't found there even when iloom started the server itself. iloom runs itself by full path, so its own commands work; anything else, such as `claude` for `il spin`, has to be on the `PATH` your `~/.bashrc` sets up. A terminal with a display avoids only the first problem: iloom opens gnome-terminal, konsole, and xterm windows with `bash -lic` too, so `/etc/profile` resets `PATH` there as well. iloom checks `DISPLAY` before `WAYLAND_DISPLAY`, so a `DISPLAY` that is set but empty makes it use tmux even in a Wayland session; unset it instead.
- **They outlive the loom.** `il cleanup` removes the worktree but leaves its tmux session (Claude, dev server, and shell windows) running. List them with `tmux ls` and close one with `tmux kill-session -t <name>`.

## Telemetry and Updates

iloom sends anonymous usage events (for example `loom.created` and `session.started`, with an anonymous ID) to PostHog unless `~/.config/iloom-ai/telemetry.json` turns them off. It has no environment variable for this, so on activation the environment writes that opt-out, `{"enabled": false}`, when the file doesn't exist yet. Once the file exists, the environment never changes it, so `il telemetry on` and `il telemetry off` keep working. To keep iloom's own default instead:

```bash
ILOOM_TELEMETRY=on flox activate
```

`il telemetry status` shows the current setting.

The package lives in the read-only Nix store, but iloom thinks it's a global npm install: once a day it would ask the npm registry for a newer version, and `il update` would try `npm install -g`. The environment sets `OVERRIDE_INSTALLATION_METHOD=flox`, which turns off both. Upgrade with `flox upgrade` instead; `il update` exits with an error.

## Secrets

The environment stores no tokens. iloom reads them from:

- **GitHub** - the `gh` login (`~/.config/gh/hosts.yml`, or `GH_TOKEN` at activation)
- **Linear** - `LINEAR_API_TOKEN`, or `issueManagement.linear.apiToken` in `.iloom/settings.local.json` (gitignored), which `il init` can set up
- **Jira and BitBucket** - API tokens in `.iloom/settings.local.json`; see the [upstream setup guide](https://github.com/iloom-ai/iloom-cli#jira-setup)

For example, `LINEAR_API_TOKEN=lin_api_... flox activate` keeps the token out of every file.

## License

iloom is under the Business Source License 1.1. Its additional use grant allows any use, including commercial use inside your organization, except selling iloom itself, building it into a product you sell, or offering it as a hosted service. This release (0.14.3) becomes Apache 2.0 on 2030-09-06; see `LICENSE` in the package.

## Configuration

| Variable | Default | Effect |
|----------|---------|--------|
| `ILOOM_TELEMETRY` | `off` | `off` writes iloom's telemetry opt-out when no telemetry setting exists yet; `on` leaves iloom's default (on) |
| `OVERRIDE_INSTALLATION_METHOD` | `flox` | Tells iloom how it was installed; anything but `global` turns off its npm update checks |
| `ILOOM_DEBUG` | unset | `true` prints debug output (same as `--debug`) |

iloom's own settings, highest priority first: command-line flags (`--set key=value`), `.iloom/settings.local.json`, `.iloom/settings.json`, `~/.config/iloom-ai/settings.json`. `il init` writes them for you.

## Helper Commands

```bash
iloom-info    # Show version, telemetry and update settings, and a command reference
```

## Resources

- [iloom GitHub](https://github.com/iloom-ai/iloom-cli)
- [Command reference](https://github.com/iloom-ai/iloom-cli/blob/main/docs/iloom-commands.md)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For iloom-specific issues:
- `il feedback "<description>"` files a report from the command line
- [iloom GitHub Issues](https://github.com/iloom-ai/iloom-cli/issues)

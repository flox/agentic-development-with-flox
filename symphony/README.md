# Symphony

OpenAI's agent orchestrator. Symphony watches an issue tracker, and for each issue in an active state it creates a workspace, starts Codex there, and keeps Codex working until the issue is done. You manage the board; the agents do the work. This environment provides OpenAI's Elixir reference implementation, Codex, and a dashboard service.

- **Tracker-driven** - Linear, GitHub Issues, Jira Cloud, Asana, and GitLab
- **One workspace per issue** - Created on demand, set up by your own shell hooks (e.g. `git clone`)
- **Codex in app-server mode** - Several agents in parallel, with per-issue retries and turn limits
- **Web dashboard and JSON API** - Running, blocked, and retrying issues, plus token totals
- **No telemetry** - Symphony itself contacts only your tracker's API
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

> **Warning:** Upstream calls this implementation "prototype software intended for evaluation only". Symphony starts Codex on issues with nobody approving each step, for as many issues and turns as the workflow allows. Use it in trusted repositories, and read [Guardrails](#guardrails) before you point it at a real tracker.

## Quick Start

### 1. Activate the Environment and Sign In to Codex

```bash
cd symphony
flox activate
codex login            # or set OPENAI_API_KEY
```

The first activation writes a starter workflow to `.flox/cache/symphony/WORKFLOW.md`. It uses Symphony's in-memory tracker, which never has issues, so you can start Symphony and look at the dashboard without running any agent.

### 2. Start Symphony

Symphony refuses to start until you acknowledge that Codex will run unattended. In this environment, that acknowledgement is a variable:

```bash
SYMPHONY_ACCEPT_NO_GUARDRAILS=true flox activate -s
```

Then open http://127.0.0.1:14000. The service runs in the background; `symphony-start` runs Symphony in the current terminal instead, with its live status view.

```bash
flox services status                    # Check the service
curl localhost:14000/api/v1/state       # Runtime state as JSON
```

### 3. Point It at Real Work

Copy upstream's [WORKFLOW.md](https://github.com/openai/symphony/blob/main/elixir/WORKFLOW.md) (or the starter) into your repository, set the tracker and the `after_create` hook that fills each workspace, and point the environment at it:

```bash
SYMPHONY_WORKFLOW=~/src/myrepo/WORKFLOW.md SYMPHONY_ACCEPT_NO_GUARDRAILS=true flox activate -s
```

A workflow file is YAML front matter plus a Markdown prompt that Codex receives for each issue. A Linear example:

```md
---
tracker:
  kind: linear
  provider:
    project_slug: "my-project-1a2b3c"     # from the project's URL
  active_states: [Todo, In Progress]
  terminal_states: [Done, Closed, Cancelled, Canceled, Duplicate]
workspace:
  root: $SYMPHONY_WORKSPACE_ROOT
hooks:
  after_create: |
    PATH="$SYMPHONY_PATH"
    git clone --depth 1 git@github.com:my-org/my-repo.git .
agent:
  max_concurrent_agents: 2
  max_turns: 10
codex:
  command: env PATH="$SYMPHONY_PATH" codex app-server
---

You are working on issue {{ issue.identifier }}: {{ issue.title }}

{{ issue.description }}
```

Symphony rereads the file when it changes; if the new version is invalid, it keeps running with the last good one. The [Elixir README](https://github.com/openai/symphony/blob/main/elixir/README.md) documents every setting and each tracker adapter.

## Guardrails

Upstream's startup banner says "Codex will run without any guardrails". What that means in practice:

- **Nobody approves anything.** Codex works through each issue on its own. Symphony's default policy rejects Codex's approval requests instead of waiting for you, and an issue where Codex needs your input shows as blocked in the dashboard. Upstream's own example workflow goes further, with `approval_policy: never`, network access, and Codex inheriting your whole environment.
- **Sandboxing is Codex's.** With the policy fields left out, Codex runs with `workspace-write`, limited to the issue's workspace. `danger-full-access` turns that off.
- **Hooks run unsandboxed.** `after_create`, `before_run`, `after_run`, and `before_remove` are shell scripts that run as you, on your machine.
- **It uses your Codex quota.** Up to `max_concurrent_agents` agents (default 10) run at once, each for up to `max_turns` turns (default 20), until the issue leaves its active states.
- **Tracker tools act as you.** Each adapter gives Codex a raw API tool (`linear_graphql`, `github_api`, ...) that Symphony runs with your token, and the tool can do whatever the token allows, not just touch the configured project.
- **Other tokens reach Codex.** Symphony removes only the configured tracker's token variable from Codex's environment. Every other variable, such as a `GITHUB_TOKEN` while the tracker is Linear, or `OPENAI_API_KEY`, is passed to Codex, and the hooks see all of them, the tracker's token included. Keep only the token you need in your shell and in `~/.config/symphony/env`.
- **The dashboard has no login.** It listens on `127.0.0.1` by default, and anyone who can reach it can read the state and trigger a refresh. Only change `server.host` on a network you trust.

`SYMPHONY_ACCEPT_NO_GUARDRAILS=true` passes upstream's `--i-understand-that-this-will-be-running-without-the-usual-guardrails` flag, for both the service and `symphony-start`. Without it, the service stops at once with an explanation in `.flox/cache/logs/symphony.log`.

## Tracker Credentials

Each tracker reads its token from an environment variable: `LINEAR_API_KEY`, `GITHUB_TOKEN`, `JIRA_BASE_URL` / `JIRA_EMAIL` / `JIRA_API_TOKEN`, `ASANA_PAT`, or `GITLAB_PAT`. Don't put a token in a `WORKFLOW.md` that Codex can read; leave the setting out, or write `$LINEAR_API_KEY`.

Pass a token at activation:

```bash
LINEAR_API_KEY=lin_api_... SYMPHONY_ACCEPT_NO_GUARDRAILS=true flox activate -s
```

Or keep tokens in `~/.config/symphony/env` (`KEY=value` lines, with no space before `=`; `#` comments, `export`, and quotes are fine, but a quoted value ends at the next matching quote, with no backslash escapes, and a value with no closing quote is skipped), which the environment loads on activation. Codex and the workflow hooks inherit what it sets, and many variables make programs run commands (`BASH_ENV`, `RUSTC_WRAPPER`, `npm_config_script_shell`, ...), so only names ending in `_TOKEN`, `_KEY`, `_PAT`, `_SECRET`, `_PASSWORD`, `_EMAIL`, `_USER`, `_USERNAME`, `_URL`, `_SLUG`, or `_ID` load. Of those, names starting with `LD_`, `GIT_`, `XDG_`, or a package manager's prefix (`PIP_`, `UV_`, `NPM_CONFIG_`, `CARGO_`, ...) are refused too. Anything else is skipped with a warning; set it when you activate instead. So is a line that isn't `KEY=value`, such as one with a space before `=`; the warning gives its line number, not its contents. Variables you already set take precedence. Make the file readable only by you:

```bash
mkdir -p ~/.config/symphony
(umask 077; echo 'LINEAR_API_KEY=lin_api_...' > ~/.config/symphony/env)
```

`SYMPHONY_ENV_FILE` points at a different file. `symphony-info` shows which tracker variables are set, without printing them.

## Login Shells and PATH

Symphony starts Codex with `bash -lc` and runs workflow hooks with `sh -lc`. Login shells read `/etc/profile`, which on Debian and Ubuntu resets `PATH`, so neither would find this environment's `codex`, `git`, or anything else from Flox. The environment saves its `PATH` as `SYMPHONY_PATH`, and the starter workflow restores it: `env PATH="$SYMPHONY_PATH" codex app-server`. Do the same in your own workflow's `codex.command`, and put `PATH="$SYMPHONY_PATH"` on a line of its own at the top of each hook. In `codex.command`, keep the `env`: Symphony runs the command as `exec <command>`, and `exec` treats `PATH=...` as the program to run, so `exec PATH=... codex` fails with "No such file or directory". On macOS, `/etc/profile` keeps the existing `PATH` entries, so the line does no harm there.

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `SYMPHONY_WORKFLOW` | `$SYMPHONY_DATA/WORKFLOW.md` | Workflow file for the service and `symphony-start` |
| `SYMPHONY_PORT` | `14000` | Dashboard and JSON API port (overrides `server.port`) |
| `SYMPHONY_ACCEPT_NO_GUARDRAILS` | `false` | `true` acknowledges unattended Codex runs, so Symphony can start |
| `SYMPHONY_DATA` | `$FLOX_ENV_CACHE/symphony` | Starter workflow, workspaces, and logs |
| `SYMPHONY_WORKSPACE_ROOT` | `$SYMPHONY_DATA/workspaces` | Per-issue workspaces, as used by the starter workflow |
| `SYMPHONY_LOGS_ROOT` | `$SYMPHONY_DATA` | Symphony writes `log/symphony.log*` here |
| `SYMPHONY_ENV_FILE` | `~/.config/symphony/env` | File of tracker credentials to load |
| `SYMPHONY_PATH` | `PATH` at activation | Restored inside the login shells Symphony starts |

Everything else (tracker, polling interval, concurrency, Codex policy, hooks, `server.host`) is set in the workflow file.

## Logs

- `.flox/cache/symphony/log/symphony.log.1` - Symphony's own log (rotated)
- `.flox/cache/logs/symphony.log` - Service startup errors, such as an invalid workflow or a missing tracker token

If `LANG` (and `LC_ALL`, `LC_CTYPE`) are unset, as under cron, the service sets a UTF-8 `LANG`, so the Erlang VM doesn't fall back to latin1 file names.

The service discards Symphony's terminal status view, which is redrawn about once a second; the dashboard shows the same information.

## Helper Commands

```bash
symphony-start    # Run Symphony in this terminal, with its status view
symphony-info     # Show configuration, log locations, and tracker credentials
```

## Resources

- [Symphony GitHub](https://github.com/openai/symphony)
- [Symphony specification](https://github.com/openai/symphony/blob/main/SPEC.md)
- [Elixir implementation README](https://github.com/openai/symphony/blob/main/elixir/README.md)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Symphony-specific issues:
- [Symphony GitHub Issues](https://github.com/openai/symphony/issues)

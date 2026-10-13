# Worktrunk

Git worktree manager built for running coding agents in parallel. `wt` gives each task its own branch and working directory, so several agents (or you and an agent) can work in one repository without stepping on each other, then merges the result back and cleans up.

- **One command per worktree** - `wt switch -c feat` creates the branch and worktree and moves you into it
- **Start an agent there** - `wt switch -c -x claude feat` launches Claude Code (or any program) in the new worktree
- **Status at a glance** - `wt list` shows every worktree with uncommitted changes, ahead/behind, and diff size
- **Merge and clean up** - `wt merge` squashes, rebases, merges, and removes the worktree and branch
- **Project hooks** - Run setup (`npm ci`), checks (`npm test`), or dev servers per worktree from `.config/wt.toml`
- **No account needed** - Works on any local git repository
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd worktrunk
flox activate
```

### 2. Work in a Repository

```bash
cd ~/code/myproject

# Create a branch and worktree, and move into it
wt switch -c fix-login

# ...edit, commit...

# See every worktree
wt list

# Merge into the default branch, remove the worktree, and return to main
wt merge
```

By default, worktrees are created next to the repository: `~/code/myproject.fix-login`.

### 3. Run Agents in Parallel

```bash
wt switch -c -x claude auth-refactor
wt switch -c -x codex test-coverage
```

`-x` runs any program in the new worktree. Arguments after `--` are passed to it, so `wt switch -c -x claude fix-bug -- 'Fix GH #322'` starts Claude Code with that prompt. The agent itself comes from its own environment (for example [claude-code](../claude-code) or [codex](../codex)) or your own install; activate both, or layer one on the other.

## Shell Integration

A program can't change its parent shell's directory, so Worktrunk uses a small `wt` shell function to follow `wt switch` and `wt merge`. This environment loads that function in interactive bash, zsh, and fish shells for the length of the activation. Nothing is added to your `~/.bashrc`, `~/.zshrc`, or fish config, so you don't need `wt config shell install`.

Without the function (for example `flox activate -- wt switch ...` from a script, or `git wt switch`), Worktrunk still creates and switches worktrees but prints the path instead of moving you there.

## Commands

| Command | Description |
|---------|-------------|
| `wt switch -c <branch>` | Create a branch and worktree, and cd into it |
| `wt switch <branch>` | Switch to an existing worktree; with no branch, open a picker |
| `wt switch ^` / `-` | Switch to the default branch / the previous worktree |
| `wt switch ... -x <program>` | Run a program (an agent, an editor) in the worktree |
| `wt list` | List worktrees and their status |
| `wt merge` | Merge the current branch into the default branch and clean up |
| `wt remove` | Remove a worktree; delete its branch if merged |
| `wt config create` | Write a commented user config |
| `wt config show` | Show config files and locations |

`git wt` runs the same commands as a git subcommand.

## Configuration

| File | Purpose |
|------|---------|
| `~/.config/worktrunk/config.toml` | Your settings: worktree location, merge defaults, aliases, LLM commit messages |
| `.config/wt.toml` (in the repository) | Shared project hooks, e.g. `pre-start = "npm ci"`, `pre-merge = "npm test"` |

Any user setting can also come from a `WORKTRUNK_` variable, with `__` between nested keys:

```bash
# Put worktrees inside the repository instead of next to it
export WORKTRUNK_WORKTREE_PATH='{{ repo_path }}/.worktrees/{{ branch | sanitize }}'
```

Worktrunk asks before running a project's hooks ("Allow and remember?"); if you decline, it creates the worktree without running them.

### Commit Messages

When `wt merge` squashes a branch, it uses "Squash commits from &lt;branch&gt;" as the message. To have an agent write commit messages instead, set `commit.generation.command`; `wt config --help` lists ready-made commands for Claude Code, Codex, OpenCode, llm, and aichat.

## Helper Commands

```bash
wt-info    # Show configuration and command reference
```

## Resources

- [Worktrunk Documentation](https://worktrunk.dev)
- [Worktrunk GitHub](https://github.com/max-sixty/worktrunk)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Worktrunk-specific issues:
- [Worktrunk GitHub Issues](https://github.com/max-sixty/worktrunk/issues)

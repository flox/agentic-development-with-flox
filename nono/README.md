# nono

A kernel-enforced sandbox for AI agents. `nono` runs a coding agent, an MCP server, or any command with OS-level limits on what it can read, write, and reach on the network, without root, a container, or a VM. On Linux it uses Landlock.

- **Filesystem limits** - The command can write only what you grant (usually the current directory) plus temp folders; credentials such as `~/.ssh` stay unreadable
- **Network control** - Block the network, or allow only listed domains (and URL paths) through nono's filtering proxy
- **Credential proxying** - Keep API keys outside the sandbox; nono's proxy adds them to approved requests
- **Signed agent profiles** - Ready-made, signed profiles for Claude Code, Codex, pi, OpenCode, and more from registry.nono.sh
- **Audit trail** - A tamper-evident record of sandboxed sessions
- **Rollback** - Snapshot the working directory and restore it after an agent takes a wrong turn
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd nono
flox activate
```

### 2. Run Something in the Sandbox

```bash
cd ~/my-project

# Read and write the current directory; everything else follows the profile.
# The network stays open unless you limit it.
nono run --allow-cwd -- make test

# No network at all
nono run --allow-cwd --block-net -- python script.py

# Only these domains
nono run --allow-cwd --allow-domain api.anthropic.com --allow-domain github.com -- <command>

# See what the sandbox would allow, without running anything
nono run --dry-run --allow-cwd -- <command>
```

### 3. Sandbox a Coding Agent

This environment doesn't include any coding agent; nono only runs what your shell can already find. Activate the agent's environment first, then this one on top of it, then run the agent from your project folder:

```bash
flox activate -r flox/claude-code   # 1. The agent (or: flox activate -d path/to/claude-code)
flox activate -r flox/nono          # 2. nono, on top
cd ~/my-project                     # 3. The folder the agent may write
command -v claude                   # Should print a path

nono search claude                  # Find a profile pack for the agent
nono pull nolabs-ai/claude          # Install it (see the note below)
nono run --allow-cwd --profile "$(nono-flox-profile nolabs-ai/claude)" -- claude
```

Activating nono last matters for plain `nono run` without `--profile`: its default profile covers the environments active when nono was activated. `nono-flox-profile` checks what's active each time it runs, so the command above works in either order.

`nono-flox-profile nolabs-ai/claude` adds the paths Flox needs to the pack's profile (see [The Flox Profile](#the-flox-profile)). With the pack alone, `claude` fails to start: in the claude-code environment it's a wrapper script in that environment's `.flox/cache`, which the pack can't read.

Packs exist for `claude`, `codex`, `pi`, `opencode`, and others; `nono search <agent>` lists them.

**Note:** a pack can do more than add a profile. `nono pull nolabs-ai/claude` also installs a nono plugin for Claude Code, adding a `nolabs-ai` marketplace under `~/.claude/plugins/` and enabling the plugin in `~/.claude/settings.json`. The environment never pulls packs itself, but `nono run --profile <pack>` offers to install a pack that's missing; answering `y` makes the same changes. `nono remove nolabs-ai/claude` removes the pack and reverses its changes to `~/.claude`.

## The Flox Profile

nono's built-in `default` profile can't read `/nix/store`, so nothing Flox installs would run inside it. Agent packs have a second gap: Flox environments keep wrapper scripts in their `.flox/cache` folders (claude-code's `claude` is one), and packs can't read those either.

`nono-flox-profile [base]` fixes both. It writes a profile that extends `base` (nono's `default` when omitted, or a pack such as `nolabs-ai/claude`) with:

- nono's `nix_runtime` group, which grants read access to `/nix/store` and the Nix profile paths
- read access to every active Flox environment, and to the `.flox` folder of each local or remote environment on `PATH`
- for `default` only, read and write access to the working directory when you pass `--allow-cwd`

It prints the profile's path, so you can pass it straight to `--profile`. Profiles go in `$FLOX_ENV_CACHE/nono/`, named by their content.

On activation the environment runs `nono-flox-profile` and makes the result the default through `NONO_PROFILE`, so `nono run` and `nono shell` use it unless you pass `--profile`. It covers the environments active at that moment, so activate nono last; if you activate another environment on top later, refresh the default with `export NONO_PROFILE=$(nono-flox-profile)`.

For your own rules, create a profile and wrap it the same way:

```bash
nono profile init my-agent --extends default   # Writes ~/.config/nono/profiles/my-agent.json
nono run --allow-cwd --profile "$(nono-flox-profile my-agent)" -- <command>
nono profile show "$NONO_FLOX_PROFILE"         # Fully resolved rules of the default Flox profile
nono profile groups                            # Policy groups you can include
```

## Commands

```bash
nono run --allow-cwd -- <command>      # Run a command in the sandbox
nono shell --allow-cwd                 # Interactive sandboxed shell
nono why --path ~/.ssh                 # Explain why a path is allowed or denied
nono profile list                      # Built-in, pack, and user profiles
nono audit list                        # Audit trail of sandboxed sessions
nono ps                                # Running or detached sessions
nono-flox-profile [base]               # Profile for Flox-installed tools (prints its path)
nono-info                              # Configuration and examples
```

### Rollback

```bash
nono run --allow-cwd --rollback -- <command>   # Snapshot the directory first
nono rollback list                             # Sessions with changes
nono rollback show <id> --diff                 # What changed
nono rollback restore <id> --snapshot 0        # Restore the state before the command
```

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `NONO_PROFILE` | the Flox profile | Profile used when you don't pass `--profile` |
| `NONO_FLOX_PROFILE` | `$FLOX_ENV_CACHE/nono/default-<sum>.json` | The Flox profile made on activation (for reference) |
| `NONO_FLOX_PROFILE_DIR` | `$FLOX_ENV_CACHE/nono` | Where `nono-flox-profile` writes profiles |
| `NONO_NO_UPDATE_CHECK` | `1` | Skips nono's release check; Flox decides which version you run (`flox upgrade`) |

```bash
# Start with a different default profile (it won't include the Flox paths)
NONO_PROFILE=my-agent flox activate
```

nono keeps user profiles in `~/.config/nono/profiles/`, packs in `~/.config/nono/packages/`, and session, audit, and rollback data in `~/.local/state/nono/`.

## Troubleshooting

**`nono: Command execution failed: claude: cannot find binary path`** - The agent isn't on `PATH`. nono only runs what your shell can find, so activate the agent's environment first and nono on top of it (`flox activate -r flox/claude-code`, then `flox activate -r flox/nono`). `command -v claude` should print a path before you run it under nono.

**`warn 1 PATH entry sandbox-writable`** - A folder on `PATH` is inside a folder the sandbox can write, so the sandboxed command could plant a program there. This happens when you run nono from inside a Flox environment's own folder, whose `.flox/cache/bin` is on `PATH`. Run nono from your project folder instead.

## System Compatibility

| Platform | Supported |
|----------|-----------|
| Linux x86_64 | Yes |
| Linux aarch64 | Yes |
| macOS Apple Silicon | Yes |

Note: macOS Intel (x86_64-darwin) is not supported. Windows works through WSL2.

## Resources

- [nono Documentation](https://nono.sh/docs)
- [Credential injection](https://nono.sh/docs/cli/features/credential-injection)
- [Networking](https://nono.sh/docs/cli/features/networking)
- [Atomic rollbacks](https://nono.sh/docs/cli/features/atomic-rollbacks)
- [Profile registry](https://registry.nono.sh)
- [nono on GitHub](https://github.com/nolabs-ai/nono)
- [sandbox-runtime](../sandbox-runtime/) - Anthropic's sandbox, as a Flox environment

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For nono issues:
- [nono GitHub Issues](https://github.com/nolabs-ai/nono/issues)

## License

This Flox environment configuration is provided as-is. nono is licensed under the Apache-2.0 license - see the [nono repository](https://github.com/nolabs-ai/nono) for details.

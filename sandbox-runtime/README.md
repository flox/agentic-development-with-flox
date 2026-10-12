# Sandbox Runtime (srt)

Anthropic's lightweight sandbox for agents. `srt` runs any command (a coding agent, an MCP server, a build script) with OS-level limits on what it can read, write, and reach on the network, without a container. It uses `bubblewrap` on Linux and `sandbox-exec` on macOS, plus a filtering proxy for network access.

- **Network allowlist** - Only the domains you list are reachable
- **Filesystem rules** - Choose what can be written; block reads of credentials and other sensitive paths
- **Whole process tree** - Limits apply to everything the command starts
- **No container** - Runs as you, in your directory, with your tools
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

srt is a research preview, and its configuration format may change.

## Quick Start

### 1. Activate the Environment

```bash
cd sandbox-runtime
flox activate
```

### 2. Create a Settings File

```bash
srt-init
```

This writes a starter `~/.srt-settings.json`, and never overwrites an existing one:

- **Network** - GitHub, npm, and PyPI only
- **Writes** - The current directory and `/tmp`, except `.env`
- **Reads** - Everything except `~/.ssh`, `~/.aws`, `~/.gnupg`, and `~/.config/gh`

Without a settings file, srt allows no network access and no writes at all, not even to the current directory.

### 3. Run Something in the Sandbox

```bash
srt -- curl -s https://github.com          # allowed
srt -- curl -s https://example.com         # blocked
srt -c "cat ~/.ssh/id_ed25519"             # blocked
srt -c "npm test"                          # writes to the current directory are allowed
```

Use `srt -- <command> [args]` when the command has flags of its own (otherwise srt may read them as its own options), or `srt -c "<string>"` for a shell command line.

## Sandboxing a Coding Agent

Give the agent its own settings file: allow its API host, plus writes to the project and the agent's config directory.

```json
{
  "network": { "allowedDomains": ["api.anthropic.com"], "deniedDomains": [] },
  "filesystem": {
    "denyRead": ["~/.ssh", "~/.aws"],
    "allowWrite": [".", "~/.pi", "/tmp"],
    "denyWrite": [".env"]
  }
}
```

```bash
srt -s ~/srt-pi.json -- pi
```

Everything the agent runs (shell commands, package installs, test runs) inherits those limits. For a local model, allow the model server's host instead, e.g. `"192.168.1.50"` for an Ollama server on your network.

## Sandboxing an MCP Server

Put `srt --` in front of the server's command in your MCP config:

```json
{
  "mcpServers": {
    "filesystem": {
      "command": "srt",
      "args": ["--", "npx", "-y", "@modelcontextprotocol/server-filesystem"]
    }
  }
}
```

If the agent doesn't run inside this environment, start srt through it instead:

```json
"command": "flox",
"args": ["activate", "-d", "/path/to/sandbox-runtime", "--",
         "srt", "--", "npx", "-y", "@modelcontextprotocol/server-filesystem"]
```

`flox activate --` sends activation output to stderr, so the MCP protocol on stdout is unaffected.

## Settings Reference

| Key | Meaning |
|-----|---------|
| `network.allowedDomains` | Hosts the sandbox can reach (`*.example.com` wildcards work) |
| `network.deniedDomains` | Hosts that are always blocked |
| `network.allowUnixSockets` | Unix sockets to allow, e.g. `/var/run/docker.sock` |
| `filesystem.allowWrite` | Paths that can be written (nothing else can) |
| `filesystem.denyWrite` | Paths that can never be written, even inside `allowWrite` |
| `filesystem.denyRead` | Paths that cannot be read |
| `filesystem.allowRead` | Paths re-allowed inside a `denyRead` path |

See the [full reference](https://github.com/anthropic-experimental/sandbox-runtime#configuration) for all options.

## Linux Note

Ubuntu 24.04 and later restrict unprivileged user namespaces by default, which stops bubblewrap from working. The environment warns on activation when this applies. Allow them with:

```bash
sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0
```

## Helper Commands

```bash
srt-info    # Show configuration and command reference
srt-init    # Write a starter ~/.srt-settings.json
```

## Resources

- [Sandbox Runtime GitHub](https://github.com/anthropic-experimental/sandbox-runtime)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For srt-specific issues:
- [Sandbox Runtime GitHub Issues](https://github.com/anthropic-experimental/sandbox-runtime/issues)

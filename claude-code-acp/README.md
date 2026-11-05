# Claude Agent ACP

Use Claude Code from editors and tools that speak the [Agent Client Protocol](https://agentclientprotocol.com) (ACP), such as Zed, Neovim, Emacs, and marimo. This environment provides [`claude-agent-acp`](https://github.com/agentclientprotocol/claude-agent-acp), the ACP adapter for Claude Code built on the Claude Agent SDK.

- **Ready to run** - Installs a prebuilt `claude-agent-acp` from the Flox catalog, with its own Claude Code; no Node.js or npm install
- **Tool calls with permission requests** - Claude asks your editor before it runs a command or edits a file
- **Editor features** - @-mentions, images, edit review, TODO lists, terminals, slash commands, and your client's MCP servers
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

The adapter used to be published as `@zed-industries/claude-code-acp`, with a `claude-code-acp` command. That package is deprecated; this environment now installs its successor, and the command is `claude-agent-acp`.

## Quick Start

### 1. Get the Adapter's Path

```bash
cd claude-code-acp
flox activate
echo "$FLOX_ENV/bin/claude-agent-acp"
```

`$FLOX_ENV` is the environment's stable path, so the path stays the same when the environment is upgraded.

### 2. Point Your Editor at It

Your ACP client starts the adapter itself and talks to it over stdin and stdout. In the client's agent settings, add a custom agent whose command is the path from step 1, with no arguments. The client runs that path directly, not through `flox activate`, and the adapter needs nothing else from the environment.

### 3. Sign In

The adapter uses Claude Code's sign-in. Either:

- **Log in to Claude Code once** (`claude /login`, for example from this repository's claude-code environment). The adapter reads the same login.
- **Use an API key.** Set `ANTHROPIC_API_KEY` in the environment your editor starts agents with, often in the custom agent's `env` setting. Exporting it in the shell where you ran `flox activate` doesn't reach an editor that's already running.

## Permissions

New sessions start in Manual mode: Claude asks before it runs a command or changes a file, and your editor shows the request. Switch modes from the editor (Accept edits, Plan, Auto, and others the adapter offers).

## Using Another Claude Code

The adapter runs the Claude Code that's packaged with it. To use a different one, set `CLAUDE_CODE_EXECUTABLE` to its path in the environment your editor starts the adapter with.

## Resources

- [claude-agent-acp on GitHub](https://github.com/agentclientprotocol/claude-agent-acp)
- [Agent Client Protocol](https://agentclientprotocol.com)
- [Claude Agent SDK](https://platform.claude.com/docs/en/agent-sdk/overview)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For adapter issues:
- [claude-agent-acp GitHub Issues](https://github.com/agentclientprotocol/claude-agent-acp/issues)

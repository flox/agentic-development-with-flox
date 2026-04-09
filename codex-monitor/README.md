# Codex Monitor

Desktop app for orchestrating multiple OpenAI Codex AI agents across local workspaces. Built with Tauri by Thomas Ricouard.

- **Workspace management** - Persistent workspaces with per-workspace Codex agent sessions
- **Thread tracking** - Pin, rename, archive, copy, and resume agent threads
- **Git/GitHub integration** - Diffs, staging, commits, branches, PRs, issues via `gh` CLI
- **Composer** - Image attachments, skill autocomplete (`$`), prompt libraries (`/prompts:`), file paths (`@`)
- **Remote daemon mode** - Run Codex remotely via Tailscale integration
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd codex-monitor
flox activate
```

### 2. Ensure Codex CLI is Available

On x86_64-linux, the Codex CLI is included automatically. On other platforms:

```bash
npm install -g @openai/codex
```

### 3. Launch

```bash
codex-monitor
```

## How It Works

Codex Monitor spawns a `codex app-server` process per workspace and communicates via the app-server protocol over stdio. Each workspace gets its own agent session with independent thread history.

## Features

- **Workspace management** with sorting and grouping
- **Worktree/clone agent support** for isolated work
- **Dictation** via Whisper-based transcription
- **File tree** with search and platform-specific icons
- **Global and workspace-scoped prompt libraries**
- **Terminal dock** with multiple tabs
- **Resizable panels** and macOS vibrancy effects
- **In-app updates**

## Configuration

Codex Monitor stores settings in platform-standard app data directories:

- `settings.json` - App settings (including Codex binary path)
- `workspaces.json` - Workspace configurations

Codex itself reads from `$CODEX_HOME/config.toml` or `~/.codex/config.toml`.

## Prerequisites

- **Codex CLI** in PATH (included on x86_64-linux, install separately on other platforms)
- **Git** (included)
- **`gh` CLI** (optional, for GitHub PR/issue features)

## Helper Commands

```bash
codex-monitor-info    # Show configuration and Codex CLI status
```

## Resources

- [Codex Monitor GitHub](https://github.com/Dimillian/CodexMonitor)
- [OpenAI Codex CLI](https://github.com/openai/codex)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Codex Monitor-specific issues:
- [Codex Monitor GitHub Issues](https://github.com/Dimillian/CodexMonitor/issues)

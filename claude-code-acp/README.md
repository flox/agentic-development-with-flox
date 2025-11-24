# Flox Environment for Claude Code ACP

A Flox environment for [Claude Code ACP](https://github.com/zed-industries/claude-code-acp), an Agent Client Protocol adapter that bridges Claude Code capabilities with ACP-compatible development environments.

## Overview

Claude Code ACP implements the Agent Client Protocol using the official Claude Code SDK, enabling AI-powered code assistance across multiple editors and development tools beyond platform-specific integrations.

## Included Tools

The environment provides:

- Node.js runtime
- npm package manager

The adapter itself is installed via npm: `@zed-industries/claude-code-acp`

## Prerequisites

- [Flox](https://flox.dev/get) installed
- Anthropic API key

## Installation & Activation

```bash
# Clone the repository
git clone https://github.com/barstoolbluz/agentic-development-with-flox
cd agentic-development-with-flox/claude-code-acp

# Activate the environment
flox activate

# Install Claude Code ACP globally
npm install -g @zed-industries/claude-code-acp
```

## Configuration

The adapter requires an Anthropic API key. Configure via:

**Environment variable:**
```bash
export ANTHROPIC_API_KEY=sk-ant-...
```

**Configuration directory:**
```bash
mkdir -p ~/.config/claude-code-acp
# Create config file with API key
```

Per Flox conventions, credentials reside in `$HOME`, not in the project directory.

## Usage

Start the ACP server:

```bash
# With environment variable
ANTHROPIC_API_KEY=sk-ant-... claude-code-acp

# Or if configured in ~/.config/
claude-code-acp
```

## ACP-Compatible Clients

Connect the server from:

- **Zed** - Native ACP support
- **Neovim** - Via ACP plugin
- **Emacs** - Via ACP mode
- **marimo** - Notebook integration

Refer to client-specific documentation for connection configuration.

## Features

The adapter provides:

- **Context mentions** - @ symbol for referencing code/files
- **Image attachments** - Visual context for assistance
- **Tool invocations** - Execute tools with permission prompts
- **Following mode** - Real-time assistance
- **Edit review** - Code change inspection
- **TODO management** - Task tracking integration
- **Terminal access** - Interactive and background execution
- **Slash commands** - Custom command extensions
- **MCP integration** - Model Context Protocol server support

## System Compatibility

This environment works on:
- Linux x86_64
- Linux aarch64 (ARM64)
- macOS x86_64 (Intel)
- macOS ARM64 (Apple Silicon)

## Upstream

- **Source**: [github.com/zed-industries/claude-code-acp](https://github.com/zed-industries/claude-code-acp)
- **Package**: `@zed-industries/claude-code-acp` (npm)
- **Maintainer**: Zed Industries
- **License**: Apache 2.0

## About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Dependencies and configuration in TOML
- **Reproducibility** - Consistent environments across systems
- **Package isolation** - No conflicts between project dependencies
- **Nixpkgs integration** - Access to 150,000+ packages

## License

Claude Code ACP: Apache 2.0 (see upstream repository)

This Flox environment configuration is provided as-is.

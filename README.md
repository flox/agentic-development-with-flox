# AI Coding Tools - Flox Environments

A collection of Flox environments for AI-powered coding tools and CLI interfaces to large language models. Each environment provides a pre-configured setup for its respective tool.

## Overview

This repository contains Flox environment configurations for various AI coding assistants, code generation tools, and LLM CLI interfaces. These environments handle package dependencies and provide activation hooks with setup guidance.

Each environment:
- Defines dependencies in `manifest.toml`
- Runs on macOS (Intel/ARM) and Linux (x86/ARM)
- Provides activation messages with usage instructions
- Follows Flox conventions for configuration (secrets in `$HOME`)

## Available Environments

### LLM CLI Interfaces

- [**aichat**](./aichat) - Multi-provider LLM CLI (OpenAI, Claude, Gemini, Ollama, Groq, Azure, Bedrock, etc.)
- [**gemini-cli**](./gemini-cli) - Google Gemini CLI interface

### AI Coding Tools

- [**amazon-q-cli**](./amazon-q-cli) - Amazon Q Developer CLI (Claude Sonnet 4)
- [**copilot-cli**](./copilot-cli) - GitHub Copilot CLI
- [**opencode**](./opencode) - OpenCode AI coding agent with TUI
- [**goose-cli**](./goose-cli) - Goose AI coding agent
- [**cursor-agent**](./cursor-agent) - Cursor Agent CLI
- [**kilocode-cli**](./kilocode-cli) - Kilocode CLI
- [**nanocoder**](./nanocoder) - Nanocoder tool
- [**qwen-code**](./qwen-code) - Qwen code model CLI
- [**eca**](./eca) - Emerge Cognitive Architecture
- [**groq-code-cli**](./groq-code-cli) - Groq-powered coding CLI
- [**forge**](./forge) - Forge development tool
- [**coderabbit-cli**](./coderabbit-cli) - CodeRabbit code review tool

### Supporting Tools

- [**claude-code**](./claude-code) - Claude Code environment
- [**claude-code-router**](./claude-code-router) - Claude Code router
- [**claude-code-acp**](./claude-code-acp) - Claude Code with ACP
- [**codex**](./codex) - OpenAI Codex environment
- [**codex-acp**](./codex-acp) - Codex with ACP
- [**spec-kit**](./spec-kit) - GitHub Spec Kit
- [**amp**](./amp) - Amp environment
- [**crush**](./crush) - Crush tool
- [**droid**](./droid) - Droid assistant
- [**catnip**](./catnip) - Catnip utility
- [**code**](./code) - Code environment
- [**claudebox**](./claudebox) - Claude sandbox
- [**backlog-md**](./backlog-md) - Markdown backlog tool

## Usage

### Prerequisites

- [Flox](https://flox.dev/get) installed
- API keys for chosen providers (stored in `$HOME` per Flox conventions)

### Basic Usage

```bash
# Clone repository
git clone https://github.com/barstoolbluz/agentic-development-with-flox
cd agentic-development-with-flox

# Navigate to an environment
cd aichat

# Activate environment
flox activate

# Follow activation messages for tool-specific setup
```

### Example: aichat

```bash
cd aichat
flox activate
# First-time users: run 'aichat' and follow interactive setup
aichat "Write a Python function to validate email addresses"
```

### Example: amazon-q-cli

```bash
cd amazon-q-cli
flox activate
q login      # Authenticate with AWS Builder ID
q chat       # Start chat session
```

## Environment Structure

Each environment directory contains:

```
environment-name/
├── .flox/
│   └── env/
│       ├── manifest.toml    # Package dependencies and configuration
│       └── manifest.lock    # Locked package versions
└── README.md                # Tool-specific documentation
```

The `manifest.toml` file defines:
- Package dependencies
- Environment variables (non-secret)
- Activation hooks (setup checks, usage messages)
- Shell profile customizations

## Security Conventions

Per Flox best practices:

- **API keys and credentials**: Must reside in `$HOME` (e.g., `~/.config/`, `~/.aws/`)
- **Environment variables**: Preferred configuration method for secrets
- **Project directories**: May contain non-secret configuration; must not contain credentials
- **`.gitignore`**: Ensures credential files are excluded from version control

## System Requirements

- macOS (Intel/ARM) or Linux (x86/ARM)
- Flox package manager
- Internet connection for LLM API access
- Valid API keys for chosen providers

## Flox Overview

[Flox](https://flox.dev/docs) provides:

- **Declarative environments** - Dependencies and configuration in TOML
- **Reproducibility** - Consistent environments across systems
- **Package isolation** - No conflicts between project dependencies
- **Nixpkgs integration** - Access to 150,000+ packages

## Attribution

Each tool is developed and maintained by its respective upstream project. See individual environment READMEs for:
- Upstream project links
- Original author/maintainer attribution
- Tool-specific licenses
- Official documentation

Flox environment configurations in this repository are provided as-is.

## License

Flox environment configurations: As-is, no warranty

Individual tools: See respective upstream licenses in environment READMEs

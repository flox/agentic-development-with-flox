# Cline

Autonomous AI coding agent for the terminal. Cline can create/edit files, run terminal commands, automate browser interactions, and use MCP tools -- all with human-in-the-loop approval. Multi-provider support with 15+ LLM backends.

- **Autonomous agent** - File editing, terminal commands, browser automation, MCP tools
- **Multi-provider** - Anthropic, OpenAI, Google Gemini, OpenRouter, AWS Bedrock, Ollama, LM Studio, and more
- **Human-in-the-loop** - Approve actions before execution, or auto-approve with `-y`
- **Headless mode** - JSON output for CI/CD pipelines and scripting
- **ACP mode** - Editor integration with Zed, Neovim, JetBrains via Agent Client Protocol
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Intel, Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd cline
flox activate
```

Cline is automatically installed via npm on first activation.

### 2. Configure a Provider

```bash
# Interactive wizard
cline auth

# Or set directly
cline auth -p anthropic -k sk-ant-...
cline auth -p openai -k sk-...
```

### 3. Run an Agent Task

```bash
cline "Add error handling to the API routes"
```

## Supported Providers

| Provider | Setup |
|----------|-------|
| Anthropic | `cline auth -p anthropic -k <key>` |
| OpenAI | `cline auth -p openai -k <key>` |
| Google Gemini | `cline auth -p gemini -k <key>` |
| OpenRouter | `cline auth -p openrouter -k <key>` |
| AWS Bedrock | `cline auth -p bedrock` |
| Azure OpenAI | `cline auth -p azure` |
| DeepSeek | `cline auth -p deepseek -k <key>` |
| Ollama (local) | `cline auth -p ollama` |
| LM Studio (local) | `cline auth -p lmstudio` |
| Any OpenAI-compatible | `cline auth -p openai-compatible` |

## Usage Examples

### Interactive Agent

```bash
# Default agent mode
cline "Refactor the auth module to use JWT tokens"

# Ask mode (no edits)
cline -m ask "How does the authentication flow work?"

# Edit mode (targeted edits)
cline -m edit "Fix the typo in the README"
```

### Headless / CI Mode

```bash
# Auto-approve all actions
cline -y "Fix all linting errors"

# JSON output for scripting
cline --json "Add unit tests for utils.ts"
```

### Context Injection

```bash
# Add files as context
cline "Explain this code" @src/auth.ts

# Add a URL as context
cline "Implement something similar" @https://example.com/api-docs
```

### ACP Mode (Editor Integration)

```bash
# Start ACP bridge for Zed, Neovim, JetBrains
cline -acp
```

## Configuration

```bash
# Interactive configuration
cline config

# In-session settings
/settings
```

## Key Features

- **File creation/editing** with diff visualization
- **Terminal command execution** with real-time output
- **Browser automation** (click, type, scroll, screenshot)
- **Linter/compiler error detection** and auto-fixing
- **MCP tool support** for extending agent capabilities
- **Workspace checkpoints** for comparing/restoring states
- **Cost tracking** across API requests
- **Plan mode vs Act mode** with different models for each

## Updating Cline

```bash
npm install -g --prefix "$FLOX_ENV_CACHE/npm-global" cline
```

## Helper Commands

```bash
cline-info    # Show configuration, API key status, and command reference
```

## Resources

- [Cline Documentation](https://docs.cline.bot/)
- [Cline GitHub](https://github.com/cline/cline)
- [Cline CLI Overview](https://docs.cline.bot/cline-cli/overview)
- [npm: cline](https://www.npmjs.com/package/cline)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Cline-specific issues:
- [Cline GitHub Issues](https://github.com/cline/cline/issues)
- [Cline Discord](https://discord.gg/cline)

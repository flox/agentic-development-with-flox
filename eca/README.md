# 🤖 Flox Environment for ECA (Editor Code Assistant)

A Flox environment for [ECA](https://github.com/editor-code-assistant/eca), a free and open-source AI pair programming assistant that brings intelligent code assistance to multiple editors through a unified protocol. This environment runs ECA as a managed service.

## ✨ Features

- **Managed service**: ECA runs as a Flox service with automatic lifecycle management
- **Multi-editor support**: Works with Emacs, VS Code, Vim, IntelliJ, and any editor with a plugin
- **Model-agnostic**: Supports OpenAI, Anthropic, GitHub Copilot, Ollama, and custom providers
- **Agentic capabilities**: LLM can act as an agent with native tools and MCPs
- **Helper commands**: Easy configuration and project context setup
- **Project context awareness**: Provides standards and code details to AI models
- **Unified configuration**: Single setup works across all editors
- **Optional Ollama layering**: Add local, private, offline LLM access via `flox activate -r flox/ollama`
- **OpenTelemetry integration**: Built-in usage metrics and observability
- **Free and open source**: Apache-2.0 license
- **Cross-platform**: macOS ARM64 (Apple Silicon) and Linux x86_64

## 🧰 Included Tools

The environment includes:

- `eca` - Editor Code Assistant server

## 🏁 Getting Started

### 📋 Prerequisites

- [Flox](https://flox.dev/get) installed on your system
- macOS ARM64 (Apple Silicon) or Linux x86_64
- API key for cloud AI providers (OpenAI, Anthropic, etc.) OR layer Ollama for local models
- Editor plugin installed:
  - **Emacs**: [eca.el](https://github.com/editor-code-assistant/eca)
  - **VS Code**: ECA extension from marketplace
  - **Vim/Neovim**: ECA plugin
  - **IntelliJ**: ECA plugin

### 💻 Installation & Activation

Get started with:

```sh
# Clone the repo
git clone https://github.com/yourusername/floxenvs && cd floxenvs/eca

# Activate the environment
flox activate
```

### 🔐 First-Time Setup

Configure ECA and start services:

```bash
# 1. Configure AI model and API keys
eca-config

# Edit the configuration file with your provider:
# - For OpenAI: Uncomment openai section, add OPENAI_API_KEY to env
# - For Anthropic: Uncomment anthropic section, add ANTHROPIC_API_KEY to env
# - For Ollama (local): Uncomment ollama section, layer Ollama (see below)
# - Save and exit

# 2. Create project context
cd ~/projects/my-app
eca-init-context

# Edit .eca/context.md with your project details

# 3. Start ECA service
flox activate -s

# Service is now running in the background
```

### 🦙 Using Ollama (Optional)

For free, private, offline AI models, layer Ollama:

```bash
# Layer Ollama environment
flox activate -r flox/ollama

# Start services (this starts both ECA and Ollama)
flox activate -s

# Download a model (required before first use)
ollama pull qwen2.5-coder:7b

# Or download other coding models:
# ollama pull qwen2.5-coder:32b      # Larger, more capable
# ollama pull deepseek-coder-v2      # Alternative coding model
# ollama pull codellama              # Meta's coding model

# Configure ECA to use Ollama
eca-config
# Uncomment the ollama provider section and set defaultModel

# Restart ECA to apply changes
flox services restart eca
```

**Available at:** [ollama.com/library](https://ollama.com/library) - browse thousands of models

### 🔌 Editor Integration

After starting ECA server, connect from your editor:

**Emacs:**
```elisp
M-x eca-connect
```

**VS Code:**
```
Cmd/Ctrl+Shift+P → ECA: Connect to Server
```

**Vim:**
```vim
:ECAConnect
```

**IntelliJ:**
```
Tools → ECA → Connect
```

## 📝 Usage

### Service Management

ECA runs as a Flox-managed service:

```bash
# Start ECA service
flox activate -s

# Check service status
flox services status

# View ECA logs
flox services logs eca

# Restart ECA
flox services restart eca

# Stop service
flox services stop eca
```

**With Ollama layered:**
```bash
# Start both ECA and Ollama services
flox activate -r flox/ollama -s

# View Ollama logs
flox services logs ollama
```

### Helper Commands

Convenient commands for configuration:

```bash
# Configure ECA (edit ~/.config/eca/config.json)
eca-config

# Create project context template
cd ~/projects/my-app
eca-init-context
# Then edit .eca/context.md with project details
```

### Chat Interface

Once services are running and you've connected from your editor, interact with AI through the chat:

```
You: Explain how the authentication module works

ECA: [analyzes codebase and explains architecture]

You: Refactor it to use dependency injection

ECA: [proposes refactoring with code changes]

You: Apply changes

ECA: [modifies files through editor integration]
```

### Project Context

The `eca-init-context` helper creates `.eca/context.md`:

```markdown
# Project Context

## Overview
[Project description]

## Architecture
[System design]

## Coding Standards
[Style guide, patterns]

## Dependencies
[Key libraries and frameworks]
```

Edit this file to add your project details - ECA automatically uses it for better AI responses.

## 🔍 How It Works

### 🗄️ Server Architecture

**Communication Protocol:**
- Uses stdin/stdout for editor communication (LSP-style)
- Single server instance supports multiple editor connections
- JSON-RPC for message exchange
- Stateful sessions maintain conversation context

**Model Integration:**
- Acts as intermediary between editors and LLMs
- Normalizes requests across different model providers
- Manages authentication and API calls
- Streams responses back to editor in real-time

### 🚀 Agentic Capabilities

**Native Tools:**
- File reading and writing
- Code search and navigation
- Symbol lookup and definitions
- Workspace modifications
- Test execution

**MCP Support:**
- Configure custom Model Context Protocol servers
- Extend capabilities with domain-specific tools
- Add database access, API integrations, etc.
- Configurable per-project

### 📂 Multi-Editor Support

**Unified Protocol:**
- Single server works with all editors
- Editor plugins translate editor-specific commands
- Consistent AI experience across environments
- Share configuration between editors

**Supported Editors:**
- **Emacs**: Native Elisp integration
- **VS Code**: TypeScript extension
- **Vim/Neovim**: Vimscript/Lua plugin
- **IntelliJ**: Java plugin
- **Others**: Any editor can implement the protocol

### 🎯 Context Awareness

**Project Understanding:**
- Reads `.eca/context.md` for project standards
- Analyzes codebase structure automatically
- Maintains conversation history per session
- Understands relationships between files

**Code Intelligence:**
- Symbol resolution and type information
- Dependency tracking
- Cross-file references
- Architecture comprehension

### 🔧 Model Flexibility

**Supported Providers:**
- **OpenAI**: GPT-4, GPT-4 Turbo, GPT-5, etc.
- **Anthropic**: Claude Sonnet, Claude Opus, Haiku
- **GitHub Copilot**: Via Copilot API
- **Ollama**: Local models (Qwen, Llama, DeepSeek, etc.)
- **Custom**: Any OpenAI-compatible API

**Provider Configuration:**
```bash
# Configure during session
/login

# Select provider
> OpenAI
> Anthropic
> GitHub Copilot
> Ollama (local)
> Custom OpenAI-compatible

# Enter credentials/endpoints
```

## 🛠️ Common Workflows

### Code Review Session

```bash
# Start services in project
cd ~/projects/my-app
flox activate -s

# Connect from editor (e.g., Emacs)
M-x eca-connect

# In editor chat:
You: Review the authentication code for security issues

ECA: [analyzes auth module, identifies vulnerabilities]
# Highlights potential SQL injection in login handler
# Suggests parameterized queries

You: Show me how to fix it

ECA: [provides code example with fix]

You: Apply to LoginHandler.java

ECA: [updates file through editor]
```

### Pair Programming

```bash
# Start services
cd ~/projects/my-app
flox activate -s

# From VS Code
> ECA: Connect to Server

# Chat-driven development:
You: Create a REST API for user management

ECA: [generates controller, service, repository]
# Creates files in project structure

You: Add input validation with Bean Validation

ECA: [adds @Valid annotations and custom validators]

You: Write unit tests

ECA: [generates test cases with mocks]
```

### Refactoring Task

```bash
# Start services
flox activate -s

# From Vim
:ECAConnect

# Request refactoring:
You: Refactor the payment service to use the strategy pattern

ECA: [analyzes current implementation]
# Proposes strategy interfaces and implementations

You: Proceed

ECA: [creates strategy interface]
ECA: [implements concrete strategies]
ECA: [updates payment service to use strategies]
ECA: [refactors tests]

You: Looks good

ECA: Refactoring complete. 8 files modified.
```

### Local Model with Ollama

```bash
# Layer Ollama environment
flox activate -r flox/ollama

# Start both ECA and Ollama services
flox activate -s

# Download your preferred model
ollama pull qwen2.5-coder:32b

# Configure ECA to use Ollama
eca-config

# In config file, uncomment the ollama provider section:
# {
#   "providers": {
#     "ollama": {
#       "url": "http://localhost:11434",
#       "models": {
#         "qwen2.5-coder:32b": {}
#       }
#     }
#   },
#   "defaultModel": "ollama/qwen2.5-coder:32b"
# }

# Restart ECA to apply changes
flox services restart eca

# Connect from editor
# Use AI assistance without external API costs - completely private!
```

### Multi-Editor Workflow

```bash
# Start ECA service once
cd ~/projects/my-app
flox activate -s

# Connect from multiple editors simultaneously:

# Terminal 1: Emacs for Elisp editing
emacs src/main.el
M-x eca-connect

# Terminal 2: VS Code for TypeScript
code src/
> ECA: Connect to Server

# Terminal 3: Vim for configuration files
vim config/settings.yml
:ECAConnect

# All editors share the same ECA service instance and context
```

### Project Context Setup

```bash
cd ~/projects/my-app

# Create context template
eca-init-context

# Edit .eca/context.md with your project details:
```

```markdown
# My Project Context

## Overview
E-commerce platform built with Spring Boot and React

## Architecture
- Backend: Spring Boot REST API
- Frontend: React SPA
- Database: PostgreSQL
- Cache: Redis

## Coding Standards
- Use dependency injection
- Write tests for all business logic
- Follow REST conventions
- Use DTOs for API responses

## Key Dependencies
- Spring Boot 3.2
- React 18
- PostgreSQL 15
```

```bash
# Start services - ECA now uses this context for all responses
flox activate -s
```

## 🔧 Troubleshooting

### Service Won't Start

```bash
# Check service status
flox services status

# View ECA logs for errors
flox services logs eca

# Verify environment is activated
flox activate

# Try restarting services
flox services restart eca

# Check if eca binary is available
which eca
```

### Editor Can't Connect

**Connection failed:**
- Ensure ECA service is running: `flox services status`
- Check ECA logs: `flox services logs eca`
- Verify editor plugin is installed
- Check plugin configuration
- Restart editor and try again
- Try restarting ECA: `flox services restart eca`

**Emacs specific:**
```elisp
M-x eca-status  ; Check connection status
M-x eca-restart ; Restart connection
```

**VS Code specific:**
```
Check Output panel: View → Output → ECA
```

### Model Configuration Issues

```bash
# Edit configuration file
eca-config

# Verify API key is correct
# For OpenAI: Check https://platform.openai.com/api-keys
# For Anthropic: Check https://console.anthropic.com/

# Test with Ollama locally (no API key needed)
# Set provider to "ollama" in config

# Restart ECA after config changes
flox services restart eca
```

### Context Not Working

**Project context not loaded:**
```bash
# Ensure .eca/context.md exists
ls -la .eca/

# Create if missing
eca-init-context

# Edit with project details
nano .eca/context.md

# Restart ECA to reload context
flox services restart eca
```

### Slow Responses

**Normal behavior:**
- First request in session: Loading project context
- Large codebase: Context analysis takes time
- Complex queries: More AI processing needed

**Using Ollama:**
- Local models may be slower depending on hardware
- Larger models (70B) require significant RAM
- Consider smaller models (7B, 13B, 32B) for faster responses

### MCP Configuration

**Custom MCPs not working:**
```bash
# Check MCP configuration file
cat ~/.config/eca/mcp.json

# Verify MCP server is running
# Check MCP server logs

# Test MCP independently
```

## 💻 System Compatibility

This environment works on:
- macOS ARM64 (Apple Silicon)
- Linux x86_64

## 🔒 Security Considerations

- **API keys**: Stored in ECA configuration file - protect with file permissions
- **Code access**: ECA has read/write access to project files
- **Network access**: Communicates with AI provider APIs (except Ollama)
- **Local models**: Ollama keeps everything private and offline
- **OpenTelemetry**: Review telemetry settings if privacy-sensitive
- **Project context**: May contain sensitive project information

**Best Practices:**
- Use environment variables for API keys
- Restrict access to `~/.config/eca/`
- Review `.eca/context.md` before committing
- Consider local models (Ollama) for private codebases
- Audit MCP server sources before adding
- Keep ECA and editor plugins updated

## 📚 Additional Resources

- **ECA Repository**: [github.com/editor-code-assistant/eca](https://github.com/editor-code-assistant/eca)
- **Documentation**: Available in GitHub repository
- **Editor Plugins**: Links in repository README
- **Issue Tracker**: [github.com/editor-code-assistant/eca/issues](https://github.com/editor-code-assistant/eca/issues)
- **Discussions**: [github.com/editor-code-assistant/eca/discussions](https://github.com/editor-code-assistant/eca/discussions)
- **Flox Documentation**: [flox.dev/docs](https://flox.dev/docs)

## 🙏 Acknowledgments

- **ECA Contributors**: Huge thanks to all the contributors to the [Editor Code Assistant project](https://github.com/editor-code-assistant/eca)! This open-source tool democratizes AI pair programming by creating a unified protocol that works across multiple editors, making AI assistance accessible to developers regardless of their editor choice. By supporting multiple AI providers including local models via Ollama, ECA ensures developers can leverage AI assistance while maintaining control over their code and data. The agentic capabilities with MCP extensibility show a thoughtful approach to building a platform that grows with the community. Thank you for this excellent contribution to the open-source development tools ecosystem!

- **nix-ai-tools**: Special thanks to [numtide](https://github.com/numtide) and contributors for maintaining [nix-ai-tools](https://github.com/numtide/nix-ai-tools), which packages and distributes AI development tools for the Nix ecosystem, making it easy to use tools like ECA in reproducible environments

## 🔗 About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Software, variables, services defined in human-readable TOML
- **Content-addressed storage** - Multiple package versions coexist without conflicts
- **Reproducibility** - Same environment across dev, CI, and production
- **Deterministic builds** - Same inputs always produce identical outputs
- **Huge package collection** - Access to 150,000+ packages from [Nixpkgs](https://github.com/NixOS/nixpkgs)

## 📝 License

This Flox environment configuration is provided as-is. ECA is licensed under the Apache-2.0 license - see the [ECA repository](https://github.com/editor-code-assistant/eca) for details.

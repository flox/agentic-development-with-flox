# 🔬 Flox Environment for Nanocoder

A Flox environment for [Nanocoder](https://github.com/Nano-Collective/nanocoder), a beautiful local-first CLI coding agent built by the community for the community. Nanocoder brings the power of agentic AI directly into your terminal with a focus on privacy, control, and flexibility.

## ✨ Features

- **Local-first architecture**: Privacy-focused design with full control over your data
- **Multi-provider support**: Ollama, OpenRouter, OpenAI, LM Studio, llama.cpp, Z.ai
- **Interactive sessions**: Conversational coding with streaming responses
- **Custom commands**: Project-specific reusable prompts as markdown files
- **MCP integration**: Connect to Model Context Protocol servers
- **Tool support**: File operations, shell command execution, system integration
- **Slash commands**: Built-in commands for provider/model switching and session management
- **Shell integration**: Execute bash commands directly with `!command`
- **Configuration flexibility**: Project-level and user-level config files
- **Environment variables**: Secure credential management
- **Free and open source**: Community-driven development

## 🧰 Included Tools

The environment includes:

- `nanocoder` - Nanocoder CLI tool

## 🏁 Getting Started

### 📋 Prerequisites

- [Flox](https://flox.dev/get) installed on your system
- Node.js 18+ (included in environment)
- API key(s) for your chosen provider(s) OR local model setup (Ollama, LM Studio, etc.)

### 💻 Installation & Activation

Get started with:

```sh
# Clone the repo
git clone https://github.com/yourusername/floxenvs && cd floxenvs/nanocoder

# Activate the environment
flox activate
```

### 🔐 First-Time Setup

Configure providers on first use:

```bash
# Start interactive session
nanocoder

# On first run, use the setup wizard
/setup-config

# Interactive workflow guides you through:
# 1. Choose provider type (Ollama, OpenRouter, OpenAI, etc.)
# 2. Enter base URL (for local providers)
# 3. Enter API key (if required)
# 4. Select models
# 5. Configure tool permissions
```

**Supported providers:**
- **Local**: Ollama, LM Studio, llama.cpp
- **Cloud**: OpenRouter, OpenAI, Anthropic (via OpenRouter), Z.ai
- **Custom**: Any OpenAI-compatible API

## 📝 Usage

### Interactive Mode

Launch an interactive coding session:

```bash
# Start in current directory
nanocoder

# Example interaction:
You: Create a REST API for user management

Nanocoder: [analyzes requirements, proposes architecture]
# Creates files
# Implements endpoints
# Adds error handling

You: Add authentication with JWT

Nanocoder: [implements auth system]
# Updates code
# Adds middleware
# Creates tests
```

### Slash Commands

Use slash commands within interactive sessions:

**Configuration & Settings:**
```
/setup-config       # Guided configuration wizard
/provider           # Show current provider or switch providers
/model              # List available models or switch model
/mcp                # List connected MCP services
```

**Custom Commands:**
```
/custom-commands    # Show available custom commands
/[command-name]     # Execute custom command from .nanocoder/commands/
```

**Session Management:**
```
/clear              # Clear conversation history
/export             # Export conversation to file
```

### Shell Commands

Execute bash commands directly without leaving the session:

```bash
nanocoder

You: Check what files are in the current directory

Nanocoder: I'll check that for you.
!ls -la

# Output shown inline

You: Now create a new file called test.txt

Nanocoder: [creates file]
!touch test.txt
```

### Custom Commands

Create reusable prompts as markdown files in `.nanocoder/commands/`:

**Create a custom command:**
```bash
# In your project root
mkdir -p .nanocoder/commands

# Create a command file
cat > .nanocoder/commands/review.md << 'EOF'
---
name: review
description: Review code for security and performance issues
category: code-quality
---

Please review the code in this file for:
1. Security vulnerabilities
2. Performance issues
3. Best practices violations
4. Code quality concerns

Provide specific recommendations with code examples.
EOF
```

**Use the custom command:**
```bash
nanocoder

/custom-commands
# Shows: review - Review code for security and performance issues

/review
# Executes the custom command prompt
```

## 🔧 Configuration

### Configuration Location

Nanocoder uses `agents.config.json` for configuration.

**⚠️ IMPORTANT - Flox Security Convention:**
Config files containing API keys or secrets MUST be in `$HOME` (`~/.nanocoder/`), never in project directories.

**User-level** (RECOMMENDED for configs with secrets):
```
~/.nanocoder/
└── agents.config.json     # Global configuration with API keys
```

**Project-level** (ONLY for non-secret settings):
```
your-project/
├── agents.config.json     # Project settings WITHOUT secrets
├── .nanocoder/
│   └── commands/          # Custom commands for this project
│       ├── review.md
│       └── refactor.md
└── ...
```

**Note:** If using project-level config, use environment variables for API keys (e.g., `ANTHROPIC_API_KEY`) instead of storing them in `agents.config.json`.

### Setup Wizard

The easiest way to configure:

```bash
nanocoder
/setup-config

# Follow the interactive wizard:
# 1. Select provider type
# 2. Enter connection details
# 3. Configure models
# 4. Set permissions
```

### Manual Configuration

Create `agents.config.json` in `~/.nanocoder/` (recommended) or use environment variables:

```json
{
  "providers": [
    {
      "name": "ollama",
      "baseUrl": "http://localhost:11434",
      "apiKey": "",
      "models": [
        "qwen2.5-coder:7b",
        "qwen2.5-coder:32b"
      ]
    },
    {
      "name": "openrouter",
      "baseUrl": "https://openrouter.ai/api/v1",
      "apiKey": "$OPENROUTER_API_KEY",
      "models": [
        "anthropic/claude-sonnet-4.5",
        "openai/gpt-5.1"
      ]
    }
  ],
  "defaultProvider": "ollama",
  "defaultModel": "qwen2.5-coder:7b",
  "mcpServers": [
    {
      "name": "filesystem",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/allowed"],
      "env": {}
    }
  ],
  "tools": {
    "fileOperations": true,
    "shellCommands": true,
    "webBrowsing": false
  }
}
```

### Environment Variables

Use environment variables for API keys:

```bash
# Add to shell profile (~/.bashrc, ~/.zshrc)
export OPENROUTER_API_KEY="sk-or-..."
export OPENAI_API_KEY="sk-..."

# Reference in agents.config.json
{
  "providers": [
    {
      "name": "openrouter",
      "apiKey": "$OPENROUTER_API_KEY"
    }
  ]
}
```

### Using Ollama (Local Models)

**Prerequisites:**
- Ollama installed and running
- Model downloaded

**Setup with Flox layering:**
```bash
# Activate with Ollama layered
flox activate -r flox/ollama

# Start Ollama
ollama serve &

# Pull a model
ollama pull qwen2.5-coder:7b
```

**Configure Ollama provider:**
```json
{
  "providers": [
    {
      "name": "ollama",
      "baseUrl": "http://localhost:11434",
      "apiKey": "",
      "models": [
        "qwen2.5-coder:7b",
        "qwen2.5-coder:32b",
        "deepseek-coder:33b"
      ]
    }
  ],
  "defaultProvider": "ollama",
  "defaultModel": "qwen2.5-coder:7b"
}
```

**Recommended models:**
- `qwen2.5-coder:7b` - Fast, 8GB VRAM
- `qwen2.5-coder:32b` - High quality, 24GB+ VRAM
- `deepseek-coder:33b` - Strong understanding, 24GB+ VRAM
- `codellama:34b` - Alternative option

### MCP Server Integration

Configure Model Context Protocol servers in `agents.config.json`:

```json
{
  "mcpServers": [
    {
      "name": "filesystem",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/path/to/project"],
      "env": {}
    },
    {
      "name": "github",
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "$GITHUB_TOKEN"
      }
    },
    {
      "name": "database",
      "command": "python",
      "args": ["-m", "my_mcp_server"],
      "env": {
        "DATABASE_URL": "$DATABASE_URL"
      }
    }
  ]
}
```

**View connected services:**
```bash
nanocoder
/mcp
# Lists all connected MCP servers and their available tools
```

## 🛠️ Common Workflows

### Getting Started with a New Project

```bash
# Navigate to your project
cd ~/projects/my-app

# Start nanocoder
nanocoder

# Configure for this project
/setup-config
# Choose provider, models, permissions

# Now use nanocoder for development
You: Create a Node.js Express API with user authentication

Nanocoder: [builds the project]
```

### Code Review Session

```bash
nanocoder

You: Review the authentication module for security issues

Nanocoder: [analyzes code, identifies issues]
# Points out vulnerabilities
# Suggests fixes
# Shows examples

You: Fix the SQL injection vulnerability you found

Nanocoder: [updates code with parameterized queries]
```

### Using Custom Commands

```bash
# Create a project-specific command
mkdir -p .nanocoder/commands
cat > .nanocoder/commands/test.md << 'EOF'
---
name: test
description: Generate comprehensive unit tests
---
Generate unit tests for the current file with:
- Happy path tests
- Edge cases
- Error handling
- 100% code coverage
EOF

# Use it
nanocoder
/test
```

### Working with Multiple Providers

```bash
nanocoder

# Start with local Ollama for exploration
/provider
# Shows: ollama (current), openrouter

You: Explain how this authentication works
Nanocoder: [uses local model for quick explanation]

# Switch to cloud for complex refactoring
/provider openrouter
/model anthropic/claude-sonnet-4.5

You: Refactor this entire auth system to use OAuth 2.0
Nanocoder: [uses powerful cloud model for complex task]
```

### Shell Integration

```bash
nanocoder

You: What's the git status?

Nanocoder: Let me check.
!git status

You: Create a new branch for this feature

Nanocoder: [creates branch]
!git checkout -b feature/new-auth

You: Now implement the feature...
```

### Debugging Session

```bash
nanocoder

You: The API returns 500 errors when creating users

Nanocoder: Let me investigate.
!cat logs/api.log | grep ERROR

Nanocoder: I see the issue - null pointer in the user validation.
# Shows the problematic code
# Proposes fix

You: Implement that fix

Nanocoder: [updates code, adds validation]
```

## 🔧 Troubleshooting

### Command Not Found

```bash
# Verify nanocoder is available
which nanocoder

# Ensure environment is activated
flox activate

# Check installation
flox list | grep nanocoder
```

### Configuration Issues

```bash
# Reconfigure with wizard
nanocoder
/setup-config

# Or check current config
cat agents.config.json

# Verify it's valid JSON
cat agents.config.json | jq .
```

### Provider Connection Errors

**Issue:** Cannot connect to provider

**Solutions:**
```bash
# For Ollama
ollama list  # Verify Ollama is running
ollama serve &  # Start if not running

# For cloud providers
# Verify API key is set
echo $OPENROUTER_API_KEY

# Check config references it correctly
cat agents.config.json | jq '.providers[] | select(.name=="openrouter")'
```

### Model Not Available

**Issue:** Selected model not found

**Solutions:**
```bash
# For Ollama - pull the model
ollama pull qwen2.5-coder:7b

# Verify it's available
ollama list

# Check what models are configured
nanocoder
/model
```

### Custom Commands Not Working

**Issue:** `/custom-commands` shows nothing

**Solutions:**
```bash
# Verify directory exists
ls -la .nanocoder/commands/

# Check markdown format
cat .nanocoder/commands/yourcommand.md

# Ensure frontmatter is correct
# Must have: name, description
# Optional: category, parameters
```

### MCP Server Issues

**Issue:** MCP services not connecting

**Solutions:**
```bash
# Verify MCP server is executable
npx -y @modelcontextprotocol/server-filesystem --help

# Check configuration
cat agents.config.json | jq '.mcpServers'

# View MCP status in nanocoder
nanocoder
/mcp
```

### Slow Local Model Performance

**Solutions:**
- Use smaller model (7B instead of 32B)
- Check GPU is being used: `ollama ps`
- Ensure sufficient VRAM available
- Consider quantized models for faster inference
- Use cloud provider for complex tasks

## 💻 System Compatibility

This environment works on:
- Linux x86_64
- macOS ARM64 (Apple Silicon)
- macOS x86_64 (Intel)

## 🔒 Security Considerations

- **API credentials**: Stored in `~/.nanocoder/agents.config.json` or via environment variables
- **Configuration location**: `~/.nanocoder/` in your home directory (**NEVER in project root**)
- **Code access**: Nanocoder can read and modify files in your project
- **Shell execution**: Can run commands with `!command` syntax
- **Network access**: Communicates with configured providers
- **MCP servers**: Third-party servers may have additional access
- **Local-first design**: Privacy-focused architecture

**Best Practices:**
- **Recommended**: Use environment variables for API keys (e.g., `ANTHROPIC_API_KEY`)
- **CRITICAL**: Config files with secrets MUST be in `$HOME` (e.g., `~/.nanocoder/`), never in project directories
- Never commit API keys to version control
- Per Flox conventions, all secrets live in `$HOME`, not in repos or `$FLOX_ENV_CACHE`
- Review tool permissions in configuration
- Be cautious with shell command execution
- Use version control for easy rollback
- Audit MCP servers before installation
- Start with local models for sensitive codebases
- Keep Nanocoder updated

## 📚 Additional Resources

- **Nanocoder Repository**: [github.com/Nano-Collective/nanocoder](https://github.com/Nano-Collective/nanocoder)
- **Community Discussions**: [GitHub Discussions](https://github.com/Nano-Collective/nanocoder/discussions)
- **Report Issues**: [GitHub Issues](https://github.com/Nano-Collective/nanocoder/issues)
- **Flox Documentation**: [flox.dev/docs](https://flox.dev/docs)

## 🙏 Acknowledgments

A special shout-out to the Nano Collective and all contributors for building Nanocoder as a truly community-driven project! Nanocoder exemplifies what open-source collaboration can achieve - a powerful, privacy-focused alternative to commercial tools, built by developers for developers. The commitment to local-first architecture and user control makes this a standout project in the AI coding assistant space.

## 🔗 About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Software, variables, services defined in human-readable TOML
- **Content-addressed storage** - Multiple package versions coexist without conflicts
- **Reproducibility** - Same environment across dev, CI, and production
- **Deterministic builds** - Same inputs always produce identical outputs
- **Huge package collection** - Access to 150,000+ packages from [Nixpkgs](https://github.com/NixOS/nixpkgs)

## 📝 License

This Flox environment configuration is provided as-is. Nanocoder is open source - see the [Nanocoder repository](https://github.com/Nano-Collective/nanocoder) for license details.

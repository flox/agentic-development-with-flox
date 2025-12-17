# 🌐 Flox Environment for MCPHost

A Flox environment for [MCPHost](https://github.com/mark3labs/mcphost), a CLI host application that enables Large Language Models (LLMs) to interact with external tools through the Model Context Protocol (MCP). MCPHost supports 20+ LLM providers (Claude, OpenAI, Gemini, Ollama) and provides a unified interface for tool-augmented AI conversations.

## ✨ Features

- **20+ LLM providers**: Anthropic Claude, OpenAI GPT, Google Gemini, Ollama, and any OpenAI-compatible endpoint
- **MCP server orchestration**: Connect multiple MCP servers for extended capabilities
- **Interactive conversations**: REPL mode with context-aware interactions
- **Script automation**: YAML-based executable scripts with variable substitution
- **Non-interactive mode**: Single prompts for scripting and CI/CD
- **Hooks system**: Custom integrations and security policies
- **Builtin servers**: Filesystem, bash, todo, and HTTP servers included
- **Tool filtering**: Fine-grained control with allowedTools/excludedTools
- **OAuth support**: Alternative authentication for Anthropic
- **Session management**: Save and resume conversations
- **Environment variables**: Flexible configuration with ${env://VAR} syntax

## 🧰 Included Tools

The environment includes:

- `mcphost` - MCPHost CLI application

## 🏁 Getting Started

### 📋 Prerequisites

- [Flox](https://flox.dev/get) installed on your system
- API key for at least one LLM provider (OpenAI, Anthropic, Google, or Ollama installed)
- Go 1.23 or later (for building from source)
- Internet connection for API access

### 💻 Installation & Activation

Get started with:

```sh
# Clone the repo
git clone https://github.com/yourusername/agentic-development-with-flox && cd agentic-development-with-flox/mcphost

# Activate the environment
flox activate
```

### 🔐 First-Time Setup

**Configuration Location:**

MCPHost stores configuration in `~/.mcphost.yml` or `~/.mcphost.json` in your home directory.

**⚠️ CRITICAL - Flox Security Convention:**
Config files with API keys MUST be in `$HOME` (`~/.mcphost.yml`), **NEVER in project directories**.

**Initial Configuration:**

```bash
# Create example configuration (includes builtin MCP servers)
mcphost-init

# Edit configuration to add your API keys
nano ~/.mcphost.yml
```

**Provider Setup Examples:**

**Option 1: Anthropic Claude (Default)**

```bash
# Set API key via environment variable (recommended)
export ANTHROPIC_API_KEY="sk-ant-your-api-key-here"

# Or add to config
cat >> ~/.mcphost.yml <<'EOF'
provider-api-key: "sk-ant-your-api-key-here"
EOF

# Test connection
mcphost -p "Hello, world!"
```

**Option 2: OpenAI**

```bash
# Set API key via environment variable
export OPENAI_API_KEY="sk-your-api-key-here"

# Configure in YAML
cat >> ~/.mcphost.yml <<'EOF'
model: "openai:gpt-4"
provider-api-key: "${env://OPENAI_API_KEY}"
EOF

# Test connection
mcphost -p "Explain MCP servers"
```

**Option 3: Google Gemini**

```bash
# Set API key
export GOOGLE_API_KEY="your-google-api-key"

# Configure
cat >> ~/.mcphost.yml <<'EOF'
model: "google:gemini-2.0-flash"
provider-api-key: "${env://GOOGLE_API_KEY}"
EOF

# Test
mcphost -p "What can you do?"
```

**Option 4: Ollama (Local)**

```bash
# Ensure Ollama is running
ollama serve

# Configure for local model
cat >> ~/.mcphost.yml <<'EOF'
model: "ollama:llama3.2"
# No API key needed for local models
EOF

# Test
mcphost -p "Hello from Ollama!"
```

## 📝 Usage

### Interactive Mode

Start an interactive conversation session:

```bash
# Start interactive REPL
mcphost

# Available commands in REPL:
/help      # Show available commands
/tools     # List all available tools
/servers   # List configured MCP servers
/history   # Display conversation history
/quit      # Exit the application
```

### Non-Interactive Mode

Execute single prompts for scripting:

```bash
# Basic prompt
mcphost -p "List files in the current directory"

# Quiet mode (only AI response, no UI)
mcphost -p "What is 2+2?" --quiet

# With different model
mcphost -m ollama:qwen2.5:3b -p "Explain quantum computing"

# Compact mode (simplified output)
mcphost -p "Generate a UUID" --compact
```

### Script Mode

Run executable YAML automation scripts:

```bash
# Run a script
mcphost script myscript.sh

# With variables
mcphost script deploy.sh --args:env production --args:region us-west

# Direct execution (if executable)
./myscript.sh
```

**Script Format:**

```yaml
#!/usr/bin/env -S mcphost script
---
mcpServers:
  filesystem:
    type: "builtin"
    name: "fs"
model: "anthropic:claude-3-5-sonnet-latest"
---
Please analyze the files in ${directory:-/tmp} and summarize their contents.
```

### MCP Server Configuration

MCPHost supports three types of MCP servers:

**1. Builtin Servers** (included with MCPHost):

```yaml
mcpServers:
  filesystem:
    type: "builtin"
    name: "fs"
    options:
      allowed_directories: ["/tmp", "${env://HOME}/documents"]

  bash:
    type: "builtin"
    name: "bash"

  todo:
    type: "builtin"
    name: "todo"

  http:
    type: "builtin"
    name: "http"
```

**2. Local Servers** (run as processes):

```yaml
mcpServers:
  github:
    type: "local"
    command: ["npx", "-y", "@modelcontextprotocol/server-github"]
    environment:
      GITHUB_TOKEN: "${env://GITHUB_TOKEN}"

  sqlite:
    type: "local"
    command: ["uvx", "mcp-server-sqlite", "--db-path", "/tmp/data.db"]
```

**3. Remote Servers** (HTTP endpoints):

```yaml
mcpServers:
  api-server:
    type: "remote"
    url: "https://api.example.com/mcp"
    headers: ["Authorization: Bearer ${env://API_TOKEN}"]
```

### Tool Filtering

Control which tools are available from each server:

```yaml
mcpServers:
  filesystem-readonly:
    type: "builtin"
    name: "fs"
    allowedTools: ["read_file", "list_directory"]  # Whitelist

  bash-safe:
    type: "builtin"
    name: "bash"
    excludedTools: ["rm", "sudo"]  # Blacklist
```

## 🔧 Configuration

### Configuration Files

MCPHost looks for configuration in this order:
1. `~/.mcphost.yml` or `~/.mcphost.json` (preferred)
2. `~/.mcp.yml` or `~/.mcp.json` (backwards compatibility)

**Example ~/.mcphost.yml:**

```yaml
# Model configuration
model: "anthropic:claude-3-5-sonnet-latest"
# Other options: openai:gpt-4, google:gemini-2.0-flash, ollama:mistral

# Generation parameters
max-tokens: 4096
temperature: 0.7
top-p: 0.95
top-k: 40

# MCP Servers
mcpServers:
  # Builtin servers (no installation required)
  filesystem:
    type: "builtin"
    name: "fs"
    options:
      allowed_directories: ["/tmp", "${env://HOME}/projects"]

  bash:
    type: "builtin"
    name: "bash"

  # Local MCP servers
  github:
    type: "local"
    command: ["npx", "-y", "@modelcontextprotocol/server-github"]
    environment:
      GITHUB_TOKEN: "${env://GITHUB_TOKEN}"

# API configuration
provider-api-key: "${env://ANTHROPIC_API_KEY}"
# provider-url: "https://api.anthropic.com"  # For custom endpoints

# Streaming
stream: true

# Hooks configuration (optional)
hooks:
  PreToolUse:
    - matcher: "bash"
      hooks:
        - type: command
          command: "/usr/local/bin/validate-bash.py"
```

### Environment Variables

MCPHost supports environment variable substitution:

```bash
# Set required variables
export ANTHROPIC_API_KEY="sk-ant-..."
export GITHUB_TOKEN="ghp_..."
export HOME_DIR="/home/user"

# Use in configuration
# ${env://VAR} - Required (fails if not set)
# ${env://VAR:-default} - Optional with default
```

## 🛠️ Common Workflows

### Tool-Augmented Conversations

```bash
# Interactive session with MCP tools
mcphost

You: Read the README.md file and summarize it

AI: [Uses filesystem MCP server to read file and provide summary]

You: Run the tests and show me any failures

AI: [Uses bash server to execute tests and analyze output]

You: Create a todo list for fixing the issues

AI: [Uses todo server to create and manage task list]
```

### Script Automation

Create `deploy.sh`:

```yaml
#!/usr/bin/env -S mcphost script
---
mcpServers:
  bash:
    type: "builtin"
    name: "bash"
model: "anthropic:claude-3-5-sonnet-latest"
---
Deploy the application to ${environment:-staging} with the following steps:
1. Run tests
2. Build the Docker image
3. Push to registry
4. Update Kubernetes deployment
Show me each command before executing.
```

Run with:
```bash
mcphost script deploy.sh --args:environment production
```

### CI/CD Integration

```bash
# In CI pipeline
mcphost -p "Review this PR diff and suggest improvements: $(git diff main)" --quiet

# Generate release notes
mcphost -p "Generate release notes from: $(git log --oneline HEAD~10..HEAD)" --quiet > RELEASE.md

# Security scan
mcphost -p "Check this code for security issues: $(cat app.py)" --quiet
```

### Hooks for Security

Configure hooks in `~/.mcphost.yml`:

```yaml
hooks:
  PreToolUse:
    - matcher: "bash"
      hooks:
        - type: command
          command: "/path/to/bash-validator.py"
          timeout: 5
```

## 🔧 Troubleshooting

### API Key Issues

```bash
# Check environment variable
echo $ANTHROPIC_API_KEY

# Test with explicit key
mcphost --provider-api-key "sk-ant-..." -p "test"

# Verify config
cat ~/.mcphost.yml | grep -v api_key
```

### MCP Server Errors

```bash
# List available tools
mcphost
/tools

# Check server configuration
cat ~/.mcphost.yml | grep -A5 mcpServers

# Test with builtin servers only
# Remove external servers temporarily
```

### Model Not Found

```bash
# Use correct format: provider:model
mcphost -m anthropic:claude-3-5-sonnet-latest -p "test"
mcphost -m openai:gpt-4 -p "test"
mcphost -m google:gemini-2.0-flash -p "test"
mcphost -m ollama:llama3.2 -p "test"
```

## 💻 System Compatibility

This environment works on:
- Linux x86_64
- Linux aarch64 (ARM64)
- macOS x86_64 (Intel)
- macOS ARM64 (Apple Silicon)

## 🔒 Security Considerations

**⚠️ CRITICAL SECURITY RULES:**

- **API keys location**: MUST be in `~/.mcphost.yml` or environment variables
- **NEVER commit secrets**: Don't commit config files with API keys
- **Hooks validation**: Review hook scripts before enabling
- **Tool filtering**: Use allowedTools/excludedTools for security
- **Environment variables**: Store in shell profile or secure manager

**Best Practices:**

```bash
# Secure config file
chmod 600 ~/.mcphost.yml

# Use environment variables
export ANTHROPIC_API_KEY="sk-ant-..."

# Disable hooks when testing untrusted scripts
mcphost --no-hooks

# Audit MCP servers before adding
# Review tool capabilities
```

## 📚 Additional Resources

- **MCPHost Repository**: [github.com/mark3labs/mcphost](https://github.com/mark3labs/mcphost)
- **MCP Protocol**: [modelcontextprotocol.io](https://modelcontextprotocol.io)
- **MCP Servers**: [github.com/modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers)
- **Flox Documentation**: [flox.dev/docs](https://flox.dev/docs)

## 🙏 Acknowledgments

- **Mark3Labs Team**: For creating MCPHost and making it open source
- **Anthropic**: For developing the Model Context Protocol
- **MCP Community**: For building the ecosystem of MCP servers

## 🔗 About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Software, variables, services defined in human-readable TOML
- **Content-addressed storage** - Multiple package versions coexist without conflicts
- **Reproducibility** - Same environment across dev, CI, and production
- **Deterministic builds** - Same inputs always produce identical outputs
- **Huge package collection** - Access to 150,000+ packages from [Nixpkgs](https://github.com/NixOS/nixpkgs)

## 📝 License

This Flox environment configuration is provided as-is. MCPHost is open source - see the [MCPHost repository](https://github.com/mark3labs/mcphost) for license details.
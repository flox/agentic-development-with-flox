# ✨ Flox Environment for Crush

A Flox environment for [Crush](https://github.com/charmbracelet/crush), a glamorous AI coding agent for the terminal from Charm. Crush brings intelligent coding assistance directly to your command line with multi-model LLM support, session-based organization, and extensive extensibility through LSP and MCP integrations.

## ✨ Features

- **Multi-model LLM support**: Switch between OpenAI, Anthropic, or custom API-compatible models
- **Session-based organization**: Maintain separate work sessions per project with persistent context
- **LSP integration**: Enhanced code understanding through Language Server Protocol
- **MCP extensibility**: Supports Model Context Protocol servers (stdio, HTTP, SSE)
- **Mid-session model switching**: Change LLMs without losing conversation context
- **Permission-based execution**: Tool execution requires approval by default (configurable)
- **Cross-platform**: Works on macOS, Linux, Windows, FreeBSD, OpenBSD, NetBSD
- **Charm ecosystem**: Beautiful terminal UI from the makers of Gum, Bubble Tea, and more

## 🧰 Included Tools

The environment includes:

- `crush` - AI coding agent for the terminal

## 🏁 Getting Started

### 📋 Prerequisites

- [Flox](https://flox.dev/get) installed on your system
- API keys for one or more LLM providers:
  - OpenAI API key (for GPT models)
  - Anthropic API key (for Claude models)
  - Or any OpenAI/Anthropic-compatible API endpoint

### 💻 Installation & Activation

Get started with:

```sh
# Clone the repo
git clone https://github.com/yourusername/floxenvs && cd floxenvs/crush

# Activate the environment
flox activate
```

### 🔐 First-Time Setup

Launch Crush and configure on first run:

```bash
# Start Crush
crush

# On first run, you'll be prompted to configure:
# - API keys for your preferred LLM provider(s)
# - Default model selection
# - Tool execution permissions
# - Other preferences
```

Configuration is stored in `~/.config/crush/` (or platform-specific config directory).

## 📝 Usage

### Basic Usage (Interactive Mode)

Launch the conversational coding assistant:

```bash
crush
```

This starts an interactive session where you can:
- Ask coding questions
- Generate and refactor code
- Debug issues with AI assistance
- Execute commands with approval
- Maintain project-specific context
- Switch models mid-conversation

Example interaction:
```
You: Help me refactor this authentication module to use JWT tokens

Crush: [analyzes code and proposes changes]
# Shows proposed modifications

You: approve

Crush: [executes refactoring]

You: Now add rate limiting to the login endpoint

Crush: [continues in same context]
```

### Session Management

Crush maintains separate sessions per project:

```bash
# Start in project directory
cd ~/projects/my-app
crush

# Crush automatically creates/resumes session for this project
# Context is preserved across sessions
```

**Benefits:**
- Each project maintains its own conversation history
- Context persists between Crush sessions
- Switch between projects without losing work

### Model Switching

Change LLM models during a session:

```bash
# Within Crush session:
# Switch to different model while keeping context

# Example commands (syntax may vary):
/model gpt-4o
/model claude-sonnet-4-5
/model custom-model-name
```

**Available models depend on your configuration:**
- OpenAI: GPT-4, GPT-4 Turbo, GPT-5, etc.
- Anthropic: Claude Sonnet, Claude Opus, etc.
- Custom: Any OpenAI/Anthropic-compatible API

### Permission-Based Tool Execution

By default, Crush requests permission before executing tools:

```
Crush: I'll run `npm install lodash` to add the dependency.

[Approve] [Reject] [Always allow for this session]
```

**Customization:**
- Configure default permission behavior in settings
- Allow specific tools automatically
- Require approval for sensitive operations

### Command-Line Options

```bash
crush --help              # Show all available options
crush --version           # Display version information

# Additional options (check --help for current list):
# --config <path>         # Specify custom config file
# --session <name>        # Use specific session name
# --model <name>          # Start with specific model
```

## 🔍 How It Works

### 🗄️ Session-Based Context

**Project Sessions:**
- Crush creates a unique session for each project directory
- Conversation history and context preserved across runs
- Project-specific knowledge builds over time
- Switch between projects seamlessly

**Context Persistence:**
- Code changes tracked across sessions
- Previous conversations remembered
- Model switches preserve context
- Session files stored in config directory

### 🚀 LSP Integration

**Language Server Protocol Support:**
- Enhanced code understanding and navigation
- Accurate symbol resolution
- Type information and documentation
- Refactoring capabilities

**Supported Languages:**
- Any language with LSP server support
- Automatic LSP detection per project
- Configurable LSP server settings

### 📂 MCP Extensibility

**Model Context Protocol:**
- Extend Crush with custom MCP servers
- Support for stdio, HTTP, and SSE transports
- Add domain-specific context providers
- Integrate with external tools and APIs

**Extension Capabilities:**
- Custom code analyzers
- Database integrations
- API documentation access
- Team-specific knowledge bases
- External tool integrations

### 🎯 Multi-Model Architecture

**Flexible LLM Selection:**
- Multiple providers configured simultaneously
- Switch models based on task requirements
- Compare outputs from different models
- Fallback to alternative providers

**Provider Support:**
- **OpenAI**: GPT-4, GPT-4 Turbo, GPT-5, etc.
- **Anthropic**: Claude Sonnet, Claude Opus, etc.
- **Custom**: Any OpenAI-compatible API (Ollama, LocalAI, etc.)
- **Custom**: Any Anthropic-compatible API

## 🛠️ Common Workflows

### Code Generation

```bash
# Start Crush in project directory
cd ~/projects/my-app
crush

You: Create a REST API for user management with CRUD operations

Crush: [generates implementation]
# Shows code structure and files to create

You: approve

Crush: [creates files and code]

You: Add input validation using Zod

Crush: [enhances implementation]
```

### Debugging with Context

```bash
crush

You: The authentication test is failing with "invalid token" error

Crush: [analyzes test output, code, and session history]
# Identifies issue based on project context

You: Fix the token validation logic

Crush: [proposes fix]

You: approve

Crush: [implements fix]
```

### Refactoring Across Sessions

```bash
# Session 1 - Start refactoring
crush
You: Let's refactor the database layer to use repository pattern
Crush: [analyzes and starts refactoring]

# Session 2 - Continue later
crush  # Same project, context preserved
You: Continue the repository refactoring from yesterday
Crush: [resumes from previous context]
```

### Model Comparison

```bash
crush

You: Generate an algorithm for efficient graph traversal

# Try with Model A
Crush: [generates solution using current model]

# Switch models
/model gpt-4o
You: Generate the same algorithm
Crush: [generates alternative approach]

# Compare both solutions in context
You: Combine the best parts of both approaches
Crush: [synthesizes optimal solution]
```

### MCP Integration Example

```bash
# With custom MCP server configured for database schema access

crush

You: Query the users table structure

Crush: [uses MCP server to fetch schema]
# Shows table definition from your database

You: Generate a migration to add email verification

Crush: [creates migration based on actual schema]
```

### Permission Workflow

```bash
crush

You: Install the packages needed for testing

Crush: I'll run these commands:
      1. npm install --save-dev jest
      2. npm install --save-dev @testing-library/react

      [Approve all] [Review each] [Reject]

# Review option allows approving/rejecting individually
```

## 🔧 Troubleshooting

### Configuration Issues

```bash
# Check config location (platform-specific)
# macOS/Linux: ~/.config/crush/
# Windows: %APPDATA%/crush/

# View current configuration
cat ~/.config/crush/config.json  # or platform equivalent

# Reset configuration (backup first!)
mv ~/.config/crush/config.json ~/.config/crush/config.json.backup
crush  # Reconfigure on next run
```

### API Key Problems

**Invalid or missing API keys:**
```bash
# Reconfigure API keys
crush
# Update keys in configuration when prompted

# Or edit config directly
nano ~/.config/crush/config.json
```

**Rate limiting:**
- Check API provider dashboard for usage
- Switch to alternative model/provider
- Wait for rate limit reset

### Session Context Issues

**Lost context or conversation:**
```bash
# Check session directory
ls ~/.config/crush/sessions/

# Session files stored per project path hash
# Context should persist automatically

# If issues persist, start fresh session:
crush --session new-session-name
```

### Model Switching Fails

**Model not available:**
- Verify model name is correct
- Check API key has access to model
- Ensure provider supports requested model
- Review configuration for custom models

**Syntax:**
```bash
# Check available models in your config
cat ~/.config/crush/config.json

# Use exact model identifier from config
```

### LSP Not Working

**Language server not detected:**
- Ensure LSP server installed for language
- Check LSP server in PATH
- Review Crush LSP configuration
- Verify project structure recognized

**Common LSP servers:**
- TypeScript/JavaScript: `typescript-language-server`
- Python: `pyright`, `pylsp`
- Go: `gopls`
- Rust: `rust-analyzer`

### Command Execution Blocked

**Permission denied:**
- Review permission settings in config
- Check tool execution permissions
- Approve when prompted
- Configure auto-approval for trusted tools

### Slow Response Times

**Performance optimization:**
- Use faster models for simple queries
- Clear old session data periodically
- Reduce context window if very large
- Check network connectivity to API provider

### MCP Server Issues

**Custom MCP server not loading:**
- Verify MCP server configuration
- Check server process is running
- Review transport type (stdio/HTTP/SSE)
- Check server logs for errors

## 💻 System Compatibility

This environment works on:
- macOS (Apple Silicon and Intel)
- Linux (x86_64 and ARM64)
- Windows (x86_64)
- FreeBSD, OpenBSD, NetBSD

## 🔒 Security Considerations

- **API key storage**: Keys stored in config file - protect with file permissions
- **Permission-based execution**: Commands require approval by default (configurable)
- **Session data**: Conversation history stored locally - may contain sensitive info
- **MCP servers**: Third-party extensions should be vetted before use
- **Tool execution**: Review all commands before approval
- **Config file security**: Restrict access to `~/.config/crush/` directory
- **Custom APIs**: Only use trusted OpenAI/Anthropic-compatible endpoints

**Best Practices:**
- Set restrictive file permissions on config directory
- Use environment variables for API keys (if supported)
- Review session data periodically
- Enable permission prompts for sensitive operations
- Audit MCP server sources before installation

## 📚 Additional Resources

- **Crush Repository**: [github.com/charmbracelet/crush](https://github.com/charmbracelet/crush)
- **Charm**: [charm.sh](https://charm.sh) - The Charm ecosystem of delightful CLI tools
- **Charm Tools**: [Gum](https://github.com/charmbracelet/gum), [Bubble Tea](https://github.com/charmbracelet/bubbletea), [Lip Gloss](https://github.com/charmbracelet/lipgloss)
- **Model Context Protocol**: [modelcontextprotocol.io](https://modelcontextprotocol.io)
- **Flox Documentation**: [flox.dev/docs](https://flox.dev/docs)

## 🙏 Acknowledgments

- **Charm Team**: An extra special shout-out to the absolutely brilliant folks at [Charm](https://github.com/charmbracelet) and all contributors to the [Crush project](https://github.com/charmbracelet/crush)! Charm has consistently elevated the entire landscape of terminal user interfaces, proving that CLI tools can be both powerful and downright beautiful. From [Gum](https://github.com/charmbracelet/gum) to [Bubble Tea](https://github.com/charmbracelet/bubbletea), from [Lip Gloss](https://github.com/charmbracelet/lipgloss) to [VHS](https://github.com/charmbracelet/vhs), and now with Crush, they continue to demonstrate that developer tools should be delightful, elegant, and a joy to use. Their unwavering commitment to open source excellence, impeccable design sensibility, and genuine care for developer experience has created an ecosystem that makes working in the terminal feel like magic. The Charm team has fundamentally changed what we expect from CLI tools, and the development community is infinitely better for it. Thank you for making the terminal glamorous! ✨

- **nix-ai-tools**: Special thanks to [numtide](https://github.com/numtide) and contributors for maintaining [nix-ai-tools](https://github.com/numtide/nix-ai-tools), which packages and distributes AI development tools for the Nix ecosystem, making it easy to use tools like Crush in reproducible environments

## 🔗 About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Software, variables, services defined in human-readable TOML
- **Content-addressed storage** - Multiple package versions coexist without conflicts
- **Reproducibility** - Same environment across dev, CI, and production
- **Deterministic builds** - Same inputs always produce identical outputs
- **Huge package collection** - Access to 150,000+ packages from [Nixpkgs](https://github.com/NixOS/nixpkgs)

## 📝 License

This Flox environment configuration is provided as-is. Crush and its dependencies have their own licenses - see the [Crush repository](https://github.com/charmbracelet/crush) for details.

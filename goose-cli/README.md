# 🪿 Flox Environment for Goose CLI

A Flox environment for [Goose](https://github.com/block/goose), a local, extensible, open-source AI agent that automates engineering tasks. Goose goes beyond code suggestions to autonomously build projects, execute code, debug, orchestrate workflows, and interact with APIs.

## ✨ Features

- **Autonomous task execution**: Build projects, write code, debug, and test end-to-end
- **Interactive sessions**: Conversational interface for iterative development
- **Web interface**: Browser-based UI with `goose web --open`
- **Session resumption**: Pick up where you left off with `goose session -r`
- **Multi-model support**: Configure multiple LLMs, optimize for cost and performance
- **MCP integration**: Connect to Model Context Protocol servers for extended capabilities
- **Extensions system**: Add tools and capabilities (file system, web scraping, automation)
- **Provider flexibility**: Works with OpenAI, Anthropic, Google Gemini, Azure, Bedrock, and more
- **Local execution**: Runs on your machine for privacy and control
- **Free and open source**: From Block (Square)

## 🧰 Included Tools

The environment includes:

- `goose` - Goose CLI tool

## 🏁 Getting Started

### 📋 Prerequisites

- [Flox](https://flox.dev/get) installed on your system
- API key for your chosen LLM provider (OpenAI, Anthropic, Gemini, etc.)
- Python 3.10+ (included in environment)
- System keyring access OR environment variables configured (see Authentication below)

### 💻 Installation & Activation

Get started with:

```sh
# Clone the repo
git clone https://github.com/yourusername/floxenvs && cd floxenvs/goose-cli

# Activate the environment
flox activate
```

### 🔐 First-Time Setup

**Authentication Methods:**

Goose stores API credentials in your system keyring by default. If your keyring is unavailable or locked, use environment variables instead.

**Method 1: System Keyring (Default)**

```bash
# Start configuration wizard
goose configure

# In the menu:
# 1. Configure providers → Select provider → Enter API key
# 2. Choose to save to keyring when prompted
# 3. Add extensions (optional)
# 4. Adjust settings
```

**Method 2: Environment Variables (Recommended for headless/CI)**

```bash
# Export your API key(s) before running goose
export OPENAI_API_KEY="your-key-here"
# or
export ANTHROPIC_API_KEY="your-key-here"
# or
export GOOGLE_API_KEY="your-key-here"

# Then configure provider
goose configure

# goose will detect the environment variable
# Choose "No" when asked to save to keyring
```

**Supported providers:**
- OpenAI (GPT-5.1, GPT-5, GPT-4o, etc.)
- Anthropic (Claude Sonnet 4.5, Opus 4.1, Haiku 4.5)
- Google Gemini (Gemini 3 Pro, Gemini 2.0)
- Azure OpenAI
- Amazon Bedrock
- Tetrate Agent Router Service (free $10 credit for first-time users)

## 📝 Usage

### Interactive Session

Start a conversational session with goose:

```bash
# Navigate to your project
cd ~/projects/my-app

# Start interactive session
goose session

# Example interaction:
You: Create a REST API for user management with CRUD operations

Goose: [analyzes requirements, creates plan, executes]
# Creates models, controllers, routes, tests
# Asks for confirmation before major changes

You: Add input validation with proper error handling

Goose: [adds validation, updates error responses]

You: Write integration tests

Goose: [generates comprehensive test suite]
```

### Resume Previous Session

Continue where you left off:

```bash
# Resume last session
goose session -r

# Previous context is maintained
You: Now add rate limiting to the API

Goose: [continues from previous work, adds rate limiting]
```

### Web Interface

Use browser-based interface:

```bash
# Launch web UI and open in browser
goose web --open

# Or just start the server
goose web
# Then navigate to http://localhost:8000
```

### Reconfigure Settings

Update configuration anytime:

```bash
# Open configuration menu
goose configure

# Options:
# - Switch LLM providers
# - Change models
# - Update API keys
# - Add/remove extensions
# - Adjust goose settings
```

## 🔧 Configuration

### LLM Providers

Goose supports multiple providers configured through `goose configure`:

**OpenAI:**
- Models: GPT-5.1, GPT-5.1-Codex, GPT-5, GPT-5-mini, GPT-5-nano, GPT-4o
- Get API key: https://platform.openai.com/api-keys

**Anthropic:**
- Models: Claude Sonnet 4.5, Claude Opus 4.1, Claude Opus 4, Claude Sonnet 4, Claude Haiku 4.5
- Get API key: https://console.anthropic.com/

**Google Gemini:**
- Models: Gemini 3 Pro, Gemini 3 Deep Think, Gemini 2.0 Flash, Gemini 2.0 Pro
- Get API key: https://aistudio.google.com/

**Azure OpenAI:**
- Enterprise deployment of OpenAI models
- Requires Azure subscription

**Amazon Bedrock:**
- AWS-hosted foundation models
- Requires AWS credentials

**Tetrate Agent Router:**
- Free $10 credit for new users
- Multi-model routing

### Multi-Model Configuration

Optimize for different tasks:

```bash
# Configure in goose configure menu
# Example strategy:
# - Fast model (GPT-5-nano, Gemini 2.0 Flash, Claude Haiku 4.5): Quick queries, code completion
# - Powerful model (GPT-5.1, Claude Opus 4.1, Gemini 3 Pro): Complex analysis, architecture
# - Cost-effective model (GPT-5-mini): Batch operations, documentation
```

### Extensions

Add capabilities through `goose configure → Add extensions`:

**Computer Controller Extension:**
- Web scraping
- File caching
- Browser automation
- System interactions

**Custom Extensions:**
- Install MCP servers for domain-specific tools
- Integrate with databases, APIs, services
- Extend goose's capabilities

## 🛠️ Common Workflows

### Building a Project from Scratch

```bash
cd ~/projects
goose session

You: Create a full-stack e-commerce application with React frontend and Node.js backend

Goose: [creates project structure]
# Sets up React app
# Creates Express backend
# Configures database
# Sets up routing and API endpoints

You: Add user authentication with JWT

Goose: [implements auth system]
# Creates auth endpoints
# Adds JWT middleware
# Updates frontend with auth UI
# Adds protected routes

You: Write tests for the authentication system

Goose: [generates test suite]
# Unit tests for auth logic
# Integration tests for endpoints
# Frontend tests for auth flow
```

### Debugging Session

```bash
cd ~/projects/my-app
goose session

You: The user login is failing with a 500 error

Goose: [analyzes logs and code]
# Identifies null pointer exception
# Traces back to database query

Goose: Found the issue in auth.js line 45. The user lookup query doesn't handle missing users properly.

You: Fix it

Goose: [updates code with proper error handling]
# Adds null checks
# Implements proper error responses
# Updates tests
```

### Code Review and Refactoring

```bash
goose session

You: Review the payment processing code for security issues

Goose: [analyzes payment module]
# Identifies security vulnerabilities
# Flags sensitive data logging
# Points out input validation gaps

You: Refactor it to follow security best practices

Goose: [refactors code]
# Implements input sanitization
# Removes sensitive logging
# Adds encryption for stored data
# Updates documentation
```

### Documentation Generation

```bash
goose session

You: Generate comprehensive API documentation for all endpoints

Goose: [analyzes endpoints and creates docs]
# Creates OpenAPI specification
# Generates markdown documentation
# Adds code examples
# Documents authentication

You: Add a getting started guide

Goose: [creates tutorial documentation]
```

### Migration Tasks

```bash
goose session

You: Migrate the codebase from JavaScript to TypeScript

Goose: [creates migration plan]
# Analyzes current structure
# Proposes incremental migration approach

You: Proceed with the migration

Goose: [executes migration]
# Adds TypeScript config
# Converts files incrementally
# Adds type definitions
# Updates build process
# Fixes type errors
```

### Web Interface Workflow

```bash
# Launch web UI
goose web --open

# Browser opens to http://localhost:8000
# Visual interface for:
# - Chat-based interaction
# - File tree navigation
# - Code diff review
# - Session history
# - Configuration management
```

### Session Management

```bash
# Start new session
goose session

# Work on task...
# Exit session (Ctrl+C or type 'exit')

# Later, resume
goose session -r

# Continue from where you left off
You: Continue with the API implementation

Goose: [picks up context, continues work]
```

## 🎯 Extensions and MCP Servers

### Built-in Extensions

Access via `goose configure → Add extensions`:

**Computer Controller:**
- Web page scraping
- File system caching
- Browser automation
- System command execution

### MCP Server Integration

Goose supports Model Context Protocol for extensibility:

```bash
# Configure MCP servers through goose configure
# Or manually edit configuration files

# Example use cases:
# - Database MCP server for direct DB access
# - GitHub MCP server for repository operations
# - Slack MCP server for team notifications
# - Custom domain-specific tools
```

## 🔧 Troubleshooting

### Configuration Issues

```bash
# Re-run configuration
goose configure

# Verify API key is correct
# Check provider status
# Try different provider

# Configuration files stored centrally
# Shared between Desktop and CLI
```

### Keyring Issues

**Problem:** Goose fails to start with keyring errors

**Solution - Use environment variables:**
```bash
# Export API key before running goose
export ANTHROPIC_API_KEY="your-key-here"
# or
export OPENAI_API_KEY="your-key-here"

# Then run goose
goose session

# Or reconfigure to use env vars
goose configure
# Choose "No" when asked to save to keyring
```

**Note:** Goose requires system keyring access by default. If your keyring is locked or unavailable, you MUST use environment variables.

### Command Not Found

```bash
# Verify goose is available
which goose

# Ensure environment is activated
flox activate

# Check installation
flox list
```

### Session Won't Start

```bash
# Check provider configuration
goose configure

# Verify API key is set
# Test with simple prompt
goose session
You: Hello

# Check for error messages
# May need to reconfigure provider
```

### Provider Authentication Errors

**Common issues:**
- Expired or invalid API key
- Rate limiting
- Provider service outage
- Incorrect endpoint configuration

**Solutions:**
```bash
# Update API key
goose configure → Configure providers

# Switch to different provider temporarily
# Check provider status pages

# For Tetrate (free tier):
# First-time auth provides $10 credit
```

### Extensions Not Working

```bash
# Check extension configuration
goose configure → Toggle extensions

# Verify extension is enabled
# Remove and re-add extension if needed

# Check MCP server status
# Review extension logs
```

### Web Interface Issues

```bash
# Ensure port 8000 is available
lsof -i :8000

# Try different port (if configurable)
# Check firewall settings

# Launch without --open flag
goose web
# Then manually navigate to http://localhost:8000
```

### Slow Response Times

**Normal behavior:**
- First request: Loading context, analyzing project
- Large codebases: More time for analysis
- Complex tasks: Planning and execution takes longer

**Optimization:**
- Use faster models for simple queries (Gemini Flash)
- Use powerful models for complex analysis (GPT-4, Claude Opus)
- Configure multi-model setup for efficiency
- Break large tasks into smaller steps

## 💻 System Compatibility

This environment works on:
- Linux x86_64
- macOS ARM64 (Apple Silicon)
- macOS x86_64 (Intel)

## 🔒 Security Considerations

- **API credentials**: Stored in system keyring by default, or use environment variables
- **Keyring requirement**: System keyring must be available/unlocked unless using env vars
- **Code access**: Goose can read and modify files in your project
- **Command execution**: Can run shell commands (with your approval)
- **Network access**: Communicates with configured LLM providers
- **MCP servers**: Third-party extensions may have additional access
- **Local execution**: Runs on your machine, not in the cloud

**Best Practices:**
- **Preferred**: Use environment variables for API keys (avoids keyring dependency)
- Use version control (git) for easy rollback
- Review code changes before accepting
- Be cautious with command execution approval
- Never commit API keys to version control
- Audit MCP servers before installation
- Keep goose and extensions updated
- Use `.gitignore` to exclude sensitive files from context

## 📚 Additional Resources

- **Goose Repository**: [github.com/block/goose](https://github.com/block/goose)
- **Documentation**: [block.github.io/goose](https://block.github.io/goose)
- **Quickstart**: [block.github.io/goose/docs/quickstart](https://block.github.io/goose/docs/quickstart)
- **Installation**: [block.github.io/goose/docs/getting-started/installation](https://block.github.io/goose/docs/getting-started/installation)
- **Guides**: [block.github.io/goose/docs/category/guides](https://block.github.io/goose/docs/category/guides)
- **Flox Documentation**: [flox.dev/docs](https://flox.dev/docs)

## 🙏 Acknowledgments

- **Block Team**: Thanks to Block (Square) for creating Goose and making it open source

## 🔗 About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Software, variables, services defined in human-readable TOML
- **Content-addressed storage** - Multiple package versions coexist without conflicts
- **Reproducibility** - Same environment across dev, CI, and production
- **Deterministic builds** - Same inputs always produce identical outputs
- **Huge package collection** - Access to 150,000+ packages from [Nixpkgs](https://github.com/NixOS/nixpkgs)

## 📝 License

This Flox environment configuration is provided as-is. Goose is open source from Block - see the [Goose repository](https://github.com/block/goose) for license details.

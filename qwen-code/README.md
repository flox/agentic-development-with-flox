# 🤖 Flox Environment for Qwen Code CLI

A Flox environment for [Qwen Code](https://github.com/QwenLM/qwen-code), an AI-powered command-line workflow tool optimized for Qwen3-Coder models. Built on technology adapted from Google's Gemini CLI, Qwen Code enables developers to query large codebases, automate workflows, and leverage vision models for multimodal analysis.

## ✨ Features

- **Code comprehension**: Query and edit large codebases beyond traditional context limits
- **Workflow automation**: Handle tasks like pull requests, rebasing, and git operations
- **Vision model support**: Auto-detects images and switches to vision-capable models
- **Enhanced parsing**: Specifically tuned for Qwen-Coder models
- **Interactive CLI**: Conversational interface with session management
- **Token optimization**: Configurable session limits to optimize costs and performance
- **Multi-provider support**: Qwen OAuth, OpenAI-compatible APIs, regional providers
- **Free tier**: 2,000 requests/day with Qwen OAuth
- **Local execution**: Runs on your machine for privacy and control

## 🧰 Included Tools

The environment includes:

- `qwen` - Qwen Code CLI tool

## 🏁 Getting Started

### 📋 Prerequisites

- [Flox](https://flox.dev/get) installed on your system
- Node.js 20+ (included in environment)
- Authentication credentials (Qwen OAuth recommended)

### 💻 Installation & Activation

Get started with:

```sh
# Clone the repo
git clone https://github.com/yourusername/agentic-development-with-flox && cd agentic-development-with-flox/qwen-code

# Activate the environment
flox activate
```

### 🔐 First-Time Setup

**Authentication Methods:**

Qwen Code stores configuration in `~/.qwen/settings.json` in your home directory (following security best practices).

**Method 1: Qwen OAuth (Recommended)**

```bash
# Start qwen and follow the OAuth flow
qwen

# Browser will open for authentication
# Grants 2,000 free requests/day
# Credentials stored in ~/.qwen/settings.json
```

**Method 2: OpenAI-Compatible API**

```bash
# Set environment variables
export OPENAI_API_KEY="your-key-here"
export OPENAI_BASE_URL="https://api.openai.com/v1"  # or other provider
export OPENAI_MODEL="qwen3-coder-32b"

# Start qwen
qwen
```

**Method 3: Manual Configuration**

```bash
# Create configuration file
mkdir -p ~/.qwen
cat > ~/.qwen/settings.json <<EOF
{
  "sessionTokenLimit": 32000,
  "experimental": {
    "vlmSwitchMode": "once"
  }
}
EOF

# Set API credentials via environment variables
export OPENAI_API_KEY="your-key-here"
```

**Supported providers:**
- Qwen OAuth (recommended - 2,000 requests/day free)
- Alibaba Cloud DashScope
- OpenAI
- OpenRouter
- ModelScope
- Regional providers (China/International)

## 📝 Usage

### Interactive Session

Start a conversational session:

```bash
# Navigate to your project
cd ~/projects/my-app

# Start interactive session
qwen

# Example interaction:
You: Describe the main pieces of this system's architecture

Qwen: [analyzes codebase, provides architectural overview]

You: Create a REST API for user management with CRUD operations

Qwen: [creates files, implements API endpoints]

You: Add input validation with proper error handling

Qwen: [updates code with validation]
```

### Session Commands

Available during interactive sessions:

```bash
/help       # Display available commands
/clear      # Remove all conversation history
/compress   # Reduce history to maintain token efficiency
/stats      # View current session information
/exit       # Close the application (/quit also works)
```

**Keyboard shortcuts:**
- `Ctrl+C` - Cancel current operation
- `Up/Down` arrows - Navigate command history

### Vision Model Support

Qwen Code automatically detects images and switches to vision-capable models:

```bash
qwen

You: [paste or upload screenshot]
You: What's wrong with this UI layout?

Qwen: [analyzes image visually, provides feedback]
```

**Configure vision behavior:**

```bash
# In ~/.qwen/settings.json
{
  "experimental": {
    "vlmSwitchMode": "once"    # Switch per query (default)
    # "vlmSwitchMode": "session"  # Switch for entire session
    # "vlmSwitchMode": "persist"  # No switching
  }
}
```

## 🔧 Configuration

### Settings File

Qwen Code uses `~/.qwen/settings.json` for configuration:

**⚠️ IMPORTANT - Flox Security Convention:**
Config files containing API keys or secrets MUST be in `$HOME` (`~/.qwen/`), never in project directories.

```json
{
  "sessionTokenLimit": 32000,
  "experimental": {
    "vlmSwitchMode": "once"
  }
}
```

**Available settings:**
- `sessionTokenLimit` - Control token usage per session (default: varies by model)
- `vlmSwitchMode` - Vision model switching behavior (`once`, `session`, `persist`)

### Environment Variables

Configure providers and models:

```bash
# API credentials
export OPENAI_API_KEY="your-key-here"

# Provider endpoint
export OPENAI_BASE_URL="https://api.openai.com/v1"

# Model selection
export OPENAI_MODEL="qwen3-coder-32b"
```

### Command-Line Flags

Override settings per session:

```bash
# Enable "yes to all" mode (skip confirmations)
qwen --yolo

# Set vision mode
qwen --vlm-switch-mode=session
```

## 🛠️ Common Workflows

### Building a Project from Scratch

```bash
cd ~/projects
qwen

You: Create a full-stack e-commerce application with React frontend and Node.js backend

Qwen: [creates project structure]
# Sets up React app
# Creates Express backend
# Configures database
# Sets up routing

You: Add user authentication with JWT

Qwen: [implements auth system]
# Creates auth endpoints
# Adds middleware
# Updates frontend

You: Write tests for the authentication system

Qwen: [generates comprehensive test suite]
```

### Debugging Session

```bash
cd ~/projects/my-app
qwen

You: The user login is failing with a 500 error

Qwen: [analyzes logs and code]
# Identifies root cause
# Traces error through stack

Qwen: Found the issue in auth.js line 45...

You: Fix it

Qwen: [updates code with proper error handling]
# Adds null checks
# Implements error responses
# Updates tests
```

### Code Review and Refactoring

```bash
qwen

You: Review the payment processing code for security issues

Qwen: [analyzes payment module]
# Identifies vulnerabilities
# Flags sensitive data exposure
# Points out validation gaps

You: Refactor it to follow security best practices

Qwen: [refactors code]
# Implements input sanitization
# Adds encryption
# Updates documentation
```

### Documentation Generation

```bash
qwen

You: Generate comprehensive API documentation for all endpoints

Qwen: [analyzes endpoints and creates docs]
# Creates OpenAPI specification
# Generates markdown docs
# Adds code examples

You: Add a getting started guide

Qwen: [creates tutorial documentation]
```

### Git and Workflow Automation

```bash
qwen

You: Analyze the git history and identify which commits introduced the authentication bug

Qwen: [runs git analysis]
# Reviews commit history
# Identifies problematic changes
# Provides detailed report

You: Create a pull request with a fix

Qwen: [creates branch, implements fix, generates PR description]
```

### Vision-Enabled Workflows

```bash
qwen

You: [upload screenshot of error message]
You: What does this error mean and how do I fix it?

Qwen: [analyzes screenshot visually]
# Reads error message from image
# Explains the issue
# Provides solution

You: [paste design mockup]
You: Implement this UI design

Qwen: [creates components matching the visual design]
```

## 🔧 Troubleshooting

### Authentication Issues

**Problem:** OAuth flow fails or credentials not saved

**Solution:**

```bash
# Verify settings file exists
ls -la ~/.qwen/settings.json

# Try environment variable method instead
export OPENAI_API_KEY="your-key-here"
export OPENAI_BASE_URL="https://dashscope.aliyuncs.com/compatible-mode/v1"

# Start qwen
qwen
```

### Command Not Found

```bash
# Verify qwen is available
which qwen

# Ensure environment is activated
flox activate

# Check installation
flox list
```

### Session Token Limits

**Problem:** Running out of tokens during long sessions

**Solution:**

```bash
# Use /compress command during session
qwen
You: /compress

# Or configure lower limits in ~/.qwen/settings.json
{
  "sessionTokenLimit": 16000
}
```

### Vision Models Not Working

**Problem:** Images not being processed

**Solution:**

```bash
# Check vision mode setting
cat ~/.qwen/settings.json

# Set explicit mode
qwen --vlm-switch-mode=once

# Verify model supports vision
# Check provider documentation
```

### Slow Response Times

**Normal behavior:**
- First request: Loading context, analyzing project
- Large codebases: More time for analysis
- Complex tasks: Planning and execution takes longer

**Optimization:**
- Use `/compress` to reduce context
- Configure session token limits
- Break large tasks into smaller steps
- Use more powerful models for complex analysis

## 💻 System Compatibility

This environment works on:
- Linux x86_64
- macOS ARM64 (Apple Silicon)
- macOS x86_64 (Intel)

## 🔒 Security Considerations

- **API credentials**: Stored in `~/.qwen/settings.json` or via environment variables
- **Configuration location**: `~/.qwen/` in your home directory (**NEVER in project root**)
- **Code access**: Qwen Code can read and modify files in your project
- **Command execution**: Can run shell commands (review before accepting)
- **Network access**: Communicates with configured providers
- **Local execution**: Runs on your machine, not in the cloud
- **Vision models**: Images sent to provider for analysis

**Best Practices:**
- **Recommended**: Use environment variables for API keys (e.g., `OPENAI_API_KEY`)
- **CRITICAL**: Config files with secrets MUST be in `$HOME` (e.g., `~/.qwen/`), never in project directories
- Never commit API keys to version control
- Per Flox conventions, all secrets live in `$HOME`, not in repos or `$FLOX_ENV_CACHE`
- Use version control (git) for easy rollback
- Review code changes before accepting
- Be cautious with command execution approval
- Keep Qwen Code updated
- Use `.gitignore` to exclude sensitive files from context

## 📚 Additional Resources

- **Qwen Code Repository**: [github.com/QwenLM/qwen-code](https://github.com/QwenLM/qwen-code)
- **Documentation**: Check repository README for latest updates
- **Qwen Models**: [qwenlm.github.io](https://qwenlm.github.io/)
- **Alibaba Cloud DashScope**: [dashscope.aliyun.com](https://dashscope.aliyun.com/)
- **Flox Documentation**: [flox.dev/docs](https://flox.dev/docs)

## 🙏 Acknowledgments

- **Qwen Team**: Thanks to Alibaba Cloud and the Qwen team for creating Qwen Code
- **Gemini CLI**: Built on technology adapted from Google's Gemini CLI

## 🔗 About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Software, variables, services defined in human-readable TOML
- **Content-addressed storage** - Multiple package versions coexist without conflicts
- **Reproducibility** - Same environment across dev, CI, and production
- **Deterministic builds** - Same inputs always produce identical outputs
- **Huge package collection** - Access to 150,000+ packages from [Nixpkgs](https://github.com/NixOS/nixpkgs)

## 📝 License

This Flox environment configuration is provided as-is. Qwen Code is from Alibaba Cloud - see the [Qwen Code repository](https://github.com/QwenLM/qwen-code) for license details.

# 🤖 Flox Environment for Codex CLI

A Flox environment for [Codex CLI](https://github.com/openai/codex), a lightweight local AI coding agent from OpenAI that runs on your computer. Codex provides conversational assistance for coding tasks, executes shell commands with approval, and integrates with your development workflow through an intelligent terminal interface.

## ✨ Features

- **Local AI coding agent**: Runs on your computer, not in the cloud
- **Conversational interface**: Natural language interaction for coding tasks
- **Command execution with approval**: Shell command safety with review system
- **Memory system**: AGENTS.md files provide persistent context across sessions
- **MCP server integration**: Extend functionality with Model Context Protocol servers
- **Execution policies**: Define rules for command restrictions and safety
- **Zero Data Retention**: Optional privacy mode prevents data storage
- **Multi-mode operation**: Interactive or non-interactive (for scripting/automation)
- **Helper functions**: Easy config and policy management
- **Cross-shell support**: Works with bash, zsh, and fish

## 🧰 Included Tools

The environment includes:

- `codex` - OpenAI's local AI coding agent

## 🏁 Getting Started

### 📋 Prerequisites

- [Flox](https://flox.dev/get) installed on your system
- ChatGPT account (Plus, Pro, Team, Edu, or Enterprise) or OpenAI API key
- Git repository (optional, for project context)

### 💻 Installation & Activation

Get started with:

```sh
# Clone the repo
git clone https://github.com/yourusername/floxenvs && cd floxenvs/codex

# Activate the environment
flox activate
```

### 🔐 First-Time Setup

Authenticate with OpenAI (required):

```bash
# Launch Codex
codex

# Choose "Sign in with ChatGPT" when prompted
# Follow browser authentication flow
# Your ChatGPT Plus/Pro/Team/Edu/Enterprise subscription includes Codex access

# Alternative: API key authentication
# (usage-based billing, requires separate setup)
```

## 📝 Usage

### Basic Usage (Interactive Mode)

Launch the conversational coding assistant:

```bash
codex
```

This starts an interactive session where you can:
- Ask coding questions
- Request code generation
- Execute shell commands (with approval)
- Refactor code
- Debug issues
- Manage git operations

Example interaction:
```
You: Create a Python function to calculate Fibonacci numbers
Codex: [generates code and explains]

You: Run the tests
Codex: [executes test command after approval]
```

### Non-Interactive Mode

Execute specific tasks via command line:

```bash
# Run a specific prompt
codex exec "Write unit tests for auth.py"

# Use in scripts/automation
codex exec "Generate API documentation"
```

### Helper Commands

The environment provides convenient utilities:

```bash
# Edit Codex configuration
codex-config

# Manage execution policies
codex-policy

# Edit a specific policy file
codex-policy default.codexpolicy

# View all policies
codex-policy

# Show help
codex --help
```

### Slash Commands

Within interactive mode, use slash commands for extended functionality:

```
/help       - Show available slash commands
/exit       - Exit Codex
/clear      - Clear conversation history
/config     - Show configuration
```

(See official documentation for complete slash command list)

## 🔍 How It Works

### 🗄️ Configuration

**Config File:** `~/.codex/config.toml`

Optional configuration includes:
- MCP server endpoints
- Execution policy rules
- Zero Data Retention settings
- Custom preferences

**Helper:** Use `codex-config` to edit configuration

### 🚀 Execution Policies

**Policy Directory:** `~/.codex/policy/`

Create `.codexpolicy` files to define command restrictions:

```python
# Example: default.codexpolicy
def prefix_rule(cmd):
    # Allow safe read operations
    if cmd.startswith("ls") or cmd.startswith("cat"):
        return "allow"

    # Prompt for git operations
    if cmd.startswith("git"):
        return "prompt"

    # Forbid destructive operations
    if cmd.startswith("rm -rf /"):
        return "forbidden"

    # Default: prompt for approval
    return "prompt"
```

**Policy Levels:**
- `allow` - Execute without prompting
- `prompt` - Ask for user approval
- `forbidden` - Never execute

**Helper:** Use `codex-policy` to manage policies

### 📂 Memory System

**AGENTS.md Files:**
- Provide persistent context across sessions
- Document project decisions and architecture
- Help Codex understand your codebase
- Located in your project root

Example AGENTS.md:
```markdown
# Project Context

## Architecture
- Microservices with REST APIs
- PostgreSQL database
- Redis for caching

## Coding Standards
- Use TypeScript strict mode
- Follow functional programming patterns
- Write unit tests for all business logic
```

### 🔐 Authentication

**ChatGPT Account (Recommended):**
- Includes Codex access with Plus/Pro/Team/Edu/Enterprise
- Browser-based authentication flow
- No usage limits beyond subscription tier

**API Key (Alternative):**
- Usage-based billing
- Requires separate configuration
- See official docs for setup

### 🎯 Approval System

When Codex wants to execute a command:
1. Shows the command to be executed
2. Displays which policy applies
3. Requests approval (unless policy is "allow")
4. Executes only after confirmation
5. Shows command output

This prevents accidental destructive operations while maintaining productivity.

## 🛠️ Common Workflows

### Code Generation

```bash
flox activate
codex

# In interactive mode:
You: Create a REST API endpoint for user authentication
Codex: [generates code with explanation]

You: Add input validation
Codex: [enhances code with validation]
```

### Code Review and Refactoring

```bash
codex

You: Review the code in src/auth.py for security issues
Codex: [analyzes and provides recommendations]

You: Refactor to use dependency injection
Codex: [refactors code]
```

### Debugging

```bash
codex

You: Why is the authentication test failing?
Codex: [analyzes test output, suggests fixes]

You: Fix the issue
Codex: [implements fix]
```

### Git Operations

```bash
codex

You: Review my uncommitted changes
Codex: [shows git diff with analysis]

You: Create a meaningful commit message
Codex: [generates descriptive commit message]

You: Commit the changes
Codex: [executes git commit after approval]
```

### Automation with Non-Interactive Mode

```bash
# In CI/CD pipeline
codex exec "Generate changelog from recent commits"

# Batch processing
for file in *.py; do
    codex exec "Add type hints to $file"
done

# Documentation generation
codex exec "Create API documentation from source code"
```

## 🔧 Troubleshooting

### Authentication Issues

```bash
# Re-authenticate
codex
# Select "Sign in with ChatGPT" again

# Check config
codex-config

# Verify subscription includes Codex
# (Plus, Pro, Team, Edu, or Enterprise required)
```

### Command Execution Blocked

```bash
# Check execution policies
codex-policy

# Edit policy to allow command
codex-policy default.codexpolicy

# Temporarily approve specific command
# (use approval prompt when it appears)
```

### Configuration Not Found

```bash
# Create/edit config
codex-config

# This creates ~/.codex/config.toml if it doesn't exist
```

### Policy Files Not Working

```bash
# View policy directory
codex-policy

# Ensure .codexpolicy extension
# Verify syntax (Python-based)
# Check file permissions
```

### Memory/Context Issues

```bash
# Create AGENTS.md in project root
echo "# Project Context" > AGENTS.md

# Add relevant information
codex-config  # Or edit AGENTS.md directly
```

### Codex Not Available

```bash
# Verify installation
which codex

# Ensure environment is activated
flox activate

# Check package
flox list
```

## 💻 System Compatibility

This environment works on:
- macOS (Apple Silicon and Intel)
- Linux (x86_64 and ARM64)

## 🔒 Security Considerations

- **Execution approval**: Commands require approval unless explicitly allowed in policies
- **Policy system**: Define rules to prevent dangerous operations
- **Local processing**: Runs on your computer with API communication to OpenAI
- **Zero Data Retention**: Optional mode prevents data storage
- **Authentication**: Secure token-based or ChatGPT account integration
- **Command visibility**: All proposed commands shown before execution
- **Audit trail**: Command history and approval decisions logged

## 📚 Additional Resources

- **Codex Repository**: [github.com/openai/codex](https://github.com/openai/codex)
- **ChatGPT Codex**: [chatgpt.com/codex](https://chatgpt.com/codex)
- **AI Tools Collection**: [nix-ai-tools](https://github.com/numtide/nix-ai-tools) - A great resource for collecting and running AI development tools with Nix
- **Flox Documentation**: [flox.dev/docs](https://flox.dev/docs)
- **OpenAI Documentation**: [platform.openai.com/docs](https://platform.openai.com/docs)

## 🙏 Acknowledgments

- **OpenAI Codex Team**: Huge thanks to OpenAI and all contributors to the [Codex project](https://github.com/openai/codex) for creating this excellent local AI coding agent
- **nix-ai-tools**: Special thanks to [numtide](https://github.com/numtide) and contributors for maintaining [nix-ai-tools](https://github.com/numtide/nix-ai-tools), which packages and distributes AI development tools for the Nix ecosystem, making it easy to use tools like Codex in reproducible environments

## 🔗 About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Software, variables, services defined in human-readable TOML
- **Content-addressed storage** - Multiple package versions coexist without conflicts
- **Reproducibility** - Same environment across dev, CI, and production
- **Deterministic builds** - Same inputs always produce identical outputs
- **Huge package collection** - Access to 150,000+ packages from [Nixpkgs](https://github.com/NixOS/nixpkgs)

## 📝 License

This Flox environment configuration is provided as-is. Codex and OpenAI services have their own terms of service - see the [OpenAI website](https://openai.com) for details.

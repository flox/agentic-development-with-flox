# 🤖 Flox Environment for Cursor Agent CLI

A Flox environment for [Cursor Agent CLI](https://cursor.com/cli), the official command-line interface for Cursor's autonomous AI coding agent. Cursor Agent CLI brings the power of Cursor's AI agent directly to your terminal, allowing you to write, review, and modify code using natural language - whether you're using Neovim, JetBrains, VS Code, or any other development environment.

## ✨ Features

- **Autonomous AI agent**: Plans and executes complex codebase changes independently
- **Dual-mode operation**: Interactive TUI for hands-on work, non-interactive mode for automation
- **Full file system access**: Read, write, and modify files across your entire codebase
- **Codebase search**: Search and navigate your project with AI assistance
- **Shell command execution**: Run terminal commands with approval system
- **Multi-model support**: Works with any model from your Cursor subscription
- **Editor-agnostic**: Use Cursor Agent alongside Neovim, JetBrains, or any IDE
- **CI/CD ready**: Non-interactive mode perfect for automated workflows
- **Beta access**: Early access to Cursor's latest CLI capabilities

## 🧰 Included Tools

The environment includes:

- `cursor-agent` - Cursor's autonomous AI coding agent for the terminal

## 🏁 Getting Started

### 📋 Prerequisites

- [Flox](https://flox.dev/get) installed on your system
- x86_64 Linux system (currently Linux-only)
- Active Cursor subscription (Individual, Business, or Enterprise)
- Git repository (recommended, for project context)

### 💻 Installation & Activation

Get started with:

```sh
# Clone the repo
git clone https://github.com/yourusername/floxenvs && cd floxenvs/cursor-agent

# Activate the environment
flox activate
```

### 🔐 First-Time Setup

Launch Cursor Agent and authenticate:

```bash
# Start interactive TUI
cursor-agent

# On first run, you'll be prompted to authenticate with your Cursor account
# Follow the authentication flow to link your subscription
```

## 📝 Usage

### Interactive TUI Mode

Launch the interactive terminal interface:

```bash
cursor-agent
```

This starts a TUI session where you can:
- Have natural language conversations about your code
- Request autonomous changes across multiple files
- Review and approve file modifications before they're applied
- Execute shell commands with explicit permission
- Search and navigate your codebase with AI assistance
- Work iteratively on complex refactoring tasks

Example interaction:
```
You: Refactor the authentication module to use JWT tokens instead of sessions

Cursor Agent: [analyzes codebase and creates execution plan]
# Shows plan: modify auth.js, update middleware, add JWT library

You: approve

Cursor Agent: [executes plan across multiple files]
# Shows each modification, requests approval for shell commands

Cursor Agent: Changes complete. I've updated 5 files and added the jsonwebtoken dependency.
```

### Non-Interactive Mode (Scripts/CI)

Execute tasks directly from the command line:

```bash
# Single prompt execution
cursor-agent "add comprehensive error handling to the API endpoints"

# Start chat with initial prompt
cursor-agent chat "review the security of the authentication code"

# Use in scripts
cursor-agent "generate unit tests for all service layer functions" > test-generation.log
```

**Perfect for:**
- CI/CD pipelines
- Automated code reviews
- Batch refactoring tasks
- Documentation generation
- Test generation workflows

### Starting with a Prompt

Jump straight into a task:

```bash
# Interactive mode with initial prompt
cursor-agent chat "find and fix any potential memory leaks"

# Non-interactive execution
cursor-agent "update all dependencies to their latest compatible versions"
```

### Command-Line Options

```bash
cursor-agent                  # Start interactive TUI
cursor-agent "prompt"         # Non-interactive execution
cursor-agent chat "prompt"    # Interactive chat with initial prompt
cursor-agent --help           # Show available options
cursor-agent --version        # Display version information
```

## 🔍 How It Works

### 🗄️ Autonomous Agent Architecture

**Planning Phase:**
- Analyzes your request and current codebase
- Creates detailed execution plan
- Identifies files to modify and commands to run
- Presents plan for review and approval

**Execution Phase:**
- Makes file modifications according to plan
- Requests permission for shell commands
- Applies changes incrementally
- Verifies changes with linters (when available)
- Self-corrects if issues detected

**Verification Phase:**
- Reviews all changes for correctness
- Checks for linter errors and warnings
- Attempts automatic fixes if needed
- Summarizes modifications made

### 🚀 Dual-Mode Operation

**Interactive TUI Mode:**
- Visual terminal interface for hands-on work
- Real-time file modification previews
- Conversational back-and-forth
- Approval prompts for destructive operations
- Iterative refinement of changes

**Non-Interactive Print Mode:**
- Headless execution for automation
- Output suitable for logging and parsing
- Perfect for CI/CD pipelines
- No user prompts (auto-approve or pre-configured)
- Scriptable and reproducible

### 📂 File System Operations

**Read Capabilities:**
- Access any file in your project
- Search codebase by content or structure
- Navigate directory hierarchies
- Read configuration files and documentation

**Write Capabilities:**
- Create new files and directories
- Modify existing code across multiple files
- Refactor with cross-file awareness
- Generate boilerplate and scaffolding

### 🎯 Shell Command Execution

**Permission-Based System:**
- Commands presented before execution
- Approval required by default (configurable)
- See exact command with arguments
- Reject dangerous operations
- Allow trusted commands automatically

**Common Operations:**
- Package installation (`npm install`, `pip install`)
- Database migrations
- Build and test commands
- Git operations
- Environment setup

### 🔧 Multi-Model Support

**Flexible Model Selection:**
- Use any model from your Cursor subscription
- Switch models based on task complexity
- Compare different model outputs
- Optimize for speed vs. reasoning power

**Model Capabilities:**
- Code generation and refactoring
- Bug detection and fixing
- Documentation writing
- Test generation
- Security analysis

## 🛠️ Common Workflows

### Refactoring with Context

```bash
# Interactive mode
cursor-agent

You: Refactor the database layer to use the repository pattern

Cursor Agent: [analyzes current architecture]
# Shows refactoring plan across 12 files

You: approve

Cursor Agent: [executes plan]
# Updates models, creates repositories, refactors services
# Requests approval to run tests

You: approve tests

Cursor Agent: All tests passing. Refactoring complete.
```

### CI/CD Integration

```bash
#!/bin/bash
# .github/workflows/ai-code-review.sh

# Non-interactive security audit
cursor-agent "Review all API endpoints for security vulnerabilities and suggest fixes" > security-audit.txt

# Check exit code
if [ $? -eq 0 ]; then
    echo "Security review complete"
    cat security-audit.txt
else
    echo "Security review failed"
    exit 1
fi
```

### Batch Test Generation

```bash
# Generate tests for entire codebase
cursor-agent "Generate comprehensive unit tests for all functions in the src/ directory that don't have tests"

# Result: Creates test files with full coverage
```

### Bug Hunting

```bash
cursor-agent chat "find and fix any bugs in the payment processing code"

# Agent searches, analyzes, proposes fixes
# You review and approve each fix
```

### Documentation Generation

```bash
# Non-interactive documentation update
cursor-agent "Update all JSDoc comments to include examples and add missing parameter descriptions"
```

### Migration Tasks

```bash
cursor-agent

You: Migrate from JavaScript to TypeScript

Cursor Agent: This is a large migration. I'll proceed incrementally:
              1. Add TypeScript config
              2. Rename .js files to .ts
              3. Add type annotations
              4. Fix type errors

You: approve

Cursor Agent: [executes migration in stages with approval gates]
```

### Code Review Assistance

```bash
# Review recent changes
cursor-agent chat "review the last commit for potential issues"

# Agent analyzes git diff and suggests improvements
```

## 🔧 Troubleshooting

### Authentication Issues

```bash
# Re-authenticate
cursor-agent
# Follow authentication flow

# Verify subscription is active
# Check https://cursor.com/settings/subscription
```

### Command Not Found

```bash
# Verify cursor-agent is available
which cursor-agent

# Ensure environment is activated
flox activate

# Check installation
flox list
```

### Agent Won't Start

```bash
# Check for error messages
cursor-agent --help

# Verify you're in a project directory (recommended)
pwd
ls -la

# Try with explicit project path
cd ~/projects/my-app
cursor-agent
```

### File Modifications Not Applied

**Common causes:**
- Files have merge conflicts
- Permission issues (read-only files)
- Files outside project directory
- Linter preventing save

**Solutions:**
```bash
# Check file permissions
ls -la <file>

# Ensure git working tree is clean
git status

# Review agent's error messages
# Agent will report specific issues
```

### Shell Commands Blocked

**Permission denied:**
- Review command carefully before approving
- Check if command is appropriate for context
- Verify command syntax is correct
- Configure auto-approval for trusted commands (advanced)

### Slow Response Times

**Normal behavior:**
- First request in session: Loading project context
- Large codebases: Context analysis takes time
- Complex refactoring: Planning phase is thorough

**Optimization tips:**
- Work in smaller, focused directories
- Break large tasks into smaller steps
- Use non-interactive mode for simple tasks
- Ensure good network connectivity

### Subscription Issues

```bash
# Verify subscription status
# Visit https://cursor.com/settings

# Required subscription tier:
# - Cursor Individual (recommended)
# - Cursor Business
# - Cursor Enterprise

# CLI is in beta - ensure you have access
```

### CI/CD Mode Not Working

**Non-interactive execution:**
```bash
# Ensure you're not in a TTY
cursor-agent "prompt" < /dev/null

# Check exit codes
echo $?

# Capture output properly
cursor-agent "prompt" 2>&1 | tee output.log
```

## 💻 System Compatibility

This environment currently works on:
- Linux x86_64

**Note:** macOS and ARM64 support planned for future releases.

## 🔒 Security Considerations

- **Authentication**: Secure token-based Cursor account authentication
- **Shell command approval**: Explicit permission required by default
- **File system access**: Full read/write access to project directory
- **Network access**: Communicates with Cursor API for AI processing
- **Code privacy**: Subject to Cursor's privacy policy and subscription terms
- **Approval gates**: Review all changes before they're applied
- **Beta software**: CLI is in beta - use with appropriate caution in production

**Best Practices:**
- Review all file modifications before approving
- Carefully examine shell commands before execution
- Use in version-controlled projects (easy rollback)
- Test in non-production environments first
- Keep Cursor subscription and CLI updated
- Don't auto-approve commands in CI without review

## 📚 Additional Resources

- **Cursor Agent CLI**: [cursor.com/cli](https://cursor.com/cli)
- **CLI Documentation**: [docs.cursor.com/cli](https://docs.cursor.com/cli/overview)
- **Cursor Agent Docs**: [docs.cursor.com/agent](https://docs.cursor.com/agent)
- **Cursor Website**: [cursor.com](https://cursor.com)
- **Cursor Blog**: [cursor.com/blog](https://cursor.com/blog)
- **Flox Documentation**: [flox.dev/docs](https://flox.dev/docs)

## 🙏 Acknowledgments

- **Cursor Team**: Thanks to the team at [Cursor](https://cursor.com) for creating the Cursor Agent CLI and making autonomous AI coding agents accessible from the terminal

- **nix-ai-tools**: Special thanks to [numtide](https://github.com/numtide) and contributors for maintaining [nix-ai-tools](https://github.com/numtide/nix-ai-tools), which packages and distributes AI development tools for the Nix ecosystem, making it easy to use tools like Cursor Agent CLI in reproducible environments

## 🔗 About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Software, variables, services defined in human-readable TOML
- **Content-addressed storage** - Multiple package versions coexist without conflicts
- **Reproducibility** - Same environment across dev, CI, and production
- **Deterministic builds** - Same inputs always produce identical outputs
- **Huge package collection** - Access to 150,000+ packages from [Nixpkgs](https://github.com/NixOS/nixpkgs)

## 📝 License

This Flox environment configuration is provided as-is. Cursor Agent CLI and the Cursor platform have their own terms of service - see the [Cursor website](https://cursor.com) for details.

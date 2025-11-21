# 🐰 Flox Environment for CodeRabbit CLI

A Flox environment for [CodeRabbit CLI](https://docs.coderabbit.ai/cli/overview), an AI-powered code review tool that catches bugs, security issues, and code smells directly in your terminal. CodeRabbit provides context-aware reviews that learn from your team's patterns and enforce coding standards before code reaches production.

## ✨ Features

- **AI-powered code reviews**: Senior-engineer level analysis in your terminal
- **Context-aware detection**: Spots race conditions, memory leaks, security vulnerabilities
- **Team standards enforcement**: Auto-reads claude.md, .cursorrules, and custom guidelines
- **Multiple review modes**: Interactive, plain text, or AI agent optimized
- **Immediate fix suggestions**: Actionable recommendations from imports to architecture
- **Learning system**: Remembers team patterns for error handling and architecture
- **Helper functions**: Convenient shortcuts for common workflows
- **Cross-shell support**: Works with bash, zsh, and fish

## 🧰 Included Tools

The environment includes:

- `coderabbit-cli` - AI code review tool (alias: `cr`)

## 🏁 Getting Started

### 📋 Prerequisites

- [Flox](https://flox.dev/get) installed on your system
- x86_64 Linux system (currently Linux-only)
- Git repository with code to review
- CodeRabbit account (free tier available)

### 💻 Installation & Activation

Get started with:

```sh
# Clone the repo
git clone https://github.com/yourusername/floxenvs && cd floxenvs/coderabbit-cli

# Activate the environment
flox activate
```

### 🔐 First-Time Setup

Authenticate with CodeRabbit (required):

```bash
# Full command
coderabbit auth login

# Or short alias
cr auth login
```

This opens your browser for authentication. Copy the access token back to the CLI to complete setup.

## 📝 Usage

### Basic Usage

Review all changes in your current branch:

```bash
coderabbit
```

This runs an interactive review showing:
- Issues found (bugs, security, code smells)
- Severity levels
- Fix suggestions
- Team standards violations

### Helper Commands

The environment provides convenient shortcuts:

```bash
# Review only uncommitted changes
coderabbit-uncommitted

# Plain text output (no colors, good for logs)
coderabbit-plain

# Prompt-only mode for AI agents (Claude Code, Cursor, etc.)
coderabbit-ai

# Review against specific base branch
coderabbit-base develop

# Show all available options
coderabbit-help
# or
cr --help
```

### Review Types

Specify what to review:

```bash
# All changes
coderabbit --type all

# Only committed changes
coderabbit --type committed

# Only uncommitted changes
coderabbit --type uncommitted
# or use helper
coderabbit-uncommitted
```

### Output Modes

Choose your preferred output format:

```bash
# Interactive mode (default)
coderabbit

# Plain text (no colors)
coderabbit --plain
# or use helper
coderabbit-plain

# Prompt-only (optimized for AI agents)
coderabbit --prompt-only
# or use helper
coderabbit-ai
```

### Custom Base Branch

Compare against a different branch:

```bash
# Compare with develop branch
coderabbit --base develop

# Or use helper
coderabbit-base develop

# With specific commit
coderabbit --base-commit abc123
```

### Additional Configuration

```bash
# Supply additional instruction files
coderabbit --config claude.md .cursorrules team-standards.md

# Specify working directory
coderabbit --cwd /path/to/project

# Disable colored output
coderabbit --no-color
```

## 🔍 How It Works

### 🗄️ Code Analysis

**Pattern Recognition:**
- Uses same AI engine as CodeRabbit's PR reviews
- Analyzes uncommitted/committed changes
- Spots bugs, logic errors, security issues
- Identifies code smells and anti-patterns

**Learning System:**
- Remembers team coding preferences
- Adapts to your project's architecture
- Learns from feedback on previous reviews
- Enforces consistent patterns across codebase

**Context Awareness:**
- Understands code relationships across files
- Maps code graph for dependency analysis
- Catches issues that simple linters miss
- Provides architectural-level insights

### 🚀 Review Process

1. **Scan**: Analyzes changed files in your working directory
2. **Detect**: Identifies issues using AI pattern recognition
3. **Contextualize**: Maps relationships and dependencies
4. **Suggest**: Provides actionable fix recommendations
5. **Learn**: Remembers patterns for future reviews

### 📂 Configuration Files

CodeRabbit automatically reads:
- `claude.md` - Claude-specific guidelines
- `.cursorrules` - Cursor editor rules
- `coderabbit.yaml` - CodeRabbit configuration
- Custom team standards documents

Supply additional files with `--config`:
```bash
coderabbit --config team-standards.md coding-guidelines.md
```

### 🎯 Issue Detection

**Security:**
- SQL injection vulnerabilities
- XSS attack vectors
- Insecure cryptography
- Exposed credentials
- Authentication bypasses

**Logic:**
- Race conditions
- Off-by-one errors
- Null pointer exceptions
- Incorrect error handling
- Edge case misses

**Quality:**
- Code smells
- Duplicated logic
- Overly complex functions
- Missing unit tests
- Poor naming conventions

**Performance:**
- Memory leaks
- N+1 queries
- Inefficient algorithms
- Resource exhaustion

## 🛠️ Common Workflows

### Quick Pre-Commit Review

```bash
# Review what you're about to commit
flox activate
coderabbit-uncommitted

# Fix issues, then commit
git add .
git commit -m "feat: add feature"
```

### AI Agent Integration

For use with Claude Code, Cursor CLI, or similar:

```bash
# Get prompt-optimized output
coderabbit-ai

# AI agent processes feedback
# Implement suggested fixes
# Run second pass to verify
coderabbit-ai
```

### Feature Branch Review

```bash
# Review entire feature branch against develop
coderabbit-base develop

# Or just uncommitted work
coderabbit-uncommitted
```

### CI/CD Integration

```bash
# In CI pipeline
coderabbit --plain --type committed > review.txt

# Parse review.txt for issues
# Fail build if critical issues found
```

### Team Standards Enforcement

```bash
# Review with custom standards
coderabbit --config team-standards.md .cursorrules

# CodeRabbit learns and applies these rules
# Future reviews automatically enforce them
```

## 🔧 Troubleshooting

### Authentication Issues

```bash
# Re-authenticate
coderabbit auth login

# Or use short alias
cr auth login

# Check authentication status
coderabbit auth status
```

### No Issues Found

This is good! But if you expected issues:
- Ensure you have uncommitted or committed changes
- Check you're in a git repository: `git status`
- Try different review type: `coderabbit --type all`
- Verify base branch is correct

### Rate Limit Errors

**Free Tier:** 1 review/hour

**Solutions:**
- Wait for rate limit to reset
- Upgrade to Pro (5 reviews/hour) or Lite (1 review/hour with learnings)
- Contact sales@coderabbit.ai for enterprise limits

### Command Not Found

```bash
# Verify coderabbit is available
which coderabbit
which cr

# Ensure environment is activated
flox activate

# Check installation
flox list
```

### Review Takes Too Long

Reviews can take 7-30+ minutes depending on:
- Amount of code changed
- Complexity of changes
- API response time

**Solutions:**
- Review smaller changesets: `coderabbit-uncommitted`
- Use `--prompt-only` mode and run in background
- Break large features into smaller commits

### Config Files Not Detected

```bash
# Verify files exist
ls -la claude.md .cursorrules coderabbit.yaml

# Explicitly specify
coderabbit --config claude.md .cursorrules

# Check working directory
pwd
coderabbit --cwd /correct/path
```

## 💻 System Compatibility

This environment currently works on:
- Linux x86_64

**Note:** macOS and ARM64 support planned.

## 🔒 Security Considerations

- **API communication**: Reviews sent to CodeRabbit API (not fully local)
- **Code privacy**: Free tier for public repos, paid for private repos
- **Team patterns**: Learnings stored to improve future reviews
- **Authentication**: Secure token-based authentication
- **Enterprise option**: Self-hosted deployment available
- **No code storage**: Reviews are ephemeral, not permanently stored

## 📊 Pricing Tiers

**Free:**
- 1 review/hour
- Basic static analysis
- Public repositories

**Lite ($12/month):**
- 1 review/hour
- Learnings-powered analysis
- Team standards enforcement
- Private repositories

**Pro ($20/month):**
- 5 reviews/hour
- All Lite features
- Advanced issue detection
- Priority support

**Enterprise:**
- Custom rate limits
- Self-hosted deployment
- Contact: sales@coderabbit.ai

## 📚 Additional Resources

- **CodeRabbit CLI Documentation**: [docs.coderabbit.ai/cli/overview](https://docs.coderabbit.ai/cli/overview)
- **CodeRabbit Website**: [coderabbit.ai](https://www.coderabbit.ai)
- **AI Tools Collection**: [nix-ai-tools](https://github.com/numtide/nix-ai-tools) - A great resource for collecting and running AI development tools with Nix
- **Flox Documentation**: [flox.dev/docs](https://flox.dev/docs)
- **GitHub Organization**: [github.com/coderabbitai](https://github.com/coderabbitai)

## 🙏 Acknowledgments

- **CodeRabbit Team**: Huge thanks to [CodeRabbit](https://github.com/coderabbitai) and all contributors for creating this excellent AI-powered code review tool that brings senior-engineer level analysis to the terminal
- **nix-ai-tools**: Special thanks to [numtide](https://github.com/numtide) and contributors for maintaining [nix-ai-tools](https://github.com/numtide/nix-ai-tools), which packages and distributes AI development tools for the Nix ecosystem, making it easy to use tools like CodeRabbit CLI in reproducible environments

## 🔗 About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Software, variables, services defined in human-readable TOML
- **Content-addressed storage** - Multiple package versions coexist without conflicts
- **Reproducibility** - Same environment across dev, CI, and production
- **Deterministic builds** - Same inputs always produce identical outputs
- **Huge package collection** - Access to 150,000+ packages from [Nixpkgs](https://github.com/NixOS/nixpkgs)

## 📝 License

This Flox environment configuration is provided as-is. CodeRabbit and its CLI tool have their own terms of service - see the [CodeRabbit website](https://www.coderabbit.ai) for details.

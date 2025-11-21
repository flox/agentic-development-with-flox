# 🤖 Flox Environment for Droid CLI

A Flox environment for [Droid](https://factory.ai), Factory's AI software development agent that automates complete development tasks across your existing workflow. Droid handles refactors, incident response, migrations, and more - working seamlessly with your IDE, terminal, CI/CD pipelines, and team communication tools.

## ✨ Features

- **Autonomous task completion**: Handles complete development tasks from start to finish
- **Dual-mode operation**: Interactive mode for IDE/terminal, headless exec mode for automation
- **Multi-interface access**: CLI, Web, Slack, Teams, Linear, Jira, and mobile
- **Workflow integration**: Works with existing tools (VS Code, JetBrains, Vim, etc.)
- **Model-agnostic**: Compatible with any AI model provider
- **CI/CD ready**: Headless execution for pipelines, cron jobs, pre-commit hooks
- **State-of-the-art performance**: 58.75% on Terminal-Bench
- **Cross-platform**: Linux x86_64 and macOS ARM64 (Apple Silicon)

## 🧰 Included Tools

The environment includes:

- `droid` - Factory's AI development agent CLI

## 🏁 Getting Started

### 📋 Prerequisites

- [Flox](https://flox.dev/get) installed on your system
- x86_64 Linux or ARM64 macOS (Apple Silicon)
- Factory.ai account
- Git repository (recommended, for project context)

### 💻 Installation & Activation

Get started with:

```sh
# Clone the repo
git clone https://github.com/yourusername/floxenvs && cd floxenvs/droid

# Activate the environment
flox activate
```

### 🔐 First-Time Setup

Launch Droid and authenticate:

```bash
# Start interactive mode
droid

# On first run, you'll be prompted to authenticate with your Factory.ai account
# Follow the authentication flow to complete setup
```

## 📝 Usage

### Interactive Mode (IDE/Terminal)

Launch the interactive development agent:

```bash
droid
```

This starts an interactive session where you can:
- Request autonomous refactoring across multiple files
- Delegate incident response and debugging tasks
- Coordinate complex migrations
- Generate code with full context awareness
- Review and approve changes before they're applied
- Work iteratively on large-scale changes

Example interaction:
```
You: Refactor the authentication system to use OAuth 2.0 instead of sessions

Droid: [analyzes codebase and creates migration plan]
# Shows plan: update dependencies, modify auth routes, migrate user sessions

You: proceed

Droid: [executes migration across multiple files]
# Updates config, rewrites auth logic, creates migration script

Droid: Migration complete. 12 files updated, tests passing.
```

### Headless Mode (Droid Exec)

Execute non-interactive tasks for automation:

```bash
# Single task execution
droid exec "add comprehensive error handling to all API endpoints"

# CI/CD integration
droid exec "review PR #123 for security vulnerabilities"

# Batch processing
droid exec "generate unit tests for all service layer functions"
```

**Perfect for:**
- CI/CD pipelines (automated code review, testing)
- Cron jobs (scheduled maintenance, updates)
- Pre-commit hooks (code quality checks)
- Batch scripts (mass refactoring, migrations)
- One-off automation tasks

### Multi-Interface Access

Droid is available across platforms:

```bash
# CLI (terminal/IDE)
droid

# Web browser
# Visit https://factory.ai to access web interface

# Slack/Teams
# Install Factory app for team collaboration

# Project managers (Linear, Jira)
# Automatic triggering from issue assignments
```

### Command-Line Options

```bash
droid                        # Start interactive mode
droid exec "task"            # Headless execution
droid --help                 # Show available options
droid --version              # Display version information
```

## 🔍 How It Works

### 🗄️ Agent-Native Development

**Task Understanding:**
- Analyzes your request with full codebase context
- Identifies files, dependencies, and integration points
- Creates comprehensive execution plan
- Presents plan for review and approval

**Autonomous Execution:**
- Makes changes across multiple files simultaneously
- Handles dependencies and side effects automatically
- Runs tests and validates changes
- Self-corrects errors and failures
- Provides detailed completion summary

**Multi-Model Intelligence:**
- Works with any AI model provider (OpenAI, Anthropic, etc.)
- Automatically selects optimal model for task complexity
- Maintains context across long-running tasks
- Learns from your codebase patterns

### 🚀 Dual-Mode Architecture

**Interactive Mode:**
- Visual feedback in IDE or terminal
- Conversational task delegation
- Real-time progress updates
- Approval gates for changes
- Iterative refinement

**Headless Exec Mode:**
- Non-interactive automation
- Single-command execution
- Exit codes for pipeline integration
- Loggable output format
- Scriptable and reproducible

### 📂 Workflow Integration

**IDE Integration:**
- VS Code extension
- JetBrains plugins
- Vim/Neovim support
- No workflow changes required
- Works alongside existing tools

**CI/CD Integration:**
- Automated code review
- Self-healing builds
- Test generation and execution
- Security scanning
- Dependency updates

**Team Collaboration:**
- Slack/Teams integration
- Shared incident triage
- Collaborative bug fixes
- Issue tracking sync (Linear, Jira)
- Mobile access for on-the-go

### 🎯 State-of-the-Art Performance

**Terminal-Bench Results:**
- 58.75% success rate (state-of-the-art)
- Leading performance across all models
- Handles complex multi-file tasks
- Reliable autonomous execution

**Task Capabilities:**
- Complete refactoring projects
- Incident response and debugging
- Large-scale migrations
- Code generation and scaffolding
- Test writing and maintenance
- Documentation updates

## 🛠️ Common Workflows

### Large-Scale Refactoring

```bash
# Interactive mode for complex refactoring
droid

You: Refactor the entire data layer to use the repository pattern

Droid: [analyzes 45 files in data layer]
# Shows migration plan with phases

You: proceed

Droid: [executes refactoring in stages]
# Phase 1: Create repository interfaces
# Phase 2: Implement repositories
# Phase 3: Update service layer
# Phase 4: Remove old data access code
# Phase 5: Update tests

Droid: Refactoring complete. All tests passing.
```

### CI/CD Code Review

```bash
#!/bin/bash
# .github/workflows/droid-review.sh

# Automated code review on PR
droid exec "Review PR for security vulnerabilities, performance issues, and code quality" > review-report.txt

if [ $? -eq 0 ]; then
    # Post review to PR comments
    gh pr comment $PR_NUMBER --body-file review-report.txt
else
    echo "Review failed"
    exit 1
fi
```

### Incident Response

```bash
# Via Slack integration
/droid investigate production error in payment service

# Droid analyzes logs, identifies issue, proposes fix
# Team reviews and approves
# Droid deploys fix automatically

# Or via CLI
droid "investigate and fix the memory leak in auth service"
```

### Database Migration

```bash
droid

You: Migrate from MongoDB to PostgreSQL

Droid: This is a major migration. I'll proceed in phases:
       1. Create PostgreSQL schema
       2. Write data migration scripts
       3. Implement dual-write layer
       4. Migrate historical data
       5. Switch reads to PostgreSQL
       6. Remove MongoDB code

You: proceed with phase 1

Droid: [creates schema matching current data model]
# Shows schema files for review
```

### Batch Test Generation

```bash
# Headless mode for batch operations
droid exec "Generate comprehensive unit tests for all functions in src/ that lack coverage"

# Processes entire directory
# Creates test files matching coverage gaps
# Ensures tests follow project patterns
```

### Pre-Commit Hook

```bash
#!/bin/bash
# .git/hooks/pre-commit

# Automated code quality check
droid exec "Review staged changes for code quality issues" > /tmp/droid-review.txt

if grep -q "CRITICAL" /tmp/droid-review.txt; then
    cat /tmp/droid-review.txt
    echo "Fix critical issues before committing"
    exit 1
fi
```

### Scheduled Maintenance

```bash
# Cron job for dependency updates
0 2 * * 1 cd /app && droid exec "Update all dependencies to latest compatible versions and run tests"

# Weekly security audit
0 3 * * 0 cd /app && droid exec "Scan codebase for security vulnerabilities and create issues"
```

### Multi-Repository Migration

```bash
# Script for organization-wide changes
for repo in $(cat repos.txt); do
    cd $repo
    droid exec "Migrate from CommonJS to ES modules"
    git commit -am "Migrate to ES modules (automated by Droid)"
    git push
done
```

## 🔧 Troubleshooting

### Authentication Issues

```bash
# Re-authenticate
droid
# Follow authentication flow

# Verify Factory.ai account is active
# Check https://factory.ai
```

### Command Not Found

```bash
# Verify droid is available
which droid

# Ensure environment is activated
flox activate

# Check installation
flox list
```

### Droid Won't Start

```bash
# Check for error messages
droid --help

# Verify you're in a project directory (recommended)
pwd
git status

# Try with explicit project path
cd ~/projects/my-app
droid
```

### Exec Mode Not Working

**Non-interactive execution issues:**
```bash
# Ensure proper syntax
droid exec "your task description"

# Check exit codes
echo $?

# Capture output for debugging
droid exec "task" 2>&1 | tee droid-output.log
```

### Tasks Not Completing

**Common causes:**
- Task too ambiguous (be more specific)
- Missing project context (ensure in git repo)
- Files outside project scope
- Permission issues

**Solutions:**
```bash
# Be more specific with requests
droid exec "refactor AuthService.authenticate() to use async/await"

# Ensure git repo is initialized
git status

# Check file permissions
ls -la
```

### Integration Issues

**IDE integration:**
- Verify VS Code extension installed
- Check JetBrains plugin is enabled
- Restart IDE after installation

**Slack/Teams integration:**
- Verify Factory app is installed
- Check bot permissions
- Review channel access

**CI/CD integration:**
```bash
# Verify authentication in CI environment
# Set FACTORY_API_KEY in CI secrets

# Test locally first
droid exec "simple task"
```

### Performance Issues

**Slow task execution:**
- Normal for large codebases (initial context loading)
- Complex tasks require more planning time
- Network latency to Factory API

**Optimization:**
- Break large tasks into smaller steps
- Work in focused directories
- Use headless exec for simple tasks

## 💻 System Compatibility

This environment works on:
- Linux x86_64
- macOS ARM64 (Apple Silicon)

## 🔒 Security Considerations

- **Authentication**: Secure Factory.ai account authentication
- **File system access**: Full read/write access to project directory
- **Network access**: Communicates with Factory API for AI processing
- **Code privacy**: Subject to Factory.ai privacy policy and terms
- **Approval gates**: Review changes before they're applied (interactive mode)
- **API secrets**: Store FACTORY_API_KEY securely in CI environments

**Best Practices:**
- Review all changes before approving in interactive mode
- Use version control for easy rollback
- Test in non-production environments first
- Secure API keys in CI/CD secrets
- Keep Factory account credentials private
- Monitor Droid activity in team environments

## 📚 Additional Resources

- **Factory Website**: [factory.ai](https://factory.ai)
- **CLI Documentation**: [docs.factory.ai/cli](https://docs.factory.ai/cli/getting-started/quickstart)
- **GitHub Repository**: [github.com/Factory-AI/factory](https://github.com/Factory-AI/factory)
- **Product Overview**: [factory.ai/product/cli](https://factory.ai/product/cli)
- **Flox Documentation**: [flox.dev/docs](https://flox.dev/docs)

## 🙏 Acknowledgments

- **Factory Team**: Thanks to the team at [Factory.ai](https://factory.ai) for creating Droid.

- **nix-ai-tools**: Special thanks to [numtide](https://github.com/numtide) and contributors for maintaining [nix-ai-tools](https://github.com/numtide/nix-ai-tools), which packages and distributes AI development tools for the Nix ecosystem, making it easy to use tools like Droid in reproducible environments

## 🔗 About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Software, variables, services defined in human-readable TOML
- **Content-addressed storage** - Multiple package versions coexist without conflicts
- **Reproducibility** - Same environment across dev, CI, and production
- **Deterministic builds** - Same inputs always produce identical outputs
- **Huge package collection** - Access to 150,000+ packages from [Nixpkgs](https://github.com/NixOS/nixpkgs)

## 📝 License

This Flox environment configuration is provided as-is. Droid and the Factory platform have their own terms of service - see the [Factory.ai website](https://factory.ai) for details.

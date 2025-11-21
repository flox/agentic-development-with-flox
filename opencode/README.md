# 🚀 Flox Environment for OpenCode

A Flox environment for [OpenCode](https://github.com/sst/opencode), an AI coding agent built for the terminal. OpenCode provides a powerful TUI interface with multi-provider support, custom agents, and seamless integration with your development workflow.

## ✨ Features

- **Terminal-native TUI**: Beautiful terminal user interface for AI-assisted coding
- **Multi-provider support**: OpenAI, Anthropic Claude, Google Gemini, AWS Bedrock, Groq, Azure OpenAI, OpenRouter
- **Dual agents**: Switch between **build** (full access) and **plan** (read-only) agents with Tab
- **Custom commands**: Define reusable commands via markdown files
- **Session management**: Save and resume conversations
- **Project-aware**: Automatic context from AGENTS.md and custom rules
- **IDE integration**: Works with VS Code and other editors
- **GitHub integration**: Trigger OpenCode from GitHub Actions via comments
- **LSP support**: Code intelligence and navigation
- **Vim-like editor**: Built by neovim users
- **SQLite persistence**: Store conversations and context
- **Client/server architecture**: Run locally or remotely

## 🧰 Included Tools

The environment includes:

- `opencode` - OpenCode CLI with TUI interface

## 🏁 Getting Started

### 📋 Prerequisites

- [Flox](https://flox.dev/get) installed on your system
- API key for your chosen provider (OpenAI, Anthropic, etc.)

### 💻 Installation & Activation

Get started with:

```sh
# Clone the repo
git clone https://github.com/yourusername/agentic-development-with-flox && cd agentic-development-with-flox/opencode

# Activate the environment
flox activate
```

### 🔐 First-Time Setup

**Authentication:**

OpenCode stores configuration in `~/.config/opencode/` in your home directory (following security best practices).

**Method 1: OpenCode Auth (Recommended)**

```bash
# Start authentication flow
opencode auth login

# Select your provider (opencode, anthropic, openai, etc.)
# Follow the prompts to add your API key
# Credentials stored in ~/.config/opencode/
```

**Method 2: Environment Variables**

```bash
# Set API key via environment variable
export ANTHROPIC_API_KEY="your-key-here"
# or
export OPENAI_API_KEY="your-key-here"

# OpenCode will detect and use the environment variable
opencode
```

**Method 3: Manual Configuration**

```bash
# Create global configuration file
mkdir -p ~/.config/opencode
cat > ~/.config/opencode/opencode.json <<EOF
{
  "model": "anthropic/claude-sonnet-4.5",
  "rules": [
    "~/.config/opencode/rules/general.md"
  ]
}
EOF

# Add API key via auth command
opencode auth login
```

**Supported providers:**
- OpenCode (hosted, easiest setup)
- Anthropic (Claude Sonnet 4.5, Opus 4.1, Haiku 4.5)
- OpenAI (GPT-5.1, GPT-5, GPT-4o, etc.)
- Google Gemini (Gemini 3 Pro, Gemini 2.0)
- AWS Bedrock
- Azure OpenAI
- Groq (fast inference)
- OpenRouter (access to many models)

## 📝 Usage

### Interactive TUI Session

Start the terminal user interface:

```bash
# Navigate to your project
cd ~/projects/my-app

# Start OpenCode TUI
opencode

# Interface:
# - Chat with AI in the bottom panel
# - View file changes in the main panel
# - Switch agents with Tab key (build ↔ plan)
# - Accept/reject changes with keybindings

# Example interaction:
You: Create a REST API for user management with CRUD operations

OpenCode: [analyzes requirements, creates files, shows diffs]
# Press Enter to accept changes
# Press Esc to reject changes

You: Add input validation with proper error handling

OpenCode: [updates code with validation]
```

### Built-in Agents

OpenCode has two agents you can switch between (press Tab):

**build agent** (default):
- Full access to read and write files
- Can execute commands
- Best for development work

**plan agent** (read-only):
- Can only read files and analyze code
- Cannot make changes
- Best for code exploration, reviews, and planning

### Session Commands

Available during TUI sessions:

```bash
/undo       # Undo last change OpenCode made
/redo       # Redo change after undo
/clear      # Clear conversation history
/exit       # Exit OpenCode
```

**Keyboard shortcuts:**
- `Tab` - Switch between build and plan agents
- `Ctrl+C` - Cancel current operation
- `Enter` - Accept changes
- `Esc` - Reject changes

### Creating Custom Agents

Create specialized agents for specific tasks:

```bash
# Create a new agent
opencode agent create

# Follow the prompts:
# 1. Agent name
# 2. System prompt/behavior
# 3. Tool access configuration
# 4. Model selection

# Agent saved to ~/.config/opencode/agents/
```

## 🔧 Configuration

### Configuration Files

OpenCode uses a hierarchical configuration system:

**⚠️ IMPORTANT - Flox Security Convention:**
Config files containing API keys or secrets MUST be in `$HOME` (`~/.config/opencode/`), never in project directories.

**Global config** (for credentials and defaults):
```bash
~/.config/opencode/
├── opencode.json          # Global settings (secrets go here)
├── agents/                # Custom agents
└── command/               # Global commands
```

**Project config** (for project-specific settings WITHOUT secrets):
```bash
your-project/
├── opencode.json          # Project settings (NO secrets!)
├── .opencode/
│   └── command/           # Project-specific commands
├── AGENTS.md              # Project instructions for AI
└── .opencoderules         # Additional rules
```

**Configuration merging:**
- Settings are deep-merged from all config locations
- Project configs override global configs for the same keys
- Use environment variables for secrets in project configs

### opencode.json Configuration

**Global config** (`~/.config/opencode/opencode.json`):
```json
{
  "model": "anthropic/claude-sonnet-4.5",
  "rules": [
    "~/.config/opencode/rules/security.md",
    "~/.config/opencode/rules/style.md"
  ],
  "disabled_providers": ["bedrock"],
  "commands": {
    "test": {
      "description": "Run tests",
      "command": "npm test"
    }
  }
}
```

**Project config** (`opencode.json` in project root):
```json
{
  "model": "anthropic/claude-sonnet-4.5",
  "rules": [
    ".opencode/rules/flox.md",
    "AGENTS.md"
  ],
  "modes": {
    "review": {
      "agent": "plan",
      "prompt": "Focus on code review and security"
    }
  }
}
```

**Available options:**
- `model` - Default model (provider_id/model_id)
- `rules` - Array of instruction file paths
- `commands` - Custom command definitions
- `modes` - Custom mode configurations
- `disabled_providers` - Providers to disable
- `agent` - Default agent (build or plan)

### Custom Commands

Create reusable commands via markdown files:

**Global command** (`~/.config/opencode/command/review.md`):
```markdown
---
description: Perform security review
---

Review this codebase for:
- Security vulnerabilities
- Input validation issues
- Authentication flaws
- SQL injection risks

Provide a detailed report with recommendations.
```

**Project command** (`.opencode/command/flox-setup.md`):
```markdown
---
description: Set up Flox environment
---

1. Check if .flox/ directory exists
2. If not, run: flox init
3. Add required packages to manifest.toml
4. Document the setup in README.md
```

**Usage:**
```bash
# In OpenCode TUI
You: /review
# or
You: /flox-setup
```

### Rules and Instructions

**AGENTS.md** (project root):
```markdown
# Project Instructions

This is a Python web application using Flask and PostgreSQL.

## Development Guidelines
- Use Flox for package management
- Follow PEP 8 style guide
- Write tests for all new features
- Keep secrets in ~/.config/opencode/, never commit them

## Key Commands
- `flox activate` - Activate environment
- `flox install <package>` - Add dependencies
- `npm test` - Run test suite
```

## 🛠️ Common Workflows

### Building Features

```bash
cd ~/projects/my-app
opencode

You: Create a user authentication system with JWT

OpenCode: [builds agent active]
# Shows plan
# Creates files: auth.py, middleware.py, tests/
# Displays diffs

You: [Press Enter to accept changes]

You: Add rate limiting to prevent abuse

OpenCode: [implements rate limiting]
You: [Press Enter to accept]
```

### Code Review and Analysis

```bash
opencode

# Switch to plan agent (read-only)
[Press Tab]

You: Review the payment processing module for security issues

OpenCode: [plan agent - analyzes without changing]
# Identifies issues
# Suggests improvements
# No files modified

You: Generate a security audit report

OpenCode: [creates report without modifying code]
```

### Debugging Session

```bash
opencode

You: The login endpoint returns 500 errors

OpenCode: [analyzes logs and code]
# Identifies root cause
# Shows problematic code

You: Fix the issue

OpenCode: [build agent - applies fix]
# Shows diff
You: [Press Enter to accept]

You: /undo
# Reverts the change

You: Try a different approach focusing on input validation

OpenCode: [implements alternative fix]
```

### Custom Agent Workflow

```bash
# Create a specialized agent
opencode agent create

Agent name: flox-packager
System prompt: You are an expert at packaging software with Flox...
Tool access: Files (read/write), Shell commands
Model: anthropic/claude-sonnet-4.5

# Use the custom agent
opencode --agent flox-packager

You: Package this Python application for distribution
```

### GitHub Integration

In your repository, use OpenCode in GitHub Actions:

```yaml
# .github/workflows/opencode.yml
name: OpenCode Task
on:
  issue_comment:
    types: [created]

jobs:
  opencode:
    if: contains(github.event.comment.body, '/opencode')
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run OpenCode
        run: |
          # OpenCode executes the task
          opencode --task "${{ github.event.comment.body }}"
```

**Usage:**
```
# In GitHub issue or PR comment
/opencode refactor the authentication module to use JWT
```

### IDE Integration

OpenCode works alongside your IDE:

```bash
# Terminal 1: Run OpenCode
opencode

# Terminal 2: Your IDE/editor
code .

# Terminal 1 (OpenCode):
You: Refactor the UserService class

OpenCode: [makes changes]
# Files update in real-time in your IDE
```

## 🎯 Flox-Aware Project Setup

This environment includes **Flox-aware templates** that make OpenCode automatically use Flox for environment management in your projects.

### Using the Templates

**Copy template files to your project:**

```bash
# Copy OpenCode project config
cp $FLOX_ENV_TEMPLATES/opencode.json ~/projects/my-app/

# Copy AGENTS.md with Flox instructions
cp $FLOX_ENV_TEMPLATES/AGENTS.md ~/projects/my-app/

# Copy Flox-specific command
mkdir -p ~/projects/my-app/.opencode/command
cp $FLOX_ENV_TEMPLATES/.opencode/command/flox-context.md ~/projects/my-app/.opencode/command/

# Copy fetch script
cp $FLOX_ENV_TEMPLATES/fetch-flox.sh ~/projects/my-app/
chmod +x ~/projects/my-app/fetch-flox.sh
```

**What the templates provide:**

The templates instruct OpenCode to:

1. **Detect Flox projects** by checking for `.flox/` directory
2. **Fetch context-specific documentation** before working on tasks:
   - Packaging: `./fetch-flox.sh packaging`
   - Kubernetes: `./fetch-flox.sh k8s`
   - Containers: `./fetch-flox.sh containers`
   - CUDA/GPU: `./fetch-flox.sh cuda`
   - CI/CD: `./fetch-flox.sh cicd`
   - Local dev: `./fetch-flox.sh local-dev`
   - Operations: `./fetch-flox.sh ops`
3. **Apply Flox best practices** from the fetched documentation
4. **Use Flox commands** instead of system package managers
5. **Custom /flox-context command** to fetch relevant docs on demand

**Example workflow:**

```bash
cd ~/projects/my-app

# Copy templates
cp $FLOX_ENV_TEMPLATES/* ./
cp -r $FLOX_ENV_TEMPLATES/.opencode .opencode/

# Start OpenCode
opencode

You: I need to set up GPU acceleration with CUDA

OpenCode: [Detects Flox project from .flox/ directory]
OpenCode: [Reads AGENTS.md for Flox patterns]
OpenCode: Let me fetch the CUDA-specific Flox documentation...
OpenCode: [Runs: ./fetch-flox.sh cuda]
OpenCode: [Applies Flox CUDA patterns]

You: /flox-context packaging

OpenCode: [Fetches packaging docs, applies patterns]
```

## 🔧 Troubleshooting

### Authentication Issues

**Problem:** Can't authenticate or API key not working

**Solution:**

```bash
# Re-run authentication
opencode auth login

# Or use environment variables
export ANTHROPIC_API_KEY="your-key-here"
opencode

# Check config
cat ~/.config/opencode/opencode.json
```

### Command Not Found

```bash
# Verify opencode is available
which opencode

# Ensure environment is activated
flox activate

# Check installation
flox list
```

### TUI Not Starting

**Problem:** OpenCode exits immediately or shows errors

**Solution:**

```bash
# Check for error messages
opencode 2>&1 | tee opencode-error.log

# Verify terminal compatibility
echo $TERM

# Try with verbose output
opencode --debug
```

### Changes Not Being Applied

**Problem:** OpenCode suggests changes but they don't appear in files

**Solution:**

```bash
# Make sure you're using build agent, not plan
# Press Tab to switch agents

# Check file permissions
ls -la

# Verify OpenCode has write access to directory
```

### Provider Not Available

**Problem:** Selected model/provider not working

**Solution:**

```bash
# List available providers
opencode auth login
# View provider list

# Check disabled providers in config
cat ~/.config/opencode/opencode.json | grep disabled_providers

# Try different provider
opencode --model openai/gpt-4o
```

### Custom Commands Not Working

**Problem:** `/command` not found

**Solution:**

```bash
# Check command file location
ls -la ~/.config/opencode/command/
ls -la .opencode/command/

# Verify markdown frontmatter
cat .opencode/command/mycommand.md
# Must have:
# ---
# description: Command description
# ---

# Restart OpenCode to reload commands
```

## 💻 System Compatibility

This environment works on:
- Linux x86_64
- macOS ARM64 (Apple Silicon)
- macOS x86_64 (Intel)

## 🔒 Security Considerations

- **API credentials**: Stored in `~/.config/opencode/` or via environment variables
- **Configuration location**: `~/.config/opencode/` in your home directory (**NEVER in project root**)
- **Code access**: OpenCode can read and modify files (build agent) or read-only (plan agent)
- **Command execution**: Build agent can execute shell commands
- **Network access**: Communicates with configured AI providers
- **Session data**: Stored in SQLite database in `~/.config/opencode/`
- **Client/server mode**: Can run remotely with proper authentication

**Best Practices:**
- **Recommended**: Use environment variables for API keys
- **CRITICAL**: Config files with secrets MUST be in `$HOME` (e.g., `~/.config/opencode/`), never in project directories
- Never commit API keys to version control
- Per Flox conventions, all secrets live in `$HOME`, not in repos or `$FLOX_ENV_CACHE`
- Use plan agent for untrusted code review
- Review changes before accepting (especially with build agent)
- Use version control (git) for easy rollback
- Keep OpenCode updated
- Audit custom agents before use
- Use `.gitignore` to exclude `opencode.json` if it contains any sensitive data

## 📚 Additional Resources

- **OpenCode Website**: [opencode.ai](https://opencode.ai)
- **GitHub Repository**: [github.com/sst/opencode](https://github.com/sst/opencode)
- **Documentation**: [opencode.ai/docs](https://opencode.ai/docs)
- **CLI Reference**: [opencode.ai/docs/cli](https://opencode.ai/docs/cli)
- **Configuration Guide**: [opencode.ai/docs/config](https://opencode.ai/docs/config)
- **Models**: [opencode.ai/docs/models](https://opencode.ai/docs/models)
- **Commands**: [opencode.ai/docs/commands](https://opencode.ai/docs/commands)
- **Flox Documentation**: [flox.dev/docs](https://flox.dev/docs)

## 🙏 Acknowledgments

- **SST Team**: Thanks to the SST team for creating OpenCode and making it open source
- **Terminal.shop**: Built by the creators of terminal.shop

## 🔗 About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Software, variables, services defined in human-readable TOML
- **Content-addressed storage** - Multiple package versions coexist without conflicts
- **Reproducibility** - Same environment across dev, CI, and production
- **Deterministic builds** - Same inputs always produce identical outputs
- **Huge package collection** - Access to 150,000+ packages from [Nixpkgs](https://github.com/NixOS/nixpkgs)

## 📝 License

This Flox environment configuration is provided as-is. OpenCode is open source from SST - see the [OpenCode repository](https://github.com/sst/opencode) for license details.

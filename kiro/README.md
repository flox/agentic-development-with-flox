# Flox Environment for Kiro

A Flox environment for [Kiro](https://kiro.dev/), an agentic AI development platform. Kiro transforms natural language prompts into structured specifications, architectural designs, and implementation tasks before code generation. Available as both an IDE (VS Code-based) and CLI interface.

## Features

- **Spec-driven development** - Natural language → EARS notation requirements → architecture → code
- **Autonomous agents** - Agents execute bug fixes and feature implementations
- **Agent hooks** - Background automation (auto-generate tests, documentation)
- **CLI and IDE** - Terminal-based CLI and full IDE interface
- **MCP integration** - Model Context Protocol for external tool connections
- **Steering files** - Project-level or global configuration for coding standards
- **Multi-language** - Python, Java, JavaScript, TypeScript, C#, Go, Rust, PHP, Ruby, Kotlin, C, C++, shell, SQL, Scala

## Included Tools

The environment includes:

- `kiro-cli` - Kiro command-line interface
- `kiro` - Kiro IDE (when launched graphically)

**Note:** On x86_64-linux, `kiro-fhs` (FHS-compatible wrapper) is used for better VS Code extension support.

## Getting Started

### Prerequisites

- [Flox](https://flox.dev/get) installed
- Internet connection for authentication and API access
- Account credentials (GitHub, Google, AWS Builder ID, or IAM Identity Center)

### Installation & Activation

```bash
# Clone the repo
git clone https://github.com/barstoolbluz/agentic-development-with-flox
cd agentic-development-with-flox/kiro

# Activate the environment
flox activate
```

### First-Time Setup

**Authentication (Required):**

```bash
# Start authentication flow
kiro-cli login

# Browser opens for authentication
# Sign in with GitHub, Google, or AWS credentials
# Return to terminal when complete

# Verify authentication
kiro-cli whoami
```

**Authentication methods:**
- **GitHub** - OAuth authentication
- **Google** - OAuth authentication
- **AWS Builder ID** - Free AWS account (no AWS account required)
- **IAM Identity Center** - For team/enterprise use

## Usage

### CLI Commands

**Interactive chat:**
```bash
# Start chat session with Claude
kiro-cli chat

# Ask questions, generate code, debug issues
You: Write a REST API for user authentication
Kiro: [generates spec → architecture → implementation]
```

**Natural language translation:**
```bash
# Convert English to shell commands
kiro-cli translate "find all large files over 100MB"

# Kiro suggests:
# find . -type f -size +100M
```

**Agent workflows:**
```bash
# List available agents
kiro-cli agent list

# Create custom agent
kiro-cli agent create

# Use specific agent
kiro-cli agent --name <agent-name>
```

**Settings management:**
```bash
# View all settings
kiro-cli settings list

# View all available settings
kiro-cli settings list --all

# Set a configuration value
kiro-cli settings chat.defaultModel "claude-3-5-sonnet"

# Open settings in editor
kiro-cli settings open

# Export settings as JSON
kiro-cli settings list --format json
```

**MCP server management:**
```bash
# List MCP servers
kiro-cli mcp list

# Add MCP server
kiro-cli mcp add

# Check server status
kiro-cli mcp status
```

**Maintenance:**
```bash
# Check installation health
kiro-cli doctor

# Update to latest version
kiro-cli update

# View version
kiro-cli version
```

### IDE Usage

Launch the Kiro IDE:
```bash
# Launch IDE (opens graphical interface)
kiro
```

The IDE provides:
- Visual spec editor
- Integrated agent chat
- Code editor with AI assistance
- Project navigation
- VS Code extension support

## Configuration

### Configuration Files

Kiro stores configuration in `$HOME` (following Flox security conventions):

**Configuration location:**
```
~/.config/kiro/              # Linux
~/.kiro/                     # macOS

├── settings.json            # Main configuration
└── ...
```

**Project-level configuration:**
```
your-project/
├── .kiro/
│   ├── settings/
│   │   └── mcp.json         # Project MCP servers
│   └── steering/            # Project steering files
│       └── coding-standards.md
└── ...
```

### Steering Files

Steering files define coding standards and preferences:

**Global steering** (`~/.kiro/steering/`):
```markdown
# My Coding Standards

## Code Style
- Use TypeScript for all new JavaScript code
- Prefer functional programming patterns
- Always include error handling

## Testing
- Write tests before implementation (TDD)
- Minimum 80% code coverage
```

**Project steering** (`.kiro/steering/`):
```markdown
# Project-Specific Rules

## Architecture
- Use hexagonal architecture
- Separate business logic from framework

## Documentation
- JSDoc for all public functions
- README for each module
```

### MCP Integration

Configure Model Context Protocol servers:

**Project MCP** (`.kiro/settings/mcp.json`):
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/project/path"]
    },
    "database": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgresql"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    }
  }
}
```

**Global MCP** (`~/.config/kiro/mcp.json`):
```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

## Common Workflows

### Building a Feature

```bash
kiro-cli chat

You: Build a user authentication system with JWT tokens

Kiro: [Generates specification]
Kiro: [Proposes architecture]
Kiro: [Creates implementation tasks]
Kiro: [Executes tasks autonomously]

# Review and iterate
You: Add rate limiting to prevent brute force attacks
Kiro: [Updates spec and implementation]
```

### Code Review and Debugging

```bash
kiro-cli chat

You: Review this code for security issues
[paste code]

Kiro: [Analyzes code]
Kiro: [Identifies issues]
Kiro: [Proposes fixes]
```

### Natural Language Automation

```bash
# Generate shell commands
kiro-cli translate "compress all log files older than 30 days"

# Kiro generates and optionally executes:
# find /var/log -name "*.log" -mtime +30 -exec gzip {} \;
```

## Troubleshooting

### Authentication Issues

**Problem:** Can't authenticate or session expired

**Solution:**
```bash
# Re-authenticate
kiro-cli logout
kiro-cli login

# Check authentication status
kiro-cli whoami

# Run diagnostics
kiro-cli doctor
```

### Command Not Found

**Problem:** `kiro-cli` command not found

**Solution:**
```bash
# Ensure environment is activated
flox activate

# Verify installation
which kiro-cli

# Check Flox package list
flox list
```

### Settings Not Persisting

**Problem:** Configuration changes not saved

**Solution:**
```bash
# Use CLI commands instead of manual file editing
kiro-cli settings chat.defaultModel "claude-3-5-sonnet"

# Verify setting was saved
kiro-cli settings chat.defaultModel

# Check settings file permissions
ls -la ~/.config/kiro/settings.json
```

### MCP Server Connection Issues

**Problem:** MCP servers not connecting

**Solution:**
```bash
# Check MCP server status
kiro-cli mcp status

# Test server configuration
kiro-cli mcp list

# Verify environment variables are set
echo $GITHUB_TOKEN

# Check logs
kiro-cli diagnostic
```

## System Compatibility

This environment works on:
- Linux x86_64 (uses `kiro-fhs` for better extension support)
- macOS x86_64 (Intel)
- macOS ARM64 (Apple Silicon)

**Note:** ARM64 Linux (`aarch64-linux`) is not currently supported by Kiro packages in nixpkgs.

## Security Considerations

- **Credentials**: Stored in `$HOME` (`~/.config/kiro/` or `~/.kiro/`)
- **Configuration location**: Always in `$HOME`, never in project directories
- **Authentication**: Required before any Kiro operations
- **Credit-based**: Kiro uses a credit-based consumption model
- **Code access**: Kiro can read and modify files in your projects
- **Command execution**: Can execute shell commands (review before accepting)
- **Network access**: Communicates with Kiro services and Claude AI

**Best Practices:**
- Never commit `.kiro/` directories with secrets to version control
- Use environment variables for secrets in project MCP configurations
- Review generated code before committing
- Use version control (git) for easy rollback
- Keep Kiro updated: `kiro-cli update`

## Additional Resources

- **Official Website**: [kiro.dev](https://kiro.dev/)
- **CLI Documentation**: [kiro.dev/docs/cli](https://kiro.dev/docs/cli)
- **CLI Commands Reference**: [kiro.dev/docs/cli/reference/cli-commands](https://kiro.dev/docs/cli/reference/cli-commands/)
- **Settings Reference**: [kiro.dev/docs/cli/reference/settings](https://kiro.dev/docs/cli/reference/settings/)
- **Authentication Guide**: [kiro.dev/docs/cli/authentication](https://kiro.dev/docs/cli/authentication/)
- **MCP Integration**: [kiro.dev/docs/mcp/configuration](https://kiro.dev/docs/mcp/configuration/)

## About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Software, variables, services defined in TOML
- **Content-addressed storage** - Multiple package versions coexist without conflicts
- **Reproducibility** - Same environment across dev, CI, and production
- **Deterministic builds** - Same inputs always produce identical outputs
- **Huge package collection** - Access to 150,000+ packages from Nixpkgs

## License

Kiro is a proprietary service from Kiro.dev. See [kiro.dev](https://kiro.dev/) for terms of service and pricing.

This Flox environment configuration is provided as-is.

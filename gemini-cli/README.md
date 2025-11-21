# 🤖 Flox Environment for Gemini CLI

A Flox environment for [Gemini CLI](https://github.com/google-gemini/gemini-cli), an open-source AI agent that brings the power of Google's Gemini models directly into your terminal. This environment includes both the CLI tool and the VS Code extension for a complete development experience.

## ✨ Features

- **Dual-mode operation**: Interactive sessions or non-interactive automation
- **Built-in tools**: File system operations, shell command execution, web fetching, Google Search
- **MCP support**: Extend functionality with Model Context Protocol servers
- **Project context**: Optional `GEMINI.md` files to tailor AI behavior per project
- **Multiple auth options**: OAuth (free tier), API key, or Vertex AI
- **VS Code integration**: IDE companion extension included
- **Output formats**: Text, JSON, or streaming JSON for scripting
- **Model selection**: Choose from Gemini 2.5 Flash, Pro, or other models
- **Free and open source**: Apache-2.0 license
- **Cross-platform**: Linux and macOS support

## 🧰 Included Tools

The environment includes:

- `gemini` - Gemini CLI tool
- VS Code Gemini CLI IDE Companion extension

## 🏁 Getting Started

### 📋 Prerequisites

- [Flox](https://flox.dev/get) installed on your system
- Node.js 20+ (included in environment)
- Google account for OAuth OR Gemini API key OR Vertex AI access

### 💻 Installation & Activation

Get started with:

```sh
# Clone the repo
git clone https://github.com/yourusername/floxenvs && cd floxenvs/gemini-cli

# Activate the environment
flox activate
```

### 🔐 First-Time Setup

Authenticate with Gemini on first use:

```bash
# Start interactive session
gemini

# On first run, you'll be prompted to choose authentication method:
# 1. Login with Google (OAuth) - Free tier: 60 req/min, 1,000 req/day
# 2. Gemini API Key - Get from https://aistudio.google.com
# 3. Vertex AI - For enterprise teams

# Or authenticate ahead of time
gemini auth
```

### 🔌 VS Code Integration

The VS Code extension is already installed in this environment:

1. Open VS Code within the Flox environment
2. The Gemini CLI IDE Companion extension will be available
3. Use Gemini features directly in your editor

## 📝 Usage

### Interactive Mode

Launch an interactive chat session:

```bash
# Start interactive session in current directory
gemini

# Example interaction:
You: Explain how the authentication module works

Gemini: [analyzes your code and explains the auth flow]

You: Refactor it to use JWT tokens

Gemini: [proposes refactoring with code changes]
```

### Non-Interactive Mode

Execute single prompts for automation:

```bash
# Single prompt
gemini -p "Generate unit tests for all functions in src/auth.js"

# JSON output for scripting
gemini --output-format json -p "List all TODO comments in the codebase"

# Streaming JSON for real-time processing
gemini --output-format stream-json -p "Analyze code quality"

# Specify model
gemini -m gemini-2.5-flash -p "Quick code review"

# Include additional directories for context
gemini --include-directories ../lib,../docs -p "Document the API"
```

### Command-Line Options

```bash
gemini                           # Interactive mode
gemini -p "prompt"               # Non-interactive mode
gemini --output-format json      # JSON output
gemini --output-format stream-json  # Streaming JSON
gemini -m gemini-2.5-flash       # Specify model
gemini --include-directories DIR # Include additional context
gemini auth                      # Authenticate or re-authenticate
gemini --help                    # Show all options
```

## 🎯 Optional Enhancements

### Project Context (GEMINI.md)

Create a `GEMINI.md` file in your project to provide persistent context:

```bash
# Create in your project directory
cd ~/projects/my-app
nano GEMINI.md
```

**Example GEMINI.md structure:**

```markdown
# Project: My TypeScript Library

## General Instructions
- Follow the existing coding style and patterns
- Write comprehensive JSDoc comments for all public APIs
- Prefer functional programming patterns over imperative
- Follow project conventions for error handling

## Coding Style
- Use 2 spaces for indentation
- Prefix interface names with `I`
- Always use strict equality (`===`)
- Use async/await instead of promises chains
- Organize imports: external first, then internal

## Architecture
- Modular design with clear separation of concerns
- Domain-driven design principles
- Repository pattern for data access

## Dependencies
- TypeScript 5.x
- Jest for testing
- ESLint + Prettier for code quality

## Notes
- Performance is critical for data processing modules
- All user inputs must be validated
- Security-sensitive code requires extra scrutiny
```

Now when you run `gemini` in that directory, it will use this context automatically.

### Flox-Aware Project Template

This environment includes a **Flox-aware GEMINI.md template** that makes Gemini automatically use Flox for environment management.

**Copy the template to your project:**

```bash
# Copy Flox-aware template
cp $FLOX_ENV_TEMPLATES/GEMINI.md ~/projects/my-app/

# Copy fetch script
cp $FLOX_ENV_TEMPLATES/fetch-flox.sh ~/projects/my-app/
chmod +x ~/projects/my-app/fetch-flox.sh
```

The template instructs Gemini to:
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

**Example workflow with Flox-aware template:**

```bash
cd ~/projects/my-app
gemini

You: I need to package this Python application for distribution

Gemini: [Detects packaging task]
Gemini: [Runs: ./fetch-flox.sh packaging]
Gemini: [Reads FLOX.md for packaging guidance]
Gemini: [Applies Flox packaging patterns]
Gemini: Let me help you package this using Flox...
```

**Customize the template** by adding your project-specific instructions after the Flox section in `GEMINI.md`.

### MCP Server Configuration

Extend Gemini CLI with custom tools via Model Context Protocol:

```bash
# Edit MCP configuration
nano ~/.gemini/settings.json
```

**Example MCP configuration:**

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "$GITHUB_TOKEN"
      }
    },
    "database": {
      "command": "python",
      "args": ["-m", "my_mcp_server"],
      "cwd": "./mcp-servers",
      "env": {
        "DATABASE_URL": "$DATABASE_URL"
      },
      "timeout": 15000
    },
    "web-api": {
      "httpUrl": "http://localhost:3000/mcp",
      "timeout": 5000
    }
  }
}
```

**MCP Server Properties:**

- `command`: Path to executable (for stdio transport)
- `args`: Command-line arguments array
- `env`: Environment variables (use `$VAR_NAME` for env vars)
- `cwd`: Working directory
- `timeout`: Request timeout in milliseconds (default: 600,000)
- `trust`: Set `true` to bypass tool confirmation prompts
- `includeTools`: Allowlist specific tools
- `excludeTools`: Block specific tools

Once configured, use MCP tools in your prompts:

```bash
gemini -p "@github List my open pull requests"
gemini -p "@database Query user table for recent signups"
```

## 🛠️ Common Workflows

### Code Review Session

```bash
cd ~/projects/my-app
gemini

You: Review the authentication code for security issues

Gemini: [analyzes auth code, identifies potential vulnerabilities]

You: Show me how to fix the SQL injection vulnerability

Gemini: [provides code example with parameterized queries]

You: Generate unit tests for the fixed code

Gemini: [creates comprehensive test cases]
```

### Automated Documentation

```bash
# Generate API documentation
gemini -p "Generate comprehensive API documentation for all exported functions" > API.md

# Update README
gemini -p "Update README.md with current features and usage examples"

# Document code with comments
gemini -p "Add JSDoc comments to all functions in src/utils.js"
```

### Scripting with JSON Output

```bash
#!/bin/bash
# analyze-codebase.sh

# Get code quality report
quality=$(gemini --output-format json -p "Analyze code quality and return a JSON report with scores")

# Parse and act on results
echo "$quality" | jq '.qualityScore'

# Generate issue tickets
gemini --output-format json -p "Find all TODO and FIXME comments, return as JSON array" | \
  jq -r '.[] | "Issue: \(.description) in \(.file):\(.line)"'
```

### Multi-Directory Context

```bash
# Include multiple directories for comprehensive analysis
gemini --include-directories ../shared-lib,../docs -p "Document the entire API surface"

# Analyze dependencies across projects
gemini --include-directories ../frontend,../backend -p "Identify shared code that could be extracted to a library"
```

### Model Selection for Different Tasks

```bash
# Fast model for quick queries
gemini -m gemini-2.5-flash -p "What does this function do?"

# Powerful model for complex analysis
gemini -m gemini-2.5-pro -p "Perform comprehensive security audit of authentication system"
```

## 🔧 Troubleshooting

### Authentication Issues

```bash
# Re-authenticate
gemini auth

# Or start fresh session and select auth method
gemini

# For Vertex AI users, set project ID
export GOOGLE_CLOUD_PROJECT=your-project-id
gemini
```

### Command Not Found

```bash
# Verify gemini is available
which gemini

# Ensure environment is activated
flox activate

# Check installation
flox list
```

### GEMINI.md Not Being Used

**Issue:** Project context not applied

**Solution:**
```bash
# Ensure file is named correctly (case-sensitive)
ls -la GEMINI.md

# Verify you're in the correct directory
pwd

# Custom context filename in settings.json
nano ~/.gemini/settings.json
# Add: "context": { "fileName": "GEMINI.md" }
```

### MCP Server Not Working

**Issue:** Custom tools not available

**Solution:**
```bash
# Check settings.json syntax
cat ~/.gemini/settings.json | jq .

# Verify MCP server is executable
which npx  # For npx-based servers
python -m my_mcp_server --help  # For Python servers

# Check environment variables are set
echo $GITHUB_TOKEN

# Test with simpler MCP server first
# See: https://geminicli.com/docs/tools/mcp-server
```

### Rate Limiting

**OAuth (Free Tier):**
- 60 requests/minute
- 1,000 requests/day

**Solutions:**
- Upgrade to API key (100 free requests daily, then usage-based)
- Use Vertex AI for enterprise limits
- Space out automated requests

### VS Code Extension Not Working

**Issue:** Extension not loading

**Solution:**
```bash
# Ensure you opened VS Code from within the Flox environment
flox activate
code .

# Check extension is listed
code --list-extensions | grep gemini

# Restart VS Code
```

## 💻 System Compatibility

This environment works on:
- Linux x86_64
- macOS ARM64 (Apple Silicon)
- macOS x86_64 (Intel)

## 🔒 Security Considerations

- **API credentials**: OAuth tokens and API keys are stored by Gemini CLI
- **Code access**: Gemini CLI can read files in and below the current directory
- **Shell execution**: Built-in shell tool can execute commands (with confirmation)
- **Network access**: Communicates with Google's Gemini API
- **MCP servers**: Third-party MCP servers have access to tools you configure
- **Project context**: GEMINI.md may contain sensitive project information

**Best Practices:**
- Review shell commands before approving execution
- Use `.gitignore` to exclude sensitive files from context
- Be cautious with `trust: true` in MCP server config
- Audit MCP server code before installation
- Use OAuth for personal projects, Vertex AI for enterprise
- Keep GEMINI.md out of version control if it contains secrets

## 📚 Additional Resources

- **Gemini CLI Repository**: [github.com/google-gemini/gemini-cli](https://github.com/google-gemini/gemini-cli)
- **Documentation**: [geminicli.com/docs](https://geminicli.com/docs)
- **GEMINI.md Guide**: [geminicli.com/docs/cli/gemini-md](https://geminicli.com/docs/cli/gemini-md)
- **MCP Servers**: [geminicli.com/docs/tools/mcp-server](https://geminicli.com/docs/tools/mcp-server)
- **API Key**: [aistudio.google.com](https://aistudio.google.com)
- **Vertex AI**: [cloud.google.com/vertex-ai](https://cloud.google.com/vertex-ai)
- **Flox Documentation**: [flox.dev/docs](https://flox.dev/docs)

## 🙏 Acknowledgments

- **Google Gemini Team**: Thanks to Google and the Gemini team for creating Gemini CLI and making it open source under the Apache-2.0 license

## 🔗 About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Software, variables, services defined in human-readable TOML
- **Content-addressed storage** - Multiple package versions coexist without conflicts
- **Reproducibility** - Same environment across dev, CI, and production
- **Deterministic builds** - Same inputs always produce identical outputs
- **Huge package collection** - Access to 150,000+ packages from [Nixpkgs](https://github.com/NixOS/nixpkgs)

## 📝 License

This Flox environment configuration is provided as-is. Gemini CLI is licensed under the Apache-2.0 license - see the [Gemini CLI repository](https://github.com/google-gemini/gemini-cli) for details.

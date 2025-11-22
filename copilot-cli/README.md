# 🤖 Flox Environment for GitHub Copilot CLI

A Flox environment for [GitHub Copilot CLI](https://github.com/github/copilot-cli), an AI-powered coding agent that brings GitHub Copilot directly to your terminal. Copilot CLI enables natural language conversations about code, helping you build, debug, and understand projects through an intelligent command-line interface.

## ✨ Features

- **Conversational coding**: Natural language interactions for development tasks
- **Agentic execution**: Plans and executes complex coding tasks autonomously
- **GitHub context awareness**: Access repos, issues, and PRs through natural queries
- **Preview-before-execution**: All actions require explicit approval before running
- **Multi-model support**: Claude Sonnet 4.5 (default), Claude Sonnet 4, GPT-5
- **MCP extensibility**: Supports Model Context Protocol servers and custom extensions
- **Inline help**: Built-in slash commands for authentication, model switching, feedback
- **Cross-platform**: Works on Linux and macOS (ARM64, x86_64)

## 🧰 Included Tools

The environment includes:

- `copilot` - GitHub Copilot CLI (also available as `github-copilot`)

## 🏁 Getting Started

### 📋 Prerequisites

- [Flox](https://flox.dev/get) installed on your system
- GitHub Copilot subscription (Plus, Pro, Team, or Enterprise)
- Git repository (optional, for project context)

### 💻 Installation & Activation

Get started with:

```sh
# Clone the repo
git clone https://github.com/yourusername/floxenvs && cd floxenvs/copilot-cli

# Activate the environment
flox activate
```

### 🔐 First-Time Setup

Authenticate with GitHub (required):

```bash
# Launch Copilot CLI
copilot

# In the interactive session, authenticate
/login

# Follow the browser authentication flow
# Your GitHub Copilot subscription must be active
```

## 📝 Usage

### Basic Usage (Interactive Mode)

Launch the conversational coding assistant:

```bash
copilot
```

This starts an interactive session where you can:
- Ask coding questions
- Request code generation and refactoring
- Debug issues with AI assistance
- Understand existing code
- Execute commands with approval
- Access GitHub context (repos, issues, PRs)

Example interaction:
```
You: Explain how the authentication module works
Copilot: [analyzes codebase and explains]

You: Refactor it to use dependency injection
Copilot: [shows proposed changes, asks for approval]

You: approve
Copilot: [executes refactoring]
```

### Slash Commands

Within interactive sessions, use these commands:

```
/login       - Authenticate with GitHub
/model       - Switch between AI models
/feedback    - Submit confidential feedback
/help        - Show available commands
/exit        - Exit Copilot CLI
```

### Model Switching

Change the AI model during a session:

```
/model

# Choose from:
# - Claude Sonnet 4.5 (default, recommended)
# - Claude Sonnet 4
# - GPT-5
```

Different models offer different capabilities:
- **Claude Sonnet 4.5**: Best overall performance, multimodal support
- **Claude Sonnet 4**: Alternative Claude model
- **GPT-5**: OpenAI's latest model

### Command-Line Options

```bash
copilot --help              # Show all available options
copilot --version           # Display version information
```

## 🔍 How It Works

### 🗄️ Conversational Interface

**Natural Language Processing:**
- Copilot CLI understands natural language queries about your code
- Maintains conversation context across multiple exchanges
- Provides relevant answers based on your project structure
- Learns from your codebase to give contextual suggestions

**GitHub Integration:**
- Queries repositories, issues, and pull requests
- Understands project history and team patterns
- Accesses documentation and README files
- Integrates with GitHub APIs for comprehensive context

### 🚀 Agentic Execution

**Task Planning:**
1. **Understand**: Analyzes your request and current codebase
2. **Plan**: Creates execution plan with multiple steps
3. **Preview**: Shows what will be changed/executed
4. **Approve**: Waits for your explicit confirmation
5. **Execute**: Performs approved actions
6. **Verify**: Reports results and checks for issues

**Safety Model:**
- All commands previewed before execution
- Explicit approval required for file changes
- No automatic execution without consent
- Rollback support for reversible operations

### 📂 MCP Extensibility

**Model Context Protocol Support:**
- Custom MCP servers can extend functionality
- GitHub's MCP server included by default
- Add domain-specific context providers
- Integrate with external tools and APIs

**Extension Points:**
- Custom code analyzers
- Additional context sources
- Specialized language support
- Team-specific patterns and rules

### 🎯 Context Awareness

**Codebase Understanding:**
- Scans project structure and files
- Identifies programming languages and frameworks
- Recognizes architectural patterns
- Maps dependencies and relationships

**GitHub Context:**
- Repository metadata and history
- Open issues and pull requests
- Team discussions and decisions
- Project documentation

## 🛠️ Common Workflows

### Code Generation

```bash
# Start Copilot
flox activate
copilot

# In interactive mode:
You: Create a REST API endpoint for user authentication with JWT tokens

Copilot: [generates code with explanation]

You: Add input validation and rate limiting

Copilot: [enhances code]

You: approve

Copilot: [writes files]
```

### Debugging Assistance

```bash
copilot

You: Why is the login test failing?

Copilot: [analyzes test output and code]
# Shows potential issues and suggests fixes

You: Fix the authentication bug

Copilot: [proposes changes]

You: approve

Copilot: [implements fix]
```

### Code Understanding

```bash
copilot

You: Explain the authentication flow in this project

Copilot: [provides detailed explanation with code references]

You: How does password hashing work here?

Copilot: [explains specific implementation details]
```

### Refactoring

```bash
copilot

You: Refactor the database layer to use a repository pattern

Copilot: [analyzes current implementation]
# Shows refactoring plan

You: approve

Copilot: [executes refactoring across multiple files]
```

### GitHub Operations

```bash
copilot

You: Show me open PRs related to authentication

Copilot: [fetches and displays relevant PRs]

You: What issues are tagged as high-priority?

Copilot: [queries GitHub and shows issues]
```

### Model Comparison

```bash
copilot

You: Generate a complex algorithm for graph traversal

# Try with default model (Claude Sonnet 4.5)

/model
# Switch to GPT-5

You: Generate the same algorithm

# Compare outputs and choose preferred approach
```

## 🔧 Troubleshooting

### Authentication Issues

```bash
# Re-authenticate
copilot
/login

# Verify subscription is active
# Check https://github.com/settings/copilot

# Ensure you have an active GitHub Copilot subscription:
# - Copilot Individual (Plus)
# - Copilot Business (Team)
# - Copilot Enterprise
```

### Command Not Found

```bash
# Verify copilot is available
which copilot
which github-copilot

# Ensure environment is activated
flox activate

# Check installation
flox list
```

### Session Won't Start

```bash
# Check for error messages
copilot --help

# Verify authentication
copilot
/login

# Clear cache (if issues persist)
rm -rf ~/.copilot-cli
```

### GitHub Context Not Available

**Ensure you're in a git repository:**
```bash
git status

# If not initialized:
git init
```

**Check remote configuration:**
```bash
git remote -v

# Should show GitHub remote
```

### Model Switching Fails

```bash
# Within a copilot session:
/model

# If models aren't available:
# - Verify subscription tier supports multiple models
# - Check authentication status
# - Try logging out and back in
```

### Slow Response Times

**Normal behavior:**
- First query in session: May take longer (loading context)
- Complex queries: Require more processing time
- Large codebases: Context analysis takes time

**Optimization tips:**
- Start copilot in project root for better context
- Break complex requests into smaller steps
- Use specific questions rather than broad queries

### Preview Shows Unexpected Changes

**Before approving:**
- Carefully review all proposed changes
- Check file paths and modifications
- Verify changes match your intent
- Use "reject" if changes are incorrect

**Alternative:**
- Rephrase your request for clarity
- Break down complex changes into steps
- Provide more specific instructions

## 💻 System Compatibility

This environment works on:
- macOS (Apple Silicon and Intel)
- Linux (x86_64 and ARM64)

## 🔒 Security Considerations

- **Authentication**: Secure token-based GitHub authentication
- **Preview-before-execution**: All actions require explicit approval
- **No automatic execution**: User consent required for changes
- **GitHub context**: Access controlled by your GitHub permissions
- **Subscription required**: Active Copilot subscription validates access
- **Data handling**: Queries processed per GitHub Copilot privacy policy
- **Local processing**: Code analysis happens in-session, results not permanently stored
- **MCP extensions**: Third-party extensions should be vetted before use

## 📚 Additional Resources

- **GitHub Copilot CLI**: [github.com/github/copilot-cli](https://github.com/github/copilot-cli)
- **Official Documentation**: [docs.github.com/en/copilot/how-tos/set-up/install-copilot-cli](https://docs.github.com/en/copilot/how-tos/set-up/install-copilot-cli)
- **Using Copilot CLI**: [docs.github.com/en/copilot/how-tos/use-copilot-agents/use-copilot-cli](https://docs.github.com/en/copilot/how-tos/use-copilot-agents/use-copilot-cli)
- **GitHub Copilot Features**: [github.com/features/copilot](https://github.com/features/copilot)
- **Flox Documentation**: [flox.dev/docs](https://flox.dev/docs)

## 🙏 Acknowledgments

- **GitHub Copilot Team**: Huge thanks to GitHub and all contributors to the [Copilot CLI project](https://github.com/github/copilot-cli) for creating this powerful AI coding agent that brings natural language assistance directly to the terminal
- **nix-ai-tools**: Special thanks to [numtide](https://github.com/numtide) and contributors for maintaining [nix-ai-tools](https://github.com/numtide/nix-ai-tools), which packages and distributes AI development tools for the Nix ecosystem, making it easy to use tools like GitHub Copilot CLI in reproducible environments

## 🔗 About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Software, variables, services defined in human-readable TOML
- **Content-addressed storage** - Multiple package versions coexist without conflicts
- **Reproducibility** - Same environment across dev, CI, and production
- **Deterministic builds** - Same inputs always produce identical outputs
- **Huge package collection** - Access to 150,000+ packages from [Nixpkgs](https://github.com/NixOS/nixpkgs)

## 📝 License

This Flox environment configuration is provided as-is. GitHub Copilot and its CLI tool have their own terms of service - see the [GitHub Copilot website](https://github.com/features/copilot) and [GitHub Terms of Service](https://docs.github.com/en/site-policy/github-terms/github-terms-of-service) for details.

# ⚡ Flox Environment for Groq Code CLI

A Flox environment for [Groq Code CLI](https://github.com/build-with-groq/groq-code-cli), a highly customizable, lightweight, and open-source coding CLI powered by Groq for instant iteration. Built as a blueprint for developers who want a customizable coding assistant without feature-heavy alternatives.

## ✨ Features

- **Lightning-fast responses**: Powered by Groq's ultra-fast LPU (Language Processing Unit) inference
- **Interactive TUI**: Terminal-based chat interface for coding assistance
- **Slash commands**: Built-in commands for model selection, authentication, and session management
- **Conversation history**: Maintains context across your session
- **Session statistics**: Track token usage and performance metrics
- **Reasoning display**: Toggle visibility of model's reasoning process
- **Extensible**: Add custom tools (AI-callable functions) and slash commands
- **Lightweight**: Minimal dependencies, fast startup
- **Customizable**: Designed as a blueprint for building your own assistant
- **Free and open source**: MIT License

## 🧰 Included Tools

The environment includes:

- `groq` - Groq Code CLI tool

## 🏁 Getting Started

### 📋 Prerequisites

- [Flox](https://flox.dev/get) installed on your system
- Groq API key (free tier available)
- Node.js 18+ (included in environment)

### 💻 Installation & Activation

Get started with:

```sh
# Clone the repo
git clone https://github.com/yourusername/floxenvs && cd floxenvs/groq-code-cli

# Activate the environment
flox activate
```

### 🔐 First-Time Setup

**Method 1: Interactive Authentication**

```bash
# Start Groq Code CLI
groq

# In the session, authenticate
/login

# Enter your API key when prompted
# Get key from: https://console.groq.com/keys
```

**Method 2: Environment Variable**

```bash
# Set API key
export GROQ_API_KEY="your-api-key-here"

# Start session
groq

# Already authenticated!
```

## 📝 Usage

### Interactive Session

Start a chat session with Groq:

```bash
# Launch interactive TUI
groq

# Example interaction:
You: Explain how async/await works in JavaScript

Groq: [provides detailed explanation with code examples]

You: Show me a practical example with error handling

Groq: [creates code example with try/catch patterns]

You: Refactor this to use Promise.all

Groq: [refactors code with parallel async operations]
```

### Slash Commands

Use slash commands within the interactive session:

**Authentication & Configuration:**
```
/login          # Authenticate with Groq API key
/model          # Select or change Groq model
```

**Session Management:**
```
/clear          # Clear conversation history and context
/stats          # Display session statistics and token usage
/reasoning      # Toggle display of reasoning content
/help           # Show all available commands
```

### Model Selection

```bash
# In session:
/model

# Available Groq models include:
# - llama-3.3-70b-versatile (recommended for coding)
# - llama-3.3-70b-specdec (speculative decoding)
# - mixtral-8x7b-32768
# - gemma2-9b-it
# And more...
```

### Environment Variable Setup

For automated workflows or persistent configuration:

```bash
# Add to your shell profile (~/.bashrc, ~/.zshrc, etc.)
export GROQ_API_KEY="your-api-key-here"

# Or in Flox environment vars
# Edit .flox/env/manifest.toml:
# [vars]
# GROQ_API_KEY = "your-api-key-here"
```

## 🛠️ Common Workflows

### Code Explanation Session

```bash
groq

You: Explain this code: [paste code snippet]

Groq: [analyzes and explains the code line by line]

You: What are potential issues?

Groq: [identifies edge cases, bugs, performance concerns]

You: How would you refactor this?

Groq: [suggests improvements with code examples]
```

### Code Generation

```bash
groq

You: Create a React component for a user profile card with avatar, name, and bio

Groq: [generates component code with props and styling]

You: Add TypeScript types

Groq: [adds type definitions and interfaces]

You: Write unit tests for this component

Groq: [creates Jest/React Testing Library tests]
```

### Debugging Session

```bash
groq

You: This function returns undefined instead of the user object. Here's the code: [paste]

Groq: [identifies the issue and explains why]

You: Show me the fixed version

Groq: [provides corrected code with explanation]
```

### Learning & Documentation

```bash
groq

You: What are the differences between Map and WeakMap in JavaScript?

Groq: [detailed comparison with use cases]

You: Give me a real-world example where WeakMap is better

Groq: [provides practical example with code]

You: /clear  # Start fresh topic

You: Explain dependency injection in TypeScript

Groq: [new explanation with clean context]
```

### Session with Reasoning Display

```bash
groq

/reasoning  # Enable reasoning display

You: Design a caching strategy for a REST API client

Groq: [shows internal reasoning process]
# Reasoning: Considering cache invalidation, TTL, storage options...
# [Provides comprehensive caching design with code]

/stats  # Check token usage
# Session statistics:
# - Messages: 6
# - Tokens: 1,234 input / 2,456 output
# - Time: 2.3s
```

### Model Comparison

```bash
groq

You: Optimize this database query [paste query]

Groq: [provides optimization with llama-3.3-70b]

/model  # Switch to different model

You: Same query - different optimization approach?

Groq: [alternative optimization strategy]
```

## 🔧 Configuration

### Configuration Storage

Groq Code CLI stores configuration in `~/.groq/`:

```
~/.groq/
├── config.json       # API key, default model, custom settings
└── ...
```

**Configuration is managed automatically** through slash commands:
- `/login` - Sets API key
- `/model` - Sets default model
- Other settings can be added by editing `~/.groq/config.json`

### Command-Line Options

```bash
# Start with custom options
groq --temperature 0.7           # Set temperature
groq --system "Custom prompt"    # Custom system message
groq --debug                     # Enable debug logging
groq --proxy http://proxy:8080   # Use proxy
groq --version                   # Show version
```

### Proxy Configuration

```bash
# Via environment variable
export GROQ_PROXY=http://proxy:8080
groq

# Or via command flag
groq --proxy http://proxy:8080
```

## 🎯 Extensibility

### Custom Tools

Groq Code CLI supports adding custom AI-callable tools:

```typescript
// Define a tool schema
const myTool = {
  name: "search_code",
  description: "Search codebase for patterns",
  parameters: {
    type: "object",
    properties: {
      query: { type: "string" }
    }
  }
}

// Tool is automatically available to AI during conversations
```

### Custom Slash Commands

Add your own slash commands to extend functionality:

```typescript
// Register custom command
registerCommand({
  name: "mycommand",
  description: "Custom functionality",
  handler: async () => {
    // Implementation
  }
})
```

See the [GitHub repository](https://github.com/build-with-groq/groq-code-cli) for detailed extensibility documentation.

## 🔧 Troubleshooting

### Command Not Found

```bash
# Verify groq is available
which groq

# Ensure environment is activated
flox activate

# Check installation
flox list
```

### Authentication Issues

```bash
# Re-authenticate
groq
/login

# Or verify environment variable
echo $GROQ_API_KEY

# Get new API key
# Visit: https://console.groq.com/keys
```

### Session Won't Start

```bash
# Check for error messages
groq --debug

# Verify API key is set
groq
/login  # Re-enter credentials

# Or use environment variable
export GROQ_API_KEY="your-key"
groq
```

### Slow Responses

**Normal behavior:**
- Groq is designed for ultra-fast inference
- If responses are slow, check:
  - Network connection
  - API rate limits
  - Model selection (some models faster than others)

**Check session stats:**
```
/stats  # View response times and token usage
```

### Configuration Issues

```bash
# Check configuration location
ls -la ~/.groq/

# Reset configuration
rm -rf ~/.groq/
groq
/login  # Reconfigure
```

### Clear Stuck Context

```bash
# In session:
/clear  # Clears conversation history

# Or restart:
# Exit session (Ctrl+C or Ctrl+D)
# Start fresh
groq
```

## 💻 System Compatibility

This environment works on:
- Linux x86_64
- macOS ARM64 (Apple Silicon)
- macOS x86_64 (Intel)

## 🔒 Security Considerations

- **API credentials**: Stored in `~/.groq/config.json` or via environment variable
- **Configuration location**: `~/.groq/` in your home directory
- **Network access**: Communicates with Groq API for inference
- **Local execution**: CLI runs locally, sends requests to Groq cloud

**Best Practices:**
- **Recommended**: Use `GROQ_API_KEY` environment variable
- Never commit API keys to version control
- Protect `~/.groq/config.json` file permissions
- Use `.gitignore` to exclude sensitive configuration
- Rotate API keys periodically
- Monitor usage via Groq Console

## 📚 Additional Resources

- **Groq Code CLI Repository**: [github.com/build-with-groq/groq-code-cli](https://github.com/build-with-groq/groq-code-cli)
- **Groq Console**: [console.groq.com](https://console.groq.com/)
- **Groq API Keys**: [console.groq.com/keys](https://console.groq.com/keys)
- **Groq Documentation**: [console.groq.com/docs](https://console.groq.com/docs)
- **Groq Playground**: [console.groq.com/playground](https://console.groq.com/playground)
- **Flox Documentation**: [flox.dev/docs](https://flox.dev/docs)

## 🙏 Acknowledgments

- **Groq Team**: Thanks to Groq for creating Groq Code CLI and making it open source under the MIT License

## 🔗 About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Software, variables, services defined in human-readable TOML
- **Content-addressed storage** - Multiple package versions coexist without conflicts
- **Reproducibility** - Same environment across dev, CI, and production
- **Deterministic builds** - Same inputs always produce identical outputs
- **Huge package collection** - Access to 150,000+ packages from [Nixpkgs](https://github.com/NixOS/nixpkgs)

## 📝 License

This Flox environment configuration is provided as-is. Groq Code CLI is licensed under the MIT License - see the [Groq Code CLI repository](https://github.com/build-with-groq/groq-code-cli) for details.

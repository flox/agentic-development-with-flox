# 🚀 Flox Environment for Kilo Code CLI

A Flox environment for [Kilo Code CLI](https://github.com/Kilo-Org/kilocode), an open-source AI coding agent that brings multi-modal autonomous development directly into your terminal. Kilo Code enables you to orchestrate, architect, code, and debug—switching into the right mode for each step of your workflow.

## ✨ Features

- **Multi-modal workflow**: Switch between architect, code, debug, ask, and orchestrator modes
- **Interactive sessions**: Conversational interface with context-aware AI
- **Autonomous mode**: Let the agent work independently with `--auto`
- **Parallel execution**: Run multiple tasks concurrently with `--parallel`
- **Session resumption**: Continue from your last conversation with `-c`
- **Multi-model support**: Access frontier models, custom LLMs, and local models
- **Flexible authentication**: Bring your own API keys (OpenAI, Anthropic, Gemini, OpenRouter, etc.)
- **Slash commands**: Built-in commands for mode/model switching and configuration
- **Configuration management**: Interactive config editor or manual JSON editing
- **Free and open source**: From Kilo

## 🧰 Included Tools

The environment includes:

- `kilocode` - Kilo Code CLI tool

## 🏁 Getting Started

### 📋 Prerequisites

- [Flox](https://flox.dev/get) installed on your system
- API key(s) for your chosen LLM provider (OpenAI, Anthropic, Gemini, etc.)
- Node.js 18+ (included in environment)

### 💻 Installation & Activation

Get started with:

```sh
# Clone the repo
git clone https://github.com/yourusername/floxenvs && cd floxenvs/kilocode-cli

# Activate the environment
flox activate
```

### 🔐 First-Time Setup

Configure API keys on first use:

```bash
# Start interactive session
kilocode

# In the session, configure providers
/config

# Or configure before starting
kilocode config

# Interactive workflow guides you through:
# 1. Select provider (OpenAI, Anthropic, Gemini, OpenRouter, etc.)
# 2. Enter API key
# 3. Set default model
# 4. Configure additional providers (optional)
```

**Supported providers:**
- OpenAI (GPT-5.1, GPT-5, GPT-4o)
- Anthropic (Claude Sonnet 4.5, Opus 4.1, Haiku 4.5)
- Google Gemini (Gemini 3 Pro, Gemini 2.0)
- OpenRouter (access to 100+ models)
- Vercel AI Gateway
- Custom/local models

## 📝 Usage

### Interactive Mode

Launch an interactive chat session:

```bash
# Start in current directory
kilocode

# Example interaction:
You: Create a REST API for user authentication with JWT

Kilo: [analyzes requirements, switches to architect mode]
# Plans system architecture
# Shows you the design

You: Looks good, implement it

Kilo: [switches to code mode, generates implementation]
# Creates files, writes code
# Implements the API

You: Add comprehensive error handling

Kilo: [updates code with error handling]

You: Write integration tests

Kilo: [generates test suite]
```

### Autonomous Mode

Let Kilo work independently:

```bash
# Run autonomous task
kilocode --auto "Implement user authentication with JWT"

# Kilo will:
# 1. Plan the architecture
# 2. Write the code
# 3. Create tests
# 4. Debug issues
# All without further input

# With timeout (in seconds)
kilocode --auto "Refactor database layer" --timeout 300

# From piped input
echo "Fix the bug in payment processing" | kilocode --auto
```

### Parallel Execution

Run multiple tasks concurrently:

```bash
# Terminal 1
kilocode --parallel "Optimize database queries"

# Terminal 2
kilocode --parallel "Update API documentation"

# Terminal 3
kilocode --parallel "Write unit tests for auth module"

# All tasks run independently in parallel
# Great for multi-core systems
```

### Resume Previous Session

Continue where you left off:

```bash
# Resume last conversation
kilocode -c
# or
kilocode --continue

# Previous context is maintained
You: Now add rate limiting to those endpoints

Kilo: [continues from previous work]
```

### Start in Specific Mode

```bash
# Launch directly in architect mode
kilocode --mode architect

# Available modes:
# - architect: System design and planning
# - code: Implementation and coding
# - debug: Error diagnosis and fixing
# - ask: Q&A and explanations
# - orchestrator: Workflow coordination
```

### Slash Commands

Use slash commands within interactive sessions:

**Configuration & Settings:**
```
/config         # Open configuration editor
/model          # Switch models or view available models
/mode           # Switch agent modes
```

**Session Management:**
```
/new            # Start fresh task (clear context)
/help           # Show all available commands
```

### Agent Modes

Switch modes based on your workflow stage:

**Architect Mode:**
- System design and planning
- Architecture decisions
- Tech stack selection
- Breaking down complex tasks

**Code Mode:**
- Implementation and coding
- File creation and editing
- Code generation
- Feature development

**Debug Mode:**
- Error diagnosis
- Bug fixing
- Log analysis
- Performance troubleshooting

**Ask Mode:**
- Questions and explanations
- Learning and documentation
- Code review and feedback
- Best practices guidance

**Orchestrator Mode:**
- Workflow coordination
- Multi-step task management
- Integration and deployment
- Process automation

## 🛠️ Common Workflows

### Full-Stack Project from Scratch

```bash
kilocode

You: Build a blog platform with React frontend and Node.js backend

Kilo: [switches to architect mode]
# Plans full system architecture
# Defines database schema
# Outlines API endpoints
# Proposes tech stack

You: Implement the backend first

Kilo: [switches to code mode]
# Creates Express server
# Sets up database models
# Implements CRUD endpoints
# Adds authentication

You: Now the frontend

Kilo: [creates React app]
# Sets up components
# Implements routing
# Connects to API
# Adds styling

You: Write tests

Kilo: [generates comprehensive test suite]
# Backend unit tests
# API integration tests
# Frontend component tests
```

### Autonomous Bug Fix

```bash
# Let Kilo diagnose and fix automatically
kilocode --auto "The user login returns 500 error for valid credentials"

# Kilo will:
# 1. Switch to debug mode
# 2. Analyze logs and code
# 3. Identify the issue
# 4. Switch to code mode
# 5. Implement fix
# 6. Verify the solution
```

### Code Review Session

```bash
kilocode

You: Review the payment processing module for security issues

Kilo: [switches to ask mode, analyzes code]
# Identifies vulnerabilities
# Flags insecure patterns
# Suggests improvements

You: Fix the issues you found

Kilo: [switches to code mode]
# Implements security fixes
# Adds input validation
# Updates error handling
# Adds security tests
```

### Parallel Development

```bash
# Terminal 1: Database optimization
kilocode --parallel "Optimize slow database queries in user service"

# Terminal 2: API documentation
kilocode --parallel "Generate OpenAPI spec for all endpoints"

# Terminal 3: Testing
kilocode --parallel "Add integration tests for payment flow"

# All tasks complete independently
# Merge results when done
```

### Refactoring Project

```bash
kilocode

You: Refactor the entire codebase from JavaScript to TypeScript

Kilo: [switches to architect mode]
# Analyzes codebase structure
# Plans incremental migration strategy
# Proposes approach

You: Proceed with the migration

Kilo: [switches to code mode]
# Adds TypeScript config
# Converts files incrementally
# Adds type definitions
# Fixes type errors
# Updates build scripts
```

### Learning and Exploration

```bash
kilocode --mode ask

You: Explain how dependency injection works in this codebase

Kilo: [analyzes code, provides explanation]
# Shows examples from your code
# Explains patterns
# Suggests improvements

You: Show me a better implementation

Kilo: [switches to architect mode]
# Proposes improved design

You: Implement it

Kilo: [switches to code mode, refactors]
```

## 🔧 Configuration

### Configuration Location

Kilo Code stores configuration in `~/.kilocode/cli/config.json`:

```
~/.kilocode/cli/
├── config.json          # API keys, providers, models, preferences
└── ...
```

### Interactive Configuration

```bash
# Open configuration editor
kilocode config

# Or within a session
/config

# Interactive workflow:
# 1. Select what to configure (providers, models, settings)
# 2. Choose provider
# 3. Enter credentials
# 4. Set preferences
```

### Manual Configuration

Edit `~/.kilocode/cli/config.json` directly:

```json
{
  "version": "1.0.0",
  "provider": "anthropic",
  "providers": [
    {
      "id": "openai",
      "provider": "openai-native",
      "openAiNativeApiKey": "sk-...",
      "apiModelId": "gpt-5.1"
    },
    {
      "id": "anthropic",
      "provider": "anthropic",
      "apiKey": "sk-ant-...",
      "apiModelId": "claude-sonnet-4.5"
    },
    {
      "id": "gemini",
      "provider": "gemini",
      "geminiApiKey": "AIza...",
      "apiModelId": "gemini-3-pro"
    }
  ]
}
```

**Structure:**
- `"provider"`: ID of active provider (references a provider's `"id"` in the array)
- `"providers"`: Array of configured providers
- Each provider object:
  - `"id"`: Unique identifier (can be anything)
  - `"provider"`: Provider type (anthropic, openai-native, gemini, ollama, etc.)
  - Provider-specific configuration fields

**To switch providers:** Change the top-level `"provider"` field to the ID of the provider you want to use.

### Environment Variable Support

Use environment variables for sensitive credentials:

```bash
# Add to shell profile (~/.bashrc, ~/.zshrc)
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="sk-ant-..."
export GOOGLE_API_KEY="AIza..."

# Reference in config.json
{
  "providers": {
    "openai": {
      "apiKey": "${OPENAI_API_KEY}"
    }
  }
}
```

### Using Ollama (Local Models)

Kilo Code supports Ollama for running local models. This is ideal for privacy, offline work, or cost savings.

**Prerequisites:**
- Ollama installed and running (`ollama serve`)
- Model downloaded (`ollama pull qwen2.5-coder:7b`)
- Sufficient hardware (see model requirements below)

**Layer Ollama with Flox:**
```bash
# Activate with Ollama layered
flox activate -r flox/ollama

# Start Ollama service
ollama serve &

# Pull recommended model
ollama pull qwen2.5-coder:7b
```

**Configure Ollama provider:**

Add to `~/.kilocode/cli/config.json`:

```json
{
  "provider": "ollama",
  "providers": [
    {
      "id": "ollama",
      "provider": "ollama",
      "ollamaBaseUrl": "http://localhost:11434",
      "ollamaModelId": "qwen2.5-coder:7b",
      "ollamaApiKey": "",
      "ollamaNumCtx": 32768
    }
  ]
}
```

**Or use interactive config:**
```bash
kilocode config
# Select Ollama as provider
# Set model: qwen2.5-coder:7b
# Set context window: 32768
```

**Recommended Models:**

| Model | Size | VRAM | Best For |
|-------|------|------|----------|
| `qwen2.5-coder:7b` | 7B | 8GB | Balanced performance |
| `qwen2.5-coder:32b` | 32B | 24GB+ | High quality coding |
| `qwen3-coder:30b` | 30B | 24GB+ | Official recommendation |
| `devstral:24b` | 24B | 16GB+ | Alternative option |
| `deepseek-coder:33b` | 33B | 24GB+ | Strong code understanding |

**Important Settings:**

- **Context window (`ollamaNumCtx`)**: **Minimum 32768 (32k)** - Ollama defaults to very short contexts which break Kilo Code
- **Timeout**: May need to increase for slower inference (see troubleshooting)
- **Hardware**:
  - GPU with 24GB+ VRAM for 30B+ models
  - Apple Silicon with 32GB+ unified memory
  - Smaller models (7B) work on 8GB VRAM

**Switch between cloud and local:**

Keep multiple providers configured:
```json
{
  "provider": "ollama",
  "providers": [
    {
      "id": "anthropic",
      "provider": "anthropic",
      "apiKey": "sk-ant-...",
      "apiModelId": "claude-sonnet-4.5"
    },
    {
      "id": "ollama",
      "provider": "ollama",
      "ollamaBaseUrl": "http://localhost:11434",
      "ollamaModelId": "qwen2.5-coder:7b",
      "ollamaApiKey": "",
      "ollamaNumCtx": 32768
    }
  ]
}
```

Switch by editing the top-level `"provider"` field:
- `"provider": "anthropic"` → Use Claude via cloud
- `"provider": "ollama"` → Use local Ollama model

## 🔧 Troubleshooting

### Command Not Found

```bash
# Verify kilocode is available
which kilocode

# Ensure environment is activated
flox activate

# Check installation
flox list | grep kilocode
```

### Configuration Issues

```bash
# Re-run configuration
kilocode config

# Or reset configuration
rm ~/.kilocode/cli/config.json
kilocode config

# Verify config file exists and is valid JSON
cat ~/.kilocode/cli/config.json | jq .
```

### Authentication Errors

**Common issues:**
- Invalid or expired API key
- Incorrect provider configuration
- Rate limiting
- Provider service outage

**Solutions:**
```bash
# Update API keys
kilocode config

# Or in session
/config

# Verify API key is correct
# Check provider status pages

# Try different provider
/model
# Select model from different provider
```

### Session Won't Start

```bash
# Check for error messages
kilocode

# Verify configuration
cat ~/.kilocode/cli/config.json

# Test with simple prompt
kilocode
You: Hello

# If fails, reconfigure
rm ~/.kilocode/cli/config.json
kilocode config
```

### Autonomous Mode Not Working

**Issue:** `--auto` mode doesn't complete tasks

**Possible causes:**
- Task too complex for single run
- Timeout too short
- Insufficient permissions (file access, command execution)

**Solutions:**
```bash
# Increase timeout
kilocode --auto "task" --timeout 600

# Break into smaller tasks
kilocode --auto "Step 1: Design architecture"
kilocode --auto "Step 2: Implement backend"

# Use interactive mode for complex tasks
kilocode
You: [Describe complex task, work interactively]
```

### Parallel Mode Issues

**Issue:** Parallel tasks conflict

**Solution:**
```bash
# Ensure tasks work on different files/modules
# Terminal 1: Frontend work
kilocode --parallel "Update React components"

# Terminal 2: Backend work
kilocode --parallel "Refactor API endpoints"

# Avoid parallel edits to same files
```

### Slow Responses

**Normal behavior:**
- First request: Loading context, analyzing project
- Large codebases: More time for analysis
- Complex tasks: Planning and execution takes longer

**Optimization:**
```bash
# Use faster models for simple tasks
/model
# Select: gpt-5-mini, claude-haiku-4.5, gemini-2.0-flash

# Use powerful models for complex analysis
/model
# Select: gpt-5.1, claude-opus-4.1, gemini-3-pro

# Configure mode-specific models (see Configuration section)
```

### Ollama Issues

**Issue:** Ollama connection fails

**Solutions:**
```bash
# Verify Ollama is running
ollama list

# If not running, start it
ollama serve &

# Check Ollama is accessible
curl http://localhost:11434/api/version

# Verify model is downloaded
ollama list | grep qwen2.5-coder
```

**Issue:** Context too long errors with Ollama

**Cause:** Default Ollama context is too short (2048 tokens)

**Solution:**
```json
// In ~/.kilocode/cli/config.json
{
  "id": "ollama",
  "provider": "ollama",
  "ollamaNumCtx": 32768  // <- Set to at least 32k
}
```

**Issue:** Ollama responses are very slow

**Solutions:**
- Use smaller model: `qwen2.5-coder:7b` instead of `qwen2.5-coder:32b`
- Check GPU is being used: `ollama ps` should show GPU memory usage
- Ensure sufficient VRAM available
- Consider quantized models for faster inference

**Issue:** "Model not found" error

**Solution:**
```bash
# Pull the model first
ollama pull qwen2.5-coder:7b

# Verify it's available
ollama list

# Update config with exact model name
```

**Issue:** Kilo Code doesn't use local model

**Verify configuration:**
```bash
# Check active provider
cat ~/.kilocode/cli/config.json | jq '.provider'
# Should show: "ollama"

# Check Ollama provider is configured
cat ~/.kilocode/cli/config.json | jq '.providers[] | select(.id=="ollama")'
```

### Platform-Specific Issues

**Windows:**
- Kilo Code CLI works best on Linux/macOS
- For Windows: Use WSL (Windows Subsystem for Linux)

**WSL Setup:**
```bash
# In WSL
flox activate
kilocode
```

## 💻 System Compatibility

This environment works on:
- Linux x86_64
- macOS ARM64 (Apple Silicon)
- macOS x86_64 (Intel)
- Windows (via WSL)

## 🔒 Security Considerations

- **API credentials**: Stored in `~/.kilocode/cli/config.json` or via environment variables
- **Configuration location**: `~/.kilocode/cli/` in your home directory
- **Code access**: Kilo can read and modify files in your project
- **Command execution**: Can run shell commands (with approval based on settings)
- **Network access**: Communicates with configured LLM providers
- **Auto-approval settings**: Control what operations run without confirmation

**Best Practices:**
- **Recommended**: Use environment variables for API keys
- Never commit API keys to version control
- Protect `~/.kilocode/cli/config.json` file permissions
- Use `.gitignore` to exclude sensitive configuration
- Review auto-approval settings carefully
- Be cautious with autonomous mode on production systems
- Use version control (git) for easy rollback
- Review changes before accepting in sensitive codebases
- Keep Kilo Code CLI updated

## 📚 Additional Resources

- **Kilo Code Repository**: [github.com/Kilo-Org/kilocode](https://github.com/Kilo-Org/kilocode)
- **Kilo Code Website**: [kilo.ai](https://kilo.ai/)
- **CLI Documentation**: [kilo.ai/docs/cli](https://kilo.ai/docs/cli)
- **Provider Configuration**: [kilo.ai/docs/providers](https://kilo.ai/docs/providers)
- **Community**: [Join discussions and get support](https://github.com/Kilo-Org/kilocode/discussions)
- **Flox Documentation**: [flox.dev/docs](https://flox.dev/docs)

## 🙏 Acknowledgments

- **Kilo Team**: Thanks to Kilo and all contributors for creating Kilo Code and making it open source

## 🔗 About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Software, variables, services defined in human-readable TOML
- **Content-addressed storage** - Multiple package versions coexist without conflicts
- **Reproducibility** - Same environment across dev, CI, and production
- **Deterministic builds** - Same inputs always produce identical outputs
- **Huge package collection** - Access to 150,000+ packages from [Nixpkgs](https://github.com/NixOS/nixpkgs)

## 📝 License

This Flox environment configuration is provided as-is. Kilo Code is open source - see the [Kilo Code repository](https://github.com/Kilo-Org/kilocode) for license details.

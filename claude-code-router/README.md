# 🤖 Flox Environment for Claude Code Router

A Flox environment for [Claude Code Router](https://github.com/musistudio/claude-code-router), a middleware proxy that routes Claude Code requests to different AI providers (OpenRouter, DeepSeek, OpenAI, Gemini, Anthropic, Ollama) with dynamic model switching, request transformation, and centralized API key management. This environment supports both interactive configuration and headless CI/CD workflows.

## ✨ Features

- **Local Ollama included by default**: Compose with ollama-headless for free, private, offline LLM access
- **Hybrid workflow support**: Interactive setup wizard OR runtime environment variable injection
- **Multi-provider routing**: DeepSeek, OpenRouter, OpenAI, Gemini, Anthropic, Ollama, and more
- **Dynamic model switching**: Change models on-the-fly with `/model provider,model-name`
- **Smart routing strategies**: Different models for background tasks, reasoning, long context, web search
- **Request transformation**: Built-in transformers for provider API compatibility
- **Centralized API key management**: Configure all providers in one place
- **Service management**: Automatic daemon management via Flox services
- **Cross-platform compatibility**: Linux and macOS (ARM64, x86_64)
- **Interactive TUI configuration**: Gum-powered setup wizard
- **Runtime configuration**: Override settings via environment variables

## 🧰 Included Tools

The environment includes:

- `claude-code-router` - AI model routing proxy server
- `claude-code` - Claude Code CLI (required by `ccr code` command)
- `gum` - Terminal UI toolkit for interactive configuration
- `curl` - HTTP client for testing
- `jq` - JSON processor for config inspection
- `bat` - Enhanced file viewer with syntax highlighting

## 🏁 Getting Started

### 📋 Prerequisites

- [Flox](https://flox.dev/get) installed on your system
- API keys for one or more AI providers (DeepSeek, OpenRouter, OpenAI, etc.)
- Claude Code installed (or use the bundled `claude-code` from this environment)

### 💻 Installation & Activation

Get started with:

```sh
# Clone the repo
git clone https://github.com/yourusername/floxenvs && cd floxenvs/claude-code-router

# Activate with interactive setup
flox activate
```

For headless/CI workflows:

```sh
# Set API keys and start service
DEEPSEEK_API_KEY=sk-xxx OPENROUTER_API_KEY=sk-xxx flox activate -s
```

## 📝 Usage Scenarios

### Interactive Setup (Local Development)

First-time activation triggers an interactive wizard:

```bash
# Activate environment
flox activate

# Run configuration wizard
ccr-setup
```

The wizard guides you through:
1. Host and port configuration
2. API key authentication (optional)
3. HTTP proxy settings (optional)
4. Provider selection (DeepSeek, OpenRouter, OpenAI, Gemini, Anthropic)

Then start the service:

```bash
# Start router as background service
flox activate -s

# Or manage manually
ccr start
```

### Headless Setup (CI/CD, Scripts)

Runtime environment variable injection without prompts:

```bash
# Set provider API keys
export DEEPSEEK_API_KEY="sk-xxx"
export OPENROUTER_API_KEY="sk-xxx"

# Optional: customize router settings
export CCR_HOST="0.0.0.0"
export CCR_PORT="3456"
export CCR_LOG_LEVEL="info"

# Start service
flox activate -s
```

One-liner:
```bash
DEEPSEEK_API_KEY=sk-xxx OPENROUTER_API_KEY=sk-xxx CCR_LOG_LEVEL=info flox activate -s
```

### Configure Claude Code to Use the Router

Set Claude Code's API base URL to the router endpoint:

```bash
export ANTHROPIC_API_BASE_URL="http://127.0.0.1:3456"
```

Optional: If you configured router authentication:
```bash
export ANTHROPIC_API_KEY="your-router-apikey"
```

Then use Claude Code normally - all requests route through the configured providers!

### Service Management

Using Flox services:

```bash
# Check service status
flox services status

# View logs
flox services logs ccr

# Restart after config changes
flox services restart ccr

# Stop service
flox services stop ccr
```

Using ccr's built-in daemon management:

```bash
ccr start      # Start daemon
ccr stop       # Stop daemon
ccr restart    # Restart daemon
ccr status     # Show status
```

### Helper Commands

Available after activation:

```bash
# Interactive configuration wizard
ccr-setup

# Generate example config
ccr-config-example

# View current configuration and status
ccr-status

# Edit configuration file
ccr-edit

# View service logs
ccr-logs

# Test router connectivity
ccr-test
```

### Model Switching

Within Claude Code, switch models dynamically:

```
/model deepseek,deepseek-reasoner          # Switch to DeepSeek reasoning model
/model openrouter,anthropic/claude-sonnet-4  # Switch to Claude via OpenRouter
/model openai,gpt-5                        # Switch to GPT-5
```

Or use the interactive selector:

```bash
ccr model  # Terminal-based model selector
ccr ui     # Web-based configuration UI
```

## 🔍 Configuration Variables

All configuration supports runtime override via environment variables:

### Router Settings

| Variable | Default | Description |
|----------|---------|-------------|
| `CCR_HOST` | `127.0.0.1` | Router host address |
| `CCR_PORT` | `3456` | Router port |
| `CCR_APIKEY` | _(empty)_ | Optional API key for router auth |
| `CCR_PROXY_URL` | _(empty)_ | HTTP proxy URL |
| `CCR_LOG_ENABLED` | `true` | Enable logging |
| `CCR_LOG_LEVEL` | `debug` | Log level (debug/info/warn/error) |
| `CCR_API_TIMEOUT_MS` | `600000` | API timeout in milliseconds |
| `CCR_NON_INTERACTIVE` | `false` | Disable interactive prompts |

### Provider API Keys

| Variable | Provider |
|----------|----------|
| `DEEPSEEK_API_KEY` | DeepSeek |
| `OPENROUTER_API_KEY` | OpenRouter |
| `OPENAI_API_KEY` | OpenAI |
| `GEMINI_API_KEY` | Google Gemini |
| `ANTHROPIC_API_KEY` | Anthropic |

### Claude Code Integration

| Variable | Description |
|----------|-------------|
| `ANTHROPIC_API_BASE_URL` | Set to `http://127.0.0.1:3456` to route through ccr |
| `ANTHROPIC_API_KEY` | Router's APIKEY if authentication enabled |

## 🔍 How It Works

### 🗄️ Configuration Management

The environment implements flexible configuration strategies:

1. **Interactive Configuration**:
   - First-time wizard via `ccr-setup`
   - Generates config at `~/.claude-code-router/config.json`
   - Uses environment variable references (`$DEEPSEEK_API_KEY`) by default
   - Editable with `ccr-edit`

2. **Headless Configuration**:
   - Runtime environment variable injection
   - Config file uses `$VAR_NAME` syntax for expansion
   - No interactive prompts required
   - Perfect for CI/CD and scripts

3. **Mixed Mode**:
   - Hard-code some keys in config file
   - Use environment variables for others
   - Maximum flexibility for different workflows

### 🚀 Service Integration

The environment uses Flox's service management with daemon support:

1. **Daemon Service**: `ccr start` self-daemonizes (runs in background)
2. **Flox Management**: Service configured with `is-daemon = true`
3. **Shutdown Command**: Graceful stop via `ccr stop`
4. **Status Tracking**: Monitor via `ccr status` or `flox services status`

### 🌐 Request Flow

```
┌─────────────┐
│ Claude Code │
└──────┬──────┘
       │ ANTHROPIC_API_BASE_URL=http://127.0.0.1:3456
       ▼
┌──────────────────┐      ┌─────────────────┐
│ Claude Code      │◄─────┤ config.json     │
│ Router (ccr)     │      │ - Providers     │
│ localhost:3456   │      │ - Router rules  │
└────────┬─────────┘      │ - Transformers  │
         │                └─────────────────┘
         │ Routes based on context
         │
    ┌────┴────┬──────────┬──────────┬──────────┐
    ▼         ▼          ▼          ▼          ▼
┌─────────┐ ┌─────────┐ ┌──────┐ ┌────────┐ ┌──────────┐
│DeepSeek │ │OpenRouter│ │OpenAI│ │ Gemini │ │Anthropic │
└─────────┘ └─────────┘ └──────┘ └────────┘ └──────────┘
```

### 📂 Directory Structure

- `~/.claude-code-router/config.json` - Main configuration
- `~/.claude-code-router/logs/` - Router logs
- `~/.claude-code-router/plugins/` - Custom transformers
- `~/.claude-code-router/.claude-code-router.pid` - Daemon PID file

## 🛠️ Configuration Examples

### Example 1: Interactive Setup with Environment Variables

Best for local development with secure credential management:

```bash
# Set API keys in shell
export DEEPSEEK_API_KEY="sk-xxx"
export OPENROUTER_API_KEY="sk-xxx"

# Run interactive setup
flox activate
ccr-setup

# Start service
flox activate -s
```

The wizard generates a config with environment variable references:

```json
{
  "Providers": [
    {
      "name": "deepseek",
      "api_key": "$DEEPSEEK_API_KEY"
    }
  ]
}
```

### Example 2: Headless CI/CD Pipeline

Best for automated workflows:

```bash
#!/bin/bash
# ci-test.sh

# Set all configuration via environment
export DEEPSEEK_API_KEY="${CI_DEEPSEEK_KEY}"
export OPENROUTER_API_KEY="${CI_OPENROUTER_KEY}"
export CCR_LOG_LEVEL="info"
export CCR_NON_INTERACTIVE="true"

# Activate and start service
flox activate -s

# Run Claude Code tests
ANTHROPIC_API_BASE_URL="http://127.0.0.1:3456" claude code "run tests"

# Cleanup
flox services stop
```

### Example 3: Smart Routing Strategy

Configure different models for different scenarios:

```json
{
  "Router": {
    "default": "deepseek,deepseek-chat",
    "background": "deepseek,deepseek-chat",
    "think": "deepseek,deepseek-reasoner",
    "longContext": "openrouter,google/gemini-2.5-pro-preview",
    "longContextThreshold": 60000,
    "webSearch": "openrouter,anthropic/claude-sonnet-4",
    "image": "openrouter,anthropic/claude-sonnet-4"
  }
}
```

This routes:
- **Default/background**: DeepSeek Chat (cost-effective)
- **Reasoning**: DeepSeek Reasoner (optimized for complex thinking)
- **Long context** (>60k tokens): Gemini 2.5 Pro (2M context window)
- **Web search/images**: Claude Sonnet 4 (multimodal capabilities)

### Example 4: Hard-Coded Configuration

Best for single-user local development (less secure):

```bash
# Create config with hard-coded keys
ccr-edit
```

```json
{
  "Providers": [
    {
      "name": "deepseek",
      "api_key": "sk-actual-hardcoded-key-here"
    }
  ]
}
```

### Example 5: Proxy Configuration

For corporate/restricted networks:

```bash
CCR_PROXY_URL="http://proxy.corp.com:8080" flox activate -s
```

Or in config:
```json
{
  "PROXY_URL": "http://proxy.corp.com:8080"
}
```

### Example 6: Local Ollama (Included by Default)

This environment **includes local Ollama support by default** via environment composition. The `ollama-headless` environment is composed with `claude-code-router`, allowing you to use local LLMs.

**Using Ollama (default):**

1. Configure the router with Ollama provider:

```bash
ccr-edit
```

Add Ollama to your config:

```json
{
  "Providers": [
    {
      "name": "ollama",
      "api_base_url": "http://localhost:11434/v1/chat/completions",
      "api_key": "",
      "models": ["qwen2.5-coder:32b", "deepseek-r1:32b"]
    },
    {
      "name": "openrouter",
      "api_base_url": "https://openrouter.ai/api/v1/chat/completions",
      "api_key": "$OPENROUTER_API_KEY",
      "models": ["anthropic/claude-sonnet-4"]
    }
  ],
  "Router": {
    "default": "ollama,qwen2.5-coder:32b",
    "background": "ollama,qwen2.5-coder:32b",
    "think": "ollama,deepseek-r1:32b",
    "longContext": "openrouter,anthropic/claude-sonnet-4"
  }
}
```

2. Start both services:

```bash
flox activate -s
```

This starts both Ollama and the router, giving you:
- Local models for most tasks (free, private, offline)
- Cloud providers for specialized needs (long context, multimodal)

**Running WITHOUT Ollama (cloud providers only):**

You have two options:

**Option A:** Comment out the `[include]` section in `.flox/env/manifest.toml`:

```toml
#[include]
#ollama = "barstoolbluz/ollama-headless"
```

**Option B:** Start only the router service:

```bash
flox activate              # Don't use -s
flox services start ccr    # Start only the router, not Ollama
```

This gives you flexibility to use cloud providers only when needed without modifying the manifest.

## 🔧 Troubleshooting

### Router Won't Start

```bash
# Check for config errors
ccr-status

# View detailed logs
ccr-logs

# Verify config exists
ls -la ~/.claude-code-router/config.json

# Test manually
ccr start
ccr status
```

### Claude Code Can't Connect to Router

```bash
# Verify router is running
ccr status

# Should show: Status: Running
# API Endpoint: http://127.0.0.1:3456

# Test connectivity
ccr-test

# Check Claude Code configuration
echo $ANTHROPIC_API_BASE_URL
# Should be: http://127.0.0.1:3456
```

### Provider Authentication Errors

```bash
# Check API keys are set
echo $DEEPSEEK_API_KEY
echo $OPENROUTER_API_KEY

# Verify config uses correct format
cat ~/.claude-code-router/config.json | jq '.Providers[].api_key'

# View logs for auth errors
ccr-logs
```

### Service Shows "Completed" Instead of "Running"

This is normal! The service is configured with `is-daemon = true` because `ccr start` self-daemonizes.

"Completed" status means the launcher successfully spawned the daemon and exited. Check the actual daemon:

```bash
ccr status          # Should show "Status: Running"
pgrep -f claude-code-router  # Should show PID
```

### Port Already in Use

```bash
# Check what's using port 3456
lsof -i :3456

# Use a different port
CCR_PORT=3457 flox activate -s

# Update Claude Code accordingly
export ANTHROPIC_API_BASE_URL="http://127.0.0.1:3457"
```

### Configuration Changes Not Applied

```bash
# Restart service to reload config
flox services restart ccr

# Or using ccr
ccr restart
```

### Can't Switch Models in Claude Code

Ensure you're using the `/model` command correctly:

```
/model provider_name,model_name

Examples:
/model deepseek,deepseek-chat
/model openrouter,anthropic/claude-sonnet-4
```

Check available models:
```bash
ccr model  # Interactive selector shows all configured models
ccr ui     # Web UI shows full configuration
```

## 💻 System Compatibility

This environment works on:
- Linux (ARM64, x86_64)
- macOS (ARM64, x86_64)

## 🔒 Security Considerations

- **Environment variable approach (recommended)**: API keys not stored in config files
- **Hard-coded keys**: Convenient but less secure - protect `~/.claude-code-router/` directory
- **Router authentication**: Optional `CCR_APIKEY` adds authentication layer
- **Network binding**: Default `127.0.0.1` restricts to localhost (use `0.0.0.0` for network access)
- **Log files**: May contain request/response data - secure `~/.claude-code-router/logs/`
- **Production use**: Always use strong API keys and restrict network access

## 📚 Additional Resources

- **Upstream Project**: [Claude Code Router on GitHub](https://github.com/musistudio/claude-code-router)
- **Claude Code**: [Official Claude Code documentation](https://claude.com/claude-code)
- **AI Tools Collection**: [nix-ai-tools](https://github.com/numtide/nix-ai-tools) - A great resource for collecting and running AI development tools with Nix
- **Flox Documentation**: [flox.dev/docs](https://flox.dev/docs)
- **Provider Documentation**:
  - [DeepSeek API](https://platform.deepseek.com/api-docs/)
  - [OpenRouter](https://openrouter.ai/docs)
  - [OpenAI API](https://platform.openai.com/docs)
  - [Google Gemini](https://ai.google.dev/docs)
  - [Anthropic API](https://docs.anthropic.com/)

## 🙏 Acknowledgments

- **Claude Code Router Team**: Huge thanks to [musistudio](https://github.com/musistudio) and all contributors to the [Claude Code Router project](https://github.com/musistudio/claude-code-router) for creating this powerful middleware proxy that enables flexible AI provider routing and model switching
- **nix-ai-tools**: Special thanks to [numtide](https://github.com/numtide) and contributors for maintaining [nix-ai-tools](https://github.com/numtide/nix-ai-tools), which packages and distributes AI development tools for the Nix ecosystem, making it easy to use tools like Claude Code Router in reproducible environments

## 🔗 About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Software, variables, services defined in human-readable TOML
- **Content-addressed storage** - Multiple package versions coexist without conflicts
- **Reproducibility** - Same environment across dev, CI, and production
- **Deterministic builds** - Same inputs always produce identical outputs
- **Huge package collection** - Access to 150,000+ packages from [Nixpkgs](https://github.com/NixOS/nixpkgs)

## 📝 License

This Flox environment configuration is provided as-is. The upstream Claude Code Router project has its own license - see the [upstream repository](https://github.com/musistudio/claude-code-router) for details.

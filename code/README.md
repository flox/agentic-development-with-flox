# 🤖 A Flox Environment for CODE

This Flox environment gives you [CODE](https://github.com/just-every/code/)—a fast, local coding agent for your terminal—with isolated configuration and cache directories per project.

## ✨ What You Get

- **Local AI coding** - Uses Ollama by default (no API costs!)
- **AI coding agent** - Multi-agent orchestration with Claude, Gemini, and GPT-5
- **Interactive CLI** - Commands like `/plan`, `/solve`, `/code` for real-time coding assistance
- **Browser integration** - Supports Chrome CDP and headless browsing with screenshots
- **Auto Drive mode** - Autonomous multi-step task execution with self-healing
- **MCP support** - Extensible via Model Context Protocol
- **Isolated config** - Each project gets its own CODE configuration and auth
- **Flexible backends** - Switch between Ollama (local) and OpenAI API (cloud)

## 🧰 What's Inside

- `code` - AI coding agent CLI
- `ollama` - Local LLM runtime (from `barstoolbluz/ollama-headless`)
- Isolated config directory in `$FLOX_ENV_CACHE/code`
- Pre-configured to use Ollama by default

## 🚀 Getting Started

### Prerequisites

- [Flox](https://flox.dev) installed
- **Option A**: Use local Ollama (included, no API key needed)
- **Option B**: OpenAI API key or ChatGPT Plus/Pro/Team subscription
- Chrome/Chromium installed (for browser integration, optional)

### Option A: Local Ollama (Recommended)

```bash
# Start environment with Ollama service
flox activate -s

# Pull a coding model (first time only)
ollama pull codellama

# Start coding session - uses Ollama automatically
code
```

### Option B: OpenAI API

```bash
# Override to use OpenAI API instead of Ollama
OPENAI_BASE_URL=https://api.openai.com/v1 \
OPENAI_API_KEY=sk-xxx \
flox activate

# Use CODE with OpenAI
code
```

### Flexible Usage

```bash
# Start without services (Ollama not running)
flox activate

# Start Ollama later if needed
flox services start

# Or use your own OpenAI API key
OPENAI_API_KEY=sk-xxx code
```

## 📝 Built-in Commands

### Interactive Commands

```bash
# Inside CODE CLI:
/plan           # Multi-agent planning
/solve          # Problem solving with consensus
/code           # Generate code with racing strategies
/settings       # Configuration hub
/themes         # Theme customization
```

### CLI Flags

```bash
# Non-interactive mode
code --no-approval "implement user authentication"

# Read-only mode (no file writes)
code --read-only "analyze this codebase"
```

## 🔧 Configuration

### Environment Variables

This environment is **pre-configured for Ollama**:
- `OPENAI_BASE_URL=http://localhost:11434/v1` (points to Ollama)
- `OPENAI_API_KEY=ollama` (dummy value for Ollama)
- `CODE_HOME=$FLOX_ENV_CACHE/code` (isolated config)

**Override to use OpenAI API:**
```bash
OPENAI_BASE_URL=https://api.openai.com/v1 \
OPENAI_API_KEY=sk-xxx \
flox activate
```

**Use custom endpoint:**
```bash
OPENAI_BASE_URL=https://custom-endpoint.com flox activate
```

### Configuration File

CODE stores its configuration in `$CODE_HOME/config.toml` (defaults to `$FLOX_ENV_CACHE/code/config.toml` in this environment).

Edit configuration:
```bash
# Settings are stored per Flox environment
cat $CODE_HOME/config.toml

# Or use interactive settings
code
# Then: /settings
```

### Authentication

CODE stores auth credentials in `$CODE_HOME/auth.json`. Two authentication methods:

1. **ChatGPT Sign-in** - For Plus/Pro/Team subscribers (uses models available to your plan)
2. **API Key** - Set `OPENAI_API_KEY` environment variable

## 🔥 Troubleshooting

### Authentication issues

Check if auth file exists:
```bash
ls -la $CODE_HOME/auth.json
```

Re-authenticate by removing old auth:
```bash
rm $CODE_HOME/auth.json
code  # Will prompt for login
```

### Config not persisting

Verify `CODE_HOME` is set correctly:
```bash
echo $CODE_HOME
# Should show: /path/to/project/.flox/cache/code
```

### Browser integration not working

Ensure Chrome/Chromium is installed and accessible:
```bash
which google-chrome
which chromium
```

## 💻 System Support

This Flox environment currently supports:
- Linux (x86_64)

**Note**: While [CODE](https://github.com/just-every/code/) itself may support multiple platforms, the `flox/code` package is currently available for x86_64-linux.

## 🔍 Power User Tips

- **Free local AI**: Ollama runs locally—no API costs, full privacy
- **Model selection**: Pull multiple models with `ollama pull` and switch between them
- **Multi-agent strategies**: Use `/plan` for consensus across models or `/solve` for racing strategies
- **Hybrid approach**: Use Ollama for quick tasks, switch to OpenAI API for complex ones
- **Project isolation**: Each Flox environment has its own CODE config—great for different projects with different settings
- **On-demand Ollama**: Start without `-s` flag, then `flox services start` when you need Ollama
- **CI automation**: Use `--no-approval --read-only` flags for automated code analysis in pipelines
- **MCP extensions**: Extend CODE with filesystem, database, and API integrations via Model Context Protocol
- **Theme customization**: Access themes with `/themes` command for personalized UI

## 🌟 Related Projects

### Upstream

This environment packages [CODE](https://github.com/just-every/code/) by just-every. **Thank you** to the just-every team and all contributors for creating and maintaining this excellent community-driven fork of OpenAI's Codex—a fast, local coding agent with multi-agent orchestration, browser integration, and extensive customization.

### Packaging & Distribution

**Special thanks** to the [nix-ai-tools](https://github.com/numtide/nix-ai-tools) project by numtide and its contributors for making AI development tools accessible through Nix packaging. This comprehensive collection of AI-powered development utilities—including code assistants, MCP servers, and language models—makes it easy to get started with AI tooling. Their work benefits the entire community.

## About Flox

[Flox](https://flox.dev/docs) combines package and environment management, building on [Nix](https://github.com/NixOS/nix). It gives you Nix with a `git`-like syntax and an intuitive UX:

- **Declarative environments**. Software packages, variables, services, etc. are defined in simple, human-readable TOML format;
- **Content-addressed storage**. Multiple versions of packages with conflicting dependencies can coexist in the same environment;
- **Reproducibility**. The same environment can be reused across development, CI, and production;
- **Deterministic builds**. The same inputs always produce identical outputs for a given architecture, regardless of when or where builds occur;
- **World's largest collection of packages**. Access to over 150,000 packages—and millions of package-version combinations—from [Nixpkgs](https://github.com/NixOS/nixpkgs).

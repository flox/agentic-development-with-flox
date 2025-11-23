# 🤖 Agentic Development with Flox

A curated collection of AI coding agents, assistants, and LLM tools packaged as ready-to-use Flox environments. Pick an agent, activate the environment, and start building with AI—no complex setup, no dependency conflicts, no containers required.

## ⚡ What's This?

This repo contains pre-configured [Flox](https://flox.dev/docs) environments for AI-powered development tools. Each environment:

- Runs consistently across macOS and Linux
- Includes smart defaults and helpful activation messages
- Works out of the box with sensible configurations
- Follows Flox security conventions (secrets in `$HOME`, never in repos)

## 🎯 Philosophy

These environments embrace **agentic development**—letting AI handle repetitive coding tasks while you focus on architecture, design, and creative problem-solving. Whether you need code generation, review, refactoring, or autonomous feature implementation, there's an agent here for your workflow.

## 📦 Available Environments

### 💬 AI Chat & LLM Tools

Multi-provider LLM interfaces for general-purpose AI assistance:

- [**aichat**](./aichat) - All-in-One LLM CLI supporting 20+ providers (OpenAI, Claude, Gemini, Ollama, Groq, Azure, Bedrock, and more)
- [**gemini-cli**](./gemini-cli) - Google Gemini CLI for conversational AI and code generation

### 🤖 AI Coding Agents & Assistants

Autonomous agents and assistants that write, refactor, and improve code:

- [**amazon-q-cli**](./amazon-q-cli) - Amazon Q Developer CLI powered by Claude Sonnet 4 with chat, agents, and AWS integration
- [**copilot-cli**](./copilot-cli) - GitHub Copilot CLI for AI-powered command suggestions and code generation
- [**opencode**](./opencode) - AI coding agent with TUI interface, dual-agent system (build & plan), and undo/redo
- [**goose-cli**](./goose-cli) - Goose AI coding agent with autonomous task execution and file operations
- [**cursor-agent**](./cursor-agent) - Cursor Agent CLI for AI-assisted coding workflows
- [**kilocode-cli**](./kilocode-cli) - Kilocode AI coding agent for terminal-based development
- [**nanocoder**](./nanocoder) - Lightweight AI coding assistant
- [**qwen-code**](./qwen-code) - Qwen code model for code generation and analysis
- [**eca**](./eca) - Emerge Cognitive Architecture for advanced AI reasoning and coding
- [**groq-code-cli**](./groq-code-cli) - Lightweight, customizable coding CLI powered by Groq for instant iteration
- [**forge**](./forge) - AI development tool for building and deploying applications

### 🔍 AI Code Review & Analysis

Tools for automated code review, bug detection, and security analysis:

- [**coderabbit-cli**](./coderabbit-cli) - AI-powered code review catching bugs, security issues, and code smells

### 🛠️ Development Tools & Utilities

Supporting tools and utilities for agentic development workflows:

- [**claude-code**](./claude-code) - Claude Code environment
- [**claude-code-router**](./claude-code-router) - Router for Claude Code workflows
- [**claude-code-acp**](./claude-code-acp) - Claude Code with ACP (Anthropic Claude Protocol)
- [**codex**](./codex) - OpenAI Codex environment
- [**codex-acp**](./codex-acp) - Codex with ACP support
- [**spec-kit**](./spec-kit) - GitHub Spec Kit for specification-driven development
- [**amp**](./amp) - Amp development environment
- [**crush**](./crush) - Crush development tool
- [**droid**](./droid) - Droid AI assistant
- [**catnip**](./catnip) - Catnip development utility
- [**code**](./code) - General code environment
- [**claudebox**](./claudebox) - Claude sandbox environment
- [**backlog-md**](./backlog-md) - Markdown-based backlog management

## 🚀 Getting Started

### Prerequisites

1. Install [Flox](https://flox.dev/get)
2. Clone this repo
   ```bash
   git clone https://github.com/yourusername/agentic-development-with-flox
   cd agentic-development-with-flox
   ```

### Quick Start Examples

**Try AIChat (supports 20+ LLM providers):**
```bash
cd aichat
flox activate
# Follow the interactive setup wizard to configure your provider
aichat "Write a Python function to validate email addresses"
```

**Try Amazon Q Developer CLI:**
```bash
cd amazon-q-cli
flox activate
q login                    # Authenticate with AWS Builder ID
q chat                     # Start AI chat session
```

**Try OpenCode (TUI coding agent):**
```bash
cd opencode
flox activate
opencode                   # Start the TUI interface
```

### General Usage

1. Navigate to the environment you want to use
   ```bash
   cd agentic-development-with-flox/goose-cli
   ```

2. Activate the environment
   ```bash
   flox activate
   ```

3. Follow the activation message for tool-specific instructions

## 🔍 How It Works

Each directory contains:

- A `manifest.toml` file in `./.flox/env/` that defines the environment
- A `README.md` with specific instructions for that tool
- Activation hooks that check for first-time setup and display helpful guidance

Flox uses declarative configuration to create reproducible environments with:

- Specific package versions
- Environment variables for configuration
- Activation hooks that guide new users through setup
- Security conventions (secrets always in `$HOME`)

## 🔐 Security Conventions

All environments follow Flox security best practices:

- **API keys and secrets**: MUST be in `$HOME` (e.g., `~/.config/`, `~/.aws/`)
- **Never commit secrets**: Configuration files with credentials are `.gitignore`d
- **Environment variables**: Preferred method for API key configuration
- **Project configs**: Can exist in repos but MUST NOT contain secrets

## 💻 System Requirements

- Works on macOS (Intel/ARM) and Linux (x86/ARM)
- Flox installed
- Internet connection for LLM provider APIs
- API keys for your chosen providers (OpenAI, Anthropic, Google, AWS, etc.)

## 🎓 Learning Resources

### New to AI Coding Agents?

Start with:
1. **aichat** - Easiest to set up, supports many providers, great for experimentation
2. **copilot-cli** - If you already use GitHub Copilot
3. **amazon-q-cli** - Powerful agent system with AWS integration

### Understanding Agentic Development

Agentic development means:
- **Agents execute tasks autonomously** - You describe what you want, agents figure out how
- **Context-aware workflows** - Agents understand your codebase, sessions, and history
- **Iterative refinement** - Chat with agents to refine implementations
- **Tool use** - Agents can read files, execute commands, and modify code

### Choosing the Right Agent

Consider:
- **Provider preference**: Some agents are tied to specific providers (Amazon Q → Claude, Copilot → OpenAI)
- **Workflow style**: TUI vs. CLI vs. chat-based
- **Features needed**: Code review, refactoring, autonomous implementation, AWS integration
- **Cost**: Free tier vs. paid (check each tool's pricing)

## 🔄 Contributing

Want to add a new AI coding agent? Create a PR with:

1. A new directory for your environment
2. A complete Flox environment with `manifest.toml` and `manifest.lock` in `.flox/env/`
3. A README following our template (see existing environments)
4. Activation hook with first-time setup guidance
5. Security conventions: no secrets in repo, guide users to set them in `$HOME`

## 🔗 Key Features of Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Software, variables, services defined in TOML
- **Content-addressed storage** - Multiple package versions coexist without conflicts
- **Reproducibility** - Same environment across dev, CI, and production
- **Deterministic builds** - Same inputs always produce identical outputs
- **Huge package collection** - Access to 150,000+ packages from Nixpkgs

## 🙏 Acknowledgments

- **Flox Team** - For creating an amazing declarative environment system
- **AI Provider Teams** - OpenAI, Anthropic, Google, AWS, Groq, and others for making powerful AI accessible
- **Open Source Maintainers** - Everyone building amazing AI coding tools

## 📝 License

Each tool has its own license. See individual environment READMEs for details. Flox environment configurations in this repo are provided as-is.

---

**Ready to supercharge your development with AI agents? Pick an environment and `flox activate`!** 🚀

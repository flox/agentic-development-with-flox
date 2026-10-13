# Agentic Development with Flox

Turn-key, isolated environments for 50+ AI coding tools, inference servers, and developer utilities. Each environment gives you everything you need -- the tool, its dependencies, its services -- without installing anything globally on your system.

## Why This Exists

AI development tools are multiplying fast. Each has its own runtime (Node, Python, Rust, Go), its own dependencies, its own services. Trying them means polluting your system with global installs, conflicting versions, and orphaned services.

These Flox environments fix that:

- **Nothing touches your global system.** Dependencies are only accessible within activated Flox environments. When you `exit` an environment, it (and the dependencies defined within it) are gone.
- **Services are scoped.** Need Ollama? PostgreSQL? A vLLM inference server? They start with the environment and stop when you leave. No stale daemons.
- **No version conflicts.** Run Python 3.12 for one tool and Python 3.14 for another, side by side.
- **Try anything risk-free.** Test-drive 50+ AI coding tools without cleanup. Don't like it? Just `exit`.
- **Composable.** Layer an inference backend with a coding agent with a web UI. Mix and match.

## Quick Start

```bash
# Install Flox (one time)
# https://flox.dev/get

# Clone the repository
git clone https://github.com/floxrox/agentic-development-with-flox
cd agentic-development-with-flox

# Pick a tool and go
cd claude-code
flox activate

# That's it. The tool, its dependencies, and any services are ready.
# When you're done:
exit
# Everything is cleaned up. Nothing was installed globally.
```

### With services (inference servers, databases, etc.)

```bash
cd ollama
flox activate -s    # -s starts managed services (Ollama server in this case)
ollama pull gemma4
# Ollama is running. When you exit, it stops.
```

### Compose environments

```bash
# Aider + local Ollama for fully offline AI pair programming
cd aider
flox edit
# Uncomment the Ollama include in [include], then:
flox activate -s
aider --model ollama_chat/gemma4
```

## Available Environments

### AI Coding Agents

- [**aider**](./aider) - Aider AI pair programming with multi-provider support (Anthropic, OpenAI, Ollama, etc.)
- [**amazon-q-cli**](./amazon-q-cli) - Amazon Q Developer CLI (Claude Sonnet 4)
- [**amp**](./amp) - Amp frontier coding agent for the terminal
- [**antigravity**](./antigravity) - Google Antigravity agent-first IDE with multi-agent orchestration and Gemini integration
- [**claude-code**](./claude-code) - Anthropic Claude Code CLI coding agent, with [ccusage](./ccusage) for usage and cost reports and a status line
- [**claurst**](./claurst) - Claurst multi-provider terminal coding agent built in Rust
- [**claw-code**](./claw-code) - Claw Code Rust-based CLI for Claude AI with tool execution and session persistence
- [**cline**](./cline) - Cline autonomous AI coding agent with multi-provider support and browser automation
- [**code**](./code) - Every Code fast local coding agent with multi-agent orchestration
- [**codewhale**](./codewhale) - Codewhale open-source coding agent for any model, built for open-weight and local models (Ollama, vLLM, SGLang)
- [**codex**](./codex) - OpenAI Codex CLI coding agent
- [**copilot-cli**](./copilot-cli) - GitHub Copilot CLI
- [**crush**](./crush) - Crush AI coding agent for the terminal by Charm
- [**cursor-agent**](./cursor-agent) - Cursor Agent CLI
- [**droid**](./droid) - Factory Droid AI software development agent
- [**eca**](./eca) - Emerge Cognitive Architecture AI pair programming assistant
- [**forge**](./forge) - ForgeCode AI pair programmer (formerly Forge by Antinomy), 300+ models
- [**gemini-cli**](./gemini-cli) - Google Gemini CLI coding agent
- [**goose-cli**](./goose-cli) - Goose AI coding agent
- [**hermes-agent**](./hermes-agent) - Hermes self-improving AI agent with persistent learning, 200+ models, and messaging gateway support
- [**ironclaw**](./ironclaw) - IronClaw secure personal AI assistant in Rust with WASM sandboxing and pgvector memory
- [**kilocode-cli**](./kilocode-cli) - Kilocode open-source AI coding agent with multi-modal workflows
- [**kiro**](./kiro) - Agentic AI development platform (IDE + CLI) with spec-driven development
- [**mistral-vibe**](./mistral-vibe) - Mistral Vibe CLI coding agent powered by Devstral
- [**mux**](./mux) - Mux parallel agentic development with multi-provider support and isolated workspaces
- [**nanobot**](./nanobot) - Nanobot ultra-lightweight personal AI agent with multi-channel chat and persistent memory
- [**nanocoder**](./nanocoder) - Nanocoder local-first CLI coding agent with multi-provider support
- [**nullclaw**](./nullclaw) - NullClaw ultra-minimal AI assistant in Zig with 50+ providers and 19 channels
- [**openclaw**](./openclaw) - OpenClaw self-hosted AI assistant/agent
- [**opencode**](./opencode) - OpenCode AI coding agent with TUI
- [**openhands**](./openhands) - OpenHands AI-driven software development agent with sandboxed Docker execution
- [**open-interpreter**](./open-interpreter) - Open Interpreter natural language interface for local code execution
- [**pi**](./pi) - pi minimal, extensible terminal coding agent with multi-model support
- [**qwen-code**](./qwen-code) - Qwen code model CLI
- [**ruflo**](./ruflo) - Ruflo multi-agent AI orchestration platform for Claude Code with self-learning swarms
- [**zeroclaw**](./zeroclaw) - Zeroclaw personal AI assistant infrastructure in Rust with multi-channel messaging and 70+ tools

### LLM CLI Interfaces

- [**aichat**](./aichat) - Multi-provider LLM CLI (OpenAI, Claude, Gemini, Ollama, Groq, Azure, Bedrock, etc.)
- [**gpt4all**](./gpt4all) - GPT4All privacy-first local LLM ecosystem with chat GUI **(linux only)**

### Local AI/ML Infrastructure

Each of these includes a managed service. Use `flox activate -s` to start the server automatically.

- [**agentic-lmstudio**](./agentic-lmstudio) - LM Studio with integrated CLI coding tools (Claude Code, Codex, OpenCode) via `lms-launch`, NVIDIA CUDA and Metal GPU support
- [**agentic-ollama**](./agentic-ollama) - Ollama with integrated CLI coding tools (Claude Code, Codex, OpenCode, OpenClaw) via `ollama launch`
- [**comfyui-complete**](./comfyui-complete) - ComfyUI image generation with custom nodes, CUDA/MPS support
- [**llamacpp**](./llamacpp) - Production llama.cpp inference server for GGUF models with GPU offload and OpenAI-compatible API **(x86_64-linux only)**
- [**lmstudio**](./lmstudio) - LM Studio local LLM inference server with OpenAI/Anthropic-compatible API, NVIDIA CUDA and Metal GPU support
- [**nvidia-triton**](./nvidia-triton) - NVIDIA Triton Inference Server with Python, ONNX, vLLM, and TensorRT backends **(x86_64-linux only)**
- [**ollama**](./ollama) - Headless Ollama environment for local LLM inference with CUDA/GPU support
- [**open-webui**](./open-webui) - Backend-agnostic Open WebUI frontend for any OpenAI-compatible server (vLLM, SGLang, Triton, llama.cpp, Ollama)
- [**open-webui-with-ollama**](./open-webui-with-ollama) - Open WebUI bundled with Ollama for a turnkey local LLM chat experience
- [**sglang**](./sglang) - Production SGLang inference server with CUDA, multi-GPU tensor parallelism **(x86_64-linux only)**
- [**vllm**](./vllm) - Production vLLM inference server with CUDA, OpenAI-compatible API **(x86_64-linux only)**

### Developer Tools

- [**agent-browser**](./agent-browser) - Vercel's headless browser automation CLI and MCP server for AI agents, with Nix Chromium on Linux
- [**agent-deck**](./agent-deck) - Terminal command center for running many coding agent sessions in tmux, with an optional web UI
- [**agnix**](./agnix) - Linter and auto-fixer for agent configs (skills, CLAUDE.md/AGENTS.md, hooks, MCP, subagents) across Claude Code, Codex, Cursor, and more
- [**backlog-md**](./backlog-md) - Markdown-native task manager and Kanban board with MCP integration
- [**catnip**](./catnip) - Multi-agent orchestration for running multiple Claude Code sessions in parallel
- [**ccusage**](./ccusage) - Token usage and cost reports from local coding agent logs (Claude Code, Codex, pi, and more), plus a Claude Code status line
- [**claudebox**](./claudebox) - Lightweight sandbox wrapper for Claude Code with command transparency
- [**claude-squad**](./claude-squad) - TUI for managing multiple AI coding agents in parallel with tmux isolation
- [**codeburn**](./codeburn) - Dashboard for AI coding token usage and costs across 40+ agents, from local session logs
- [**coderabbit-cli**](./coderabbit-cli) - AI-powered code review tool for the terminal
- [**codex-monitor**](./codex-monitor) - Desktop app for orchestrating multiple Codex AI agents across workspaces
- [**openspec**](./openspec) - Lightweight spec framework for spec-driven development with AI assistants
- [**sandbox-runtime**](./sandbox-runtime) - Anthropic's lightweight filesystem and network sandbox (srt) for agents, MCP servers, and commands
- [**sfw**](./sfw) - Socket Firewall Free: blocks known-malicious npm, PyPI, and crates packages, transparently wrapping package managers for agents
- [**spec-kit**](./spec-kit) - Spec-driven development framework for AI coding agents
- [**toad**](./toad) - Toad unified TUI for AI coding agents by Will McGugan (Rich/Textual)
- [**vibe-kanban**](./vibe-kanban) - Kanban board that runs coding agents in isolated git worktrees, as a background service
- [**worktrunk**](./worktrunk) - Git worktree manager for running coding agents in parallel, with shell integration loaded on activation

### MCP and Integration

- [**basic-memory**](./basic-memory) - Local-first agent memory: Markdown notes, knowledge graph, and semantic search over MCP
- [**claude-code-acp**](./claude-code-acp) - Agent Client Protocol adapter for Claude Code
- [**codex-acp**](./codex-acp) - Agent Client Protocol adapter for OpenAI Codex
- [**mcphost**](./mcphost) - CLI host for LLM interaction with external tools via Model Context Protocol
- [**serena**](./serena) - MCP server giving coding agents IDE-grade semantic code tools via language servers

## How It Works

Each environment is a directory with a `.flox/env/manifest.toml` that declares everything the tool needs:

```
tool-name/
├── .flox/env/
│   ├── manifest.toml    # Packages, services, hooks, config
│   └── manifest.lock    # Pinned versions for reproducibility
└── README.md            # Tool-specific docs
```

When you run `flox activate`:

1. **Packages** are made available on your PATH (from the Nix store -- nothing installed globally)
2. **Hooks** run setup logic (create venvs, check API keys, initialize databases)
3. **Profile functions** are loaded (helper commands like `tool-info`, `tool-update`)
4. **Services** start if you used `flox activate -s` (inference servers, databases, gateways)

When you `exit`, everything stops. The Nix store retains cached packages for fast re-activation, but nothing runs in the background and nothing pollutes your system. Two exceptions are deliberate: [agent-deck](./agent-deck) keeps agent sessions running in tmux after you leave, and [agent-browser](./agent-browser)'s browser daemon exits after an hour idle (or on `agent-browser close`).

## Composing Environments

Environments can be combined. Add infrastructure backends to coding tools via `[include]` in the manifest:

```toml
# Example: AI coding tool + local Ollama + PostgreSQL
[include]
environments = [
  { remote = "flox/ollama" },
  { remote = "floxrox/postgres-headless" },
]
```

Or layer at runtime:

```bash
flox activate -r floxrox/postgres-headless
```

Additional composable environments are available from the [floxrox catalog](https://github.com/barstoolbluz/floxenvs) -- databases, container runtimes, workflow orchestrators, Python versions, and more.

## Conventions

- **API keys** stay in `$HOME` (e.g., `~/.config/`, env vars). Never stored in project directories.
- **Services** use non-standard ports to avoid conflicts (e.g., PostgreSQL on 15432).
- **Helper functions** follow the pattern `tool-info` (show config) and `tool-update` (update the tool).
- **All environments** run on macOS (Apple Silicon) and Linux (x86/ARM) unless noted. Intel Macs (`x86_64-darwin`) are not supported: nixpkgs no longer builds most packages for that platform.

## For AI Agents

This repository includes [FLOX.md](./FLOX.md) -- a reference guide for AI agents working with Flox environments. Covers manifest authoring, service configuration, package resolution, and language-specific patterns.

Several environments (claude-code, codewhale, codex, copilot-cli, crush, gemini-cli, mistral-vibe, pi, agentic-ollama, agentic-lmstudio) also ship the [Flox skills](https://github.com/flox/flox-skills) -- `flox`, `floxify`, and `flox-debug` -- via the `flox/skills-flox` package, so the agent can create, onboard, and debug Flox environments on its own. These replace the deprecated Flox MCP server.

## Prerequisites

- [Flox](https://flox.dev/get) installed
- API keys for your chosen providers (set as environment variables)

## Attribution

Each tool is developed and maintained by its respective upstream project. See individual environment READMEs for upstream links, licenses, and documentation.

## License

Flox environment configurations: As-is, no warranty. Individual tools: see respective upstream licenses.

# AI Coding Tools - Flox Environments

A collection of Flox environments for AI-powered coding tools and CLI interfaces to large language models. Each environment provides a pre-configured setup for its respective tool.

## Overview

This repository contains Flox environment configurations for various AI coding assistants, code generation tools, and LLM CLI interfaces. These environments handle package dependencies and provide activation hooks with setup guidance.

Each environment:
- Defines dependencies in `manifest.toml`
- Runs on macOS (Intel/ARM) and Linux (x86/ARM)
- Provides activation messages with usage instructions
- Follows Flox conventions for configuration (secrets in `$HOME`)

## Working with Flox Environments

This repository includes [FLOX.md](./FLOX.md) - a reference guide for AI agents and developers working with Flox environments. Similar to CLAUDE.md or other agent-specific instruction files, FLOX.md provides structured guidance for:

- Creating and modifying manifest files
- Installing packages and resolving conflicts
- Configuring services and background processes
- Building and publishing packages
- Composing and layering environments
- Language-specific development patterns (Python, C/C++, Node.js, CUDA)
- Platform-specific considerations and troubleshooting

AI agents should consult FLOX.md when performing environment management tasks.

## Available Environments

### AI Coding Agents

- [**aider**](./aider) - Aider AI pair programming with multi-provider support (Anthropic, OpenAI, Ollama, etc.)
- [**amazon-q-cli**](./amazon-q-cli) - Amazon Q Developer CLI (Claude Sonnet 4)
- [**amp**](./amp) - Amp frontier coding agent for the terminal
- [**antigravity**](./antigravity) - Google Antigravity agent-first IDE with multi-agent orchestration and Gemini integration
- [**claude-code**](./claude-code) - Anthropic Claude Code CLI coding agent
- [**claurst**](./claurst) - Claurst multi-provider terminal coding agent built in Rust
- [**cline**](./cline) - Cline autonomous AI coding agent with multi-provider support and browser automation
- [**code**](./code) - Every Code fast local coding agent with multi-agent orchestration
- [**codex**](./codex) - OpenAI Codex CLI coding agent
- [**copilot-cli**](./copilot-cli) - GitHub Copilot CLI
- [**crush**](./crush) - Crush AI coding agent for the terminal by Charm
- [**cursor-agent**](./cursor-agent) - Cursor Agent CLI
- [**droid**](./droid) - Factory Droid AI software development agent
- [**eca**](./eca) - Emerge Cognitive Architecture AI pair programming assistant
- [**forge**](./forge) - Forge AI coding agent by Antinomy
- [**gemini-cli**](./gemini-cli) - Google Gemini CLI coding agent
- [**goose-cli**](./goose-cli) - Goose AI coding agent
- [**ironclaw**](./ironclaw) - IronClaw secure personal AI assistant in Rust with WASM sandboxing and pgvector memory
- [**kilocode-cli**](./kilocode-cli) - Kilocode open-source AI coding agent with multi-modal workflows
- [**kiro**](./kiro) - Agentic AI development platform (IDE + CLI) with spec-driven development
- [**mux**](./mux) - Mux parallel agentic development with multi-provider support and isolated workspaces
- [**nanobot**](./nanobot) - Nanobot ultra-lightweight personal AI agent with multi-channel chat and persistent memory
- [**nanocoder**](./nanocoder) - Nanocoder local-first CLI coding agent with multi-provider support
- [**openclaw**](./openclaw) - OpenClaw self-hosted AI assistant/agent
- [**opencode**](./opencode) - OpenCode AI coding agent with TUI
- [**qwen-code**](./qwen-code) - Qwen code model CLI
- [**ruflo**](./ruflo) - Ruflo multi-agent AI orchestration platform for Claude Code with self-learning swarms
- [**zeroclaw**](./zeroclaw) - Zeroclaw personal AI assistant infrastructure in Rust with multi-channel messaging and 70+ tools

### LLM CLI Interfaces

- [**aichat**](./aichat) - Multi-provider LLM CLI (OpenAI, Claude, Gemini, Ollama, Groq, Azure, Bedrock, etc.)
- [**gpt4all**](./gpt4all) - GPT4All local LLM interface

### Local AI/ML Infrastructure

- [**agentic-ollama**](./agentic-ollama) - Ollama for agentic development: local LLM server with integrated CLI coding tools (Claude Code, Codex, OpenCode, OpenClaw\*) via `ollama launch` (\*OpenClaw commented out by default in manifest)
- [**comfyui-complete**](./comfyui-complete) - ComfyUI image generation with custom nodes, CUDA/MPS support
- [**llamacpp**](./llamacpp) - Production llama.cpp inference server for GGUF models with GPU offload and OpenAI-compatible API
- [**lm-studio**](./lm-studio) - LM Studio local LLM desktop app and inference server with OpenAI/Anthropic-compatible API
- [**nvidia-triton**](./nvidia-triton) - NVIDIA Triton Inference Server with Python, ONNX, vLLM, and TensorRT backends
- [**ollama**](./ollama) - Headless Ollama environment for local LLM inference with CUDA/GPU support
- [**open-webui**](./open-webui) - Backend-agnostic Open WebUI frontend for any OpenAI-compatible server (vLLM, SGLang, Triton, llama.cpp, Ollama)
- [**open-webui-with-ollama**](./open-webui-with-ollama) - Open WebUI bundled with Ollama for a turnkey local LLM chat experience
- [**sglang**](./sglang) - Production SGLang inference server with CUDA, multi-GPU tensor parallelism
- [**vllm**](./vllm) - Production vLLM inference server with CUDA, OpenAI-compatible API

### Developer Tools

- [**backlog-md**](./backlog-md) - Markdown-native task manager and Kanban board with MCP integration
- [**catnip**](./catnip) - Multi-agent orchestration for running multiple Claude Code sessions in parallel
- [**claudebox**](./claudebox) - Lightweight sandbox wrapper for Claude Code with command transparency
- [**coderabbit-cli**](./coderabbit-cli) - AI-powered code review tool for the terminal
- [**spec-kit**](./spec-kit) - Spec-driven development framework for AI coding agents
- [**toad**](./toad) - Toad unified TUI for AI coding agents by Will McGugan (Rich/Textual)

### MCP and Integration

- [**claude-code-acp**](./claude-code-acp) - Agent Client Protocol adapter for Claude Code
- [**claude-code-router**](./claude-code-router) - Middleware proxy routing Claude Code requests to multiple AI providers
- [**codex-acp**](./codex-acp) - Agent Client Protocol adapter for OpenAI Codex
- [**flox-mcp-server**](./flox-mcp-server) - MCP server enabling AI assistants to manage Flox environments
- [**mcphost**](./mcphost) - CLI host for LLM interaction with external tools via Model Context Protocol

## Usage

### Prerequisites

- [Flox](https://flox.dev/get) installed
- API keys for chosen providers (stored in `$HOME` per Flox conventions)

### Basic Usage

```bash
# Clone repository
git clone https://github.com/barstoolbluz/agentic-development-with-flox
cd agentic-development-with-flox

# Navigate to an environment
cd aichat

# Activate environment
flox activate

# Follow activation messages for tool-specific setup
```

### Example: aichat

```bash
cd aichat
flox activate
# First-time users: run 'aichat' and follow interactive setup
aichat "Write a Python function to validate email addresses"
```

### Example: amazon-q-cli

```bash
cd amazon-q-cli
flox activate
q login      # Authenticate with AWS Builder ID
q chat       # Start chat session
```

## Environment Structure

Each environment directory contains:

```
environment-name/
├── .flox/
│   └── env/
│       ├── manifest.toml    # Package dependencies and configuration
│       └── manifest.lock    # Locked package versions
└── README.md                # Tool-specific documentation
```

The `manifest.toml` file defines:
- Package dependencies
- Environment variables (non-secret)
- Activation hooks (setup checks, usage messages)
- Shell profile customizations

## Composable Development Environments

AI coding tools frequently generate code requiring backend infrastructure. This repository includes several local AI/ML infrastructure environments that can be composed with the coding tools:

### Included Infrastructure Environments

**Local LLM Serving**
- **ollama** - Headless Ollama for local LLM inference with CUDA/GPU support
- **agentic-ollama** - Ollama for agentic development with integrated CLI coding tools and GPU acceleration
- **vllm** - Production vLLM inference server with CUDA and OpenAI-compatible API
- **sglang** - Production SGLang inference server with multi-GPU tensor parallelism
- **llamacpp** - Production llama.cpp server for GGUF models with GPU offload
- **nvidia-triton** - NVIDIA Triton Inference Server with Python, ONNX, vLLM, and TensorRT backends
- **lm-studio** - LM Studio local LLM app and inference server with OpenAI/Anthropic-compatible API
- **gpt4all** - CPU-optimized local LLM inference

**Web Interfaces**
- **open-webui** - Backend-agnostic Open WebUI frontend (vLLM, SGLang, Triton, llama.cpp, Ollama)
- **open-webui-with-ollama** - Open WebUI bundled with Ollama for turnkey local LLM chat
- **comfyui-complete** - ComfyUI image generation with 22 custom nodes, CUDA/MPS support

**MCP Infrastructure**
- **mcphost** - Model Context Protocol host for AI agent communication

These can be activated directly or composed with coding environments:

```bash
# Run Ollama for local inference with agentic tools
cd agentic-ollama && flox activate -s

# Layer with AI coding tools
cd ../aichat
flox activate -- cd ../agentic-ollama && flox activate
```

### Additional environments from floxrox catalog

The following environments from the [floxrox catalog](https://github.com/barstoolbluz/floxenvs) can also be composed with AI coding environments:

### Available via `floxrox/<environment-name>`

**Databases (headless)**
- `postgres-headless`, `mysql-headless`, `mariadb-headless` - Relational databases
- `redis-headless` - In-memory data store
- `neo4j-headless` - Graph database

**AI/ML Infrastructure**
- `ollama-headless` - Local LLM inference with CUDA support
- `jupyterlab-headless` - Notebook environment for data analysis
- `open-webui` - Web interface for Ollama (includes ollama-headless)

**Container and Orchestration**
- `kind-headless` - Kubernetes in Docker for local cluster testing
- `colima-headless` - Docker-compatible container runtime

**Workflow Orchestration**
- `airflow-local-dev`, `airflow-k8s-executor`, `airflow-stack` - Apache Airflow
- `dagster-headless` - Dagster orchestration platform
- `prefect-headless` - Prefect workflow automation
- `temporal-headless`, `temporal-ui` - Temporal workflow engine
- `n8n-headless` - n8n workflow automation

**Python Development**
- `python310`, `python311`, `python312`, `python313` - Python versions with venv management

**CLI Tools**
- `xplatform-cli-tools` - AWS CLI, GitHub CLI, Git with 1Password integration

### Composition Methods

**Via manifest includes:**
```toml
[include]
environments = [
  { owner = "floxrox", name = "postgres-headless" },
  { owner = "floxrox", name = "redis-headless" }
]
```

**Via runtime configuration:**
```bash
# Headless environments accept environment variable overrides
PGPORT=5432 PGUSER=admin REDIS_PORT=6379 flox activate -s
```

**Transitive composition example (airflow-stack):**
```toml
# airflow-stack includes airflow-local-dev and airflow-k8s-executor
# which transitively include postgres-headless, redis-headless, kind-headless
[include]
environments = [
  { remote = "barstoolbluz/airflow-local-dev" },
  { remote = "barstoolbluz/airflow-k8s-executor" }
]

[hook]
on-activate = '''
# Override inherited environment variables for production tuning
export POSTGRES_MAX_CONNECTIONS="200"
export REDIS_MAXMEMORY="1gb"
export AIRFLOW_CELERY_WORKERS="4"
'''
```

### Configuration Pattern

All headless environments follow a consistent pattern:
- Runtime configuration via environment variables with defaults (`${VAR:-default}`)
- Service-based execution (`flox activate -s`)
- Non-standard ports to avoid conflicts (PostgreSQL: 15432, Redis: 16379)
- Configuration inspection via `<service>-info` shell functions

This pattern enables programmatic configuration by AI agents and composition without manual intervention.

### Layering vs Composition

Flox supports two distinct environment combination patterns:

**Layering (Runtime)**
- Activation-time stacking: `flox activate -r floxrox/postgres-headless`
- Sequential execution - later layers override earlier layers
- Preserves subshell boundaries between environments
- Conflicts surface at runtime
- Use case: Ad-hoc development tools, debugging overlays

**Composition (Build-time)**
- Declarative merging via `[include]` in manifest
- Deterministic - environments merge into single namespace
- Conflicts surface at manifest evaluation
- Transitive - includes are recursive
- Use case: Repeatable, shareable infrastructure stacks

**Example - Layering for ad-hoc debugging:**
```bash
# Stack debugging tools on top of AI coding environment
cd aichat
flox activate -r floxrox/postgres-headless
# PostgreSQL available for testing AI-generated database code
```

**Example - Composition for repeatable stack:**
```toml
# AI coding environment with persistent database backend
[include]
environments = [
  { owner = "floxrox", name = "postgres-headless" }
]

[hook]
on-activate = '''
# Customize inherited PostgreSQL configuration
export PGDATABASE="ai_generated_app"
export POSTGRES_MAX_CONNECTIONS="50"
'''
```

Both patterns support environment variable overrides. Composition allows modification of inherited variables via hooks, while layering relies on the order of activation.

## Security Conventions

Per Flox best practices:

- **API keys and credentials**: Must reside in `$HOME` (e.g., `~/.config/`, `~/.aws/`)
- **Environment variables**: Preferred configuration method for secrets
- **Project directories**: May contain non-secret configuration; must not contain credentials
- **`.gitignore`**: Ensures credential files are excluded from version control

## System Requirements

- macOS (Intel/ARM) or Linux (x86/ARM)
- Flox package manager
- Internet connection for LLM API access
- Valid API keys for chosen providers

## Flox Overview

[Flox](https://flox.dev/docs) provides:

- **Declarative environments** - Dependencies and configuration in TOML
- **Reproducibility** - Consistent environments across systems
- **Package isolation** - No conflicts between project dependencies
- **Nixpkgs integration** - Access to 150,000+ packages

## Attribution

Each tool is developed and maintained by its respective upstream project. See individual environment READMEs for:
- Upstream project links
- Original author/maintainer attribution
- Tool-specific licenses
- Official documentation

Flox environment configurations in this repository are provided as-is.

## License

Flox environment configurations: As-is, no warranty

Individual tools: See respective upstream licenses in environment READMEs

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

This repository includes [FLOX.md](./floxenvs/FLOX.md) - a reference guide for AI agents and developers working with Flox environments. Similar to CLAUDE.md or other agent-specific instruction files, FLOX.md provides structured guidance for:

- Creating and modifying manifest files
- Installing packages and resolving conflicts
- Configuring services and background processes
- Building and publishing packages
- Composing and layering environments
- Language-specific development patterns (Python, C/C++, Node.js, CUDA)
- Platform-specific considerations and troubleshooting

AI agents should consult FLOX.md when performing environment management tasks.

## Available Environments

### LLM CLI Interfaces

- [**aichat**](./aichat) - Multi-provider LLM CLI (OpenAI, Claude, Gemini, Ollama, Groq, Azure, Bedrock, etc.)
- [**gemini-cli**](./gemini-cli) - Google Gemini CLI interface
- [**gpt4all**](./gpt4all) - GPT4All local LLM interface

### AI Coding Tools

- [**amazon-q-cli**](./amazon-q-cli) - Amazon Q Developer CLI (Claude Sonnet 4)
- [**copilot-cli**](./copilot-cli) - GitHub Copilot CLI
- [**opencode**](./opencode) - OpenCode AI coding agent with TUI
- [**goose-cli**](./goose-cli) - Goose AI coding agent
- [**cursor-agent**](./cursor-agent) - Cursor Agent CLI
- [**kilocode-cli**](./kilocode-cli) - Kilocode CLI
- [**nanocoder**](./nanocoder) - Nanocoder tool
- [**qwen-code**](./qwen-code) - Qwen code model CLI
- [**eca**](./eca) - Emerge Cognitive Architecture
- [**groq-code-cli**](./groq-code-cli) - Groq-powered coding CLI
- [**forge**](./forge) - Forge development tool
- [**kiro**](./kiro) - Agentic AI development platform (IDE + CLI) with spec-driven development
- [**coderabbit-cli**](./coderabbit-cli) - CodeRabbit code review tool

### Local AI/ML Infrastructure

- [**ollama**](./ollama) - Local LLM inference server with GPU/CUDA support
- [**open-webui**](./open-webui) - Feature-rich web UI for LLMs (Ollama, OpenAI)
- [**comfyui**](./comfyui) - Node-based UI for Stable Diffusion workflows
- [**vllm**](./vllm) - High-throughput LLM serving engine

### Supporting Tools

- [**flox-mcp-server**](./flox-mcp-server) - MCP server enabling AI assistants to manage Flox environments
- [**mcphost**](./mcphost) - MCP host environment
- [**claude-code**](./claude-code) - Claude Code environment
- [**claude-code-router**](./claude-code-router) - Claude Code router
- [**claude-code-acp**](./claude-code-acp) - Claude Code with ACP
- [**codex**](./codex) - OpenAI Codex environment
- [**codex-acp**](./codex-acp) - Codex with ACP
- [**spec-kit**](./spec-kit) - GitHub Spec Kit
- [**amp**](./amp) - Amp environment
- [**crush**](./crush) - Crush tool
- [**droid**](./droid) - Droid assistant
- [**catnip**](./catnip) - Catnip utility
- [**code**](./code) - Code environment
- [**claudebox**](./claudebox) - Claude sandbox
- [**backlog-md**](./backlog-md) - Markdown backlog tool

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
- **ollama** - Run Llama, Mistral, CodeLlama and other models locally with GPU acceleration
- **vllm** - Production-grade LLM serving with optimized throughput
- **gpt4all** - CPU-optimized local LLM inference

**Web Interfaces**
- **open-webui** - Full-featured chat interface for local and remote LLMs
- **comfyui** - Visual workflow builder for Stable Diffusion and image generation

**MCP Infrastructure**
- **mcphost** - Model Context Protocol host for AI agent communication

These can be activated directly or composed with coding environments:

```bash
# Run Ollama for local inference
cd ollama && flox activate -s

# Layer with AI coding tools
cd ../aichat
flox activate -- cd ../ollama && flox activate
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

# 🤖 Flox Environment for AIChat

A Flox environment for [AIChat](https://github.com/sigoden/aichat), an all-in-one LLM CLI tool that brings conversational AI to your terminal. AIChat supports 20+ LLM providers (OpenAI, Claude, Gemini, Ollama, Groq, Azure, Bedrock, and more), enabling powerful workflows like shell assistance, code generation, RAG (Retrieval-Augmented Generation), AI tools, agents, and context-aware sessions.

## ✨ Features

- **20+ LLM providers**: OpenAI, Claude, Gemini, Ollama, Groq, Azure OpenAI, AWS Bedrock, Cohere, Perplexity, Mistral, and more
- **Shell Assistant**: Convert natural language to shell commands with automatic execution
- **Interactive Chat REPL**: Tab completion, command history, vi/emacs keybindings
- **RAG (Retrieval-Augmented Generation)**: Integrate documents and codebases into conversations
- **AI Tools & Agents**: Function calling for executing code, searching web, running commands
- **Roles system**: Custom prompts and personas defined in `roles.yaml`
- **Session management**: Resume context-aware conversations across terminals
- **Code generation**: Generate, explain, and refactor code in any language
- **Multi-modal support**: Text, images, and vision capabilities (provider-dependent)
- **Streaming responses**: Real-time output as the model generates
- **Markdown rendering**: Beautiful terminal output with syntax highlighting
- **File integration**: Include files in prompts with `.file` command
- **Command execution**: Execute generated shell commands directly from REPL

## 🧰 Included Tools

The environment includes:

- `aichat` - All-in-one LLM CLI tool
- `jq` - JSON processor for configuration management
- `curl` - For API testing and debugging

## 🏁 Getting Started

### 📋 Prerequisites

- [Flox](https://flox.dev/get) installed on your system
- API key for at least one LLM provider (OpenAI, Claude, etc.)
- Internet connection for API access

### 💻 Installation & Activation

Get started with:

```sh
# Clone the repo
git clone https://github.com/yourusername/agentic-development-with-flox && cd agentic-development-with-flox/aichat

# Activate the environment
flox activate
```

### 🔐 First-Time Setup

**Configuration Location:**

AIChat stores configuration in `~/.config/aichat/` in your home directory (following security best practices).

**⚠️ CRITICAL - Flox Security Convention:**
Config files with API keys MUST be in `$HOME` (`~/.config/aichat/`), **NEVER in project directories**.

**Initial Configuration:**

```bash
# First run creates configuration directory
aichat

# AIChat will prompt you to select a provider
# Choose your preferred LLM provider (e.g., OpenAI, Claude, etc.)

# Exit (Ctrl+C or Ctrl+D)
```

**Provider Setup Examples:**

**Option 1: OpenAI**

```bash
# Set API key via environment variable (recommended)
export OPENAI_API_KEY="sk-your-api-key-here"

# Or configure in config.yaml
cat > ~/.config/aichat/config.yaml <<'EOF'
model: openai:gpt-4
clients:
  - type: openai
    api_key: sk-your-api-key-here
EOF

# Test connection
aichat "Hello, world!"
```

**Option 2: Anthropic Claude**

```bash
# Set API key via environment variable
export ANTHROPIC_API_KEY="sk-ant-your-api-key-here"

# Or configure in config.yaml
cat > ~/.config/aichat/config.yaml <<'EOF'
model: claude:claude-3-5-sonnet-20241022
clients:
  - type: claude
    api_key: sk-ant-your-api-key-here
EOF

# Test connection
aichat "Explain what you can do"
```

**Option 3: Ollama (Local)**

```bash
# No API key needed - runs locally
cat > ~/.config/aichat/config.yaml <<'EOF'
model: ollama:llama3.2
clients:
  - type: ollama
    api_base: http://localhost:11434
EOF

# Ensure Ollama is running
# ollama serve

# Test connection
aichat "Hello from Ollama!"
```

**Option 4: Google Gemini**

```bash
# Set API key via environment variable
export GEMINI_API_KEY="your-gemini-api-key-here"

# Or configure in config.yaml
cat > ~/.config/aichat/config.yaml <<'EOF'
model: gemini:gemini-1.5-pro
clients:
  - type: gemini
    api_key: your-gemini-api-key-here
EOF

# Test connection
aichat "What models do you support?"
```

**Environment Variables for API Keys (Recommended):**

Add to your shell profile (`~/.bashrc`, `~/.zshrc`, etc.):

```bash
# OpenAI
export OPENAI_API_KEY="sk-..."

# Anthropic Claude
export ANTHROPIC_API_KEY="sk-ant-..."

# Google Gemini
export GEMINI_API_KEY="..."

# Groq
export GROQ_API_KEY="gsk_..."

# Cohere
export COHERE_API_KEY="..."

# Mistral
export MISTRAL_API_KEY="..."
```

## 📝 Usage

### Interactive REPL Mode

Start an interactive chat session:

```bash
# Start REPL
aichat

# Example interactions:
You> How do I list all running Docker containers?

AI> To list all running Docker containers, use:
    docker ps

    For all containers (including stopped):
    docker ps -a

You> .role code

AI> Role set to 'code'. I'll focus on code generation and analysis.

You> Write a Python function to validate email addresses

AI> [generates complete function with regex validation and tests]

# Exit with Ctrl+C, Ctrl+D, or type .exit
```

**REPL Commands:**

```bash
.role <name>              # Switch to a different role
.info                     # Show current session info
.model <name>             # Change the model
.prompt <text>            # Set custom system prompt
.session [name]           # Start/resume a session
.save <file>              # Save conversation to file
.file <path>              # Include file contents in conversation
.rag <path>               # Add documents to RAG context
.clear                    # Clear conversation history
.edit                     # Open editor for multi-line input
.exit                     # Exit the REPL
```

### One-Shot Mode

Execute single commands without entering REPL:

```bash
# Simple query
aichat "What is the capital of France?"

# Code generation
aichat "Write a bash script to backup a directory"

# With role
aichat -r code "Implement quicksort in Python"

# With file context
aichat -f main.py "Explain what this code does"

# Execute mode (auto-run shell commands)
aichat -e "find all PDF files modified in the last week"
```

### Shell Assistant Mode

Convert natural language to shell commands:

```bash
# Execute mode - AIChat suggests and optionally runs commands
aichat -e "find all large files over 100MB"

# AIChat suggests:
# find . -type f -size +100M
# Execute? [y/N]: y

# More examples
aichat -e "compress all log files in /var/log"
aichat -e "kill all processes using port 8080"
aichat -e "show disk usage sorted by size"
aichat -e "find and delete all node_modules folders"
```

### Code Mode

Generate code with syntax highlighting:

```bash
# Code generation
aichat -c "Python function to parse JSON"

# With language specification
aichat -c "rust function to read a file"

# Refactoring
aichat -c -f old_code.py "Refactor this to use async/await"
```

### Roles System

Use predefined or custom roles for specialized tasks:

```bash
# List available roles
aichat --list-roles

# Use a role in one-shot mode
aichat -r emoji "translate this text to emojis: Hello world"

# Use a role in REPL
aichat
You> .role shell
AI> Role set to 'shell'. I'll help with shell commands and scripts.
You> How do I monitor CPU usage in real-time?
```

**Create Custom Roles:**

Edit `~/.config/aichat/roles.yaml`:

```yaml
# Flox Expert Role
- name: flox
  prompt: |
    You are an expert in Flox package management and declarative development environments.

    Key principles:
    - Use Flox for reproducible environments
    - Prefer `flox install` over system package managers
    - Keep environments declarative with manifest.toml
    - Use environment variables for configuration
    - Follow Flox security conventions (secrets in $HOME)

    When helping with Flox:
    1. Always check for .flox/ directory first
    2. Recommend Flox-based solutions
    3. Explain the benefits of declarative environments
    4. Reference Flox documentation when appropriate

# Code Reviewer Role
- name: reviewer
  prompt: |
    You are a senior code reviewer focused on:
    - Code quality and maintainability
    - Security vulnerabilities
    - Performance issues
    - Best practices and idioms
    - Test coverage

    Provide constructive feedback with examples.

# Documentation Writer Role
- name: docs
  prompt: |
    You are a technical documentation expert.
    Write clear, comprehensive documentation including:
    - Overview and purpose
    - Installation instructions
    - Usage examples
    - API reference
    - Troubleshooting guides

    Use Markdown formatting with code examples.

# DevOps Expert Role
- name: devops
  prompt: |
    You are a DevOps engineer specializing in:
    - CI/CD pipelines
    - Container orchestration (Docker, Kubernetes)
    - Infrastructure as Code (Terraform, Ansible)
    - Monitoring and observability
    - Cloud platforms (AWS, GCP, Azure)

    Provide production-ready solutions with security in mind.
```

**Use Custom Roles:**

```bash
# Use Flox expert role
aichat -r flox "How do I add Python to my environment?"

# Use reviewer role
aichat -r reviewer -f app.py "Review this code"

# Use docs role
aichat -r docs "Generate API documentation for this REST service"

# Use DevOps role
aichat -r devops "Create a GitHub Actions workflow for testing"
```

### Session Management

Persistent conversations with context:

```bash
# Start a named session
aichat -s project-alpha
You> I'm working on a REST API with authentication
AI> Great! I'll help you build that. What framework are you using?

# Exit and resume later
aichat -s project-alpha
You> Continue with the JWT implementation
AI> [picks up context from previous conversation]

# List all sessions
ls ~/.config/aichat/sessions/

# Clear a session
rm ~/.config/aichat/sessions/project-alpha.yaml
```

### RAG (Retrieval-Augmented Generation)

Integrate documents and code into conversations:

```bash
# Start AIChat REPL
aichat

# Add documentation to RAG context
You> .rag /path/to/docs

# AIChat indexes the documents
AI> RAG context updated with 150 documents

# Ask questions about the documents
You> What does the authentication module do?
AI> [answers based on indexed documentation]

# Add source code
You> .rag /path/to/src

# Ask about implementation
You> How is user validation implemented?
AI> [references actual code from indexed files]
```

**RAG with One-Shot:**

```bash
# Create RAG context file
cat > ~/.config/aichat/rag.yaml <<'EOF'
sources:
  - /home/user/projects/myapp/docs
  - /home/user/projects/myapp/src
EOF

# Query with RAG context
aichat --rag "Explain the database schema design"
```

### File Integration

Include file contents in prompts:

```bash
# Include single file
aichat -f main.py "Add error handling to this code"

# Multiple files
aichat -f main.py -f utils.py "Refactor these modules"

# From REPL
aichat
You> .file config.yaml
You> Explain this configuration
```

### Multi-Modal (Vision)

Use images with supported models:

```bash
# Analyze an image
aichat -f screenshot.png "What's in this image?"

# With code
aichat -f diagram.png -f code.py "Does this code match the architecture diagram?"

# From REPL
You> .file architecture.png
You> .file implementation.py
You> Verify the implementation matches the architecture
```

## 🔧 Configuration

### Configuration Files

AIChat uses a hierarchical configuration system:

**⚠️ IMPORTANT - Flox Security Convention:**
Config files containing API keys MUST be in `$HOME` (`~/.config/aichat/`), **NEVER in project directories**.

**Global config** (for credentials and defaults):
```
~/.config/aichat/
├── config.yaml           # Main configuration (API keys, model settings)
├── roles.yaml            # Custom roles and prompts
├── rag.yaml              # RAG sources (optional)
├── sessions/             # Saved sessions
│   ├── project-a.yaml
│   └── debugging.yaml
└── cache/                # Response cache (optional)
```

### config.yaml Structure

**Minimal configuration:**

```yaml
model: openai:gpt-4
```

**Comprehensive configuration:**

```yaml
# Default model (format: provider:model-name)
model: claude:claude-3-5-sonnet-20241022

# Stream responses in real-time
stream: true

# Save conversation history
save: true

# Markdown rendering in terminal
highlight: true

# Enable keybindings (vi or emacs)
keybindings: vi

# Temperature (0.0 = deterministic, 1.0 = creative)
temperature: 0.7

# Token limits
max_output_tokens: 4096

# LLM Provider Clients
clients:
  # OpenAI
  - type: openai
    api_key: sk-...
    # api_base: https://api.openai.com/v1  # Optional: custom endpoint
    # organization_id: org-...              # Optional: organization

  # Anthropic Claude
  - type: claude
    api_key: sk-ant-...
    # api_base: https://api.anthropic.com   # Optional: custom endpoint

  # Google Gemini
  - type: gemini
    api_key: ...

  # Ollama (Local)
  - type: ollama
    api_base: http://localhost:11434

  # Groq
  - type: groq
    api_key: gsk_...

  # Azure OpenAI
  - type: azure-openai
    api_base: https://YOUR-RESOURCE.openai.azure.com
    api_key: ...
    deployment_id: gpt-4

  # AWS Bedrock
  - type: bedrock
    access_key_id: AKIA...
    secret_access_key: ...
    region: us-east-1

# Function calling / Tools
function_calling: true

# RAG settings
rag:
  enabled: true
  chunk_size: 1000
  chunk_overlap: 200

# Proxy settings (optional)
# proxy: http://localhost:8080

# Custom prompts
# system_prompt: "You are a helpful assistant."
```

**Using environment variables in config.yaml:**

```yaml
model: openai:gpt-4

clients:
  - type: openai
    api_key: ${OPENAI_API_KEY}

  - type: claude
    api_key: ${ANTHROPIC_API_KEY}

  - type: gemini
    api_key: ${GEMINI_API_KEY}
```

### roles.yaml Structure

Define custom personas and prompts:

```yaml
# Simple role
- name: pirate
  prompt: "Talk like a pirate in all responses. Use pirate vocabulary and expressions."

# Role with temperature
- name: creative-writer
  prompt: "You are a creative writer specializing in fiction and storytelling."
  temperature: 0.9

# Role with specific model
- name: code-reviewer
  prompt: |
    You are a senior software engineer conducting code reviews.
    Focus on:
    - Code quality and readability
    - Security vulnerabilities
    - Performance optimization
    - Best practices
    - Test coverage

    Provide specific, actionable feedback with examples.
  model: claude:claude-3-5-sonnet-20241022
  temperature: 0.3

# Role with functions/tools
- name: assistant
  prompt: "You are a helpful AI assistant with access to various tools."
  functions:
    - name: web_search
      description: "Search the web for information"
    - name: execute_code
      description: "Execute code in various languages"
```

## 🛠️ Common Workflows

### Code Development

```bash
# Generate boilerplate
aichat -r code "Create a FastAPI REST API with user authentication"

# Code review
aichat -r reviewer -f main.py "Review this code for issues"

# Refactoring
aichat -f legacy.py "Refactor this to use modern Python patterns"

# Add tests
aichat -f app.py "Generate pytest tests for this module"

# Debug
aichat -e "why is my Python script failing with ImportError?"
```

### Infrastructure & DevOps

```bash
# Dockerfile creation
aichat -r devops "Create a Dockerfile for a Node.js application"

# Kubernetes manifests
aichat "Generate Kubernetes deployment for a web app"

# CI/CD pipeline
aichat "Create a GitHub Actions workflow for Python testing"

# Terraform
aichat "Write Terraform to provision an AWS EC2 instance"

# Shell scripts
aichat -e "create a backup script for MySQL databases"
```

### Documentation

```bash
# API documentation
aichat -r docs -f api.py "Generate API documentation"

# README generation
aichat -r docs "Create a README for a Python CLI tool"

# Code comments
aichat -f complex.py "Add detailed comments explaining this code"

# Architecture docs
aichat -r docs "Document the architecture of this microservices system"
```

### Learning & Exploration

```bash
# Explain concepts
aichat "Explain Rust ownership and borrowing"

# Compare technologies
aichat "Compare PostgreSQL vs MongoDB for a social media app"

# Best practices
aichat -r devops "What are best practices for Docker security?"

# Debug errors
aichat "Why am I getting 'segmentation fault' in C++?"
```

### Data Analysis

```bash
# Generate analysis scripts
aichat -r code "Python script to analyze CSV data and plot results"

# SQL queries
aichat "Write a SQL query to find top 10 customers by revenue"

# Data transformation
aichat -f data.json "Convert this JSON to CSV format"
```

### Session-Based Development

```bash
# Start feature development session
aichat -s feature-auth
You> I need to implement JWT authentication for my API
AI> I'll help you implement JWT authentication...

# Continue later
aichat -s feature-auth
You> Add refresh token functionality
AI> [continues from previous context]

# Code review session
aichat -s code-review
You> .file pr_changes.py
You> Review these changes for the pull request
```

## 🎯 Flox-Aware Project Setup

This environment includes **Flox-aware templates** that make AIChat automatically use Flox for environment management.

### Using the Templates

**Copy template roles to your config:**

```bash
# Copy Flox-aware roles
mkdir -p ~/.config/aichat
cat $FLOX_ENV_TEMPLATES/roles/flox-aware.yaml >> ~/.config/aichat/roles.yaml

# Available Flox-aware roles:
# - flox: General Flox expertise
# - flox-dev: Flox development workflows
# - flox-pkg: Flox packaging guidance
```

**What the templates provide:**

The Flox-aware roles instruct AIChat to:

1. **Detect Flox projects** by checking for `.flox/` directory
2. **Use Flox commands** instead of system package managers
3. **Apply Flox best practices**:
   - Secrets in `$HOME`, never in project directories
   - Declarative environments with `manifest.toml`
   - Reproducible package versions
   - Environment-specific configuration
4. **Reference Flox documentation** for complex tasks
5. **Recommend Flox-based solutions** for development challenges

**Example workflow:**

```bash
# Use Flox-aware role
aichat -r flox

You> I need to set up a Python development environment

AI> I'll help you set up a Flox-based Python environment.

    First, let me check if you're in a Flox environment:

    flox list

    If not, initialize one:

    flox init

    Then add Python and common tools:

    flox install python311 python311Packages.pip
    flox install python311Packages.pytest
    flox install python311Packages.black

    This ensures everyone on your team has the exact same environment.

You> Add PostgreSQL support

AI> Add PostgreSQL to your Flox environment:

    flox install postgresql

    Then activate hooks in your manifest.toml to start the database:

    [hook]
    on-activate = '''
      export PGDATA="$FLOX_ENV_CACHE/postgres"
      [ -d "$PGDATA" ] || initdb
      pg_ctl start -l "$FLOX_ENV_CACHE/postgres.log"
    '''
```

**Integration with sessions:**

```bash
# Start Flox project session
aichat -s -r flox myproject

You> I'm starting a new web app project

AI> Great! Let me help you set up a Flox-based web app environment...
    [provides Flox-specific guidance]

# Resume later with Flox context
aichat -s myproject

You> Add Redis caching
AI> [continues with Flox-aware solutions]
```

## 🔧 Troubleshooting

### Connection Issues

**Problem:** Cannot connect to LLM provider

**Solution:**

```bash
# Check API key is set
echo $OPENAI_API_KEY

# Test with verbose output
aichat --verbose "test"

# Check configuration
cat ~/.config/aichat/config.yaml

# Verify network connectivity
curl -I https://api.openai.com

# Test with different model
aichat --model openai:gpt-3.5-turbo "test"
```

### Configuration Errors

**Problem:** AIChat won't start or shows config errors

**Solution:**

```bash
# Validate YAML syntax
cat ~/.config/aichat/config.yaml | yq .

# Check for syntax errors in roles
cat ~/.config/aichat/roles.yaml | yq .

# Reset to default config
mv ~/.config/aichat/config.yaml ~/.config/aichat/config.yaml.bak
aichat  # Will create new default config

# Check AIChat version
aichat --version

# View full error with verbose mode
aichat --verbose
```

### Role Not Found

**Problem:** Custom role not recognized

**Solution:**

```bash
# List available roles
aichat --list-roles

# Check roles file exists
ls -la ~/.config/aichat/roles.yaml

# Validate YAML syntax
cat ~/.config/aichat/roles.yaml | yq .

# Check role name spelling
grep "name:" ~/.config/aichat/roles.yaml
```

### Session Issues

**Problem:** Cannot resume session or session lost

**Solution:**

```bash
# List all sessions
ls -la ~/.config/aichat/sessions/

# Check session file
cat ~/.config/aichat/sessions/my-session.yaml

# Start fresh session
aichat -s new-session

# Clear corrupted session
rm ~/.config/aichat/sessions/problematic-session.yaml
```

### RAG Not Working

**Problem:** RAG context not including documents

**Solution:**

```bash
# Check RAG configuration
cat ~/.config/aichat/rag.yaml

# Verify file paths exist
ls -la /path/to/rag/sources

# Enable RAG explicitly
aichat --rag "query about documents"

# Check file permissions
ls -la ~/.config/aichat/cache/

# Clear RAG cache
rm -rf ~/.config/aichat/cache/rag/
```

### Slow Responses

**Problem:** AIChat responses are very slow

**Solution:**

```bash
# Use faster model
aichat --model openai:gpt-3.5-turbo "query"

# Disable streaming temporarily
aichat --no-stream "query"

# Check network latency
ping api.openai.com

# Reduce max tokens
aichat --max-tokens 1000 "query"

# Clear cache
rm -rf ~/.config/aichat/cache/
```

### API Rate Limits

**Problem:** Hitting rate limits

**Solution:**

```bash
# Use different provider
aichat --model claude:claude-3-5-sonnet-20241022 "query"

# Add delay between requests (in scripts)
aichat "query 1" && sleep 2 && aichat "query 2"

# Use local model (Ollama)
aichat --model ollama:llama3.2 "query"

# Check rate limit status
# (provider-specific, check provider dashboard)
```

### Environment Variable Issues

**Problem:** API keys not being read

**Solution:**

```bash
# Check environment variable is set
env | grep API_KEY

# Export in current shell
export OPENAI_API_KEY="sk-..."

# Add to shell profile permanently
echo 'export OPENAI_API_KEY="sk-..."' >> ~/.bashrc
source ~/.bashrc

# Use config file instead
cat > ~/.config/aichat/config.yaml <<'EOF'
clients:
  - type: openai
    api_key: sk-...
EOF
```

## 💻 System Compatibility

This environment works on:
- Linux x86_64
- Linux aarch64 (ARM64)
- macOS x86_64 (Intel)
- macOS ARM64 (Apple Silicon)

**Provider compatibility:**
- OpenAI: All platforms
- Anthropic Claude: All platforms
- Google Gemini: All platforms
- Ollama: Requires local installation
- Azure OpenAI: All platforms
- AWS Bedrock: Requires AWS credentials

## 🔒 Security Considerations

**⚠️ CRITICAL SECURITY RULES:**

- **API keys location**: MUST be in `~/.config/aichat/config.yaml` or environment variables in `$HOME`
- **NEVER commit secrets**: Don't commit `config.yaml` with API keys to version control
- **Per Flox conventions**: All secrets live in `$HOME`, **NEVER in project directories or `$FLOX_ENV_CACHE`**
- **Environment variables**: Store in `~/.bashrc`, `~/.zshrc`, or secure secret managers
- **Config file permissions**: Ensure only you can read config files

**Best Practices:**

```bash
# Secure config file permissions
chmod 600 ~/.config/aichat/config.yaml

# Use environment variables (recommended)
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="sk-ant-..."

# Never put secrets in project config files
# ✅ Good: ~/.config/aichat/config.yaml (in $HOME)
# ❌ Bad:  /project/.aichat/config.yaml (in project)
# ❌ Bad:  $FLOX_ENV_CACHE/aichat-config.yaml

# Add to .gitignore if you must have project-level config
echo ".aichat/" >> .gitignore

# Use different API keys for different projects
export PROJECT_A_API_KEY="sk-..."
aichat --config project-a-config.yaml

# Audit your configuration
cat ~/.config/aichat/config.yaml | grep -v api_key

# Rotate API keys regularly
# (generate new keys in provider dashboard)

# Monitor API usage
# (check provider dashboard for unusual activity)
```

**Data Privacy:**

- **Prompts and responses**: Sent to LLM provider (cloud) or local (Ollama)
- **Code and files**: Included in prompts when using `-f` or `.file`
- **Sessions**: Stored locally in `~/.config/aichat/sessions/`
- **RAG documents**: Indexed locally in cache
- **No telemetry**: AIChat doesn't send analytics

**Code Execution:**

- **Shell commands**: Review before executing in `-e` mode
- **Generated code**: Always review before running
- **File operations**: AIChat can read files you specify with `-f`
- **RAG indexing**: Only indexes paths you specify

## 📚 Additional Resources

- **Official Repository**: [github.com/sigoden/aichat](https://github.com/sigoden/aichat)
- **Documentation**: [github.com/sigoden/aichat/wiki](https://github.com/sigoden/aichat/wiki)
- **Configuration Guide**: [github.com/sigoden/aichat/blob/main/config.example.yaml](https://github.com/sigoden/aichat/blob/main/config.example.yaml)
- **Roles Examples**: [github.com/sigoden/aichat/blob/main/roles.yaml](https://github.com/sigoden/aichat/blob/main/roles.yaml)
- **Issue Tracker**: [github.com/sigoden/aichat/issues](https://github.com/sigoden/aichat/issues)
- **Flox Documentation**: [flox.dev/docs](https://flox.dev/docs)

**LLM Provider Documentation:**
- **OpenAI**: [platform.openai.com/docs](https://platform.openai.com/docs)
- **Anthropic Claude**: [docs.anthropic.com](https://docs.anthropic.com)
- **Google Gemini**: [ai.google.dev/docs](https://ai.google.dev/docs)
- **Ollama**: [ollama.ai/docs](https://ollama.ai/docs)
- **Groq**: [console.groq.com/docs](https://console.groq.com/docs)
- **AWS Bedrock**: [docs.aws.amazon.com/bedrock](https://docs.aws.amazon.com/bedrock)

## 🙏 Acknowledgments

- **sigoden**: Creator and maintainer of AIChat
- **LLM Providers**: OpenAI, Anthropic, Google, Meta, Mistral, and others for making powerful AI models accessible
- **Flox Community**: For promoting reproducible development environments

## 🔗 About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Software, variables, services defined in human-readable TOML
- **Content-addressed storage** - Multiple package versions coexist without conflicts
- **Reproducibility** - Same environment across dev, CI, and production
- **Deterministic builds** - Same inputs always produce identical outputs
- **Huge package collection** - Access to 150,000+ packages from [Nixpkgs](https://github.com/NixOS/nixpkgs)

**Why Flox for AIChat?**

- **Consistent LLM tooling**: Same AIChat version across all developers
- **Isolated environments**: Different projects can use different AIChat configs
- **Reproducible AI workflows**: Share exact tool versions with team
- **Cross-platform**: Same environment on Linux and macOS
- **No conflicts**: AIChat doesn't interfere with system Python or other tools

## 📝 License

This Flox environment configuration is provided as-is. AIChat is licensed under the MIT License - see the [LICENSE](https://github.com/sigoden/aichat/blob/main/LICENSE) file in the AIChat repository for details.

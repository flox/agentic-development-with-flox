# 💫 Flox Environment for GitHub Spec Kit

A Flox environment for [GitHub Spec Kit](https://github.com/github/spec-kit), a framework for spec-driven development that adds structured workflows to AI coding agents.

**IMPORTANT: Spec-Kit is NOT a standalone AI coding agent.** It's a methodology framework designed to be used **WITH** other AI agents by adding structured spec-driven development workflows to them.

## ✨ Features

- **Spec-Driven Development**: Structured workflow from specification to implementation
- **Multi-agent support**: Works with 14+ AI coding agents
- **Project initialization**: Bootstrap projects with agent-specific slash commands
- **Five-phase workflow**: Constitution → Specify → Plan → Tasks → Implement
- **Quality validation**: Built-in analysis and checklist generation
- **Technology-agnostic**: Works across diverse stacks and languages
- **Slash command integration**: Creates commands in `.claude/`, `.github/prompts/`, etc.
- **Free and open source**: From GitHub

## 🧰 Included Tools

The environment includes:

- `specify` - Spec Kit project initialization tool

## 🎯 What Is Spec-Driven Development?

Spec-Driven Development is a methodology where **specifications become executable artifacts** that directly generate implementations, rather than merely guiding them.

### The Five-Phase Workflow

1. **Constitution** (`/constitution`) - Establish project governing principles
2. **Specify** (`/specify`) - Define requirements and user stories
3. **Plan** (`/plan`) - Create technical implementation strategies
4. **Tasks** (`/tasks`) - Generate actionable task lists
5. **Implement** (`/implement`) - Execute all tasks to build features

## 🔗 Integration with AI Agents

Spec-Kit is designed to **layer with AI agent environments**. It creates agent-specific slash commands in your projects that implement the spec-driven workflow.

### Supported Agents from Our Collection

These AI agent environments work with Spec-Kit:

| Agent Environment | Spec-Kit Flag | Integration |
|-------------------|---------------|-------------|
| **gemini-cli** | `--ai gemini` | Creates commands in `.gemini/` |
| **kilocode-cli** | `--ai kilocode` | Creates commands for Kilocode |
| **copilot-cli** | `--ai copilot` | Creates commands in `.github/prompts/` |
| **cursor-agent** | `--ai cursor-agent` | Creates commands for Cursor |

### Other Supported Agents

Spec-Kit also supports: `qwen`, `opencode`, `codex`, `windsurf`, `auggie`, `codebuddy`, `amp`, `shai`, `q`

## 🏁 Getting Started

### 📋 Prerequisites

- [Flox](https://flox.dev/get) installed on your system
- One or more AI coding agent environments (gemini-cli, kilocode-cli, copilot-cli, cursor-agent)
- Git (for project initialization)

### 💻 Installation & Activation

**Spec-Kit should be layered with an AI agent environment:**

```sh
# Activate AI agent first, then add spec-kit on top

# With Gemini CLI
flox activate -r flox/gemini-cli
flox activate -r flox/spec-kit

# With Kilocode CLI
flox activate -r flox/kilocode-cli
flox activate -r flox/spec-kit

# With GitHub Copilot CLI
flox activate -r flox/copilot-cli
flox activate -r flox/spec-kit

# With Cursor Agent
flox activate -r flox/cursor-agent
flox activate -r flox/spec-kit
```

### 🚀 Initialize a Project

Once layered with an AI agent, initialize a new project:

```bash
# Create new project with Gemini CLI
specify init my-project --ai gemini

# Or with Kilocode
specify init my-project --ai kilocode

# Or with Copilot
specify init my-project --ai copilot

# Or initialize in current directory
specify init . --ai gemini
```

This creates:
- Project structure with spec-driven workflow templates
- Agent-specific slash command files
- Git repository (optional with `--no-git`)
- Ready-to-use development environment

## 📝 Usage

### Complete Workflow Example

**1. Layer environments and initialize:**
```bash
# Activate Gemini CLI, then add spec-kit on top
flox activate -r flox/gemini-cli
flox activate -r flox/spec-kit

# Initialize project
specify init blog-platform --ai gemini
cd blog-platform
```

**2. Launch your AI agent:**
```bash
# Start Gemini CLI in the project
gemini
```

**3. Use spec-driven workflow:**
```
# In Gemini CLI session:

# Step 1: Establish project principles
/constitution

You: This is a personal blog platform focused on simplicity and speed

Gemini: [Creates constitution with principles, guidelines, constraints]

# Step 2: Define requirements
/specify

You: Users should be able to create, edit, and delete blog posts with markdown support

Gemini: [Generates detailed specification with user stories, acceptance criteria]

# Step 3: Create technical plan
/plan

Gemini: [Develops technical implementation strategy, architecture decisions]

# Step 4: Generate tasks
/tasks

Gemini: [Breaks down plan into actionable tasks with dependencies]

# Step 5: Implement
/implement

Gemini: [Executes tasks, builds features, creates code]
```

### Using with Different Agents

**With Kilocode:**
```bash
flox activate -r flox/kilocode-cli
flox activate -r flox/spec-kit
specify init ecommerce-api --ai kilocode
cd ecommerce-api

kilocode
# Use /constitution, /specify, /plan, /tasks, /implement
```

**With Copilot:**
```bash
flox activate -r flox/copilot-cli
flox activate -r flox/spec-kit
specify init mobile-app --ai copilot
cd mobile-app

github-copilot-cli
# Use /constitution, /specify, /plan, /tasks, /implement
```

### Available Commands

```bash
# Initialize new project
specify init <project-name> --ai <agent>

# Initialize in current directory
specify init . --ai <agent>

# Check installed AI agents
specify check

# Display version info
specify version

# Skip git initialization
specify init <project> --ai <agent> --no-git

# Force overwrite in existing directory
specify init . --ai <agent> --force
```

### Initialization Options

```bash
# Basic initialization
specify init my-project --ai gemini

# Shell script type (sh or ps)
specify init my-project --ai copilot --script ps

# Skip AI agent tool checks
specify init my-project --ai kilocode --ignore-agent-tools

# With GitHub token for API requests
specify init my-project --ai gemini --github-token ghp_...

# Or use environment variable
export GITHUB_TOKEN=ghp_...
specify init my-project --ai gemini

# Debug mode for troubleshooting
specify init my-project --ai copilot --debug
```

## 🛠️ Common Workflows

### Starting a New Feature with Spec-Driven Workflow

```bash
# Activate Gemini CLI, then add spec-kit
flox activate -r flox/gemini-cli
flox activate -r flox/spec-kit

# Create project
specify init user-auth-service --ai gemini
cd user-auth-service

# Start Gemini
gemini

# Follow the workflow
/constitution
# Define project principles

/specify
# Create feature specification

/plan
# Develop technical approach

/tasks
# Break into implementable tasks

/implement
# Build the feature
```

### Adding Spec-Kit to Existing Project

```bash
# Navigate to your project
cd existing-project

# Activate Kilocode, then add spec-kit
flox activate -r flox/kilocode-cli
flox activate -r flox/spec-kit

# Initialize spec-kit in current directory
specify init . --ai kilocode

# Now use spec-driven workflow
kilocode
/constitution
```

### Multi-Agent Workflow

Use different agents for different phases:

```bash
# Use Gemini for specification
flox activate -r flox/gemini-cli
flox activate -r flox/spec-kit
specify init --here --ai gemini
gemini
/constitution
/specify

# Switch to Kilocode for implementation
flox activate -r flox/kilocode-cli
flox activate -r flox/spec-kit
kilocode
/plan
/tasks
/implement
```

### Quality Validation

```bash
# After implementation, validate
gemini
/analyze
# Reviews implementation against spec

/checklist
# Generates quality checklist
```

## 🔧 Integration Patterns

### Pattern 1: Temporary Layering (Recommended)

Layer spec-kit only when needed:

```bash
# When starting a new project
flox activate -r flox/gemini-cli
flox activate -r flox/spec-kit
specify init my-project --ai gemini

# Later, use just the agent
flox activate -r flox/gemini-cli
cd my-project
gemini
# Slash commands are already in the project
```

### Pattern 2: Persistent Layering

Keep spec-kit available throughout development:

```bash
# Create a wrapper script or alias
cat > ~/bin/gemini-spec << 'EOF'
#!/bin/bash
flox activate -r flox/gemini-cli
flox activate -r flox/spec-kit
EOF
chmod +x ~/bin/gemini-spec

# Use combined environment
gemini-spec
cd my-project
gemini
```

### Pattern 3: Cross-Agent Projects

Initialize with multiple agent configurations:

```bash
# Initialize for Gemini
flox activate -r flox/gemini-cli
flox activate -r flox/spec-kit
specify init my-project --ai gemini

cd my-project

# Add Kilocode commands
flox activate -r flox/kilocode-cli
flox activate -r flox/spec-kit
specify init . --ai kilocode --force

# Now both agents have slash commands
```

## 📚 Slash Commands Reference

After initialization, these commands are available in your AI agent:

### Core Workflow Commands

- `/constitution` - Establish project governing principles
  - Define project vision and values
  - Set technical constraints
  - Establish quality standards

- `/specify` - Create detailed specifications
  - Define user stories
  - Establish acceptance criteria
  - Document requirements

- `/plan` - Develop technical implementation plan
  - Architecture decisions
  - Technology choices
  - Implementation strategy

- `/tasks` - Break down into actionable tasks
  - Task list with dependencies
  - Priority ordering
  - Effort estimates

- `/implement` - Execute implementation
  - Follow task list
  - Build features
  - Create code

### Quality Assurance Commands

- `/analyze` - Validate implementation against spec
  - Check completeness
  - Verify requirements met
  - Identify gaps

- `/checklist` - Generate quality checklist
  - Testing requirements
  - Code review points
  - Deployment readiness

## 🎯 Benefits of Spec-Driven Development

### Traditional Approach Problems

- **Incomplete specifications**: AI makes assumptions
- **Inconsistent implementations**: Varies by prompt
- **Missing requirements**: Discovered late
- **Poor quality**: No validation framework

### Spec-Driven Approach Solutions

- ✅ **Complete specifications**: Structured workflow ensures nothing missed
- ✅ **Consistent implementations**: Follows defined plan
- ✅ **Early requirement discovery**: Systematic specification phase
- ✅ **Built-in quality**: Analysis and checklist validation

### When to Use Spec-Driven Development

**Best for:**
- New projects or features
- Complex implementations
- Team collaboration
- Projects requiring documentation
- Systems with strict requirements
- Learning and experimentation

**May be overkill for:**
- Quick prototypes
- Simple scripts
- Exploratory coding
- Well-understood problems

## 🔧 Troubleshooting

### Command Not Found

```bash
# Verify spec-kit is available
which specify

# Ensure environment is activated
flox activate -r flox/spec-kit

# Check installation
flox list | grep spec-kit
```

### AI Agent Not Detected

```bash
# Check what agents are available
specify check

# Activate the agent, then add spec-kit
flox activate -r flox/gemini-cli
flox activate -r flox/spec-kit

# Try initialization
specify init test-project --ai gemini
```

### Slash Commands Not Working in Agent

**Issue:** Agent doesn't recognize `/constitution`, `/specify`, etc.

**Solutions:**
1. Verify project was initialized with spec-kit:
   ```bash
   ls .claude/commands/  # For Claude/Gemini
   ls .github/prompts/   # For Copilot
   ```

2. Re-initialize if needed:
   ```bash
   flox activate -r flox/gemini-cli
   flox activate -r flox/spec-kit
   specify init . --ai gemini --force
   ```

3. Restart your AI agent after initialization

### Git Repository Issues

**Issue:** Git initialization fails

**Solutions:**
```bash
# Skip git initialization
specify init my-project --ai gemini --no-git

# Or initialize manually after
cd my-project
git init
git add .
git commit -m "Initial commit from spec-kit"
```

### Template Download Failures

**Issue:** Cannot download template from GitHub

**Solutions:**
```bash
# Use GitHub token
export GITHUB_TOKEN=ghp_...
specify init my-project --ai gemini

# Skip TLS verification (not recommended)
specify init my-project --ai gemini --skip-tls

# Enable debug mode
specify init my-project --ai gemini --debug
```

### Wrong Agent Initialized

**Issue:** Initialized for wrong agent

**Solution:**
```bash
# Re-initialize with correct agent
cd my-project
flox activate -r flox/kilocode-cli
flox activate -r flox/spec-kit
specify init . --ai kilocode --force
```

## 💻 System Compatibility

This environment works on:
- Linux x86_64
- macOS ARM64 (Apple Silicon)
- macOS x86_64 (Intel)

## 🔒 Security Considerations

- **Project templates**: Downloaded from GitHub's official spec-kit repository
- **Git initialization**: Optional, user-controlled
- **No credential storage**: Spec-kit doesn't store API keys or credentials
- **Local execution**: All initialization happens locally
- **Agent permissions**: Follow security practices of your chosen AI agent

**Best Practices:**
- Review templates after initialization
- Use version control for all projects
- Follow your AI agent's security guidelines
- Validate generated specifications
- Review implementation code before deployment

## 📚 Additional Resources

- **GitHub Spec Kit Repository**: [github.com/github/spec-kit](https://github.com/github/spec-kit)
- **Spec-Driven Development Guide**: [GitHub Blog](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/)
- **Documentation**: [Spec Kit Docs](https://github.com/github/spec-kit/tree/main/docs)
- **Flox Documentation**: [flox.dev/docs](https://flox.dev/docs)

### Compatible AI Agent Environments

From this collection:
- [gemini-cli](../gemini-cli/) - Google Gemini CLI
- [kilocode-cli](../kilocode-cli/) - Kilo Code multi-modal agent
- [copilot-cli](../copilot-cli/) - GitHub Copilot CLI
- [cursor-agent](../cursor-agent/) - Cursor Agent CLI

## 🙏 Acknowledgments

- **GitHub Team**: Thanks to GitHub for creating Spec Kit and making it open source

## 🔗 About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Software, variables, services defined in human-readable TOML
- **Content-addressed storage** - Multiple package versions coexist without conflicts
- **Reproducibility** - Same environment across dev, CI, and production
- **Deterministic builds** - Same inputs always produce identical outputs
- **Huge package collection** - Access to 150,000+ packages from [Nixpkgs](https://github.com/NixOS/nixpkgs)

## 📝 License

This Flox environment configuration is provided as-is. GitHub Spec Kit is open source - see the [Spec Kit repository](https://github.com/github/spec-kit) for license details.

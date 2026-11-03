# Flox Environment for GitHub Spec Kit

A Flox environment for [GitHub Spec Kit](https://github.com/github/spec-kit), a framework for spec-driven development that adds structured workflows to AI coding agents.

**IMPORTANT: Spec-Kit is NOT a standalone AI coding agent.** It's a methodology framework designed to be used **WITH** other AI agents by adding structured spec-driven development workflows to them.

## Features

- **Spec-Driven Development**: Structured workflow from specification to implementation
- **Multi-agent support**: Integrations for 40+ AI coding agents
- **Project initialization**: Bootstrap projects with agent-specific skills or slash commands
- **Five-phase workflow**: Constitution → Specify → Plan → Tasks → Implement
- **Quality validation**: Built-in clarification, analysis, and checklist generation
- **Technology-agnostic**: Works across diverse stacks and languages
- **Free and open source**: From GitHub

## Included Tools

The environment includes:

- `specify` - Spec Kit project initialization tool

## What Is Spec-Driven Development?

Spec-Driven Development is a methodology where **specifications become executable artifacts** that directly generate implementations, rather than merely guiding them.

### The Five-Phase Workflow

1. **Constitution** (`/speckit-constitution`) - Establish project governing principles
2. **Specify** (`/speckit-specify`) - Define requirements and user stories
3. **Plan** (`/speckit-plan`) - Create technical implementation strategies
4. **Tasks** (`/speckit-tasks`) - Generate actionable task lists
5. **Implement** (`/speckit-implement`) - Execute all tasks to build features

Agents that use skills (Antigravity, Claude Code, Codex, Copilot, Cursor) run these as `/speckit-<name>`. Agents that use command files (Kilo Code, OpenCode, Qwen Code, and others) run them as `/speckit.<name>`.

## Integration with AI Agents

Spec-Kit is designed to **layer with AI agent environments**. It writes agent-specific skills or commands into your project that implement the spec-driven workflow.

### Supported Agents from Our Collection

| Agent Environment | `--integration` | Creates | Run as |
|-------------------|-----------------|---------|--------|
| **antigravity-cli** | `agy` | `.agents/skills/` | `/speckit-constitution` |
| **claude-code** | `claude` | `.claude/skills/` | `/speckit-constitution` |
| **codex** | `codex` | `.agents/skills/` | `/speckit-constitution` |
| **copilot-cli** | `copilot` | `.github/skills/` | `/speckit-constitution` |
| **cursor-agent** | `cursor-agent` | `.cursor/skills/` | `/speckit-constitution` |
| **kilocode-cli** | `kilocode` | `.kilo/commands/` | `/speckit.constitution` |

### Other Supported Agents

Spec-Kit also has integrations for, among others: `amp`, `cline`, `droid`, `forge`, `goose`, `hermes`, `kiro-cli`, `opencode`, `pi`, `qwen`, and `vibe` (Mistral Vibe). Run `specify integration list` for the full list.

## Getting Started

### Prerequisites

- [Flox](https://flox.dev/get) installed on your system
- One or more AI coding agent environments (antigravity-cli, claude-code, codex, copilot-cli, cursor-agent, kilocode-cli)

### Installation & Activation

**Spec-Kit should be layered with an AI agent environment:**

```sh
# Activate AI agent first, then add spec-kit on top

# With Antigravity CLI
flox activate -r flox/antigravity-cli
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

### Initialize a Project

Once layered with an AI agent, initialize a new project:

```bash
# Create new project for Antigravity CLI
specify init my-project --integration agy

# Or for Kilocode
specify init my-project --integration kilocode

# Or for Copilot
specify init my-project --integration copilot

# Or initialize in the current directory
specify init --here --integration agy
```

This creates:
- `.specify/` with the workflow templates, scripts, and project memory (including the constitution)
- The agent's skills or command files (see the table above)

`specify init` doesn't create a Git repository; run `git init` yourself if you want one.

## Usage

### Complete Workflow Example

**1. Layer environments and initialize:**
```bash
# Activate Antigravity CLI, then add spec-kit on top
flox activate -r flox/antigravity-cli
flox activate -r flox/spec-kit

# Initialize project
specify init blog-platform --integration agy
cd blog-platform
```

**2. Launch your AI agent:**
```bash
# Start Antigravity CLI in the project
agy
```

**3. Use spec-driven workflow:**
```
# In Antigravity CLI session:

# Step 1: Establish project principles
/speckit-constitution This is a personal blog platform focused on simplicity and speed

Antigravity: [Creates constitution with principles, guidelines, constraints]

# Step 2: Define requirements
/speckit-specify Users should be able to create, edit, and delete blog posts with markdown support

Antigravity: [Generates detailed specification with user stories, acceptance criteria]

# Step 3: Create technical plan
/speckit-plan

Antigravity: [Develops technical implementation strategy, architecture decisions]

# Step 4: Generate tasks
/speckit-tasks

Antigravity: [Breaks down plan into actionable tasks with dependencies]

# Step 5: Implement
/speckit-implement

Antigravity: [Executes tasks, builds features, creates code]
```

### Using with Different Agents

**With Kilocode:**
```bash
flox activate -r flox/kilocode-cli
flox activate -r flox/spec-kit
specify init ecommerce-api --integration kilocode
cd ecommerce-api

kilocode
# Use /speckit.constitution, /speckit.specify, /speckit.plan, /speckit.tasks, /speckit.implement
```

**With Copilot:**
```bash
flox activate -r flox/copilot-cli
flox activate -r flox/spec-kit
specify init mobile-app --integration copilot
cd mobile-app

copilot
# Use /speckit-constitution, /speckit-specify, /speckit-plan, /speckit-tasks, /speckit-implement
```

### Available Commands

```bash
# Initialize new project
specify init <project-name> --integration <agent>

# Initialize in current directory
specify init --here --integration <agent>

# Merge into a non-empty directory without asking
specify init --here --integration <agent> --force

# Check installed AI agents
specify check

# List integrations and which are installed in this project
specify integration list

# Display version info
specify version
```

### Initialization Options

```bash
# Basic initialization
specify init my-project --integration agy

# Script type (sh, ps, or py)
specify init my-project --integration copilot --script ps

# Skip AI agent tool checks
specify init my-project --integration kilocode --ignore-agent-tools

# Never prompt (for scripts and agent harnesses)
specify init my-project --integration agy --non-interactive
```

## Common Workflows

### Starting a New Feature with Spec-Driven Workflow

```bash
# Activate Antigravity CLI, then add spec-kit
flox activate -r flox/antigravity-cli
flox activate -r flox/spec-kit

# Create project
specify init user-auth-service --integration agy
cd user-auth-service

# Start Antigravity CLI
agy

# Follow the workflow
/speckit-constitution
# Define project principles

/speckit-specify
# Create feature specification

/speckit-plan
# Develop technical approach

/speckit-tasks
# Break into implementable tasks

/speckit-implement
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
specify init --here --integration kilocode

# Now use spec-driven workflow
kilocode
/speckit.constitution
```

### Multi-Agent Workflow

Use different agents for different phases. Install a second integration into the project first (see Pattern 3 below), then:

```bash
# Use Antigravity CLI for specification
flox activate -r flox/antigravity-cli
agy
/speckit-constitution
/speckit-specify

# Switch to Kilocode for implementation
flox activate -r flox/kilocode-cli
kilocode
/speckit.plan
/speckit.tasks
/speckit.implement
```

### Quality Validation

```bash
agy
/speckit-clarify
# Asks structured questions about ambiguous areas (before /speckit-plan)

/speckit-checklist
# Generates quality checklists for the requirements (after /speckit-plan)

/speckit-analyze
# Cross-artifact consistency report (after /speckit-tasks, before /speckit-implement)
```

## Integration Patterns

### Pattern 1: Temporary Layering (Recommended)

Layer spec-kit only when needed:

```bash
# When starting a new project
flox activate -r flox/antigravity-cli
flox activate -r flox/spec-kit
specify init my-project --integration agy

# Later, use just the agent
flox activate -r flox/antigravity-cli
cd my-project
agy
# The spec-kit skills are already in the project
```

### Pattern 2: Persistent Layering

Keep spec-kit available throughout development:

```bash
# Create a wrapper script or alias
cat > ~/bin/agy-spec << 'EOF'
#!/bin/bash
flox activate -r flox/antigravity-cli -- flox activate -r flox/spec-kit
EOF
chmod +x ~/bin/agy-spec

# Use combined environment
agy-spec
cd my-project
agy
```

### Pattern 3: Cross-Agent Projects

Install more than one integration into the same project:

```bash
# Initialize for Antigravity CLI
flox activate -r flox/antigravity-cli
flox activate -r flox/spec-kit
specify init my-project --integration agy

cd my-project

# Add Kilocode commands alongside it
specify integration install kilocode --force

# Now both agents have the workflow
specify integration list
```

`--force` is needed when the integrations aren't declared safe to install together. To replace the integration instead, use `specify integration switch <agent>`.

## Workflow Commands Reference

After initialization, these are available in your AI agent (shown in skills form; command-file agents use `/speckit.<name>`):

### Core Workflow

- `/speckit-constitution` - Establish project governing principles
  - Define project vision and values
  - Set technical constraints
  - Establish quality standards

- `/speckit-specify` - Create detailed specifications
  - Define user stories
  - Establish acceptance criteria
  - Document requirements

- `/speckit-plan` - Develop technical implementation plan
  - Architecture decisions
  - Technology choices
  - Implementation strategy

- `/speckit-tasks` - Break down into actionable tasks
  - Task list with dependencies
  - Priority ordering

- `/speckit-implement` - Execute implementation
  - Follow task list
  - Build features
  - Create code

- `/speckit-converge` - Assess the codebase and append remaining work as tasks

### Quality Assurance

- `/speckit-clarify` - Ask structured questions to de-risk ambiguous areas before planning
- `/speckit-analyze` - Cross-artifact consistency and alignment report
- `/speckit-checklist` - Generate quality checklists for requirements completeness, clarity, and consistency

## Benefits of Spec-Driven Development

### Traditional Approach Problems

- **Incomplete specifications**: AI makes assumptions
- **Inconsistent implementations**: Varies by prompt
- **Missing requirements**: Discovered late
- **Poor quality**: No validation framework

### Spec-Driven Approach Solutions

- **Complete specifications**: Structured workflow ensures nothing missed
- **Consistent implementations**: Follows defined plan
- **Early requirement discovery**: Systematic specification phase
- **Built-in quality**: Analysis and checklist validation

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

## Troubleshooting

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
flox activate -r flox/antigravity-cli
flox activate -r flox/spec-kit

# Try initialization
specify init test-project --integration agy

# Or skip the check
specify init test-project --integration agy --ignore-agent-tools
```

### Workflow Commands Not Working in Agent

**Issue:** Agent doesn't recognize `/speckit-constitution`, `/speckit-specify`, etc.

**Solutions:**
1. Verify project was initialized with spec-kit:
   ```bash
   specify integration status
   ls .agents/skills/    # Antigravity, Codex
   ls .claude/skills/    # Claude Code
   ls .github/skills/    # Copilot
   ls .kilo/commands/    # Kilocode
   ```

2. Re-initialize if needed:
   ```bash
   flox activate -r flox/antigravity-cli
   flox activate -r flox/spec-kit
   specify init --here --integration agy --force
   ```

3. Restart your AI agent after initialization

### Wrong Agent Initialized

**Issue:** Initialized for the wrong agent

**Solution:**
```bash
# Switch the project to the correct agent
cd my-project
specify integration switch kilocode
```

## System Compatibility

This environment works on:
- Linux x86_64 and ARM64
- macOS ARM64 (Apple Silicon)

## Security Considerations

- **Bundled templates**: Spec-kit ships its templates; `specify init` works offline
- **No credential storage**: Spec-kit doesn't store API keys or credentials
- **Local execution**: All initialization happens locally
- **Agent permissions**: Follow security practices of your chosen AI agent

**Best Practices:**
- Review templates after initialization
- Use version control for all projects
- Follow your AI agent's security guidelines
- Validate generated specifications
- Review implementation code before deployment

## Additional Resources

- **GitHub Spec Kit Repository**: [github.com/github/spec-kit](https://github.com/github/spec-kit)
- **Spec-Driven Development Guide**: [GitHub Blog](https://github.blog/ai-and-ml/generative-ai/spec-driven-development-with-ai-get-started-with-a-new-open-source-toolkit/)
- **Documentation**: [Spec Kit Docs](https://github.com/github/spec-kit/tree/main/docs)
- **Flox Documentation**: [flox.dev/docs](https://flox.dev/docs)

### Compatible AI Agent Environments

From this collection:
- [antigravity-cli](../antigravity-cli/) - Google Antigravity CLI
- [claude-code](../claude-code/) - Anthropic Claude Code
- [codex](../codex/) - OpenAI Codex CLI
- [kilocode-cli](../kilocode-cli/) - Kilo Code multi-modal agent
- [copilot-cli](../copilot-cli/) - GitHub Copilot CLI
- [cursor-agent](../cursor-agent/) - Cursor Agent CLI

## Acknowledgments

- **GitHub Team**: Thanks to GitHub for creating Spec Kit and making it open source

## About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Software, variables, services defined in human-readable TOML
- **Content-addressed storage** - Multiple package versions coexist without conflicts
- **Reproducibility** - Same environment across dev, CI, and production
- **Deterministic builds** - Same inputs always produce identical outputs
- **Huge package collection** - Access to 150,000+ packages from [Nixpkgs](https://github.com/NixOS/nixpkgs)

## License

This Flox environment configuration is provided as-is. GitHub Spec Kit is open source - see the [Spec Kit repository](https://github.com/github/spec-kit) for license details.

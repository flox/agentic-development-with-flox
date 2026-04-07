# Google Antigravity

Google's agent-first IDE for agentic development. Built as a deep fork of VS Code, Antigravity integrates Gemini models for autonomous multi-agent coding workflows with a visual Manager dashboard for orchestrating parallel tasks.

- **Agent-first IDE** - Delegate complex multi-step coding tasks to autonomous AI agents
- **Manager View** - Spawn, monitor, and orchestrate multiple agents working in parallel
- **Multi-model** - Gemini 3.1 Pro, Gemini 3 Flash, Claude Sonnet 4.6, Claude Opus 4.6
- **Artifacts** - Agents produce code diffs, screenshots, browser recordings, and implementation plans
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd antigravity
flox activate
```

### 2. Launch the IDE

```bash
# Open Antigravity
antigravity

# Open a specific project
antigravity /path/to/project
```

### 3. Sign In

Sign in with your Google Account when prompted. Gemini models are available immediately on the free tier.

## Architecture

Antigravity has three surfaces:

- **Editor** - Familiar VS Code-based IDE with inline AI commands (Cmd/Ctrl+I) and tab completions
- **Manager** - Mission Control dashboard for spawning and monitoring autonomous agents across workspaces
- **Browser** - Integrated browser for automated testing and agent-driven web interactions

## Agent Configuration

### agents.md

Add an `agents.md` file to your project root for agent-specific instructions (similar to `CLAUDE.md`):

```markdown
# Agent Instructions

- Always write tests for new functions
- Use TypeScript strict mode
- Follow the existing project conventions
```

### skills.md

Define reusable agent skills for building autonomous pipelines:

```markdown
# Skills

## deploy
Run `npm run build && npm run deploy` after all tests pass.

## review
Check code for security issues, performance problems, and style violations.
```

## IDE Shortcuts

| Shortcut | Action |
|----------|--------|
| Cmd/Ctrl+I | Inline AI command (natural language) |
| Manager View | Spawn and orchestrate parallel agents |

## Supported Models

| Model | Provider | Notes |
|-------|----------|-------|
| Gemini 3.1 Pro | Google | Primary, generous rate limits |
| Gemini 3 Flash | Google | Fast, lower cost |
| Claude Sonnet 4.6 | Anthropic | Available in model picker |
| Claude Opus 4.6 | Anthropic | Available in model picker |

## Pricing

| Tier | Price | Notes |
|------|-------|-------|
| Free | $0/month | Rate-limited, weekly refresh |
| Pro | $20/month | Higher rate limits, 5-hour refresh |
| Ultra | $249.99/month | Highest rate limits, priority access |

## Supported Platforms

| Platform | Package |
|----------|---------|
| Linux x86_64 | `antigravity-fhs` |
| Linux aarch64 | `antigravity-fhs` |
| macOS Apple Silicon | `antigravity` |

Note: macOS Intel (x86_64-darwin) is not currently supported.

## Helper Commands

```bash
antigravity-info    # Show configuration, shortcuts, and model info
```

## Antigravity vs Gemini CLI

Both are Google AI development tools with different use cases:

- **Antigravity** - Visual IDE with multi-agent orchestration, Manager dashboard, browser automation. Best for complex projects requiring parallel agent workflows.
- **Gemini CLI** - Terminal-based AI coding agent. Best for quick tasks, scripting, and developers who prefer CLI workflows.

Both are available as Flox environments in this repository.

## Resources

- [Google Antigravity](https://antigravity.google/)
- [Documentation](https://antigravity.google/docs)
- [Getting Started Codelab](https://codelabs.developers.google.com/getting-started-google-antigravity)
- [Choosing Antigravity or Gemini CLI](https://cloud.google.com/blog/topics/developers-practitioners/choosing-antigravity-or-gemini-cli)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Antigravity-specific issues:
- [Antigravity Documentation](https://antigravity.google/docs)
- [Google Developer Community](https://developers.google.com/community)

# OpenSpec

Lightweight spec framework that adds a specification layer between humans and AI coding assistants. Instead of requirements living only in chat history, you and the AI agree on specs (proposals, requirements, design, tasks) before any code gets written.

- **Spec-driven workflow** - Each change gets its own folder with proposal, specs, design, and tasks
- **Works with 20+ AI assistants** - Slash commands integrate with Claude Code, Codex, and more
- **Lightweight** - Fluid, not rigid; iterative, not waterfall
- **Brownfield-friendly** - Designed for existing projects
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Intel, Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd openspec
flox activate
```

### 2. Initialize in Your Project

```bash
cd /path/to/your/project
openspec init
```

This creates the `openspec/` directory and registers slash commands with your AI coding assistant.

### 3. Use Slash Commands in Your AI Assistant

```
/opsx:propose "Add user authentication with OAuth"
# AI creates openspec/changes/<name>/ with:
#   proposal.md     why/what
#   specs/          requirements and scenarios
#   design.md       technical approach
#   tasks.md        implementation checklist

/opsx:apply
# AI implements the tasks

/opsx:archive
# AI archives the completed change to openspec/changes/archive/<date>-<name>/
```

## CLI Reference

| Command | Description |
|---------|-------------|
| `openspec init` | Initialize OpenSpec in the current project |
| `openspec update` | Refresh AI agent instructions and slash commands (run after upgrades) |
| `openspec config profile` | Switch between default and expanded workflow profiles |

## Workflow Profiles

**Default profile** - Core slash commands:
- `/opsx:propose "<idea>"`
- `/opsx:apply`
- `/opsx:archive`

**Expanded profile** - Adds:
- `/opsx:new`
- `/opsx:continue`
- `/opsx:ff`
- `/opsx:verify`
- `/opsx:sync`
- `/opsx:bulk-archive`
- `/opsx:onboard`

Switch with `openspec config profile`.

## Project Structure

After running `openspec init`, your project gets:

```
openspec/
├── changes/                # Active changes
│   └── <change-name>/
│       ├── proposal.md     # Why and what
│       ├── specs/          # Requirements and scenarios
│       ├── design.md       # Technical approach
│       └── tasks.md        # Implementation checklist
└── changes/archive/        # Completed changes
    └── <date>-<name>/
```

## Telemetry

OpenSpec collects anonymous command names and version (disabled in CI). Opt out:

```bash
export OPENSPEC_TELEMETRY=0
# or
export DO_NOT_TRACK=1
```

## Helper Commands

```bash
openspec-info    # Show configuration and command reference
```

## Supported AI Assistants

OpenSpec works with 20+ AI coding tools including Claude Code, Codex, Cursor, and more. Recommended models: Opus 4.5 and GPT 5.2 for both planning and implementation.

## Resources

- [OpenSpec GitHub](https://github.com/Fission-AI/OpenSpec)
- [npm: @fission-ai/openspec](https://www.npmjs.com/package/@fission-ai/openspec)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For OpenSpec-specific issues:
- [OpenSpec GitHub Issues](https://github.com/Fission-AI/OpenSpec/issues)

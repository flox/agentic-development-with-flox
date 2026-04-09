# Toad

Unified terminal interface (TUI) for AI coding agents by Will McGugan (creator of Rich and Textual). A single, polished terminal application that drives multiple coding agents through one consistent experience. Built by Batrachian AI.

- **AI app store** - Discover and install coding agents from within the TUI
- **Multi-agent** - Claude, Gemini, Codex, Open Hands, and more via Agent Client Protocol
- **Rich TUI** - Integrated shell, markdown editor, fuzzy file picker, beautiful diffs
- **Web mode** - Serve as a web application with `toad serve`
- **Concurrent sessions** - Run multiple agent sessions, resume with Ctrl+R
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Intel, Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd toad
flox activate
```

Toad is automatically installed into a Python 3.14 venv on first activation.

### 2. Launch

```bash
# Launch the TUI
toad

# Open a specific project
toad ~/projects/my-app

# Launch with a specific agent
toad -a claude

# Run as a web application
toad serve
```

## Supported Agents

Toad integrates with coding agents via the Agent Client Protocol:

- **Claude** (Anthropic)
- **Gemini** (Google)
- **Codex** (OpenAI)
- **Open Hands**
- Additional agents discoverable via the in-app agent store

## TUI Features

- **Integrated shell** with color output, interactive commands, and tab completion
- **Markdown prompt editor** with syntax highlighting for code fences
- **Fuzzy file picker** triggered via `@` key, with tree view
- **Beautiful diffs** in side-by-side or unified views
- **Elegant markdown rendering** (tables, quotes, lists)
- **In-app settings** -- no manual JSON editing required

## Configuration

Toad manages configuration through its in-app settings UI. No environment variables or JSON files to edit manually. API keys and agent preferences are configured within the TUI.

## Helper Commands

```bash
toad-info      # Show configuration and command reference
toad-update    # Update batrachian-toad to latest version
```

## Technical Notes

- Python 3.14 is required (Toad depends on features not available in earlier versions)
- The venv is cached at `$FLOX_ENV_CACHE/venv` and reused across activations
- The `toad` wrapper unsets `PYTHONPATH` to prevent contamination from other Flox environments
- A `.deps_installed` sentinel file tracks installation state

## Resources

- [Toad GitHub](https://github.com/batrachianai/toad)
- [Batrachian AI](https://batrachian.ai)
- [Textualize Discord (#toad channel)](https://discord.gg/textualize)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Toad-specific issues:
- [Toad GitHub Issues](https://github.com/batrachianai/toad/issues)

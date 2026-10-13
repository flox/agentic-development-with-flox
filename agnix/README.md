# agnix

Linter for AI agent configuration. agnix catches broken skills, subagents, hooks, MCP configs, and instruction files before your coding agent silently ignores them, and can fix many problems automatically. It runs offline and needs no account.

- **Many agents** - Claude Code, Codex CLI, Cursor, GitHub Copilot, Kiro, Gemini CLI, Cline, OpenCode, and the Agent Skills standard
- **Many file types** - SKILL.md, CLAUDE.md, AGENTS.md, subagents, hooks, `.mcp.json`, Cursor rules, Codex `config.toml`, and more
- **Auto-fix** - Preview fixes, apply high-confidence fixes only, or apply all of them
- **CI-ready** - Nonzero exit on errors, plus JSON, SARIF, and GitHub Actions output
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate the Environment from Your Project

```bash
cd /path/to/your/project
flox activate -d /path/to/agnix    # this directory
```

Activating from the project lets the banner report the project's `.agnix.toml`.

### 2. Lint the Project

```bash
agnix .
```

Example findings:

```
.claude/agents/reviewer.md:1:0 error: Invalid model 'gpt-9'. Valid values: default, best, fable, sonnet, opus, haiku, ... [fixable]
.mcp.json:1:18 error: Server 'fs' has type 'stdio' but is missing required 'command' field
CLAUDE.md:5:1 error: Import target not found: @missing-file.md
CLAUDE.md:3:8 warning: Redundant instruction 'be helpful' - LLMs already follow this by default [fixable]
```

`agnix explain <RULE>` shows what a rule checks and the documentation it is based on:

```bash
agnix --format json . | grep '"rule"'   # find rule IDs
agnix explain CC-AG-003
```

## Fixing Problems

```bash
agnix --dry-run --show-fixes .   # Preview every proposed fix
agnix --fix .                    # Apply high-confidence fixes only
agnix --fix-unsafe .             # Apply all fixes, including medium- and low-confidence ones
```

`--fix` applies only fixes agnix marks as high-confidence, so it often changes nothing. Many fixes (renaming a skill, replacing an invalid model, adding missing frontmatter) are medium-confidence and only `--fix-unsafe` applies them. Preview first and review the result with `git diff`: a medium-confidence fix can remove a whole line, including text on that line the finding wasn't about.

## Choosing What to Check

agnix checks every agent's files by default. Restrict it to the tools you use, or turn off individual rules, in `.agnix.toml` at the project root:

```bash
agnix init   # writes a starter .agnix.toml with every option
```

```toml
tools = ["claude-code"]

[rules]
disabled_rules = ["CC-AG-003"]
```

`agnix --target claude-code` still works, but agnix reports it as deprecated in favor of `tools`.

`agnix tools detect` prints the versions of the agent CLIs on your `PATH` as a `[tool_versions]` snippet, so version-dependent rules can match the tools you actually run.

## CI and Git Hooks

agnix exits 1 when it finds errors and 0 otherwise. Warnings don't fail the run unless you pass `--strict`.

```bash
agnix --strict .              # Fail on warnings too
agnix --format sarif . > agnix.sarif   # Code-scanning upload
agnix --format github .       # GitHub Actions annotations
```

Pass file paths instead of a directory to check only those files, as a pre-commit hook would:

```bash
agnix .mcp.json CLAUDE.md
```

`agnix --watch .` re-lints whenever a file changes.

## Editor Integration

The flox/agnix package provides the `agnix` CLI only. Upstream also has an `agnix-lsp` language server and an `agnix-mcp` MCP server, but this package doesn't build them. For in-editor diagnostics, use the upstream [editor extensions](https://agent-sh.github.io/agnix/docs/editor-integration) (VS Code, JetBrains, Neovim, Zed).

## Telemetry

Telemetry is opt-in and off by default. `agnix telemetry status` shows the setting; `agnix telemetry enable` and `disable` change it. It also respects `DO_NOT_TRACK`.

## Helper Commands

```bash
agnix-info    # Show configuration and command reference
```

## Resources

- [agnix GitHub](https://github.com/agent-sh/agnix)
- [Rules reference](https://agent-sh.github.io/agnix/docs/rules)
- [Configuration reference](https://agent-sh.github.io/agnix/docs/configuration)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For agnix-specific issues:
- [agnix GitHub Issues](https://github.com/agent-sh/agnix/issues)

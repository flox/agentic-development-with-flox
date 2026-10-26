# agent-lint

Six checkers for coding-agent configuration in one environment: two security scanners for skills, two linters for Claude Code projects, and two validators for `SKILL.md` files. Use them before you install a skill someone else wrote, before you commit your own, or in CI.

- **Security scanning** - [SkillSpector](https://github.com/NVIDIA/SkillSpector) and [skillcheck](https://github.com/agentigy/skillcheck) look for prompt injection, remote script fetching, credential access, hardcoded secrets, and privilege escalation
- **Project linting** - [claudelint](https://claudelint.com) and [cclint](https://github.com/carlrannaberg/cclint) check CLAUDE.md, skills, subagents, settings, hooks, MCP configs, and plugins
- **Skill quality** - [skill-tools](https://github.com/skill-tools/skill-tools) and [skill-validator](https://github.com/agent-ecosystem/skill-validator) validate `SKILL.md` against the Agent Skills spec and score it
- **CI-ready** - Nonzero exit codes, and SARIF, JSON, or GitHub annotations from most of them
- **No account** - No sign-up; the checks run on your machine, though some reach the network: LLM analysis, Git clones, vulnerability lookups, and link checks (see [Network Access](#network-access))
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

The sibling [agnix](../agnix) environment overlaps with the linters here: it lints the same Claude Code files (and those of Codex, Cursor, Copilot, and others) and can fix many problems. Use agnix as the everyday linter; this environment adds the security scanners, skill scoring, and a second opinion.

## Quick Start

### 1. Activate the Environment from Your Project

```bash
cd /path/to/your/project
flox activate -d /path/to/agent-lint    # this directory
```

### 2. Run the Checks

```bash
skillspector scan -r --no-llm .claude/skills   # security scan of each skill
skillcheck .claude/skills                      # secrets, injection, privilege escalation
claudelint                                     # lint the whole Claude Code project
cclint                                         # agents, commands, settings, CLAUDE.md
skill-tools check .claude/skills               # spec validation, lint, quality score
skill-validator check .claude/skills           # structure, links, content
```

### 3. Check a Skill Before Installing It

```bash
skillspector scan https://github.com/anthropics/skills/tree/main/skills/skill-creator --no-llm
```

SkillSpector clones the repository into a temporary directory and scans it there.

## Which One When

| Task | Tool |
|------|------|
| Is this third-party skill safe to install? | `skillspector scan <url-or-dir> --no-llm` |
| Gate a coding agent's skill installs | SkillSpector's MCP server (`skillspector-register`; not yet in the Flox build, see below) |
| Catch secrets and dangerous commands in my own skills | `skillcheck`, plus `claudelint`'s secret rules |
| Lint the whole project (CLAUDE.md imports, skills, agents, settings, hooks, MCP, plugins) | `claudelint` (or [agnix](../agnix)) |
| Format Claude markdown and shell scripts | `claudelint format` |
| Is my `SKILL.md` spec-compliant, and how good is it? | `skill-tools check`, `skill-validator check` |
| Which skill would a prompt trigger? | `skill-tools route "<prompt>" -s <dir>` |
| A second opinion on agents, commands, and CLAUDE.md structure | `cclint` |

The tools find different things. Run against a sample project with a deliberately malicious skill, SkillSpector flagged the instruction override, the `curl ... | sudo bash`, and the SSH key upload; claudelint and skill-tools flagged the hardcoded tokens; skillcheck flagged them only where they weren't in a code block (see below); skill-validator flagged the invalid name and the links.

## SkillSpector

Security scanner for agent skills, from NVIDIA. It runs static analysis (pattern rules, YARA rules, Python AST checks, dependency checks) and, unless told otherwise, LLM analysis on top.

```bash
skillspector scan ./my-skill --no-llm                # static checks only
skillspector scan -r ./skills --no-llm               # each subdirectory with a SKILL.md
skillspector scan ./my-skill --no-llm --format sarif -o report.sarif
skillspector scan ./my-skill --no-llm --fail-on-findings   # exit 1 on any finding
skillspector baseline ./my-skill --no-llm           # accept current findings: writes .skillspector-baseline.yaml
skillspector scan ./my-skill --no-llm --baseline .skillspector-baseline.yaml   # report only new ones
```

Each report has a 0-100 risk score, a severity, and a recommendation (`SAFE` to `DO NOT INSTALL`). The static score is a triage signal, not a verdict: scripts that read environment variables or call `subprocess` raise it, so legitimate, script-heavy skills can score 100. In testing, Anthropic's skill-creator skill and the flox skill both did. Read the findings.

**LLM analysis.** Without `--no-llm`, SkillSpector sends the skill's content to an LLM. With `SKILLSPECTOR_PROVIDER` unset, it uses NVIDIA's hosted API (`NVIDIA_INFERENCE_KEY`) and falls back to OpenAI if `OPENAI_API_KEY` is set, so a key already in your shell is used without asking. With neither, the LLM stages fail with tracebacks and the scan is reported incomplete (exit 2). The banner shows which applies. To pick a provider:

```bash
SKILLSPECTOR_PROVIDER=ollama flox activate -d /path/to/agent-lint      # a local Ollama
SKILLSPECTOR_PROVIDER=anthropic ANTHROPIC_API_KEY=... flox activate -d /path/to/agent-lint
SKILLSPECTOR_PROVIDER=claude_cli flox activate -d /path/to/agent-lint  # your Claude Code login
```

`skillspector scan --help` lists every provider and its variables. Only `--no-llm` was tested here.

**MCP server.** `skillspector mcp` exposes one tool, `scan_skill`, so an agent can scan a skill before installing it. It needs SkillSpector's optional Python `mcp` dependency, which the `flox/skillspector` package (2.12.0) doesn't include, so in this environment it stops with "The MCP server requires the optional 'mcp' dependency". The environment still writes a launcher and a registration helper into `$FLOX_ENV_CACHE/bin`, ready for a package that includes it:

```bash
skillspector-register claude-code    # also: codex, print
```

`skillspector-register` starts the server once first, and registers nothing while it can't run. The launcher clears `PYTHONPATH`, so the server doesn't pick up Python packages from other environments you have active (which can make it appear to work in one shell and not another). Once it runs, note that the tool's `use_llm` argument defaults to true; without a provider, tell the agent to pass `use_llm: false`.

## skillcheck

Fast static scanner for skill files: hardcoded secrets (AWS, GitHub, Stripe, JWT, generic API keys), command injection, path traversal, privilege escalation, and information disclosure.

```bash
skillcheck .claude/skills
skillcheck --fail-on HIGH .claude/skills          # exit 1 on HIGH or CRITICAL (default: CRITICAL)
skillcheck --format sarif .claude/skills > skillcheck.sarif
```

Two limits to know:

- **It skips hidden directories.** `skillcheck .` never looks inside `.claude/`; pass `.claude/skills` (or the skill directory) explicitly. It scans every `.md` file it finds, not only `SKILL.md`.
- **It ignores code blocks.** Anything inside a fenced block is treated as an example and not reported, and most skills put their commands in code blocks. A skill with `curl ... | sudo bash` and a GitHub token in a `bash` block passed cleanly; the same lines as plain text produced six findings. Don't use skillcheck alone for third-party skills.

## claudelint

Linter for a whole Claude Code project: CLAUDE.md (including `@` imports), skills, subagents, settings, hooks, MCP configs, plugins, LSP configs, and output styles. Plain `claudelint` runs every validator.

```bash
claudelint                                  # lint the project (check-all)
claudelint --fix                            # apply fixes
claudelint --format sarif -o claudelint.sarif
claudelint explain skill-hardcoded-secrets  # rule documentation
claudelint init --yes                       # write .claudelintrc.json and .claudelintignore
claudelint format --check                   # markdownlint, prettier, and shellcheck
```

Plain `claudelint init`, which asks questions first, crashes in 0.10.0 (`Prompt type "list" is not registered`), so use `--yes` and edit the files afterwards. It writes a cache to `.claudelint-cache/` in the project; add that to `.gitignore`, or pass `--no-cache`. The environment includes shellcheck, which `claudelint format` uses for shell scripts.

## cclint

Linter for Claude Code agents, commands, `settings.json`, and CLAUDE.md, with suggestions for what CLAUDE.md should cover.

```bash
cclint                 # whole project
cclint agents          # also: commands, settings, context
cclint --format json -o cclint.json
```

Its schemas lag behind current Claude Code. In testing it rejected `model: fable` in a subagent and reported `permissions` and `model` in `settings.json` as unrecognized fields; claudelint accepted both. Treat its errors as hints, and prefer claudelint or agnix for settings.

## skill-tools

Validates `SKILL.md` files against the Agent Skills specification, lints them for quality (vague descriptions, hardcoded paths, embedded secrets, missing examples), and scores them from 0 to 100.

```bash
skill-tools check .claude/skills                         # validate + lint + score
skill-tools score ./my-skill
skill-tools route "summarize this pdf" -s .claude/skills # which skill a prompt matches
skill-tools route --conflicts -s .claude/skills          # overlapping skills
skill-tools to-prompt ./my-skill                         # <available_skills> XML
skill-tools init my-skill                                # scaffold a new skill
```

`skill-tools --version` prints an older version number than the package's; that's upstream.

## skill-validator

Checks skill directory structure, frontmatter, token counts, links, content quality, and "contamination" (instructions mixing languages or tools).

```bash
skill-validator check .claude/skills                  # all checks
skill-validator check --skip links .claude/skills     # without fetching links
skill-validator check -o json .claude/skills          # also: compact, markdown
skill-validator check --strict ./my-skill             # exit 1 for warnings too, not 2
```

`check` exits 1 when it finds errors and 2 when it finds only warnings, so warnings already fail a CI step; `--strict` reports them as errors. It also sends an HTTP request to every link in the skill, so on an untrusted skill that means contacting the URLs it contains. Use `--skip links` there.

`skill-validator score evaluate` is an optional LLM-as-judge score. It needs `ANTHROPIC_API_KEY` or `OPENAI_API_KEY`, or `--provider claude-cli` to use your Claude Code login. It wasn't tested here.

## Network Access

| Tool | Network use |
|------|-------------|
| SkillSpector | LLM provider unless `--no-llm`; clones Git URLs you pass it; queries [OSV](https://osv.dev) for vulnerabilities in a skill's declared dependencies |
| skillcheck | None |
| claudelint | Checks the npm registry for a newer release once a day; the environment turns that off (`NO_UPDATE_NOTIFIER=1`) |
| cclint | None |
| skill-tools | None |
| skill-validator | Fetches every link in the skill during `check` (skip with `--skip links`); LLM provider for `score evaluate` |

No usage telemetry turned up in any of their code. SkillSpector bundles LangSmith, which sends traces only if you set `LANGSMITH_TRACING` (or `LANGCHAIN_TRACING_V2`).

## Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `SKILLSPECTOR_PROVIDER` | unset (NVIDIA, then OpenAI) | LLM provider for SkillSpector |
| `SKILLSPECTOR_MODEL` | provider default | LLM model for SkillSpector |
| `NO_UPDATE_NOTIFIER` | `1` | Stops claudelint's update check; activate with `NO_UPDATE_NOTIFIER=` to allow it |

## Helper Commands

```bash
agent-lint-info          # Show versions, SkillSpector's LLM setting, and commands
skillspector-register    # Register SkillSpector's MCP server: claude-code, codex, or print
```

## Resources

- [SkillSpector GitHub](https://github.com/NVIDIA/SkillSpector)
- [skillcheck GitHub](https://github.com/agentigy/skillcheck)
- [claudelint GitHub](https://github.com/pdugan20/claudelint) and [documentation](https://claudelint.com)
- [cclint GitHub](https://github.com/carlrannaberg/cclint)
- [skill-tools GitHub](https://github.com/skill-tools/skill-tools)
- [skill-validator GitHub](https://github.com/agent-ecosystem/skill-validator)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For tool-specific issues, use each tool's GitHub issues (links above).

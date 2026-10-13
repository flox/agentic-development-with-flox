# Serena

MCP server that gives coding agents IDE-grade semantic code tools. Instead of reading whole files and editing by string matching, an agent using Serena can find symbols, follow references, and replace or insert code at the symbol level, backed by real language servers.

- **Semantic tools** - Find symbol, find references and implementations, rename, replace symbol body, diagnostics
- **Many languages** - Python, TypeScript/JavaScript, Go, Rust, Java, C/C++, C#, Ruby, PHP, and 40+ more via LSP
- **Works with your agent** - Claude Code, Codex, and any other MCP client
- **Project memories** - Serena keeps per-project notes the agent can read and update
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd serena
flox activate
```

### 2. Register Serena with Your Agent

```bash
serena-register claude-code    # or: codex
```

This registers Serena once, in the agent's user-level MCP config. The agent then starts Serena itself whenever it runs; you don't need to keep this environment active.

The registration points at this environment's directory. If you move or re-clone the repository, run `serena-register` again from the new location; it replaces the existing `serena` entry.

For any other MCP client, print the command and JSON snippet to paste into its config:

```bash
serena-register print
```

### 3. Use It

Start your agent in a project directory. Serena detects the project from the working directory (the nearest ancestor with `.git` or `.serena/project.yml`) and starts the matching language servers.

Check it is connected, e.g. in Claude Code with `claude mcp list` or `/mcp`.

## How the Launcher Works

`serena-register` points your agent at `serena-mcp`, a small launcher in `$FLOX_ENV_CACHE/bin` that runs:

```bash
flox activate -d <this environment> -- serena start-mcp-server ...
```

So Serena always runs with this environment's `uv` and `node`, whichever shell or environment started the agent. Because `flox activate --` sends activation output to stderr, the MCP protocol on stdout stays clean.

## Language Servers

Serena downloads most language servers on first use into `~/.serena`. This environment provides what those downloads need:

- **uv** - Python
- **node / npm** - TypeScript, JavaScript, Bash, JSON, YAML, and others

Other languages use the toolchain on your `PATH` (`gopls`, `rust-analyzer`, `java`, `clangd`, ...). Activate your project's own environment before starting the agent, and Serena picks those up.

### Python Projects

For Python, Serena's language server (pyright) does not use the Python on your `PATH` or find a project `.venv` by itself, so imports of your project's dependencies show up as unresolved. Point pyright at the virtual environment with a `pyrightconfig.json` in the project root:

```json
{ "venvPath": ".", "venv": ".venv" }
```

Use the directory that contains your virtual environment as `venvPath`, and the environment's directory name as `venv`.

```bash
serena project create          # Configure the current project (--language to choose)
serena project index           # Pre-index for faster first queries on large projects
serena project health-check    # Check that the language servers start
```

## Configuration

While this environment is active, Serena's own Python and its command-line tools (`python`, `python3`, `flask`, `uvicorn`, `httpx`, `dotenv`) come first on `PATH`, ahead of your own. You only need the environment active to run `serena-register` or the `serena` commands; agents start Serena through `serena-mcp` on their own.

Serena's global config is `~/.serena/serena_config.yml` (set `SERENA_HOME` to use another directory). Per-project settings are in `.serena/project.yml`.

By default Serena opens a dashboard tab in your browser each time an agent starts it. To keep the dashboard but stop it opening automatically, set:

```yaml
web_dashboard_open_on_launch: false
```

Serena sends anonymous usage information (OS, version, context) when it starts. Set `SERENA_USAGE_REPORTING=false` to turn this off.

## Helper Commands

```bash
serena-info    # Show configuration and command reference
```

## Resources

- [Serena Documentation](https://oraios.github.io/serena/)
- [Serena GitHub](https://github.com/oraios/serena)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Serena-specific issues:
- [Serena GitHub Issues](https://github.com/oraios/serena/issues)

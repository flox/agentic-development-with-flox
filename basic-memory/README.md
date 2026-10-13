# Basic Memory

Local-first memory for coding agents. Basic Memory stores what your agent learns as plain Markdown notes in a directory you own, indexes them into a local knowledge graph, and serves them over MCP so the agent can write, search, and build on them across sessions.

- **Plain Markdown** - Notes are ordinary `.md` files you can read, edit, grep, and commit
- **Knowledge graph** - Observations and `[[wiki links]]` between notes become searchable relations
- **Semantic search** - Full-text plus local vector search (FastEmbed, sqlite-vec); no API key
- **Works with your agent** - Claude Code, Codex, and any other MCP client
- **Local by default** - No account needed; the optional Basic Memory Cloud is never used unless you log in
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd basic-memory
flox activate
```

### 2. Register Basic Memory with Your Agent

```bash
basic-memory-register claude-code    # or: codex
```

This registers Basic Memory once, in the agent's user-level MCP config. The agent then starts it itself whenever it runs; you don't need to keep this environment active.

The registration points at this environment's directory. If you move or re-clone the repository, run `basic-memory-register` again from the new location; it replaces the existing `basic-memory` entry.

For any other MCP client, print the command and JSON snippet to paste into its config:

```bash
basic-memory-register print
```

### 3. Use It

Ask your agent to remember something ("write a note about how we deploy"), or to look something up ("search my notes for the deploy steps"). Check it is connected, e.g. in Claude Code with `claude mcp list` or `/mcp`.

The first search downloads a small embedding model (about 65 MB, from Hugging Face) into the Basic Memory data directory. The Hugging Face library also keeps a few small metadata files in `~/.cache/huggingface`.

## Where Notes Live

Notes go in `~/basic-memory` by default, organized into whatever folders the agent chooses. Config and the search index live in `~/.basic-memory` (or `$XDG_CONFIG_HOME/basic-memory` when `XDG_CONFIG_HOME` is set).

To keep notes somewhere else, add a project and make it the default:

```bash
bm project add work ~/notes/work
bm project default work
bm project list
```

Projects are just directories, so you can keep one per repository (e.g. `bm project add myapp ~/src/myapp/docs/memory`) and commit the notes alongside the code. Agents can also list and switch projects through MCP.

| Variable | Default | Purpose |
|----------|---------|---------|
| `BASIC_MEMORY_HOME` | `~/basic-memory` | Location of the first project, used when Basic Memory creates its config; afterwards use `bm project` |
| `BASIC_MEMORY_CONFIG_DIR` | `~/.basic-memory` | Config, database, and embedding model cache |
| `BASIC_MEMORY_NO_PROMOS` | `1` (set by this environment) | Cloud promos and their analytics event; `1`, `true`, or `yes` turns them off, anything else (e.g. `0`) allows them |
| `BASIC_MEMORY_AUTO_UPDATE` | `true` | Daily PyPI update check; `false` disables it |

## How the Launcher Works

`basic-memory-register` points your agent at `basic-memory-mcp`, a small launcher in `$FLOX_ENV_CACHE/bin` that runs:

```bash
flox activate -d <this environment> -- basic-memory mcp
```

So Basic Memory always runs with this environment's packages and settings, whichever shell or environment started the agent. Because `flox activate --` sends activation output to stderr, the MCP protocol on stdout stays clean.

## Working from the Shell

`bm` is a short alias for `basic-memory`. The same tools the agent uses are available on the command line:

```bash
bm tool search-notes "deploy"                      # Search
bm tool read-note "Deploy steps"                   # Read a note by title or permalink
echo "Body" | bm tool write-note --title "Idea" --folder inbox
bm tool recent-activity                            # What changed lately
bm doctor                                          # Check files against the index
bm reindex                                         # Rebuild the search index
```

While this environment is active, Basic Memory's own Python and its tools (`python`, `python3`, `pytest`, `pyright`, `hf`, `uvicorn`, ...) come first on `PATH`, ahead of your own. You only need the environment active to run `basic-memory-register` or the `bm` commands; agents start Basic Memory through `basic-memory-mcp` on their own.

## Privacy

- **Telemetry** - Basic Memory's Logfire instrumentation is off by default and stays off unless you enable it in `config.json`.
- **Analytics** - The interactive CLI shows Basic Memory Cloud promos and sends an anonymous event to Umami when it does. This environment sets `BASIC_MEMORY_NO_PROMOS=1`, which turns off both.
- **Update check** - Once a day, when an agent starts the MCP server or you run a `bm` command in a terminal, Basic Memory asks PyPI for the latest version. A Flox install never updates itself; set `BASIC_MEMORY_AUTO_UPDATE=false` to skip the check.
- **Cloud** - `bm cloud` commands are for the paid Basic Memory Cloud service. Nothing here uses them.

## License

Basic Memory is licensed under the AGPL-3.0.

## Helper Commands

```bash
basic-memory-info    # Show configuration and command reference
```

## Resources

- [Basic Memory Documentation](https://docs.basicmemory.com)
- [Basic Memory GitHub](https://github.com/basicmachines-co/basic-memory)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Basic Memory-specific issues:
- [Basic Memory GitHub Issues](https://github.com/basicmachines-co/basic-memory/issues)

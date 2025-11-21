# 📋 A Flox Environment for Backlog.md

This Flox environment gives you [Backlog.md](https://github.com/MrLesk/Backlog.md)—a markdown-native task manager and Kanban visualizer—preconfigured with shell completions, helpful aliases, and an optional MCP server for AI coding assistants.

## ✨ What You Get

- **Markdown-native task management** - Every task is a plain `.md` file in your Git repo
- **Interactive Kanban board** - Terminal-based board that updates in real-time
- **Modern web interface** - Sleek browser UI for visual task management
- **AI-ready** - Works with Claude Code, Gemini CLI, Codex via MCP protocol
- **Shell completions** - Tab completion configured automatically
- **Convenient aliases** - Quick access to common commands
- **100% private & offline** - All data stays in your repository

## 🧰 What's Inside

- `backlog-md` - Task management CLI, Kanban board, and web UI
- Shell completions for bash/zsh automatically installed
- MCP service for AI coding assistant integration (optional)
- Helpful aliases: `bb`, `bt`, `bw`, `bl`

## 🚀 Getting Started

### Prerequisites

- [Flox](https://flox.dev) installed
- A Git repository (backlog-md stores tasks in `backlog/` folder)

### Setup in Two Commands

```bash
# Activate the environment
flox activate

# Initialize backlog in your project
backlog init "My Project"
```

Follow the prompts to configure your task management setup and choose AI integration mode (MCP recommended).

## 📝 Built-in Commands

### Quick Aliases

```bash
bb              # backlog board - view Kanban board
bt              # backlog task - task management
bw              # backlog browser - launch web UI
bl              # backlog task list - list all tasks
```

### Common Workflows

```bash
# Create a task
bt create "Implement authentication"

# Create with details
bt create "Add OAuth" -d "Google + GitHub" -s "To Do" -l auth,backend

# List all tasks
bl

# View interactive Kanban board
bb

# Launch web interface (opens browser)
bw

# View specific task details
backlog task 7

# Edit task status and assignee
backlog task edit 7 -s "In Progress" -a @username

# Add acceptance criteria
backlog task edit 7 --ac "Must work with OAuth 2.0" --ac "Support refresh tokens"

# Archive completed task
backlog task archive 7
```

### Search and Filter

```bash
# Fuzzy search across all tasks
backlog search "auth"

# Filter by status
backlog search "api" --status "In Progress"

# Combine filters
backlog search "feature" --status "To Do" --priority high
```

### Export and Sharing

```bash
# Export board to markdown
backlog board export

# Export with version tag
backlog board export --export-version "v1.2.0"

# Export to README.md with markers
backlog board export --readme
```

## 🤖 MCP Service (AI Integration)

For AI coding assistants like Claude Code, Codex, and Gemini CLI:

```bash
# Start MCP server
flox activate -s

# Or manage service separately
flox services start
flox services status
flox services logs backlog-mcp
flox services stop
```

The MCP server allows AI tools to:
- Read task details and workflow instructions
- Create and update tasks programmatically
- Query task status and dependencies
- Follow your project's task management patterns

## 🔧 Configuration

Override defaults via environment variables:

```bash
# Custom web UI port
BACKLOG_PORT=8080 flox activate

# Disable auto-open browser
BACKLOG_AUTO_OPEN=false flox activate
```

Backlog.md's own configuration is managed via:
```bash
# Interactive configuration wizard
backlog config

# View all config values
backlog config list

# Set specific value
backlog config set defaultEditor "code --wait"
```

## 🔥 Troubleshooting

### Shell completions not working

Exit and re-activate the environment:
```bash
exit
flox activate
```

### MCP service exits immediately

Check the service logs:
```bash
cat $FLOX_ENV_CACHE/logs/backlog-mcp.log
```

The MCP server may need the current directory to be initialized with `backlog init` first.

### Commands not found

Make sure you're in an activated Flox environment:
```bash
flox activate
```

### Tasks not showing up

Ensure you've initialized backlog in the current repository:
```bash
backlog init
```

## 💻 System Support

This Flox environment currently supports:
- Linux (x86_64)

**Note**: While [Backlog.md](https://github.com/MrLesk/Backlog.md) itself is cross-platform (macOS, Linux, Windows), the `flox/backlog-md` package is currently only available for x86_64-linux. For other platforms, install backlog-md via npm/bun: `npm i -g backlog.md`

## 🔍 Power User Tips

- **Dependencies**: Link related tasks with `--dep task-1,task-2` to create execution sequences
- **Drafts**: Create draft tasks with `--draft` and promote them when ready with `backlog draft promote`
- **Cross-branch accuracy**: Backlog.md checks task states across active branches for accuracy
- **Web + CLI sync**: All changes in the web UI sync with markdown files instantly
- **Export automation**: Use `backlog board export` in CI to generate status reports

## 🌟 Related Projects

### Upstream

This environment packages [Backlog.md](https://github.com/MrLesk/Backlog.md) by MrLesk. **Thank you** to MrLesk and all contributors for creating and maintaining this excellent markdown-native task manager designed for human-AI collaboration in Git repositories.

### Packaging & Distribution

**Special thanks** to the [nix-ai-tools](https://github.com/numtide/nix-ai-tools) project by numtide and its contributors for making AI development tools accessible through Nix packaging. This comprehensive collection of AI-powered development utilities—including code assistants, MCP servers, and language models—makes it easy to get started with AI tooling. Their work benefits the entire community.

## About Flox

[Flox](https://flox.dev/docs) combines package and environment management, building on [Nix](https://github.com/NixOS/nix). It gives you Nix with a `git`-like syntax and an intuitive UX:

- **Declarative environments**. Software packages, variables, services, etc. are defined in simple, human-readable TOML format;
- **Content-addressed storage**. Multiple versions of packages with conflicting dependencies can coexist in the same environment;
- **Reproducibility**. The same environment can be reused across development, CI, and production;
- **Deterministic builds**. The same inputs always produce identical outputs for a given architecture, regardless of when or where builds occur;
- **World's largest collection of packages**. Access to over 150,000 packages—and millions of package-version combinations—from [Nixpkgs](https://github.com/NixOS/nixpkgs).

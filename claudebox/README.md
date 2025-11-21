# 🔒 Flox Environment for Claudebox

A Flox environment for [Claudebox](https://github.com/numtide/nix-ai-tools/tree/main/packages/claudebox), a lightweight sandbox wrapper for Claude Code that provides transparency into executed commands. This environment creates a safe, monitored workspace where you can see exactly what Claude Code is doing in real-time.

## ✨ Features

- **Lightweight sandboxing**: Uses bubblewrap for transparent command execution
- **Real-time monitoring**: See all executed commands in a live tmux pane
- **Credential isolation**: Shadows $HOME (no credentials accessible except ~/.claude)
- **Read-only project access**: Parent folder mounted read-only for dependency access
- **Command logging**: All commands stored in /tmp for review
- **Telemetry disabled**: Auto-updates and telemetry turned off in sandbox
- **Helper functions**: Convenient shortcuts for common usage patterns
- **Cross-shell support**: Works with bash, zsh, and fish

## 🧰 Included Tools

The environment includes:

- `claudebox` - Sandbox wrapper for Claude Code
- `claude-code` - Claude Code CLI (what gets sandboxed)
- `tmux` - Terminal multiplexer for command monitoring display
- `bat` - Enhanced file viewer for logs

## 🏁 Getting Started

### 📋 Prerequisites

- [Flox](https://flox.dev/get) installed on your system
- x86_64 Linux system (currently Linux-only)
- Basic familiarity with Claude Code

### 💻 Installation & Activation

Get started with:

```sh
# Clone the repo
git clone https://github.com/yourusername/floxenvs && cd floxenvs/claudebox

# Activate the environment
flox activate
```

This displays usage information and makes claudebox available.

## 📝 Usage

### Basic Usage

Start claudebox with default settings (horizontal tmux split):

```bash
claudebox
```

This opens:
- **Top pane**: Claude Code interface
- **Bottom pane**: Live command monitoring

### Helper Commands

The environment provides convenient shortcuts:

```bash
# Start with vertical split (side-by-side panes)
claudebox-vertical

# Start without tmux monitoring (direct Claude Code)
claudebox-no-monitor

# Start with minimal settings (no tmux config, no monitor)
claudebox-minimal

# Show all available options
claudebox-help
# or
claudebox --help
```

### Command-Line Options

Claudebox supports these flags:

```bash
claudebox [OPTIONS]

Options:
  --no-monitor                    Skip tmux monitoring, run Claude directly
  --split-direction horizontal    Set pane layout (horizontal or vertical)
  --split-direction vertical
  --no-tmux-config               Ignore user tmux configuration
  -h, --help                     Display help information
```

### Examples

**Vertical split layout (preferred for wide terminals):**
```bash
claudebox --split-direction vertical
# or use the helper
claudebox-vertical
```

**Run without monitoring (direct access):**
```bash
claudebox --no-monitor
# or use the helper
claudebox-no-monitor
```

**Ignore user tmux config:**
```bash
claudebox --no-tmux-config
```

**Combine options:**
```bash
claudebox --split-direction vertical --no-tmux-config
```

## 🔍 How It Works

### 🗄️ Sandboxing Model

**Home Directory Shadowing:**
- Claudebox creates a shadow $HOME environment
- No credentials accessible (except ~/.claude for Claude Code configuration)
- Prevents accidental access to sensitive files

**Read-Only Project Access:**
- Parent folder mounted read-only
- Dependencies remain accessible
- Changes only affect the sandboxed project

**Command Interception:**
- Node.js instrumentation intercepts all executed commands
- Commands displayed in real-time via tmux
- Full command history logged to /tmp

### 🚀 Monitoring Interface

**Tmux Layout:**
- Adaptive split based on terminal dimensions
- Wide terminals: vertical split (side-by-side)
- Narrow terminals: horizontal split (stacked)
- Live command output updates as Claude Code works

**What You See:**
- Command as executed (with full arguments)
- Execution status (running, completed, failed)
- Output and errors in real-time

### 🔐 Security Model

**Important:** Claudebox is **not a security boundary**. It's designed for:
- **Transparency**: See what Claude Code is doing
- **Awareness**: Monitor command execution in real-time
- **Convenience**: Sandboxed testing without affecting your main environment

**Not designed for:**
- Security isolation (use proper containerization for that)
- Preventing malicious code execution
- Production deployments

### 📂 What's Sandboxed

**Isolated:**
- $HOME directory (shadowed)
- Credentials and SSH keys (except ~/.claude)
- User configuration files

**Accessible:**
- Project directory (read-write)
- Parent folder (read-only)
- Project dependencies
- System tools and commands

## 🛠️ Common Workflows

### Quick Code Review

```bash
# Start claudebox with monitoring
flox activate
claudebox

# Use Claude Code as normal
# Watch commands execute in the monitoring pane
# Review command log after session
```

### Development Without Monitoring

For when you trust the workflow and don't need monitoring:

```bash
flox activate
claudebox-no-monitor
```

### Custom Layout for Wide Screens

```bash
flox activate
claudebox-vertical
```

### Reviewing Command History

Commands are logged to /tmp. View them with:

```bash
# Find the latest log file
ls -lt /tmp/claudebox-* | head -1

# View with bat (syntax highlighting)
bat $(ls -t /tmp/claudebox-* | head -1)
```

## 🔧 Troubleshooting

### Claudebox Won't Start

```bash
# Check if claudebox is available
which claudebox

# Verify tmux is installed
which tmux

# Try minimal mode
claudebox-minimal
```

### Tmux Issues

```bash
# Start without user tmux config
claudebox --no-tmux-config

# Check for existing tmux sessions
tmux ls

# Kill stuck sessions
tmux kill-session -t claudebox
```

### Claude Code Not Found

```bash
# Verify claude-code is available
which claude

# Ensure environment is activated
flox activate

# Check installation
flox list
```

### Split Direction Not Working

```bash
# Verify terminal dimensions
echo $COLUMNS x $LINES

# Force vertical split
claudebox-vertical

# Or specify explicitly
claudebox --split-direction vertical
```

### No Command Monitoring Visible

```bash
# Verify tmux is running
tmux ls

# Check if --no-monitor was accidentally used
# Restart without the flag
claudebox
```

### Can't Access Project Files

This is expected behavior - claudebox shadows $HOME. Access files via:
- Current project directory (read-write)
- Parent folder (read-only)
- Not from $HOME (isolated)

## 💻 System Compatibility

This environment currently works on:
- Linux x86_64

**Note:** macOS and ARM64 support coming soon.

## 🔒 Security Considerations

- **Not a security boundary**: Designed for transparency, not isolation
- **Shadow $HOME**: Credentials isolated (except ~/.claude)
- **Read-only parent**: Prevents accidental modification of dependencies
- **Command logging**: All commands visible and logged
- **No telemetry**: Disabled in sandbox environment
- **Use for development**: Not intended for production or untrusted code

## 📚 Additional Resources

- **Upstream Package**: [Claudebox in nix-ai-tools](https://github.com/numtide/nix-ai-tools/tree/main/packages/claudebox)
- **AI Tools Collection**: [nix-ai-tools](https://github.com/numtide/nix-ai-tools) - A great resource for collecting and running AI development tools with Nix
- **Claude Code**: [Official Claude Code documentation](https://claude.com/claude-code)
- **Flox Documentation**: [flox.dev/docs](https://flox.dev/docs)
- **Bubblewrap**: [Lightweight sandboxing tool](https://github.com/containers/bubblewrap)
- **tmux**: [Terminal multiplexer](https://github.com/tmux/tmux)

## 🙏 Acknowledgments

- **nix-ai-tools Team**: Special thanks to [numtide](https://github.com/numtide) and all contributors to [nix-ai-tools](https://github.com/numtide/nix-ai-tools) for creating and packaging Claudebox, making it easy to use this transparent sandbox wrapper for Claude Code in reproducible Nix-based environments

## 🔗 About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Software, variables, services defined in human-readable TOML
- **Content-addressed storage** - Multiple package versions coexist without conflicts
- **Reproducibility** - Same environment across dev, CI, and production
- **Deterministic builds** - Same inputs always produce identical outputs
- **Huge package collection** - Access to 150,000+ packages from [Nixpkgs](https://github.com/NixOS/nixpkgs)

## 📝 License

This Flox environment configuration is provided as-is. Claudebox and its dependencies have their own licenses - see the [nix-ai-tools repository](https://github.com/numtide/nix-ai-tools) for details.

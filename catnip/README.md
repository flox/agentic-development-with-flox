# Catnip Multi-Agent Development Environment

This Flox environment provides [Catnip](https://github.com/wandb/catnip) - a powerful multi-agent orchestration tool for running multiple Claude Code sessions in parallel.

## What is Catnip?

Catnip is a web service that:
- 🔒 **Isolates** Claude Code sessions in Docker containers
- 🌳 **Manages** git worktrees automatically for parallel development
- 📱 **Provides** web + mobile UI for monitoring sessions
- 🔄 **Enables** multiple Claude agents working simultaneously
- 🌐 **Forwards** ports automatically for service preview
- 🔐 **Handles** SSH access for remote development

## Quick Start

### 1. Activate the Environment

```bash
cd catnip
flox activate
```

The environment will check for a container runtime. If you don't have Docker installed:

```
ℹ️  No container runtime detected

   Catnip requires a container runtime (Docker/Colima/Podman)

   Options:
   1. Start Colima (included): flox activate -s
   2. Use existing Docker:     sudo systemctl start docker (Linux)
   3. Use Docker Desktop:      Start Docker Desktop (macOS)
```

**If you see this**, the environment includes **Colima** (a lightweight Docker alternative):

```bash
# Start Colima service
flox activate -s

# In another terminal, activate again (Colima is now running)
flox activate
```

You'll see:
```
✅ Container runtime ready
🐱 Catnip environment ready!

Quick start:
  catnip-start              # Launch Catnip with API keys
  catnip-start-dind         # Launch with Docker-in-Docker

Access: http://localhost:6369
```

### 2. Set Your API Key

```bash
# Option 1: Export before activation
export ANTHROPIC_API_KEY=your-key-here
flox activate

# Option 2: Pass during activation
ANTHROPIC_API_KEY=your-key flox activate

# Option 3: Add to your shell profile
echo 'export ANTHROPIC_API_KEY=your-key' >> ~/.bashrc
```

### 3. Launch Catnip

```bash
# Simple launch
catnip-start

# With Docker-in-Docker (for containerized projects)
catnip-start-dind

# Check configuration
catnip-info
```

### 4. Access the Web UI

Open your browser to: **http://localhost:6369**

From the UI, you can:
- Create new workspaces (git worktrees)
- Start multiple Claude Code sessions
- Monitor progress across all agents
- Access terminal interfaces
- Preview running services

## Usage Patterns

### Pattern 1: Parallel Feature Development

```bash
flox activate
catnip-start

# In web UI:
# - Create workspace "feature-auth"
# - Create workspace "feature-dashboard"
# - Create workspace "feature-api"

# Each workspace gets its own:
# - Git worktree (isolated branch)
# - Claude Code session
# - Environment variables
# - Port allocation
```

### Pattern 2: Multi-Language Projects

```bash
# Override language versions
CATNIP_PYTHON_VERSION=3.11 \
CATNIP_NODE_VERSION=18.0.0 \
flox activate

catnip-start
```

### Pattern 3: Containerized Development

```bash
# Enable Docker-in-Docker for building/running containers
catnip-start-dind

# Inside Catnip workspace, you can now:
# - docker build
# - docker-compose up
# - Build multi-container apps
```

### Pattern 4: Custom Project Setup

Create a `setup.sh` in your project root:

```bash
#!/bin/bash
# This runs when Catnip creates a workspace

# Install Python dependencies
if [ -f requirements.txt ]; then
    pip install -r requirements.txt
fi

# Install Node dependencies
if [ -f package.json ]; then
    npm install
fi

# Start background services
if [ -f docker-compose.yml ]; then
    docker-compose up -d
fi
```

Catnip will automatically run this when creating workspaces.

## Helper Commands

The environment provides these convenience functions:

### `catnip-start`
Launches Catnip with API keys automatically passed from environment.

```bash
catnip-start
catnip-start --custom-flag  # Pass extra args to catnip run
```

### `catnip-start-dind`
Launches Catnip with Docker-in-Docker support for containerized projects.

```bash
catnip-start-dind
```

### `catnip-info`
Shows current configuration and API key status.

```bash
catnip-info
```

Output:
```
Catnip Configuration:
  Port: 6369
  Python: 3.12
  Node: 20.11.0
  Go: 1.22
  Rust: 1.75.0

API Keys:
  ✓ ANTHROPIC_API_KEY set
  ✗ OPENAI_API_KEY missing
```

## Configuration

### Environment Variables

Override defaults by setting these before activation:

```bash
# API Keys
export ANTHROPIC_API_KEY=sk-ant-...
export OPENAI_API_KEY=sk-...

# Language Versions (for Catnip containers)
export CATNIP_PYTHON_VERSION=3.11
export CATNIP_NODE_VERSION=18.0.0
export CATNIP_GO_VERSION=1.21
export CATNIP_RUST_VERSION=1.70.0

# Port (if 6369 is in use)
export CATNIP_PORT=7000

# Colima resources (if using included Colima runtime)
export COLIMA_CPU=4
export COLIMA_MEMORY=8
export COLIMA_DISK=100

flox activate
```

### Colima Runtime Configuration

This environment includes **Colima** - a lightweight, free Docker alternative.

**Default Colima settings**:
- CPU: 2 cores
- Memory: 2GB
- Disk: 60GB
- Runtime: Docker

**Custom resources**:
```bash
# High-performance setup
COLIMA_CPU=4 COLIMA_MEMORY=8 flox activate -s

# Check Colima status
colima status

# View Colima info
colima-info
```

**When to use Colima**:
- ✅ You don't have Docker Desktop
- ✅ You want a free, lightweight alternative
- ✅ You're on Linux without system Docker
- ✅ You want isolated container runtime per project

**When to use existing Docker**:
- ✅ You already have Docker Desktop running
- ✅ You have system Docker installed
- ✅ You share containers across multiple projects

The environment auto-detects if Docker is already running and won't start Colima unnecessarily.

### Git Worktrees

Catnip automatically:
- Creates git worktrees in container
- Commits changes to `refs/catnip/$WORKSPACE_NAME`
- Creates branches like `feature/your-workspace-name`
- Keeps everything organized

**Viewing changes on host**:
```bash
# Fetch all catnip refs
git fetch catnip

# Or clone the catnip git server
git clone -o catnip http://localhost:6369/your-repo.git

# Checkout a workspace branch
git checkout feature/your-workspace-name
```

### Port Forwarding

Catnip automatically detects and forwards ports when services start inside workspaces.

**Access patterns**:
- Direct: `http://localhost:$PORT`
- Via Catnip proxy: `http://localhost:6369/$PORT`

The UI shows all active ports and provides click-through links.

## Mobile Access

Catnip supports mobile monitoring via the iOS app (currently in TestFlight beta).

**Setup**:
1. Visit https://catnip.run on mobile
2. Login with GitHub
3. See all your Catnip sessions
4. Monitor progress on the go

## Troubleshooting

### "ANTHROPIC_API_KEY not set"

```bash
# Set the key before activation
export ANTHROPIC_API_KEY=your-key
flox activate
```

### Port 6369 Already In Use

```bash
# Use different port
CATNIP_PORT=7000 flox activate
catnip-start
# Access at http://localhost:7000
```

### Catnip Command Not Found

```bash
# Ensure you're in activated environment
flox activate
which catnip  # Should show path in .flox/run
```

### Docker Issues (for --dind mode)

```bash
# Check Docker is running
docker ps

# Ensure your user is in docker group (Linux)
sudo usermod -aG docker $USER
newgrp docker
```

## Advanced: Composing with Other Environments

### Example: ML Development Stack

Create `ml-dev/.flox/env/manifest.toml`:

```toml
version = 1

[include]
environments = [
    { dir = "../catnip" }  # Include this Catnip environment
]

[install]
python313Full.pkg-path = "python313Full"
uv.pkg-path = "uv"

[vars]
UV_CACHE_DIR = "$FLOX_ENV_CACHE/uv-cache"

[hook]
on-activate = '''
setup_ml() {
  venv="$FLOX_ENV_CACHE/venv"
  if [ ! -d "$venv" ]; then
    uv venv "$venv" --python python3
  fi
}
setup_ml
'''
```

Now you have Catnip + ML tools in one environment:

```bash
cd ml-dev
flox activate
catnip-start  # Catnip containers have Python + ML tools
```

## Resources

- **Catnip GitHub**: https://github.com/wandb/catnip
- **Catnip Docs**: https://github.com/wandb/catnip#readme
- **Flox Docs**: https://flox.dev/docs
- **Claude Code**: https://claude.ai/code

## Tips

1. **Use descriptive workspace names**: `feature-user-auth` better than `test1`
2. **Commit frequently**: Catnip auto-commits help track Claude's progress
3. **Check the logs**: UI shows real-time command output
4. **Preview services**: Start dev servers in workspaces, preview in browser
5. **SSH access**: Use `ssh catnip` for remote development (Catnip configures this)

## What's Next?

Once you're comfortable with Catnip:
- Try running multiple experiments in parallel
- Use mobile app to monitor while away from desk
- Integrate with GitHub Codespaces (add to `.devcontainer/devcontainer.json`)
- Build custom environment compositions for your team
- Publish reproducible ML/AI development stacks

Happy multi-agent development! 🐱✨

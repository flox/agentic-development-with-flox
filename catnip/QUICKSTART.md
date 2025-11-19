# Catnip Quick Start Guide

## 30-Second Setup

```bash
# 1. Navigate to the catnip environment
cd catnip

# 2. Set your API key (if not already in environment)
export ANTHROPIC_API_KEY=your-key-here

# 3. Activate the environment
flox activate

# 4. If no container runtime detected, start Colima (in separate terminal)
flox activate -s

# 5. Launch Catnip
catnip-start
```

**Note**: If you already have Docker running, skip step 4.

## What Happens Next

1. **Catnip starts** and opens on http://localhost:6369
2. **Open your browser** to that URL
3. **Create a workspace** - This creates a git worktree
4. **Start Claude** - The agent begins working in that workspace
5. **Create more workspaces** - Run multiple agents in parallel

## Real-World Example

Let's say you want to work on three features simultaneously:

```bash
# Start Catnip
flox activate
catnip-start
```

In the web UI (http://localhost:6369):

1. **Workspace 1**: `feature-authentication`
   - Tell Claude: "Implement JWT authentication for our API"
   - Claude works in `refs/catnip/feature-authentication` branch

2. **Workspace 2**: `feature-dashboard`
   - Tell Claude: "Create a React dashboard with charts"
   - Claude works in `refs/catnip/feature-dashboard` branch

3. **Workspace 3**: `fix-database-bug`
   - Tell Claude: "Fix the SQL injection vulnerability in user queries"
   - Claude works in `refs/catnip/fix-database-bug` branch

All three Claudes work **simultaneously** in isolated environments!

## Reviewing Changes

```bash
# Back on your host machine, fetch the changes
git fetch catnip

# Check out what Claude did in workspace 1
git checkout feature-authentication

# Review the code
git log
git diff main

# Merge if you're happy with it
git checkout main
git merge feature-authentication
```

## Environment Variables You Can Set

```bash
# API Keys
export ANTHROPIC_API_KEY=sk-ant-...
export OPENAI_API_KEY=sk-...

# Custom language versions
export CATNIP_PYTHON_VERSION=3.11
export CATNIP_NODE_VERSION=18.0.0

# Custom port
export CATNIP_PORT=7000

# Then activate
flox activate
catnip-start
```

## Commands Available

Once activated, you have:

- `catnip-start` - Launch Catnip with your API keys
- `catnip-start-dind` - Launch with Docker-in-Docker support
- `catnip-info` - Show current configuration
- `catnip` - Direct access to catnip binary

## Docker-in-Docker Mode

If your project needs to build/run containers:

```bash
flox activate
catnip-start-dind

# Inside Catnip workspaces, you can now:
# - docker build -t myapp .
# - docker-compose up
# - Run containerized tests
```

## Troubleshooting

### "Command not found: catnip-start"

You're not in the activated environment:

```bash
# Make sure you're in the right directory
cd catnip

# Activate first
flox activate

# Now try again
catnip-start
```

### "ANTHROPIC_API_KEY not set"

```bash
# Set it before activating
export ANTHROPIC_API_KEY=your-key
flox activate

# Or pass it during activation
ANTHROPIC_API_KEY=your-key flox activate
```

### Port 6369 in use

```bash
# Use a different port
CATNIP_PORT=7000 flox activate
catnip-start
# Access at http://localhost:7000
```

## Next Steps

See [README.md](./README.md) for:
- Advanced usage patterns
- Custom project setup with `setup.sh`
- Mobile access
- Environment composition
- Tips and tricks

## Pro Tips

1. **Name workspaces descriptively** - Future you will thank you
2. **Use for experiments** - Try risky refactors safely
3. **Monitor on mobile** - Check progress while getting coffee
4. **Review before merging** - Always check Claude's work
5. **Create setup.sh** - Automate dependency installation per workspace

Happy multi-agent coding! 🐱✨

# Catnip Environment Architecture

## Overview

This Flox environment provides a complete multi-agent development setup by **composing** the Colima container runtime environment with Catnip orchestration tools.

## Component Separation

```
┌─────────────────────────────────────────────────────────┐
│ catnip/ (This Environment)                             │
│ ├─ Catnip orchestrator                                 │
│ ├─ Git tools                                           │
│ └─ Composes: barstoolbluz/colima-headless              │
│                                                         │
│    ┌────────────────────────────────────────────────┐  │
│    │ colima-headless (Composed Environment)         │  │
│    │ ├─ Colima container runtime                    │  │
│    │ ├─ Docker CLI                                  │  │
│    │ ├─ kubectl                                     │  │
│    │ └─ Colima service definition                   │  │
│    └────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

## Composition Pattern

### Why Composition (Not Layering)?

This environment uses **composition** rather than **layering** because:

1. ✅ **Deterministic**: Same result every activation
2. ✅ **Shareable**: Single environment definition for teams
3. ✅ **Declarative**: Everything in `manifest.toml`
4. ✅ **No nested shells**: Simpler activation model

### How It Works

```toml
[include]
environments = [
    { remote = "barstoolbluz/colima-headless" }
]
```

**At build time**, Flox:
1. Fetches `colima-headless` manifest from FloxHub
2. Merges packages: `colima`, `docker-client`, `kubectl`, `catnip`, `git`
3. Merges hooks: Colima setup + Catnip detection
4. Merges services: Colima service becomes available
5. Merges profile functions: Both `colima-info` and `catnip-*` available

**At activation**, you get:
```bash
flox activate
# → Single shell with ALL tools from both environments
# → colima, docker, kubectl, catnip, git all on PATH
# → Both hooks run in sequence
# → All functions available
```

## Runtime Flow

### Scenario 1: User Has Docker Already

```bash
cd catnip
flox activate

# Hook checks:
# → docker ps ✓ (succeeds)
# → "✅ Container runtime ready"

catnip-start
# → Catnip uses existing Docker
# → No Colima needed
```

### Scenario 2: User Needs Container Runtime

```bash
cd catnip
flox activate

# Hook checks:
# → docker ps ✗ (fails)
# → "ℹ️  No container runtime detected"
# → "Start Colima: flox activate -s"

# In separate terminal:
flox activate -s
# → Colima service starts
# → Sets DOCKER_HOST=unix://$HOME/.colima/default/docker.sock
# → Docker commands now work

# Back in first terminal:
catnip-start
# → Catnip uses Colima's Docker socket
# → Everything works!
```

## Key Design Decisions

### 1. Auto-Detection

```bash
# Hook in manifest.toml
if ! docker ps >/dev/null 2>&1; then
  echo "No runtime, here are options..."
else
  echo "✅ Container runtime ready"
fi
```

**Benefit**: Environment works whether user has Docker or needs Colima.

### 2. Colima as Service

```toml
[services]
colima.command = '''
  colima start --cpu $COLIMA_CPU --memory $COLIMA_MEMORY --foreground
'''
```

**Benefit**: Users run `flox activate -s` to start Colima, or ignore if Docker exists.

### 3. Configurable Resources

```bash
# From colima-headless
export COLIMA_CPU="${COLIMA_CPU:-2}"
export COLIMA_MEMORY="${COLIMA_MEMORY:-2}"
```

**Benefit**: Users can override: `COLIMA_CPU=4 COLIMA_MEMORY=8 flox activate -s`

### 4. Single Responsibility

**colima-headless**: Container runtime
- Provides: Docker socket
- Manages: VM resources
- Exposes: `colima`, `docker`, `kubectl`

**catnip**: Multi-agent orchestration
- Provides: Catnip CLI
- Requires: Container runtime
- Exposes: `catnip`, `catnip-start`, `catnip-info`

**Together**: Complete multi-agent environment with optional container runtime.

## Environment Variables

### From catnip/

```bash
# API Keys
ANTHROPIC_API_KEY    # Required for Claude
OPENAI_API_KEY       # Optional for GPT models

# Catnip Configuration
CATNIP_PORT           # Default: 6369
CATNIP_PYTHON_VERSION # Default: 3.12
CATNIP_NODE_VERSION   # Default: 20.11.0
CATNIP_GO_VERSION     # Default: 1.22
CATNIP_RUST_VERSION   # Default: 1.75.0
```

### From colima-headless/

```bash
# Colima Resources
COLIMA_CPU           # Default: 2 cores
COLIMA_MEMORY        # Default: 2GB
COLIMA_DISK          # Default: 60GB

# Colima Configuration
COLIMA_ARCH          # Default: x86_64
COLIMA_RUNTIME       # Default: docker
COLIMA_PROFILE       # Default: default
COLIMA_CPU_TYPE      # Auto-detected (host/qemu64)
COLIMA_KUBERNETES    # Default: false

# Docker Integration
DOCKER_HOST          # Set by Colima to socket path
KUBECONFIG           # Set by Colima if K8s enabled
```

## Commands Available

### Catnip Commands

```bash
catnip-start         # Launch Catnip with API keys
catnip-start-dind    # Launch with Docker-in-Docker
catnip-info          # Show Catnip configuration
catnip               # Direct access to catnip binary
```

### Colima Commands

```bash
colima-info          # Show Colima configuration
colima status        # Check Colima VM status
colima list          # List Colima profiles
colima ssh           # SSH into Colima VM
colima stop          # Stop Colima
colima delete        # Remove Colima VM
```

### Container Commands

```bash
docker ps            # List containers
docker build         # Build images
docker run           # Run containers
kubectl get nodes    # If Kubernetes enabled
```

### Service Commands

```bash
flox activate -s     # Start Colima service
flox services status # Check service status
flox services logs colima  # View Colima logs
flox services stop colima  # Stop Colima
```

## Use Cases

### Use Case 1: Solo Developer, No Docker

```bash
# Terminal 1: Start Colima
cd catnip
COLIMA_CPU=4 COLIMA_MEMORY=8 flox activate -s

# Terminal 2: Use Catnip
cd catnip
flox activate
catnip-start

# Create multiple workspaces in UI
# All use Colima's container runtime
```

### Use Case 2: Team with Docker Desktop

```bash
# Everyone already has Docker running
cd catnip
flox activate
# → "✅ Container runtime ready"

catnip-start
# → Uses existing Docker, no Colima needed
```

### Use Case 3: CI/CD Pipeline

```yaml
# GitHub Actions
- name: Setup Catnip
  run: |
    flox activate -s  # Start Colima in background
    flox activate -- catnip run --detach

- name: Create Workspaces
  run: |
    # Use Catnip API to create workspaces
    # All run in Colima containers
```

## Benefits of This Architecture

### 1. **Batteries Included**
- New users get container runtime automatically
- No "install Docker first" prerequisite
- Works out of the box

### 2. **Flexible**
- Uses existing Docker if available
- Colima only starts when needed
- Resources configurable per-project

### 3. **Reproducible**
- Same manifest everywhere
- Composed environments version-locked
- Team uses identical setup

### 4. **Composable**
- Can include this in other environments
- Layering still possible for ad-hoc tools
- Modular design

## Future Extensions

### Potential Compositions

```toml
# ML Development
[include]
environments = [
    { remote = "barstoolbluz/colima-headless" },
    { remote = "flox/catnip" },
    { remote = "team/python-ml" },
    { remote = "team/cuda-base" }
]
```

```toml
# Full-Stack Development
[include]
environments = [
    { remote = "barstoolbluz/colima-headless" },
    { remote = "flox/catnip" },
    { remote = "team/nodejs-dev" },
    { remote = "team/postgres" }
]
```

### Potential Layering

```bash
# Base: Catnip with Colima
flox activate

# Ad-hoc: Add debugging tools
flox activate -r team/debug-tools

# Now have: Catnip + Colima + debug tools
```

## Comparison: Composition vs Layering

| Aspect | This (Composition) | Alternative (Layering) |
|--------|-------------------|------------------------|
| **Setup** | `flox activate` | `flox activate -r colima -- flox activate -r catnip` |
| **Shells** | Single shell | Nested shells |
| **Commands** | All available | Outer shell commands shadowed |
| **Reproducible** | Yes (same every time) | Depends on order |
| **Shareable** | Yes (single manifest) | Requires documentation |
| **Conflicts** | Surface at build time | Surface at runtime |
| **Use Case** | Standard setup | Ad-hoc experimentation |

## Why This Works

1. **colima-headless** provides a **service** (Colima VM)
2. **catnip** provides **tools** (orchestration CLI)
3. Neither conflicts with the other
4. Both can run simultaneously
5. Both benefit from composition
6. Users can ignore Colima if Docker exists
7. Users can customize Colima resources if needed

This is a textbook example of **environment composition** done right.

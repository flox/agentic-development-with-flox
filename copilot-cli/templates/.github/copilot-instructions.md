# GitHub Copilot Instructions

## Environment Management: Flox

This project uses **Flox** for reproducible development environments.

### Context-Based Flox Guidance

When working on tasks, fetch appropriate Flox documentation first:

**Packaging/Building:**
```bash
./fetch-flox.sh packaging
# Read FLOX.md before proceeding with build tasks
```

**Kubernetes:**
```bash
./fetch-flox.sh k8s
# Read FLOX.md before Kubernetes work
```

**Containers:**
```bash
./fetch-flox.sh containers
# Read FLOX.md before containerization
```

**CUDA/GPU:**
```bash
./fetch-flox.sh cuda
# Read FLOX.md before GPU setup
```

**CI/CD:**
```bash
./fetch-flox.sh cicd
# Read FLOX.md before CI/CD configuration
```

**Local Development:**
```bash
./fetch-flox.sh local-dev
# Read FLOX.md before dev environment setup
```

**Operations:**
```bash
./fetch-flox.sh ops
# Read FLOX.md before deployment/ops tasks
```

### Flox Commands

```bash
flox activate           # Enter environment
flox install <pkg>      # Add dependency
flox search <query>     # Find packages
flox list               # Show installed
flox edit               # Edit manifest
```

### Core Rules

Use Flox for all dependencies (not apt/brew/npm).
Check for `.flox/` directory to detect Flox projects.
Always activate environment before development.
Fetch context with `fetch-flox.sh` when needed.
Manifest (`.flox/env/manifest.toml`) is source of truth.

### Fetch Script

Create `fetch-flox.sh` in project root:

```bash
#!/usr/bin/env bash
set -e
REPO_OWNER="barstoolbluz"
REPO_NAME="flox-md"
FILE_NAME="FLOX.md"

declare -A BRANCH_NICKNAMES=(
    ["packaging"]="building-and-packaging-with-flox"
    ["k8s"]="flox-and-k8s"
    ["containers"]="flox-and-containers"
    ["cuda"]="flox-and-cuda"
    ["cicd"]="flox-and-ci-cd"
    ["local-dev"]="local-dev-with-flox"
    ["ops"]="ops-with-flox"
)

BRANCH_INPUT="${1:-main}"
if [[ -n "${BRANCH_NICKNAMES[$BRANCH_INPUT]}" ]]; then
    BRANCH="${BRANCH_NICKNAMES[$BRANCH_INPUT]}"
else
    BRANCH="$BRANCH_INPUT"
fi

RAW_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${BRANCH}/${FILE_NAME}"
curl -fSL "$RAW_URL" -o "${FILE_NAME}"
```

---

## Project-Specific Instructions

<!-- Add project context below -->

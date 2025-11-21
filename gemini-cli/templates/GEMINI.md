# Project Configuration for Gemini CLI

## Environment Management with Flox

This project uses **Flox** for reproducible development environments.

### About Flox

Flox provides declarative, reproducible environments built on Nix. All dependencies, tools, and configurations are managed through Flox.

### When You Need Flox Context

Based on what I ask you to do, fetch the appropriate Flox documentation **before proceeding**:

| My Request | You Should | Command to Run |
|------------|------------|----------------|
| "Package this" or "Build this" | Fetch packaging guide | `./fetch-flox.sh packaging` |
| "Deploy to Kubernetes" | Fetch K8s guide | `./fetch-flox.sh k8s` |
| "Containerize this" | Fetch container guide | `./fetch-flox.sh containers` |
| "Setup CUDA/GPU" | Fetch CUDA guide | `./fetch-flox.sh cuda` |
| "Setup CI/CD" | Fetch CI/CD guide | `./fetch-flox.sh cicd` |
| "Local dev setup" | Fetch local dev guide | `./fetch-flox.sh local-dev` |
| "Deploy this" or "Operations" | Fetch ops guide | `./fetch-flox.sh ops` |

### Workflow

1. **I ask you to do something requiring Flox knowledge**
2. **You run**: `./fetch-flox.sh <appropriate-context>`
3. **You read**: The downloaded `FLOX.md` file
4. **You apply**: Flox best practices from that guide
5. **You proceed**: With my original request

### Flox Command Reference

```bash
# Activate environment
flox activate

# Install packages
flox install <package>

# Search packages
flox search <query>

# Show package details
flox show <package>

# List installed
flox list

# Edit manifest
flox edit
```

### Core Principles

- ✅ **Use Flox for all dependencies** - Not apt, brew, npm globally
- ✅ **Check for `.flox/` directory** - Indicates Flox project
- ✅ **Activate before working** - Always `flox activate` first
- ✅ **Manifest is source of truth** - `.flox/env/manifest.toml`
- ✅ **Fetch context when needed** - Use `fetch-flox.sh` proactively

### Fetch Script

Save as `fetch-flox.sh` in project root:

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
    echo "Using nickname '$BRANCH_INPUT' → branch '$BRANCH'"
else
    BRANCH="$BRANCH_INPUT"
fi

RAW_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${BRANCH}/${FILE_NAME}"

echo "Downloading ${FILE_NAME}..."
if curl -fSL "$RAW_URL" -o "${FILE_NAME}"; then
    echo "✓ Saved to $(pwd)/${FILE_NAME}"
else
    echo "✗ Failed to fetch ${FILE_NAME}" >&2
    exit 1
fi
```

---

## General Instructions

<!-- Project-specific instructions below -->

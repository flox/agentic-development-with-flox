# AI Agent Instructions

This project uses **Flox** for reproducible development environments.

## Environment Management with Flox

### What is Flox?

Flox provides declarative, reproducible development environments built on Nix. All project dependencies, tools, and configurations are managed through Flox environments.

### When You Need Context About Flox

Based on what the user asks you to do, fetch the appropriate Flox documentation:

| User Request | Context to Fetch | Command |
|--------------|------------------|---------|
| Package or build software | Packaging guide | `./fetch-flox.sh packaging` |
| Work with Kubernetes | K8s integration | `./fetch-flox.sh k8s` |
| Use containers/Docker | Container guide | `./fetch-flox.sh containers` |
| Setup CUDA/GPU | CUDA guide | `./fetch-flox.sh cuda` |
| Configure CI/CD | CI/CD integration | `./fetch-flox.sh cicd` |
| Local development setup | Local dev guide | `./fetch-flox.sh local-dev` |
| Operations/deployment | Ops guide | `./fetch-flox.sh ops` |

### Fetch Flox Context Script

```bash
#!/usr/bin/env bash
# Script to fetch FLOX.md from a specific branch of the remote repository
# Usage: ./fetch-flox.sh [branch-name-or-nickname]
# Default: main

set -e

# Remote repository details
REPO_OWNER="barstoolbluz"
REPO_NAME="flox-md"
FILE_NAME="FLOX.md"

# Branch nickname mappings
declare -A BRANCH_NICKNAMES=(
    ["packaging"]="building-and-packaging-with-flox"
    ["k8s"]="flox-and-k8s"
    ["containers"]="flox-and-containers"
    ["cuda"]="flox-and-cuda"
    ["cicd"]="flox-and-ci-cd"
    ["local-dev"]="local-dev-with-flox"
    ["ops"]="ops-with-flox"
)

# Get branch from argument or use default
BRANCH_INPUT="${1:-main}"

# Resolve nickname to full branch name if applicable
if [[ -n "${BRANCH_NICKNAMES[$BRANCH_INPUT]}" ]]; then
    BRANCH="${BRANCH_NICKNAMES[$BRANCH_INPUT]}"
    echo "Using nickname '$BRANCH_INPUT' → branch '$BRANCH'"
else
    BRANCH="$BRANCH_INPUT"
    echo "Fetching from branch '$BRANCH'"
fi

# Construct the raw GitHub URL
RAW_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${BRANCH}/${FILE_NAME}"

# Fetch the file
echo "Downloading ${FILE_NAME} from ${RAW_URL}..."
if curl -fSL "$RAW_URL" -o "${FILE_NAME}"; then
    echo "Successfully saved ${FILE_NAME} to $(pwd)/${FILE_NAME}"
else
    echo "Error: Failed to fetch ${FILE_NAME} from branch '${BRANCH}'" >&2
    echo "Please verify the branch exists and contains ${FILE_NAME}" >&2
    exit 1
fi
```

### How to Use

1. **Save the script**: Copy the above script to `fetch-flox.sh` in project root
2. **Make it executable**: `chmod +x fetch-flox.sh`
3. **When user needs Flox help**: Run `./fetch-flox.sh <context>` before proceeding
4. **Read FLOX.md**: After fetching, read the downloaded `FLOX.md` for guidance
5. **Apply the guidance**: Follow Flox best practices from the documentation

### Flox Environment Commands

```bash
# Activate environment
flox activate

# Install package
flox install <package>

# Search for packages
flox search <package>

# Show package info
flox show <package>

# List installed packages
flox list

# Edit manifest
flox edit
```

### Important

- **Always check for Flox environment first**: Look for `.flox/` directory
- **Use Flox instead of system package managers**: Don't use apt, brew, npm globally
- **Activate before working**: Ensure `flox activate` before development tasks
- **Reproducibility**: All dependencies should be in the Flox manifest

---

## Project-Specific Instructions

<!-- Add project-specific context below -->

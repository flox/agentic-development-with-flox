# Goose Instructions

This project uses **Flox** for reproducible development environments.

## Environment Management with Flox

### About Flox

Flox provides declarative, reproducible development environments built on Nix. All project dependencies, tools, and configurations are managed through Flox.

## Context-Based Flox Guidance

When working on tasks, fetch appropriate Flox documentation before proceeding.

### Task to Context Mapping

| User Request | Context | Command |
|--------------|---------|---------|
| Package or build software | Packaging | `./fetch-flox.sh packaging` |
| Work with Kubernetes | K8s | `./fetch-flox.sh k8s` |
| Use containers/Docker | Containers | `./fetch-flox.sh containers` |
| Setup CUDA/GPU | CUDA | `./fetch-flox.sh cuda` |
| Configure CI/CD | CI/CD | `./fetch-flox.sh cicd` |
| Local development setup | Local dev | `./fetch-flox.sh local-dev` |
| Operations/deployment | Ops | `./fetch-flox.sh ops` |

## Workflow

1. **User makes a request** requiring Flox knowledge
2. **Identify context** from the mapping table above
3. **Fetch documentation**: Run `./fetch-flox.sh <context>`
4. **Read FLOX.md**: Study the downloaded guide
5. **Apply best practices**: Use Flox patterns from documentation
6. **Complete task**: Proceed with user's original request

## Fetch Flox Context Script

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
    echo "Using nickname '$BRANCH_INPUT' → branch '$BRANCH'"
else
    BRANCH="$BRANCH_INPUT"
    echo "Fetching from branch '$BRANCH'"
fi

RAW_URL="https://raw.githubusercontent.com/${REPO_OWNER}/${REPO_NAME}/${BRANCH}/${FILE_NAME}"

echo "Downloading ${FILE_NAME} from ${RAW_URL}..."
if curl -fSL "$RAW_URL" -o "${FILE_NAME}"; then
    echo "Successfully saved ${FILE_NAME} to $(pwd)/${FILE_NAME}"
else
    echo "Error: Failed to fetch ${FILE_NAME} from branch '${BRANCH}'" >&2
    echo "Please verify the branch exists and contains ${FILE_NAME}" >&2
    exit 1
fi
```

### Setup

1. Copy `fetch-flox.sh` to project root
2. Make executable: `chmod +x fetch-flox.sh`
3. Run when needed: `./fetch-flox.sh <context>`

## Flox Command Reference

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

## Core Principles

- ✅ **Check for Flox first**: Look for `.flox/` directory
- ✅ **Use Flox for dependencies**: Not apt, brew, npm globally
- ✅ **Activate before working**: Run `flox activate` first
- ✅ **Fetch context proactively**: When user's task matches a context type
- ✅ **Manifest is source of truth**: `.flox/env/manifest.toml`
- ✅ **Reproducibility**: Same environment everywhere

## Goose-Specific Integration

- **Profile configuration**: Use `.goose/profiles.yaml` to embed Flox instructions
- **Session context**: Goose maintains conversation context across sessions
- **Toolkit integration**: Flox commands can be part of Goose's toolkit
- **Local models**: Works with Ollama for local, privacy-focused development

---

## Project-Specific Instructions

<!-- Add project-specific context below -->

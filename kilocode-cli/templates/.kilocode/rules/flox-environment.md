# Flox Environment Management

This project uses **Flox** for reproducible development environments.

## What is Flox?

Flox provides declarative, reproducible development environments built on Nix. All project dependencies, tools, and configurations are managed through Flox.

## Detection

Check for `.flox/` directory in the project root. If present, this is a Flox-managed project.

## Context-Based Documentation Fetching

Before working on specific types of tasks, fetch appropriate Flox documentation:

### Task to Context Mapping

| User's Request | Context | Fetch Command |
|----------------|---------|---------------|
| Package or build software | Packaging | `./fetch-flox.sh packaging` |
| Work with Kubernetes | K8s | `./fetch-flox.sh k8s` |
| Use containers/Docker | Containers | `./fetch-flox.sh containers` |
| Setup CUDA/GPU | CUDA | `./fetch-flox.sh cuda` |
| Configure CI/CD | CI/CD | `./fetch-flox.sh cicd` |
| Local development setup | Local dev | `./fetch-flox.sh local-dev` |
| Operations/deployment | Ops | `./fetch-flox.sh ops` |

### Workflow

1. User makes a request requiring Flox knowledge
2. Identify which context from the table above
3. Run: `./fetch-flox.sh <context>`
4. Read the downloaded `FLOX.md` file
5. Apply Flox best practices from the documentation
6. Proceed with the user's original request

## Fetch Flox Context Script

The project should have `fetch-flox.sh` in the root:

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

## Flox Commands Reference

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

# Edit manifest directly
flox edit

# Show environment info
flox info
```

## Core Rules for Flox Projects

1. **Always activate first**: Run `flox activate` before development work
2. **Use Flox for dependencies**: Don't use apt, brew, npm globally
3. **Manifest is source of truth**: `.flox/env/manifest.toml` defines all packages
4. **Reproducibility**: Flox ensures same environment across machines
5. **Fetch context proactively**: When task matches a context type, fetch guidance first
6. **Read documentation**: After fetching FLOX.md, read it before proceeding

## When to Fetch Context

Automatically fetch context when user mentions:

- **Packaging keywords**: build, package, compile, distribute, release
- **Kubernetes keywords**: k8s, kubernetes, kubectl, deployment, pod, service
- **Container keywords**: docker, containerize, dockerfile, image, registry
- **CUDA keywords**: GPU, CUDA, nvidia, machine learning training
- **CI/CD keywords**: pipeline, github actions, gitlab ci, jenkins, continuous
- **Local dev keywords**: development environment, dev setup, local setup
- **Ops keywords**: deploy, deployment, production, infrastructure, terraform

## Example Workflow

User: "I need to package this Python application for distribution"

1. Detect packaging context
2. Run: `./fetch-flox.sh packaging`
3. Read FLOX.md for packaging best practices
4. Apply Flox packaging patterns
5. Help user package their application

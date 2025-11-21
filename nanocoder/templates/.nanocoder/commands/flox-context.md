---
name: flox-context
description: Fetch context-specific Flox documentation based on current task
---

# Flox Context Fetcher

This command helps you fetch appropriate Flox documentation before working on tasks.

## Usage

When I'm working on a task, determine which context I need and fetch it:

```bash
./fetch-flox.sh <context>
```

## Context Selection

| Task Type | Context | Command |
|-----------|---------|---------|
| Package or build software | packaging | `./fetch-flox.sh packaging` |
| Work with Kubernetes | k8s | `./fetch-flox.sh k8s` |
| Use containers/Docker | containers | `./fetch-flox.sh containers` |
| Setup CUDA/GPU | cuda | `./fetch-flox.sh cuda` |
| Configure CI/CD | cicd | `./fetch-flox.sh cicd` |
| Local development setup | local-dev | `./fetch-flox.sh local-dev` |
| Operations/deployment | ops | `./fetch-flox.sh ops` |

## Workflow

1. User asks me to work on a task
2. I determine which Flox context is needed
3. I run `./fetch-flox.sh <context>` to download FLOX.md
4. I read FLOX.md for Flox best practices
5. I apply those practices to the task
6. I proceed with the user's request

## Fetch Script

The `fetch-flox.sh` script should exist in the project root:

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

## Important Principles

- Always check for `.flox/` directory to detect Flox projects
- Use Flox for all dependencies (not apt, brew, npm globally)
- Activate environment before working: `flox activate`
- Fetch context proactively when user's request matches a context type
- The manifest (`.flox/env/manifest.toml`) is the source of truth

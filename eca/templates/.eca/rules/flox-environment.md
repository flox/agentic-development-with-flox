# Flox Environment Management Rule

**Description**: Use Flox for all environment and dependency management

**Globs**: `**/*`, `.flox/**/*`

## Overview

This project uses **Flox** for reproducible development environments. Flox provides declarative, reproducible environments built on Nix.

## Detection

Look for `.flox/` directory in the project root. If present, this is a Flox-managed project.

## Context-Based Documentation

Fetch appropriate Flox documentation based on the task type:

### Context Mapping

| User Request Type | Context | Fetch Command |
|-------------------|---------|---------------|
| Package or build software | Packaging | `./fetch-flox.sh packaging` |
| Kubernetes work | K8s | `./fetch-flox.sh k8s` |
| Container/Docker work | Containers | `./fetch-flox.sh containers` |
| CUDA/GPU setup | CUDA | `./fetch-flox.sh cuda` |
| CI/CD configuration | CI/CD | `./fetch-flox.sh cicd` |
| Local development setup | Local dev | `./fetch-flox.sh local-dev` |
| Operations/deployment | Ops | `./fetch-flox.sh ops` |

## Standard Workflow

1. User makes a request requiring Flox knowledge
2. Determine which context is needed from the mapping table
3. Execute: `./fetch-flox.sh <context>`
4. Read the downloaded `FLOX.md` file for context-specific guidance
5. Apply Flox best practices from the documentation
6. Proceed with the user's original request

## Fetch Script

The project should contain `fetch-flox.sh` in the root directory:

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

## Flox Commands

```bash
# Activate environment
flox activate

# Install package
flox install <package>

# Search for packages
flox search <package>

# Show package information
flox show <package>

# List installed packages
flox list

# Edit manifest directly
flox edit

# Show environment details
flox info
```

## Rules for Flox Projects

1. **Always activate first**: Ensure `flox activate` before any development work
2. **Use Flox exclusively**: Don't use system package managers (apt, brew, npm globally)
3. **Manifest is authoritative**: `.flox/env/manifest.toml` defines the environment
4. **Reproducibility**: Flox ensures identical environments across machines
5. **Fetch context proactively**: When task type matches a context, fetch documentation first
6. **Read before acting**: After fetching FLOX.md, read it thoroughly before proceeding

## Trigger Keywords

Automatically fetch context when user mentions:

- **Packaging**: build, package, compile, distribute, release, bundle
- **Kubernetes**: k8s, kubernetes, kubectl, deployment, pod, service, helm
- **Containers**: docker, containerize, dockerfile, image, registry, oci
- **CUDA**: GPU, CUDA, nvidia, tensorflow, pytorch, machine learning
- **CI/CD**: pipeline, github actions, gitlab ci, jenkins, continuous integration
- **Local dev**: development environment, dev setup, local setup, onboarding
- **Ops**: deploy, deployment, production, infrastructure, terraform, ansible

## Integration with ECA

ECA's background service model works well with Flox:

- Flox manages all dependencies including ECA itself
- Services defined in `.flox/env/manifest.toml` work with ECA's daemon
- Both support reproducible, declarative configuration
- AGENTS.md in project root provides additional guidance

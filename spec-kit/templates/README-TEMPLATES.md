# Flox-Aware AI Agent Templates

This directory contains canonical templates that make AI coding agents "Flox-native" by default.

## What These Templates Do

Each template:
1. **Instructs the agent to use Flox** for environment management
2. **Includes `fetch-flox.sh` script** for context-specific guidance
3. **Maps user requests to Flox contexts** (packaging, k8s, containers, etc.)
4. **Provides Flox command reference** for the agent

## Available Templates

### Universal Standard

**`AGENTS.md`** - Emerging universal standard
- Supported by: ECA, GitHub Copilot, others
- Location: Project root
- Use: Copy to any project root

### Agent-Specific Templates

**`GEMINI.md`** (Gemini CLI)
- Location: Project root or `~/.gemini/GEMINI.md`
- Hierarchical loading supported

**`.github/copilot-instructions.md`** (GitHub Copilot)
- Location: `.github/` directory
- Alternative: `AGENTS.md` in root

**Nanocoder Commands** (`.nanocoder/commands/`)
- Custom commands with YAML frontmatter
- Example: `/flox-context` command

**Kilocode Rules** (`.kilocode/rules/`)
- Markdown files with optional metadata
- Auto-loaded based on globs

**ECA Rules** (`.eca/rules/`)
- Markdown files with description/globs
- Plus `AGENTS.md` in root

## Fetch Script (`fetch-flox.sh`)

All templates reference this script for dynamic Flox context:

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
    echo "✗ Failed to fetch" >&2
    exit 1
fi
```

## Usage

### For Users

1. **Copy template to your project:**
   ```bash
   cp templates/AGENTS.md /path/to/your/project/
   cp templates/fetch-flox.sh /path/to/your/project/
   chmod +x /path/to/your/project/fetch-flox.sh
   ```

2. **Customize project-specific section:**
   Edit the template to add your project's specific context

3. **Agent automatically uses it:**
   AI agents will read the instructions and become Flox-aware

### For Agent Environments

Each agent environment can include these templates and document their usage in the README.

## Context Mapping

| User Request | Context | Command |
|--------------|---------|---------|
| Build/package software | Packaging | `./fetch-flox.sh packaging` |
| Kubernetes deployment | K8s | `./fetch-flox.sh k8s` |
| Containerize app | Containers | `./fetch-flox.sh containers` |
| Setup CUDA/GPU | CUDA | `./fetch-flox.sh cuda` |
| CI/CD pipeline | CI/CD | `./fetch-flox.sh cicd` |
| Local dev environment | Local dev | `./fetch-flox.sh local-dev` |
| Deploy/operations | Ops | `./fetch-flox.sh ops` |

## Implementation Status

- ✅ Universal `AGENTS.md`
- ✅ Gemini CLI `GEMINI.md`
- ✅ GitHub Copilot `.github/copilot-instructions.md`
- ⏳ Nanocoder commands (TODO)
- ⏳ Kilocode rules (TODO)
- ⏳ ECA rules (TODO)
- ⏳ Goose profiles (TODO)

## Next Steps

1. Complete remaining agent-specific templates
2. Update each agent's README with template usage
3. Add optional activation hook helpers for template deployment
4. Test templates with each agent
5. Document best practices for customization

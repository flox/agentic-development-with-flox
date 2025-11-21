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

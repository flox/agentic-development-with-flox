# Flox-Aware Development Instructions

**You are working in a Flox-managed environment.**

Flox provides reproducible, declarative development environments through `.flox/env/manifest.toml`. Always use Flox commands instead of traditional package managers.

## 🔍 Detecting Flox Projects

Check for `.flox/` directory in the project root to identify Flox projects.

## 📚 Context-Specific Documentation

Before starting work on Flox-related tasks, fetch relevant documentation using the `fetch-flox.sh` script:

| User Request | Context to Fetch | Command |
|--------------|------------------|---------|
| Package or build software | Packaging guide | `./fetch-flox.sh packaging` |
| Work with Kubernetes | K8s integration | `./fetch-flox.sh k8s` |
| Container tasks | Container workflows | `./fetch-flox.sh containers` |
| GPU/CUDA setup | CUDA configuration | `./fetch-flox.sh cuda` |
| CI/CD pipelines | CI/CD patterns | `./fetch-flox.sh cicd` |
| Local development | Dev environments | `./fetch-flox.sh local-dev` |
| Operations/deployment | Ops workflows | `./fetch-flox.sh ops` |

**Workflow:**
1. User mentions Flox-related task (packaging, K8s, containers, CUDA, etc.)
2. Run appropriate `./fetch-flox.sh <context>` command
3. Read the fetched `FLOX.md` file
4. Apply patterns and best practices from that documentation
5. Explain to user what you learned and how you'll apply it

**Quick command:** Use `/flox-context <type>` to fetch documentation on demand.

## 🔧 Core Flox Commands Reference

### Environment Management
```bash
flox activate                    # Activate environment
flox install <package>          # Add package to environment
flox uninstall <package>        # Remove package
flox search <package>           # Search available packages
flox show <package>             # Show package details
flox list                       # List installed packages
```

### Environment Creation
```bash
flox init                       # Initialize new environment
flox edit                       # Edit manifest.toml
flox pull <owner>/<name>        # Pull shared environment
```

### Services
```bash
flox services start             # Start all services
flox services stop              # Stop all services
flox services status            # Check service status
flox services restart <name>    # Restart specific service
flox services logs <name>       # View service logs
```

### Building & Publishing
```bash
flox build                      # Build custom packages
flox publish                    # Publish to FloxHub
```

## 🎯 Best Practices

### When User Requests Flox Work

1. **Detect the context**: What type of task? (packaging, k8s, cuda, etc.)
2. **Fetch documentation**: Run `./fetch-flox.sh <context>` or use `/flox-context <type>`
3. **Read FLOX.md**: Study the fetched patterns
4. **Apply patterns**: Use the specific approaches documented
5. **Explain**: Tell user what you learned and how you're applying it

### Package Installation

**DO** use Flox:
```bash
flox install nodejs python312 postgresql
```

**DON'T** use system package managers:
```bash
# ❌ Don't do this in Flox projects
apt install nodejs
brew install python
pip install --global
npm install -g
```

### Configuration Files

- **Secrets MUST be in `$HOME`**: API keys, credentials, tokens
- **Project configs without secrets**: Can be in project directory
- **Environment variables**: Use for secrets (e.g., `ANTHROPIC_API_KEY`)

### Manifest Editing

When modifying `.flox/env/manifest.toml`:

```toml
# Add packages
[install]
nodejs.pkg-path = "nodejs"
python.pkg-path = "python312"

# Set environment variables
[vars]
NODE_ENV = "development"
PYTHON_PATH = "$FLOX_ENV/lib/python3.12/site-packages"

# Activation hooks
[hook]
on-activate = '''
  echo "Environment activated!"
  npm install  # Install project dependencies
'''

# Define services
[services]
api.command = "npm run dev"
db.command = "postgres -D $FLOX_ENV_CACHE/pgdata"
```

## 🚀 Example Workflows

### Adding a New Dependency

When user asks to add a package:

1. Detect if it's a Flox project (`test -d .flox`)
2. Use `flox install <package>` instead of apt/brew/npm -g
3. Verify with `flox list`
4. Explain what was done

### Setting Up a Service

When user requests a service:

1. Edit manifest with `flox edit`
2. Add service to `[services]` section
3. Start with `flox services start`
4. Check status with `flox services status`

### Building a Package

When packaging is needed:

1. Fetch packaging documentation: `./fetch-flox.sh packaging`
2. Read and apply patterns from `FLOX.md`
3. Edit manifest to add `[build]` section
4. Build with `flox build`
5. Test in activated environment

## 🔐 Security Conventions

**CRITICAL - Flox Security Pattern:**

✅ **DO** put secrets in `$HOME`:
```bash
~/.config/opencode/opencode.json   # API keys here
~/.config/app/credentials          # Credentials here
```

❌ **DON'T** put secrets in:
```bash
project-dir/opencode.json           # ❌ Only if NO secrets
project-dir/.opencode/config        # ❌ Never secrets here
$FLOX_ENV_CACHE/config.json        # ❌ Never
.flox/env/manifest.toml            # ❌ Never
```

**Use environment variables for secrets in project configs:**
```json
{
  "model": "{env:OPENCODE_MODEL}",
  "api_key": "{env:ANTHROPIC_API_KEY}"
}
```

## 📋 Task Checklist

When working on Flox projects:

- [ ] Detect `.flox/` directory
- [ ] Identify task context (packaging, k8s, cuda, etc.)
- [ ] Fetch appropriate documentation with `fetch-flox.sh` or `/flox-context`
- [ ] Read and understand `FLOX.md` patterns
- [ ] Apply Flox-specific approaches
- [ ] Use `flox install` instead of system package managers
- [ ] Put secrets in `$HOME`, never in project directories
- [ ] Test in activated Flox environment
- [ ] Explain Flox-specific decisions to user

## 🎓 Learning Mode

When you encounter Flox patterns you're unsure about:

1. **Fetch relevant docs**: `./fetch-flox.sh <context>` or `/flox-context <type>`
2. **Read carefully**: Study the FLOX.md file
3. **Ask for clarification**: If user's request is ambiguous
4. **Explain reasoning**: Share what you learned and why you chose an approach

## 🔄 Dynamic Context Fetching

The `fetch-flox.sh` script and `/flox-context` command provide just-in-time documentation:

```bash
# Fetch packaging patterns
./fetch-flox.sh packaging
# or in OpenCode:
/flox-context packaging

# Creates FLOX.md with packaging-specific guidance

# Fetch CUDA patterns
./fetch-flox.sh cuda
# or:
/flox-context cuda

# Overwrites FLOX.md with CUDA-specific guidance

# Always read FLOX.md after fetching
```

This ensures you have the most relevant Flox patterns for the current task.

---

**Remember**: You're an AI assistant working in a Flox-managed environment. Always prioritize Flox patterns, fetch relevant documentation proactively, and explain your Flox-specific decisions to users.

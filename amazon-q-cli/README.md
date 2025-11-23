# 🤖 Flox Environment for Amazon Q Developer CLI

A Flox environment for [Amazon Q Developer CLI](https://github.com/aws/amazon-q-developer-cli), AWS's AI-powered command line assistant. Amazon Q Developer enhances your terminal with intelligent chat, code generation, command translation, and autonomous agents powered by Claude Sonnet 4.

## ✨ Features

- **AI-powered chat**: Interactive conversations with Claude Sonnet 4 in your terminal
- **Command translation**: Convert natural language to shell commands with `q translate`
- **Code generation**: Generate code in hundreds of programming languages
- **Autonomous agents**: Multi-step task execution (feature implementation, refactoring, upgrades)
- **Custom agents**: Define specialized agents with JSON configuration
- **MCP integration**: Model Context Protocol server support for extended capabilities
- **AWS integration**: Query AWS resources and generate CLI commands
- **Command autocompletion**: AI-powered suggestions for popular CLIs
- **Knowledge base**: Enable AWS documentation and best practices
- **Session management**: Resume previous conversations
- **IDE integration**: Works with VS Code, JetBrains, Visual Studio, Eclipse
- **Multi-language support**: Discuss architecture and build apps in your preferred language

## 🧰 Included Tools

The environment includes:

- `q` - Amazon Q Developer CLI
- `aws-cli` - AWS Command Line Interface (optional, for AWS integration)

## 🏁 Getting Started

### 📋 Prerequisites

- [Flox](https://flox.dev/get) installed on your system
- AWS Builder ID (free) or IAM Identity Center account (Pro, $19/month)
- Internet connection for AI model access

### 💻 Installation & Activation

Get started with:

```sh
# Clone the repo
git clone https://github.com/yourusername/agentic-development-with-flox && cd agentic-development-with-flox/amazon-q-cli

# Activate the environment
flox activate
```

### 🔐 First-Time Setup

**Authentication:**

Amazon Q CLI stores configuration in `~/.aws/amazonq/` in your home directory (following security best practices).

**Method 1: AWS Builder ID (Recommended for Free Tier)**

```bash
# Start authentication flow
q login

# Select "AWS Builder ID"
# Browser opens for authentication
# Sign in or create account
# Return to terminal

# Verify login
q doctor
```

**Method 2: IAM Identity Center (Pro - $19/month)**

```bash
# Configure IAM Identity Center
q login

# Select "IAM Identity Center"
# Enter your Start URL
# Browser opens for authentication
# Sign in with your organization credentials

# Verify login
q doctor
```

**Features by tier:**
- **Free (Builder ID)**: Chat, code generation, command translation, basic agents
- **Pro (IAM Identity Center)**: Advanced agents, priority support, team collaboration

## 📝 Usage

### Interactive Chat

Start an AI-powered conversation:

```bash
# Start chat session
q chat

# Example interactions:
You: How do I list all running Docker containers?

Q: To list all running Docker containers, use:
   docker ps

   For all containers (including stopped):
   docker ps -a

You: Write a Python function to validate email addresses

Q: [generates complete function with regex validation]

You: Explain this code [paste code]

Q: [provides detailed explanation]
```

### Natural Language Command Translation

Convert English to shell commands:

```bash
# Translate natural language to commands
q translate "find all PDF files modified in the last week"

# Q suggests:
find . -name "*.pdf" -mtime -7

# With AWS CLI
q translate "list all S3 buckets in us-east-1"

# Q suggests:
aws s3 ls --region us-east-1
```

### Session Management

Resume previous conversations:

```bash
# Start new chat
q chat

# Work on something...
# Exit (Ctrl+C or type /exit)

# Resume later
q chat --resume

# Continue from where you left off
You: Continue implementing the authentication module

Q: [picks up context, continues work]
```

### Custom Agents

Create specialized agents for specific tasks:

```bash
# Custom agents are JSON files in:
# ~/.aws/amazonq/agents/     (global)
# .amazonq/agents/           (project-level)

# Example: Create Flox-aware agent
cat > ~/.aws/amazonq/agents/flox-expert.json <<'EOF'
{
  "name": "Flox Expert",
  "description": "Expert in Flox package management and environments",
  "instructions": "You are an expert in Flox...",
  "model": "claude-3-sonnet",
  "tools": ["bash", "file"],
  "knowledge": {
    "enabled": true,
    "sources": ["flox-docs"]
  }
}
EOF

# Use the custom agent
q chat --agent flox-expert

# Or set as default
q settings chat.defaultAgent "flox-expert"
```

### MCP Server Integration

Enable Model Context Protocol servers for extended capabilities:

**Global configuration** (`~/.aws/amazonq/mcp.json`):
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/user/projects"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "${GITHUB_TOKEN}"
      }
    }
  }
}
```

**Project configuration** (`.amazonq/mcp.json` in project root):
```json
{
  "mcpServers": {
    "project-db": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgresql"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    }
  }
}
```

### Settings Management

Configure Amazon Q CLI:

```bash
# View all settings
q settings list

# View with descriptions
q settings list --all

# Set default model
q settings chat.defaultModel "claude-3-sonnet"

# Enable knowledge base
q settings chat.enableKnowledge true

# Export settings
q settings list --format json-pretty > my-settings.json

# Delete a setting
q settings --delete chat.defaultAgent
```

### Diagnostics

Check installation and configuration:

```bash
# Run diagnostics
q doctor

# Checks:
# - Installation integrity
# - Authentication status
# - Network connectivity
# - Configuration validity
# - MCP server status
```

## 🔧 Configuration

### Configuration Files

Amazon Q CLI uses a hierarchical configuration system:

**⚠️ IMPORTANT - Flox Security Convention:**
Config files containing secrets MUST be in `$HOME` (`~/.aws/amazonq/`), never in project directories.

**Global config** (for credentials and defaults):
```
~/.aws/amazonq/
├── config.json            # Global settings
├── mcp.json               # Global MCP servers
└── agents/                # Global custom agents
    ├── flox-expert.json
    └── security-reviewer.json
```

**Project config** (for project-specific settings WITHOUT secrets):
```
your-project/
├── .amazonq/
│   ├── mcp.json           # Project MCP servers (NO secrets!)
│   └── agents/            # Project custom agents
│       └── project-agent.json
└── ...
```

**Configuration merging:**
- Settings from both global and project configs are combined
- Project configs override global configs for conflicting keys
- Use environment variables for secrets in project configs

### Custom Agent Configuration

**Agent JSON structure:**
```json
{
  "name": "Agent Name",
  "description": "What this agent does",
  "instructions": "Detailed system prompt and behavior instructions",
  "model": "claude-3-sonnet",
  "tools": ["bash", "file", "aws"],
  "knowledge": {
    "enabled": true,
    "sources": ["aws-docs", "project-docs"]
  },
  "temperature": 0.7,
  "maxTokens": 4096
}
```

**Available tools:**
- `bash` - Execute shell commands
- `file` - Read and write files
- `aws` - AWS API operations
- `web` - Web scraping and fetching

## 🛠️ Common Workflows

### Building Features

```bash
q chat

You: Create a REST API for user authentication with JWT tokens

Q: [analyzes requirements]
Q: I'll create a complete authentication API. Let me break this down:
   1. User model with password hashing
   2. JWT token generation and validation
   3. Login and register endpoints
   4. Protected route middleware
   5. Tests

   [generates complete implementation]

You: Add rate limiting to prevent brute force attacks

Q: [implements rate limiting with Redis]
```

### Code Review and Analysis

```bash
q chat

You: Review this code for security issues
[paste code]

Q: [analyzes code]
   I've identified several security concerns:
   1. SQL injection vulnerability in line 45
   2. Missing input validation on user data
   3. Passwords not hashed before storage
   4. No CSRF protection

   Here's how to fix each issue...
```

### AWS Infrastructure

```bash
q chat

You: List all Lambda functions in my account

Q: [generates and explains command]
   aws lambda list-functions --region us-east-1

You: Show me the configuration for function-name

Q: aws lambda get-function-configuration \
     --function-name function-name \
     --region us-east-1
```

### Framework Upgrades

```bash
q chat

You: Upgrade this Java application from Java 8 to Java 17

Q: [analyzes codebase]
   I'll perform the upgrade in these steps:
   1. Update pom.xml/build.gradle
   2. Replace deprecated APIs
   3. Update dependencies
   4. Fix compatibility issues
   5. Run tests

   [executes autonomous upgrade]
```

### Debugging

```bash
q chat

You: The app crashes with "Connection refused" error

Q: Let me help debug this. Can you:
   1. Show me the error logs
   2. Check if the service is running
   3. Verify the connection URL

You: [provides logs]

Q: The issue is in your database connection string.
   The host is set to 'localhost' but should be '127.0.0.1'
   or your actual database hostname.

   Here's the fix: [provides solution]
```

### Documentation Generation

```bash
q chat

You: Generate API documentation for this project

Q: [analyzes codebase]
   I'll create comprehensive documentation including:
   - API overview and architecture
   - Endpoint reference with examples
   - Authentication guide
   - Error handling documentation
   - Getting started guide

   [generates complete documentation]
```

## 🧪 Local Development & Testing

### Layering LocalStack for Local AWS Testing

For local development and testing without connecting to real AWS services, you can layer the `flox/localstack` environment underneath Amazon Q CLI. This is useful for:

- Testing AWS integrations locally
- Developing without AWS account costs
- Faster iteration cycles
- Offline development

**Layer LocalStack:**

```bash
# Activate with LocalStack layered underneath
flox activate -r flox/localstack

# LocalStack services will be available at localhost:4566
# Amazon Q can now query and interact with local AWS services
```

**Example workflow:**

```bash
# Start with LocalStack layered
flox activate -r flox/localstack

# LocalStack starts automatically in the background
# All AWS services are now available locally

# Use Amazon Q to interact with local AWS
q chat

You> Create an S3 bucket and list all buckets

Q: [Detects AWS context, uses local endpoint]
Q: I'll create an S3 bucket using the AWS CLI locally:

    aws --endpoint-url=http://localhost:4566 s3 mb s3://my-test-bucket
    aws --endpoint-url=http://localhost:4566 s3 ls

You> Set up a Lambda function

Q: [Provides LocalStack-compatible Lambda deployment commands]
```

**Benefits:**

- **No AWS charges**: All services run locally
- **Fast feedback**: No network latency to AWS regions
- **Reproducible**: Consistent local environment
- **Offline capable**: Work without internet
- **Safe testing**: Experiment without affecting production

**Available LocalStack services:**

LocalStack emulates major AWS services including S3, DynamoDB, Lambda, SQS, SNS, API Gateway, CloudFormation, and more. See the [LocalStack documentation](https://docs.localstack.cloud/) for a full list.

## 🔧 Troubleshooting

### Authentication Issues

**Problem:** Can't authenticate or login fails

**Solution:**

```bash
# Re-run authentication
q login

# Check authentication status
q doctor

# Clear cached credentials
rm -rf ~/.aws/amazonq/session

# Try again
q login
```

### Command Not Found

```bash
# Verify q is available
which q

# Ensure environment is activated
flox activate

# Check installation
flox list
```

### Chat Not Responding

**Problem:** `q chat` hangs or doesn't respond

**Solution:**

```bash
# Check network connectivity
q doctor

# Check authentication
q login --status

# Try with verbose output
q chat --verbose

# Clear cache
rm -rf ~/.aws/amazonq/cache
```

### Custom Agent Not Working

**Problem:** Custom agent not recognized

**Solution:**

```bash
# List available agents
q settings list | grep agent

# Check agent file location
ls -la ~/.aws/amazonq/agents/
ls -la .amazonq/agents/

# Validate JSON syntax
cat ~/.aws/amazonq/agents/my-agent.json | jq .

# Reload configuration
q doctor
```

### MCP Server Issues

**Problem:** MCP server not connecting

**Solution:**

```bash
# Check MCP configuration
cat ~/.aws/amazonq/mcp.json | jq .

# Test MCP server manually
npx -y @modelcontextprotocol/server-filesystem /path

# Check logs
q chat --verbose

# Disable MCP temporarily
mv ~/.aws/amazonq/mcp.json ~/.aws/amazonq/mcp.json.bak
```

### Slow Response Times

**Normal behavior:**
- First request: Model initialization
- Large codebases: More context to analyze
- Complex tasks: Multi-step reasoning

**Optimization:**
- Use faster model for simple queries
- Break large tasks into smaller steps
- Clear chat history: `/clear` in chat session

## 💻 System Compatibility

This environment works on:
- Linux x86_64
- Linux aarch64 (ARM64)
- macOS x86_64 (Intel)
- macOS ARM64 (Apple Silicon)

## 🔒 Security Considerations

- **API credentials**: Stored in `~/.aws/amazonq/` or via AWS credentials
- **Configuration location**: `~/.aws/amazonq/` in your home directory (**NEVER in project root**)
- **Code access**: Amazon Q can read and write files when using tools
- **Command execution**: Can execute shell commands (review before accepting)
- **Network access**: Communicates with AWS services and Claude AI
- **MCP servers**: Third-party servers may have additional access
- **Session data**: Stored locally in `~/.aws/amazonq/`

**Best Practices:**
- **Recommended**: Use AWS credentials management (IAM, Builder ID)
- **CRITICAL**: Config files with secrets MUST be in `$HOME` (e.g., `~/.aws/amazonq/`), never in project directories
- Never commit AWS credentials to version control
- Per Flox conventions, all secrets live in `$HOME`, not in repos or `$FLOX_ENV_CACHE`
- Review code changes before accepting
- Use version control (git) for easy rollback
- Keep Amazon Q CLI updated: `q upgrade`
- Audit MCP servers before enabling
- Use `.gitignore` to exclude `.amazonq/` if it contains sensitive data

## 📚 Additional Resources

- **Official Documentation**: [docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line.html](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line.html)
- **GitHub Repository**: [github.com/aws/amazon-q-developer-cli](https://github.com/aws/amazon-q-developer-cli)
- **CLI Command Reference**: [docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line-reference.html](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line-reference.html)
- **Custom Agents Guide**: [docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line-custom-agents.html](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line-custom-agents.html)
- **MCP Documentation**: [docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line-mcp.html](https://docs.aws.amazon.com/amazonq/latest/qdeveloper-ug/command-line-mcp.html)
- **AWS Developer Center**: [aws.amazon.com/developer/learning/q-developer-cli/](https://aws.amazon.com/developer/learning/q-developer-cli/)
- **Flox Documentation**: [flox.dev/docs](https://flox.dev/docs)

## 🙏 Acknowledgments

- **AWS Team**: Thanks to AWS for creating Amazon Q Developer and making the CLI available
- **Anthropic**: Powers Amazon Q with Claude Sonnet 4

## 🔗 About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Software, variables, services defined in human-readable TOML
- **Content-addressed storage** - Multiple package versions coexist without conflicts
- **Reproducibility** - Same environment across dev, CI, and production
- **Deterministic builds** - Same inputs always produce identical outputs
- **Huge package collection** - Access to 150,000+ packages from [Nixpkgs](https://github.com/NixOS/nixpkgs)

## 📝 License

This Flox environment configuration is provided as-is. Amazon Q Developer is a service from AWS - see the [AWS Service Terms](https://aws.amazon.com/service-terms/) for details.

# 🔌 A Flox Environment for Codex ACP Adapter

This Flox environment provides [Codex ACP Adapter](https://github.com/zed-industries/codex-acp)—an ACP (Agent Client Protocol) adapter that bridges OpenAI's Codex with ACP-compatible editors and applications.

## ✨ What You Get

- **Headless ACP service** - Runs in the background, waiting for editor connections
- **Codex integration** - Access OpenAI's Codex code generation model
- **Editor compatibility** - Works with Zed and other ACP-compatible clients
- **Tool invocations** - Permission-based tool execution
- **Code review workflows** - Built-in `/review` and `/review-branch` commands
- **Context mentions** - Support for file and project context
- **Image uploads** - Visual context for AI assistance
- **Automated logging** - All output captured to logs

## 🧰 What's Inside

- `codex-acp` - ACP adapter service for Codex
- Automated logging to `$FLOX_ENV_CACHE/logs/codex-acp.log`
- Service management via Flox

## 🚀 Getting Started

### Prerequisites

- [Flox](https://flox.dev) installed
- OpenAI API key or ChatGPT Plus/Pro/Team subscription
- ACP-compatible editor (e.g., Zed)

### Start the Service

```bash
# With OpenAI API key
OPENAI_API_KEY=sk-xxx flox activate -s

# Or with Codex-specific key
CODEX_API_KEY=sk-xxx flox activate -s
```

The service runs in the background and listens for ACP protocol messages from connected editors.

### Connect from Zed (or other ACP client)

Once the service is running, configure your editor to connect to the ACP adapter. The exact configuration depends on your editor.

## 📝 Service Management

```bash
# Start service
OPENAI_API_KEY=sk-xxx flox activate -s

# Check status
flox services status

# View logs
flox services logs codex-acp
# Or directly:
cat $FLOX_ENV_CACHE/logs/codex-acp.log

# Restart service
flox services restart codex-acp

# Stop service
flox services stop codex-acp
```

## 🔧 Configuration

### Authentication

The adapter supports three authentication methods:

1. **OpenAI API Key** (recommended for most users):
   ```bash
   OPENAI_API_KEY=sk-xxx flox activate -s
   ```

2. **Codex-specific API Key**:
   ```bash
   CODEX_API_KEY=sk-xxx flox activate -s
   ```

3. **ChatGPT Subscription**:
   - Paid ChatGPT Plus/Pro/Team account
   - Limited to local projects (not remote)

### Environment Variables

- `OPENAI_API_KEY` - OpenAI API key for authentication
- `CODEX_API_KEY` - Codex-specific API key (alternative to OPENAI_API_KEY)

**Important**: API keys are **never stored** in the manifest. Always provide them at runtime using the patterns shown above.

## 🎯 Built-in Commands

When connected via an ACP-compatible editor, the adapter supports:

- `/review` - Code review workflows
- `/review-branch` - Branch-based code review
- `/init` - Initialize project context
- Tool invocations with permission requests
- TODO list management
- Context mentions for files and projects

## 🔥 Troubleshooting

### Service won't start

Check if API key is set:
```bash
echo $OPENAI_API_KEY
# Should output your API key
```

Verify service is running:
```bash
flox services status
```

### Check logs for errors

```bash
cat $FLOX_ENV_CACHE/logs/codex-acp.log
```

### Service exits immediately

The service requires a valid API key. Ensure you're starting with:
```bash
OPENAI_API_KEY=sk-xxx flox activate -s
```

### Editor can't connect

1. Verify the service is running: `flox services status`
2. Check the editor's ACP configuration
3. Review logs: `flox services logs codex-acp`

## 💻 System Support

This Flox environment supports:
- Linux (x86_64)

**Note**: While the [Codex ACP Adapter](https://github.com/zed-industries/codex-acp) may support multiple platforms, the `flox/codex-acp` package is currently available for x86_64-linux.

## 🔍 Power User Tips

- **Headless design**: This is a background service—no interactive CLI
- **Editor integration**: Designed to work seamlessly with Zed and other ACP clients
- **Log monitoring**: Use `tail -f $FLOX_ENV_CACHE/logs/codex-acp.log` to watch real-time activity
- **Multiple projects**: Each Flox environment gets its own isolated service instance
- **CI/CD**: Can be used in automated workflows with proper API key management
- **Permission-based tools**: The adapter requests permissions before executing tools

## 🌟 Related Projects

### Upstream

This environment packages [Codex ACP Adapter](https://github.com/zed-industries/codex-acp) by Zed Industries. **Thank you** to the Zed Industries team and all contributors for building and maintaining this excellent ACP adapter that bridges OpenAI's Codex with editor integrations.

### Packaging & Distribution

**Special thanks** to the [nix-ai-tools](https://github.com/numtide/nix-ai-tools) project by numtide and its contributors for making AI development tools accessible through Nix packaging. This comprehensive collection of AI-powered development utilities—including code assistants, MCP servers, and language models—makes it easy to get started with AI tooling. Their work packaging `codex-acp` and many other AI tools is invaluable to the community.

## About Flox

[Flox](https://flox.dev/docs) combines package and environment management, building on [Nix](https://github.com/NixOS/nix). It gives you Nix with a `git`-like syntax and an intuitive UX:

- **Declarative environments**. Software packages, variables, services, etc. are defined in simple, human-readable TOML format;
- **Content-addressed storage**. Multiple versions of packages with conflicting dependencies can coexist in the same environment;
- **Reproducibility**. The same environment can be reused across development, CI, and production;
- **Deterministic builds**. The same inputs always produce identical outputs for a given architecture, regardless of when or where builds occur;
- **World's largest collection of packages**. Access to over 150,000 packages—and millions of package-version combinations—from [Nixpkgs](https://github.com/NixOS/nixpkgs).

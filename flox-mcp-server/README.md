# Flox Environment for Flox MCP Server

A Flox environment for [Flox MCP Server](https://github.com/flox/mcp-server), a Model Context Protocol server that enables AI assistants to manage Flox package environments.

## Overview

The Flox MCP Server implements the [Model Context Protocol](https://modelcontextprotocol.io/) (MCP) specification, providing AI assistants with tools to:

- Initialize and manage Flox environments
- Search and install packages
- Run commands within isolated environments
- Query environment and system information

The server operates via stdio transport and integrates with MCP-compatible clients.

## Included Tools

The environment includes:

- `flox-mcp` - MCP server executable

## Prerequisites

- [Flox](https://flox.dev/get) installed
- MCP-compatible client (Claude Code, Claude Desktop, or VS Code with MCP extension)

## Installation & Activation

```bash
# Clone the repository
git clone https://github.com/barstoolbluz/agentic-development-with-flox
cd agentic-development-with-flox/flox-mcp-server

# Activate the environment
flox activate
```

## Integration

### Claude Code

Add the server to Claude Code configuration:

```bash
# Local project scope
claude mcp server add flox -- flox-mcp

# User scope (global)
claude mcp server add --scope user flox -- flox-mcp
```

### Claude Desktop

Add to `~/Library/Application Support/Claude/claude_desktop_config.json` (macOS) or equivalent:

```json
{
  "mcpServers": {
    "flox": {
      "command": "flox-mcp"
    }
  }
}
```

### VS Code

Configure via MCP extension:

1. Run `MCP: Add Server`
2. Select `Command (stdio)`
3. Enter `flox-mcp` as command
4. Enter `flox-mcp-server` as server ID

Start server:

1. Run `MCP: List Servers`
2. Select `flox-mcp-server`
3. Select `Start Server`

## MCP Tools

The server exposes the following tools to AI assistants:

| Tool | Description |
|------|-------------|
| `init_new_environment` | Initialize Flox environment in directory |
| `search_packages` | Search Flox package registry |
| `show_package` | Get package details and versions |
| `list_environments` | List available Flox environments |
| `install_package` | Install packages to environment |
| `uninstall_package` | Remove package from environment |
| `run_command` | Execute command in environment |
| `list_installed_packages` | List installed packages with versions |

## MCP Resources

The server provides the following resources:

| Resource | Description |
|----------|-------------|
| `flox://cli/default_environment_dir` | Default environment directory path |
| `flox://cli/current_system_type` | System type (e.g., x86_64-linux, aarch64-darwin) |
| `flox://documentation` | Flox documentation URL |
| `flox://example-environments` | Example environments URL |

## Usage

Once integrated with an MCP client, the AI assistant can invoke tools to manage Flox environments. Example assistant interactions:

**Initialize environment:**
```
User: Create a Flox environment in ./myproject
Assistant: [uses init_new_environment tool]
```

**Search and install:**
```
User: Add Python 3.11 to the environment
Assistant: [uses search_packages, then install_package]
```

**Run commands:**
```
User: Run pytest in the project environment
Assistant: [uses run_command with environment context]
```

## Testing

Test the server directly via stdio:

```bash
# Activate environment
flox activate

# Run server (stdio mode)
flox-mcp

# Server awaits JSON-RPC messages on stdin
```

## Configuration

The server requires no configuration files. All behavior is controlled via MCP protocol messages from the client.

**Environment variables:**
- None required for basic operation
- MCP client may set additional variables

**Permissions:**
- Server executes `flox` commands with user's permissions
- Can modify any Flox environment user has access to

## System Compatibility

This environment works on:
- Linux x86_64
- Linux aarch64 (ARM64)
- macOS ARM64 (Apple Silicon)

**Note:** macOS x86_64 (Intel) is not currently supported by the `flox/flox-mcp-server` package.

## Security Considerations

- Server executes arbitrary `flox` commands via subprocess
- MCP client controls which tools are invoked
- Server has same filesystem access as user
- Commands run with user's permissions
- No authentication/authorization layer (relies on MCP client)

## Upstream

- **Source**: [github.com/flox/mcp-server](https://github.com/flox/mcp-server)
- **Package**: `flox/flox-mcp-server` (Flox catalog)
- **Protocol**: [Model Context Protocol](https://modelcontextprotocol.io/)
- **License**: MIT

## About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Dependencies and configuration in TOML
- **Reproducibility** - Consistent environments across systems
- **Package isolation** - No conflicts between project dependencies
- **Nixpkgs integration** - Access to 150,000+ packages

## License

Flox MCP Server: MIT (see upstream repository)

This Flox environment configuration is provided as-is.

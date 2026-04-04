# Flox Environment for OpenClaw

A Flox environment for [OpenClaw](https://github.com/openclaw/openclaw), a self-hosted, open-source AI assistant and agent platform. OpenClaw provides a WebSocket gateway, terminal UI, and single-turn agent mode.

## Features

- **Self-hosted**: Runs on your own infrastructure, full control over data and configuration
- **Gateway architecture**: WebSocket-based gateway for persistent agent sessions
- **Terminal UI**: Built-in TUI that connects to the gateway
- **Single-turn agent mode**: Run one-off agent tasks from the command line
- **Multi-channel**: Connect multiple frontends to the same gateway
- **Health checks**: Built-in diagnostics via `openclaw doctor`
- **Flox service**: Gateway runs as a managed service, stops cleanly on environment exit

## Included Tools

The environment includes:

- `openclaw` - OpenClaw CLI (gateway, TUI, agent, configuration)

## Getting Started

### Prerequisites

- [Flox](https://flox.dev/get) installed on your system
- API keys for your chosen LLM provider

### Installation & Activation

```bash
# Clone the repo
git clone https://github.com/barstoolbluz/agentic-development-with-flox
cd agentic-development-with-flox/openclaw

# Activate the environment
flox activate

# Or start with the gateway service
flox activate -s
```

### First-Time Setup

```bash
# Interactive onboarding wizard (API keys, daemon install, channels)
openclaw onboard

# Or configure manually
openclaw configure
```

## Usage

### Start the Gateway

The gateway is defined as a Flox service. It starts with `flox activate -s` and stops when the environment exits -- no orphaned processes or systemd units.

```bash
# Start the environment with the gateway service
flox activate -s
```

### Terminal UI

```bash
# Connect the TUI to a running gateway
openclaw tui
```

### Single-Turn Agent

```bash
# Run one agent turn from the command line
openclaw agent --message "Refactor the authentication module"
```

### Health Checks

```bash
# Diagnose configuration and connectivity issues
openclaw doctor
```

### Helper Commands

```bash
# Edit OpenClaw configuration
openclaw-config
```

## How It Works

### Package Installation

The `openclaw` package in nixpkgs is marked as insecure. This environment installs it via a [separate Nix flake](https://github.com/barstoolbluz/openclaw-nix) that overrides the insecure predicate, allowing installation through Flox without modifying system-wide Nix configuration.

### Configuration

On first activation, the environment bootstraps a minimal config at `$FLOX_ENV_CACHE/openclaw/openclaw.json`. Subsequent activations leave the config intact. To regenerate from scratch:

```bash
RESET=1 flox activate
```

Configuration and state are environment-local (stored in `$FLOX_ENV_CACHE`, not `$HOME`).

| File | Location | Purpose |
|------|----------|---------|
| Config | `$FLOX_ENV_CACHE/openclaw/openclaw.json` | OpenClaw configuration |
| State | `$FLOX_ENV_CACHE/openclaw/` | OpenClaw state directory |
| API keys | Per `openclaw onboard` | Provider credentials |

## System Compatibility

This environment works on:
- Linux x86_64 and ARM64
- macOS ARM64 (Apple Silicon) and x86_64 (Intel)

## Troubleshooting

### "Insecure package" Errors

The environment handles this automatically via the [openclaw-nix](https://github.com/barstoolbluz/openclaw-nix) flake. If you see insecure package errors, ensure the flake reference in `manifest.toml` is correct:

```toml
openclaw.flake = "github:barstoolbluz/openclaw-nix"
```

### Configuration Issues

```bash
# Run diagnostics
openclaw doctor

# Edit configuration directly
openclaw-config

# View current config
cat "$OPENCLAW_CONFIG_PATH"

# Reset config to default
RESET=1 flox activate
```

## Additional Resources

- **OpenClaw Repository**: [github.com/openclaw/openclaw](https://github.com/openclaw/openclaw)
- **OpenClaw Documentation**: [docs.openclaw.ai](https://docs.openclaw.ai)
- **Flox Documentation**: [flox.dev/docs](https://flox.dev/docs)

## About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Software, variables, services defined in human-readable TOML
- **Content-addressed storage** - Multiple package versions coexist without conflicts
- **Reproducibility** - Same environment across dev, CI, and production
- **Deterministic builds** - Same inputs always produce identical outputs
- **Huge package collection** - Access to 150,000+ packages from [Nixpkgs](https://github.com/NixOS/nixpkgs)

## License

This Flox environment configuration is provided as-is. OpenClaw is open source -- see the [OpenClaw repository](https://github.com/openclaw/openclaw) for license details.

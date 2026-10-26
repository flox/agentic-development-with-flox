# Amp Flox Environment

This is a Flox environment for Amp, the frontier coding agent.

## Quick Start

1. Start Amp interactively:
   ```bash
   amp
   ```

2. Execute a task:
   ```bash
   amp -x "explain this codebase"
   ```

3. Configure your environment:
   ```bash
   amp-config
   ```

The first activation in a terminal runs a short setup (mode, API key, editor, proxy) and saves it to `.flox/cache/amp-config/amp.config`; `amp-config` runs it again. Setup needs a terminal: a script started from your terminal still opens it, even with `flox activate -- amp ...`. Only where there is no terminal at all, such as cron or CI, is it skipped, and Amp uses smart mode until you run `amp-config`. Empty proxy settings are never applied, so the `HTTP_PROXY` and `HTTPS_PROXY` you already have are kept, including with a configuration saved by an earlier version of this environment. You can also edit `amp.config` by hand; `AMP_MODE=rush`, with or without `export` and quotes, is accepted.

## Learn More

- Documentation: https://docs.ampcode.com/
- Install Guide: https://ampcode.com/install
- GitHub: https://github.com/sourcegraph/amp

## Helper Commands

- `amp-mode` - Switch between smart/rush/free modes
- `amp-info` - Show current configuration
- `amp-help` - Display help message
- `amp-mcp-add` - Add MCP servers

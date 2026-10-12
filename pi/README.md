# pi

Minimal terminal coding agent with multi-model support. pi gives the model four tools (read, bash, edit, write) and stays out of the way; you extend it with skills, prompt templates, extensions, and themes, or bundle them as Pi packages.

- **Multi-provider** - Anthropic, OpenAI, Google Gemini, Mistral, xAI, DeepSeek, OpenRouter, Groq, 25+ more
- **Subscription or API key** - Sign in with `/login`, or use provider API keys from the environment
- **Flox skills built in** - flox, floxify, and flox-debug are loaded automatically
- **Extensible** - Skills, prompt templates, extensions, themes, and Pi packages via npm or git
- **Scriptable** - Non-interactive (`-p`), JSON, and RPC output modes
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd pi
flox activate
```

### 2. Configure a Provider

```bash
# Set an API key
export ANTHROPIC_API_KEY=sk-ant-...

# Or sign in interactively inside pi
pi
# then type: /login
```

### 3. Start Coding

```bash
# Interactive session
pi

# Non-interactive single prompt
pi -p "explain this codebase"

# Continue the previous session
pi -c
```

## Supported Providers

Set the environment variable for your provider, or use `/login`:

| Provider | Env Var |
|----------|---------|
| Anthropic | `ANTHROPIC_API_KEY` |
| OpenAI | `OPENAI_API_KEY` |
| Google Gemini | `GEMINI_API_KEY` |
| Mistral | `MISTRAL_API_KEY` |
| xAI | `XAI_API_KEY` |
| DeepSeek | `DEEPSEEK_API_KEY` |
| OpenRouter | `OPENROUTER_API_KEY` |
| Groq | `GROQ_API_KEY` |
| 25+ additional providers | see `/login` |

## In-App Commands

| Command | Description |
|---------|-------------|
| `/login` | Sign in to a provider (OAuth or API key) |
| `/model` | Switch model |
| `/skill:<name>` | Load a skill explicitly, e.g. `/skill:flox` |

## Flox Skills

The environment installs `flox/skills-flox` and wraps `pi` so it starts with `--skill` pointing at the Flox skills:

- **flox** - Create and manage Flox environments, add packages, services
- **floxify** - Add a Flox environment to an existing project
- **flox-debug** - Diagnose package resolution and activation problems

pi has no environment variable for skill locations, so the wrapper (in `$FLOX_ENV_CACHE/bin`) passes the flag. pi's own subcommands (`install`, `list`, `update`, `auth`, ...) and `pi --no-skills` run unwrapped. Your own skills in `~/.pi/agent/skills` and `~/.agents/skills` still load as usual.

## Helper Commands

```bash
pi-info    # Show configuration, API key status, and command reference
```

## Resources

- [pi GitHub](https://github.com/earendil-works/pi)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For pi-specific issues:
- [pi GitHub Issues](https://github.com/earendil-works/pi/issues)

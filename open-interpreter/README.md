# Open Interpreter

A natural language interface for computers. Lets LLMs run code (Python, JavaScript, Shell) locally on your machine with no restrictions. An unrestricted, local alternative to ChatGPT's Code Interpreter.

- **Local code execution** - Run Python, JavaScript, Shell with no file-size or runtime limits
- **Multi-provider** - OpenAI, Anthropic, Cohere, Ollama, LM Studio, Llamafile, and any LiteLLM provider
- **Interactive chat** - Terminal-based conversational interface
- **Local models** - Run fully offline with Llamafile or any OpenAI-compatible server
- **YAML profiles** - Configurable per-project settings
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Intel, Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd open-interpreter
flox activate
```

### 2. Set an API Key

```bash
export OPENAI_API_KEY=sk-...
# or
export ANTHROPIC_API_KEY=sk-ant-...
```

### 3. Start Chatting

```bash
# Interactive chat
interpreter

# Shorthand
i

# First run installs dependencies into a persistent venv (one time).
```

## CLI Reference

| Command | Description |
|---------|-------------|
| `interpreter` | Start interactive chat |
| `i` | Shorthand for interpreter |
| `interpreter --model <model>` | Use a specific model |
| `interpreter --local` | Use a local Llamafile model |
| `interpreter --api_base <url> --api_key <key>` | Connect to a local server |
| `interpreter -y` | Auto-run code (skip confirmation) |
| `interpreter --profiles` | Open profiles directory |
| `interpreter --profile <name>.yaml` | Use a specific profile |
| `interpreter --verbose` | Debug mode |

## In-Chat Commands

| Command | Description |
|---------|-------------|
| `%reset` | Reset conversation |
| `%undo` | Undo last message |
| `%tokens [prompt]` | Show token usage |
| `%verbose [true/false]` | Toggle debug mode |
| `%help` | Show help |

## Local Model Usage

```bash
# Built-in Llamafile support
interpreter --local

# LM Studio / Ollama / any OpenAI-compatible server
interpreter --api_base "http://localhost:1234/v1" --api_key "fake_key"
```

## Configuration

YAML profiles stored in the profiles directory (`interpreter --profiles` to open):

```yaml
# default.yaml
llm:
  model: gpt-4
  api_key: sk-...
  context_window: 3000
  max_tokens: 1000
auto_run: false
```

## Helper Commands

```bash
interpreter-info    # Show configuration, API key status, and command reference
```

## Resources

- [Open Interpreter GitHub](https://github.com/OpenInterpreter/open-interpreter)
- [Open Interpreter Documentation](https://docs.openinterpreter.com/)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Open Interpreter-specific issues:
- [Open Interpreter GitHub Issues](https://github.com/OpenInterpreter/open-interpreter/issues)
- [Open Interpreter Discord](https://discord.gg/Hvz9Axh84z)

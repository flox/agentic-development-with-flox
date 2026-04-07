# Aider

AI pair programming in your terminal. Aider lets you collaborate with LLMs to edit code in your local git repository, with automatic commits, multi-file editing, and support for 100+ languages.

- **aider-chat-full** v0.86.1 (includes voice and browser UI dependencies)
- **Multi-provider** - Anthropic, OpenAI, DeepSeek, Google Gemini, Ollama, and more
- **Git-native** - Automatic commits with descriptive messages, easy undo
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Intel, Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd aider
flox activate
```

### 2. Set an API Key (or use local models)

```bash
# Cloud providers
export ANTHROPIC_API_KEY=sk-ant-...
export OPENAI_API_KEY=sk-...

# Or use local models via Ollama (no API key needed)
aider --model ollama_chat/gemma4
```

### 3. Start Aider

```bash
# Auto-detect best available model
aider

# Specify a model
aider --model sonnet
aider --model o3-mini
aider --model deepseek

# Web UI
aider --browser
```

## Supported Providers

| Provider | Example | Env Var |
|----------|---------|---------|
| Anthropic | `aider --model sonnet` | `ANTHROPIC_API_KEY` |
| OpenAI | `aider --model o3-mini` | `OPENAI_API_KEY` |
| DeepSeek | `aider --model deepseek` | `DEEPSEEK_API_KEY` |
| Google Gemini | `aider --model gemini/gemini-2.5-pro` | `GEMINI_API_KEY` |
| Ollama (local) | `aider --model ollama_chat/gemma4` | `OLLAMA_API_BASE` |
| OpenRouter | `aider --model openrouter/<model>` | `OPENROUTER_API_KEY` |

## Environment Variables

### API Keys

Set in your shell profile or pass at activation time:

```bash
ANTHROPIC_API_KEY=sk-ant-... flox activate
```

### Aider Settings

| Variable | Default | Description |
|----------|---------|-------------|
| `AIDER_MODEL` | *(auto)* | Main chat model |
| `AIDER_DARK_MODE` | `true` | Dark terminal theme |
| `AIDER_AUTO_COMMITS` | `true` | Auto-commit AI changes |
| `AIDER_GITIGNORE` | `true` | Auto-add .aider* to .gitignore |
| `OLLAMA_API_BASE` | `http://127.0.0.1:11434` | Ollama endpoint for local models |
| `AIDER_WEAK_MODEL` | *(auto)* | Model for commit messages/summarization |
| `AIDER_EDITOR_MODEL` | *(auto)* | Model for editor tasks |
| `AIDER_ARCHITECT` | *(off)* | Enable architect mode (separate architect/editor models) |

## Chat Commands

Once inside an aider session:

### File Management
| Command | Description |
|---------|-------------|
| `/add <file>` | Add files to the chat context |
| `/drop <file>` | Remove files from chat |
| `/read-only <file>` | Add as read-only reference |
| `/ls` | List known files |

### Editing and Development
| Command | Description |
|---------|-------------|
| `/ask <question>` | Ask without making edits |
| `/code <request>` | Request code modifications |
| `/architect` | Use architect mode (separate planning/editing) |
| `/run <cmd>` or `!<cmd>` | Run a shell command |
| `/test <cmd>` | Run tests, include output on failure |
| `/lint` | Lint and auto-fix files |

### Git
| Command | Description |
|---------|-------------|
| `/commit` | Commit current changes |
| `/undo` | Revert last aider commit |
| `/diff` | Show changes since last message |
| `/git <cmd>` | Run a git command |

### Context
| Command | Description |
|---------|-------------|
| `/voice` | Voice input (transcribed) |
| `/web <url>` | Fetch a webpage as context |
| `/paste` | Paste from clipboard |
| `/map` | Show repo structure |
| `/tokens` | Show token usage |

### Model Switching
| Command | Description |
|---------|-------------|
| `/model <name>` | Switch main model mid-session |
| `/editor-model <name>` | Switch editor model |
| `/reasoning-effort <level>` | Adjust reasoning effort |

## Usage Examples

### Basic Pair Programming

```bash
aider
# > /add src/auth.py src/models.py
# > Add OAuth2 support with Google and GitHub providers
```

### Architect Mode

```bash
aider --architect
# Uses a strong model for planning, a fast model for editing
```

### With Local Models via Ollama

```bash
# Compose with the ollama environment
aider --model ollama_chat/gemma4
aider --model ollama_chat/qwen3
aider --model ollama_chat/devstral
```

### Voice-Driven Development

```bash
aider
# > /voice
# (speak your request, aider transcribes and executes)
```

### Browser UI

```bash
aider --browser
# Opens web interface at http://localhost:8501
```

## Composition with Ollama

The manifest includes a commented-out Ollama include for fully local AI pair programming. To enable it:

```bash
flox edit
# Uncomment the Ollama line in [include]:
#   environments = [
#     { remote = "flox/ollama" },
#   ]
```

Then:
```bash
flox activate -s          # Start Ollama service
ollama pull gemma4        # Download a model
aider --model ollama_chat/gemma4  # Start aider with local model
```

If no API keys are detected on activation, the environment will remind you about this option.

## Helper Commands

```bash
aider-info    # Show current configuration, API key status, and command reference
```

## Resources

- [Aider Documentation](https://aider.chat/)
- [Aider GitHub](https://github.com/aider-ai/aider)
- [Supported Models](https://aider.chat/docs/llms.html)
- [Configuration Reference](https://aider.chat/docs/config.html)
- [Chat Commands](https://aider.chat/docs/usage/commands.html)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Aider-specific issues:
- [Aider GitHub Issues](https://github.com/aider-ai/aider/issues)
- [Aider Discord](https://discord.gg/Tv2uQnR88V)

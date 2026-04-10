# GPT4All

Privacy-first local LLM ecosystem. Run quantized language models on your own hardware with no API keys, no data collection, and no internet required. Includes a chat GUI and Python bindings.

- **Fully local** - Runs entirely on your machine, no data ever leaves
- **CPU-optimized** - Designed to run well on consumer CPUs (GPU optional)
- **Model library** - Access to dozens of open-source quantized models
- **Chat GUI** - Desktop application for conversational interaction
- **Linux only** - Package available for x86_64-linux and aarch64-linux

## Quick Start

### 1. Activate the Environment

```bash
cd gpt4all
flox activate
```

### 2. Launch the Chat GUI

```bash
gpt4all
```

On first launch, GPT4All will prompt you to download a model. Models range from ~2GB to ~10GB depending on size and quantization.

## Platform Support

| Platform | Status |
|----------|--------|
| Linux x86_64 | Supported |
| Linux aarch64 | Supported |
| macOS | Not available via this package |
| Windows | Not available via this package |

For macOS or Windows, download GPT4All directly from [gpt4all.io](https://gpt4all.io).

## Features

- **Local LLM chat** - Conversational interface with persistent history
- **Model browser** - Download and manage models from the GPT4All library
- **LocalDocs** - Chat with your own documents (privacy-preserving RAG)
- **CPU inference** - Optimized for running without a GPU
- **OpenAI-compatible API** - Optional local server mode

## Resources

- [GPT4All Website](https://gpt4all.io)
- [GPT4All GitHub](https://github.com/nomic-ai/gpt4all)
- [Model Library](https://gpt4all.io/models)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For GPT4All-specific issues:
- [GPT4All GitHub Issues](https://github.com/nomic-ai/gpt4all/issues)
- [GPT4All Discord](https://discord.gg/mGZE39AS3e)

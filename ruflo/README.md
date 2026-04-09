# Ruflo

Multi-agent AI orchestration platform for Claude Code. Coordinates 100+ specialized AI agents with self-learning intelligence, fault-tolerant consensus, and WASM-based policy kernels. Formerly known as Claude Flow.

- **Multi-agent swarms** - 100+ specialized agents (coder, tester, reviewer, architect, security) with hierarchical or mesh coordination
- **Self-learning (RuVector/SONA)** - Reinforcement learning, Flash Attention, HNSW vector search, pattern storage
- **Swarm topologies** - Mesh, hierarchical, ring, star with Raft/BFT/Gossip consensus
- **Intelligent routing** - Q-Learning router with 8 experts, 130+ skills, complexity-based dispatch
- **310+ MCP tools** - Native Claude Code integration via Model Context Protocol
- **Token optimization** - 30-50% API cost reduction through caching and WASM Agent Booster
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Intel, Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd ruflo
flox activate
```

Ruflo is automatically installed via npm on first activation.

### 2. Initialize

```bash
# Interactive setup wizard
ruflo init --wizard

# Or quick init
ruflo init
```

### 3. Start Using

```bash
# Manage agent swarms
ruflo swarm

# List and configure agents
ruflo agents

# Configure routing policies
ruflo router
```

## CLI Reference

| Command | Description |
|---------|-------------|
| `ruflo init` | Initialize Ruflo (optional `--wizard`) |
| `ruflo swarm` | Manage agent swarms |
| `ruflo agents` | List and configure agents |
| `ruflo router` | Configure routing policies |
| `ruflo memory` | Manage knowledge graph and vector store |
| `ruflo optimize` | Run optimization workers |
| `ruflo audit` | Run security audits |
| `ruflo session` | Persist, restore, export sessions |
| `ruflo plugins` | Manage custom plugins |
| `ruflo hooks intelligence --status` | Check RuVector intelligence status |

## Supported Providers

| Provider | Notes |
|----------|-------|
| Anthropic Claude | Primary, native integration |
| OpenAI GPT | Automatic failover |
| Google Gemini | Automatic failover |
| Cohere | Automatic failover |
| Ollama (local) | Local model support |

Ruflo features automatic failover and cost-based routing between providers.

## Key Features

- **Swarm topologies** - Mesh, hierarchical, ring, star with configurable consensus (Raft, BFT, Gossip)
- **Agent Booster** - WASM-based fast edits (<1ms, zero LLM cost) for simple tasks
- **Memory system** - HNSW-indexed vector database, AgentDB with SQLite/WAL, knowledge graph with PageRank
- **Background workers** - 12 auto-dispatching workers for security audits, optimization, learning
- **Plugin SDK** - Custom workers, hooks, providers, security modules; IPFS marketplace
- **Security (AIDefence)** - Prompt injection blocking, input validation, path traversal prevention

## Helper Commands

```bash
ruflo-info      # Show configuration, API key status, and command reference
ruflo-update    # Update ruflo to latest version
```

## Resources

- [Ruflo GitHub](https://github.com/ruvnet/ruflo)
- [Ruflo Documentation](https://github.com/ruvnet/ruflo#readme)
- [npm: ruflo](https://www.npmjs.com/package/ruflo)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For Ruflo-specific issues:
- [Ruflo GitHub Issues](https://github.com/ruvnet/ruflo/issues)

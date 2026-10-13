# Socket Firewall (sfw)

Socket Firewall Free blocks known-malicious packages before they are downloaded. Put `sfw` in front of a package-manager command (or let the environment do it for you), and every package that command fetches is checked against Socket's malware data first. Useful whenever a coding agent installs dependencies on your behalf.

- **Blocks confirmed malware** - Typosquats and other packages Socket has confirmed as malicious, before any of their code reaches your machine
- **npm, yarn, pnpm, pip, uv, cargo** - The package managers Socket Firewall Free supports
- **Optional transparent wrapping** - `SFW_WRAP=true` routes plain `npm install`, `npx -y`, `pip install`, `uvx`, ... through sfw, including commands run by agents and scripts
- **No account** - No sign-up or API key (but see [Privacy](#privacy))
- **Cross-platform** - Linux (x86_64, aarch64), macOS (Apple Silicon)

## Quick Start

### 1. Activate the Environment

```bash
cd sfw
flox activate
```

The environment provides `sfw`, not the package managers. Use the ones on your system, or layer an environment that has them (see [Wrapping for Agents](#wrapping-for-agents)).

### 2. Install Through sfw

```bash
sfw npm install lodash            # checked, then installed
sfw pip install requests          # pip, inside a virtual environment
sfw uv pip install flask
sfw cargo fetch
```

A flagged package is blocked and the command fails:

```bash
sfw npm install lodahs            # a typosquat of lodash
```

```text
=== Socket Firewall ===

 - blocked npm package: name: lodahs; version: 0.0.1-security; reason: malware (critical) - https://socket.dev/npm/package/lodahs/alerts/0.0.1-security
```

(`lodahs` is now an empty npm security placeholder, so trying it is safe.) sfw is silent when nothing is blocked; add `--verbose`, or set `SFW_VERBOSE=true`, to see a "Protected by Socket Firewall" banner on every run.

## Wrapping for Agents

Prefixing `sfw` works for commands you type, but an agent runs `npm install` on its own. Turn on wrapping and plain package-manager commands go through sfw automatically:

```bash
SFW_WRAP=true flox activate
```

The `flox/sfw` package ships a small shim for `npm`, `yarn`, `pnpm`, `pip`, `uv`, and `cargo`; the environment adds the same shim for `npx`, `pip3`, and `uvx`, which agents often use to start MCP servers (`npx -y <server>`, `uvx <server>`). It keeps all of them in `$FLOX_ENV_CACHE/sfw-shims`, and with wrapping on it puts that directory first on `PATH`. Each shim finds the real command further down `PATH` and runs it under `sfw`, and a package manager that calls itself again (an install script running `npm`, for example) is not wrapped twice. Because it works through `PATH`, it covers interactive shells, `flox activate -- <command>`, scripts, and the package-manager commands an agent started from that shell runs (with the exceptions below).

Activate this environment *after* the one that provides your package managers, so the shims come first:

```bash
cd ~/my-project && flox activate                  # an environment with node, uv, ...
SFW_WRAP=true flox activate -d /path/to/sfw       # then sfw on top
claude                                            # the agent's npm/npx/pip/uv/uvx/cargo calls are now checked
```

The other way round, the later environment's `npm` comes first on `PATH` and sfw is bypassed. Run `sfw-info` to see which package managers are wrapped:

```text
Package managers:
  npm    through sfw (/path/to/env/bin/npm)
  yarn   not installed
  pip    through sfw (/usr/bin/pip)
```

Wrapping only catches commands found through `PATH` under one of those names. These are not checked:

- a command run by its full path, such as `.venv/bin/pip install ...`
- `python -m pip install ...`, since the command is `python` (use `pip` or `sfw python -m pip ...`)
- versioned names such as `pip3.12`

In interactive bash and zsh the environment moves the shims back to the front before each prompt, so `source .venv/bin/activate` doesn't bypass them; a script that activates a virtual environment and then runs `pip` does bypass them.

## How It Works

For each wrapped command, sfw starts a local proxy on `127.0.0.1` with a temporary CA certificate, and points the command at it (`HTTPS_PROXY`, `SSL_CERT_FILE`, `NODE_EXTRA_CA_CERTS`, `PIP_CERT`, `CARGO_HTTP_PROXY`, `GIT_SSL_CAINFO`, and similar). The proxy checks each package the command requests against Socket's service and refuses downloads of packages flagged as malware. Nothing is changed outside that command: no system certificate store, no global proxy setting.

## Privacy

Socket Firewall Free needs network access to Socket's service; without it, sfw cannot check packages. According to [Socket's documentation](https://docs.socket.dev/docs/socket-firewall-free), telemetry is always on in the free version and includes:

- a non-reversible machine identifier
- the names, namespaces, and versions of packages it permitted or blocked
- the latency sfw added and any errors (without local file paths or stack traces)
- the GitHub organization name from your configured git remotes (not repository names, code, or history)

Use is not rate-limited, except where Socket detects abuse. Configurable policies, private registries, telemetry settings, and more ecosystems (Go, Java, Ruby, .NET) are in the paid Socket Firewall Enterprise.

## License

The Flox catalog lists sfw as unfree: it is a prebuilt binary under Socket's own license, based on the PolyForm Shield license, which allows any use except building a product that competes with Socket. `flox install` shows a notice, and the environment needs no extra configuration.

## Configuration

| Variable | Default | Effect |
|----------|---------|--------|
| `SFW_WRAP` | `false` | `true` routes plain `npm`, `npx`, `yarn`, `pnpm`, `pip`, `pip3`, `uv`, `uvx`, and `cargo` through sfw |
| `SFW_VERBOSE` | unset | `true` prints the sfw banner and scan details on every run |

## Helper Commands

```bash
sfw-info    # Show version, wrapping status, and which package managers go through sfw
```

## Resources

- [Socket Firewall Free GitHub](https://github.com/SocketDev/sfw-free)
- [Socket Firewall Free documentation](https://docs.socket.dev/docs/socket-firewall-free)

## Support

For issues with this Flox environment:
- Check the main README at the repository root
- Review the manifest: `.flox/env/manifest.toml`

For sfw-specific issues:
- [Socket Firewall Free GitHub Issues](https://github.com/SocketDev/sfw-free/issues)

---
description: Fetch Flox context-specific documentation
---

# Flox Context Fetcher

Fetch and apply Flox documentation for specific use cases.

## Usage

```bash
/flox-context <type>
```

## Available Contexts

- `packaging` - Building and packaging with Flox
- `k8s` - Kubernetes integration patterns
- `containers` - Container workflows and Docker
- `cuda` - GPU and CUDA configuration
- `cicd` - CI/CD pipeline patterns
- `local-dev` - Local development environments
- `ops` - Operations and deployment

## Workflow

1. I will run `./fetch-flox.sh <type>` to fetch documentation
2. I will read the generated `FLOX.md` file
3. I will apply the patterns and best practices from that documentation
4. I will explain to you what I learned and how I'm applying it

## Example

```
You: /flox-context packaging

Me: [Runs: ./fetch-flox.sh packaging]
Me: [Reads FLOX.md]
Me: I've fetched the Flox packaging documentation. Here's what I learned:
    - Use flox build with [build] section in manifest
    - Package dependencies are automatically handled
    - Built packages go to $out/bin

    Let me apply these patterns to package your application...
```

## Notes

- The fetched FLOX.md file contains context-specific best practices
- Each context provides different guidance optimized for that use case
- You can fetch multiple contexts sequentially if needed
- The documentation is always up-to-date from the flox-md repository

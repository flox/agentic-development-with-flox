# Catnip Setup Guide

## Overview

This Flox environment automatically configures Catnip with:

1. **SSH Keys**: For remote container access via SSH (port 2222)
2. **GitHub CLI**: For private repository access and authentication
3. **Git Full**: Complete Git installation with all features

## SSH Key Management

Catnip creates SSH keys at `~/.ssh/catnip_remote` for remote container access. This Flox environment manages these keys portably by:

1. **Generating keys once** in `$FLOX_ENV_CACHE/catnip-ssh/`
2. **Copying them** to `~/.ssh/` where Catnip expects them
3. **Ensuring proper permissions** (600 for private key, 644 for public key)

## How It Works

The `setup_catnip_ssh_keys()` function (called automatically by `catnip-start`):
- Creates SSH keys in the Flox cache directory if they don't exist
- Copies them to `~/.ssh/catnip_remote[.pub]`
- Sets correct permissions

This approach ensures:
- ✅ Keys persist across Flox environment activations
- ✅ Keys are generated once and reused
- ✅ Works on most systems where `~/.ssh` is a regular directory under `$HOME`

## GitHub CLI Authentication

The environment includes GitHub CLI (`gh`) for seamless GitHub integration in Catnip.

### Setup (One-time)

Authenticate with GitHub to enable private repository access:

```bash
flox activate
gh auth login
```

Follow the prompts to authenticate via browser or token.

### What This Enables

- ✅ Clone and push to private GitHub repositories from Catnip
- ✅ Automatic Git credential management
- ✅ GitHub API access for workflows

### Checking Status

```bash
catnip-info  # Shows GitHub CLI authentication status
```

Or directly:

```bash
gh auth status
```

### Note

When you run `catnip-start`, you'll see a reminder if GitHub CLI isn't authenticated:

```
ℹ️  GitHub CLI not authenticated - private repos won't be accessible in Catnip
To enable private repo access: gh auth login
```

You can safely ignore this if you only work with public repositories or use SSH keys for Git.

## Special Case: Symlinked ~/.ssh

If your `~/.ssh` is a symlink to a location **outside** `$HOME` (e.g., `/mnt/other-partition/ssh`), Docker/Colima cannot bind-mount the SSH keys because that location isn't mounted in the container runtime VM.

### Solution Options

**Option 1: Mount the external location in Colima** (Recommended for your setup)

Edit `~/.colima/default/colima.yaml`:

```yaml
mounts:
  - location: /mnt/your-partition  # Replace with your actual path
    writable: true
```

Then restart Colima:
```bash
flox activate -s -- colima restart
```

**Option 2: Make ~/.ssh a regular directory**

If you don't need `~/.ssh` to be a symlink:
```bash
# Backup current setup
cp -r ~/.ssh ~/.ssh.backup

# Remove symlink and create real directory
rm ~/.ssh
mkdir ~/.ssh
chmod 700 ~/.ssh

# Copy your existing keys back
cp ~/.ssh.backup/* ~/.ssh/
```

**Option 3: Disable SSH in Catnip**

If you don't need SSH access to containers:
```bash
catnip-start --disable-ssh
```

This works without any SSH key setup, but you lose the ability to SSH into containers (you can still use `docker exec`).

## Troubleshooting

### Error: "mkdir /home/user/.ssh: file exists"

This means Docker can't create a bind mount because `~/.ssh` is a symlink to an unmounted location.

**Check if `~/.ssh` is a symlink:**
```bash
ls -ld ~/.ssh
```

If it shows `lrwxrwxrwx ... ~/.ssh -> /some/other/path`, use Option 1 or 2 above.

### Verifying the Setup

```bash
# Check where keys are stored
ls -la $FLOX_ENV_CACHE/catnip-ssh/

# Check where Catnip expects them
ls -la ~/.ssh/catnip_remote*

# Test SSH to running Catnip container
ssh catnip echo "SSH works!"
```

## Why This Approach?

Catnip hardcodes the SSH key path to `~/.ssh/catnip_remote` in its binary, so we must place keys there. By managing the "source of truth" in `$FLOX_ENV_CACHE` and copying to `~/.ssh`, we get:

- **Portability**: Keys generated once, work across systems
- **Flexibility**: Users can customize their `~/.ssh` setup
- **Compatibility**: Works with Catnip's hardcoded expectations

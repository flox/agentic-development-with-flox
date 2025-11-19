# Catnip Troubleshooting Guide

## Common Issues

### "Docker is not running or not accessible"

**Error**:
```
❌ Failed to start container: Docker is not running or not accessible.
docker: Cannot connect to the Docker daemon at unix:///home/daedalus/.colima/default/docker.sock
```

**Diagnosis**: The environment is configured to use Colima, but Colima service isn't running.

**Solution 1: Start Colima Service (Recommended)**

```bash
# Terminal 1: Start Colima
flox activate -s

# Wait for Colima to start (you'll see):
# Starting Colima profile: default
# Configuration: 2CPU, 2GB RAM, 60GB disk

# Terminal 2: Use Catnip
flox activate
catnip-start
```

**Solution 2: Use Existing System Docker**

If you have Docker installed system-wide:

```bash
# Unset Colima socket
unset DOCKER_HOST

# Or switch Docker context
docker context use default

# Start system Docker
sudo systemctl start docker

# Activate and use
flox activate
catnip-start
```

**Solution 3: Use Podman (Docker Alternative)**

```bash
# Install podman
sudo apt install podman  # or your package manager

# Start podman socket
systemctl --user enable --now podman.socket

# Set Docker socket to podman
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/podman/podman.sock

# Use Catnip
flox activate
catnip-start
```

---

### Kubernetes Node Scenario

**Situation**: You're on a k8s node with containerd but no Docker daemon.

**Why this happens**:
- Kubernetes uses **containerd** directly (via CRI)
- Catnip needs **Docker API**
- containerd and Docker API are different

**Options**:

**Option A: Use Colima (Isolated from k8s)**
```bash
# Colima creates its own VM with Docker
# Won't interfere with k8s containerd
flox activate -s
# In another terminal
flox activate
catnip-start
```

**Option B: Install Docker alongside containerd**
```bash
# Install Docker (won't conflict with containerd)
sudo apt install docker.io
sudo systemctl start docker
sudo usermod -aG docker $USER
newgrp docker

# Use Catnip
flox activate
unset DOCKER_HOST  # Don't use Colima socket
catnip-start
```

**Option C: Use nerdctl (containerd CLI)**

*Note: Catnip doesn't directly support nerdctl, but you can try:*

```bash
# Install nerdctl
sudo apt install nerdctl

# Create Docker-compatible socket
# (Advanced - requires configuration)
```

---

### Docker Context Issues

**Problem**: Docker context points to wrong socket

```bash
# Check contexts
docker context ls

# Output:
# NAME       DOCKER ENDPOINT
# colima *   unix:///home/user/.colima/default/docker.sock
# default    unix:///var/run/docker.sock
```

**Solution**: Switch to correct context

```bash
# If using system Docker
docker context use default

# If using Colima
docker context use colima
flox activate -s  # Start Colima
```

---

### "Cannot connect to the Docker daemon"

**Full error**:
```
Cannot connect to the Docker daemon at unix:///var/run/docker.sock.
Is the docker daemon running?
```

**Check 1**: Is Docker running?
```bash
sudo systemctl status docker
# If not running:
sudo systemctl start docker
```

**Check 2**: Are you in docker group?
```bash
groups | grep docker
# If not:
sudo usermod -aG docker $USER
newgrp docker  # Or log out/in
```

**Check 3**: Check socket permissions
```bash
ls -l /var/run/docker.sock
# Should show: srw-rw---- 1 root docker
```

---

### Colima Won't Start

**Error**: Colima fails to start or times out

**Solution 1**: Delete existing instance
```bash
colima delete default
flox activate -s  # Try again
```

**Solution 2**: Check virtualization support
```bash
# Linux: Check KVM
ls -la /dev/kvm
# Should be accessible

# macOS: Check Virtualization Framework
# Requires macOS 13+ for best performance
```

**Solution 3**: Reduce resources
```bash
# Lower CPU/memory requirements
COLIMA_CPU=1 COLIMA_MEMORY=2 flox activate -s
```

**Solution 4**: Check logs
```bash
flox activate -s  # In one terminal
# In another:
flox services logs colima
```

---

### Multiple Container Runtimes Conflict

**Scenario**: You have Docker Desktop, Colima, and/or Podman

**Solution**: Choose one and stick with it per session

```bash
# Option 1: Use Docker Desktop
unset DOCKER_HOST
docker context use default

# Option 2: Use Colima
docker context use colima
flox activate -s

# Option 3: Use Podman
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/podman/podman.sock
```

---

### Port 6369 Already in Use

**Error**: Catnip can't bind to port 6369

**Solution**:
```bash
# Use different port
CATNIP_PORT=7000 flox activate
catnip-start

# Access at http://localhost:7000
```

**Or find what's using the port**:
```bash
sudo lsof -i :6369
# Kill the process if needed
```

---

### Memory/CPU Constraints

**Issue**: Colima/Docker runs out of resources

**Solution**: Increase allocation
```bash
# For Colima
COLIMA_CPU=4 COLIMA_MEMORY=8 flox activate -s

# For Docker Desktop
# GUI: Settings → Resources → increase limits
```

**Check current usage**:
```bash
docker stats
```

---

### SSH Port 2222 Conflict

**Error**: Catnip can't bind SSH port 2222

**Solution**: Disable SSH or use different port
```bash
# Disable SSH
catnip run --disable-ssh

# Or edit manifest to change port
# (Advanced)
```

---

### Permission Denied Errors

**Error**: Permission denied when accessing Docker

**Temporary fix**:
```bash
sudo chmod 666 /var/run/docker.sock
# (Not recommended for production)
```

**Proper fix**:
```bash
sudo usermod -aG docker $USER
# Log out and back in
# Or:
newgrp docker
```

---

### Catnip Container Immediately Exits

**Check logs**:
```bash
docker logs catnip-catnip
```

**Common causes**:
1. Missing environment variables
2. Port conflicts
3. Volume permission issues

**Solution**:
```bash
# Clean up old container
docker rm -f catnip-catnip

# Try again with verbose logging
catnip run -e DEBUG=1
```

---

### API Key Not Working

**Issue**: Catnip starts but Claude doesn't respond

**Check**:
```bash
flox activate
catnip-info
# Should show:
# ✓ ANTHROPIC_API_KEY set
```

**Solution**:
```bash
# Ensure key is set before activation
export ANTHROPIC_API_KEY=sk-ant-...
flox activate
catnip-start
```

---

### WSL2 Specific Issues

**Docker socket path differs on WSL2**

**Solution**:
```bash
export DOCKER_HOST=unix:///var/run/docker-desktop.sock
```

**Or install Docker inside WSL2**:
```bash
sudo apt install docker.io
sudo systemctl start docker
```

---

## Getting Help

If none of these solutions work:

1. **Check Catnip logs**:
   ```bash
   docker logs catnip-catnip
   ```

2. **Check Flox service logs**:
   ```bash
   flox services logs colima
   ```

3. **Test Docker directly**:
   ```bash
   docker run hello-world
   ```

4. **Verify environment**:
   ```bash
   flox activate
   env | grep -E 'DOCKER|COLIMA|CATNIP'
   ```

5. **Report issue**: Include output from above commands

---

## Quick Reference

### Container Runtime Priorities

1. **Existing system Docker** → Use it (fastest)
2. **Docker Desktop** → Use it (easiest)
3. **Colima** → Great alternative (free, lightweight)
4. **Podman** → Advanced option (Docker-compatible)

### Common Commands

```bash
# Check runtime status
docker ps

# Check Colima status
colima status

# Check Docker context
docker context ls

# Reset everything
docker rm -f $(docker ps -aq)
colima delete default
```

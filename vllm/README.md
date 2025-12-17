# 🚀 Flox Environment for vLLM

A Flox environment for [vLLM](https://github.com/vllm-project/vllm), a high-throughput and memory-efficient inference and serving engine for Large Language Models (LLMs). vLLM achieves up to 24x higher throughput than HuggingFace Transformers through innovative techniques like PagedAttention and continuous batching.

## ✨ Features

**Quick Start:** Includes TinyLlama-1.1B as a default model for immediate testing - just run `flox activate -s` to start serving!

- **PagedAttention**: Revolutionary attention algorithm that manages attention keys/values like virtual memory
- **24x higher throughput**: Compared to naive HuggingFace Transformers implementation
- **Continuous batching**: Dynamic request batching for optimal GPU utilization
- **OpenAI-compatible API**: Drop-in replacement for OpenAI API server
- **Quantization support**: GPTQ, AWQ, SqueezeLLM, FP8 KV Cache for reduced memory usage
- **Tensor parallelism**: Distribute models across multiple GPUs
- **Streaming outputs**: Token-by-token streaming for real-time responses
- **Multi-LoRA support**: Serve multiple LoRA adapters efficiently
- **Prefix caching**: Automatic KV cache reuse for repeated prompts
- **Speculative decoding**: Accelerate inference with draft models

## 🧰 Included Tools

The environment includes:

- `vllm` - vLLM inference server (CUDA-enabled build)
- `curl` - For API testing and health checks
- `jq` - JSON processing for API responses

## 🏁 Getting Started

### 📋 Prerequisites

- [Flox](https://flox.dev/get) installed on your system
- **NVIDIA GPU with CUDA support** (required)
- CUDA 12.1+ compatible drivers
- Minimum 16GB GPU memory (24GB+ recommended for 7B models)
- Linux x86_64 system
- (Optional) Hugging Face account for gated models

### 💻 Installation & Activation

Get started with:

```sh
# Clone the repo
git clone https://github.com/yourusername/agentic-development-with-flox && cd agentic-development-with-flox/vllm

# Activate the environment
flox activate
```

### 🔐 First-Time Setup

**GPU Verification:**

```bash
# Check GPU availability
nvidia-smi

# vLLM will show GPU info on activation
flox activate
```

**Default Model:**

vLLM comes pre-configured with **TinyLlama-1.1B** as a default model for quick testing and development. This lightweight model:
- Works on GPUs with as little as 4GB VRAM
- Downloads quickly (~2GB)
- Perfect for testing your setup
- **NOT recommended for production use**

**Choosing Your Production Model:**

Select a model based on your GPU memory and use case:

| GPU VRAM | Recommended Models | Use Cases |
|----------|-------------------|------------|
| 8GB | `microsoft/Phi-3-mini-4k-instruct` | Light workloads, testing |
| 16GB | `mistralai/Mistral-7B-Instruct-v0.2` | General purpose, chat |
| 24GB | `meta-llama/Llama-2-13b-chat-hf` | Advanced reasoning |
| 40GB+ | `mistralai/Mixtral-8x7B-Instruct-v0.1` | Complex tasks, MoE |

**Quick Start (with default model):**

```bash
# Start immediately with TinyLlama (testing only)
flox activate -s

# Test the API
vllm-test "Hello, world!"
```

**Production Setup:**

```bash
# Override default with your preferred model
export VLLM_MODEL="mistralai/Mistral-7B-Instruct-v0.2"

# For gated models (Llama, Gemma), set HF token
export HF_TOKEN="hf_your_token_here"

# Optional: Customize server settings
export VLLM_PORT=8000
export VLLM_GPU_MEMORY_UTILIZATION=0.9

# Start the server
flox activate -s
```

## 📝 Usage

### Starting the Server

**Quick Start (with default TinyLlama):**

```bash
# Start immediately with default model (testing only)
flox activate -s
```

**Production Setup (with custom model):**

```bash
# Set your production model
export VLLM_MODEL="mistralai/Mistral-7B-Instruct-v0.2"
flox activate -s

# Check service status
flox services status

# View logs
flox services logs vllm

# Restart if needed
flox services restart vllm
```

**Manual start:**

```bash
# Activate environment
flox activate

# Start server manually
python -m vllm.entrypoints.openai.api_server \
    --model $VLLM_MODEL \
    --host 0.0.0.0 \
    --port 8000
```

### Helper Commands

```bash
# Check server status
vllm-status

# Test the API
vllm-test "Tell me a joke"

# List loaded models
vllm-models

# Pre-download a model
vllm-download meta-llama/Llama-2-7b-chat-hf
```

### API Usage

vLLM provides an OpenAI-compatible API:

**Completions API:**

```bash
curl -X POST "http://localhost:8000/v1/completions" \
    -H "Content-Type: application/json" \
    -d '{
        "model": "mistralai/Mistral-7B-Instruct-v0.2",
        "prompt": "The capital of France is",
        "max_tokens": 100,
        "temperature": 0.7
    }'
```

**Chat Completions API:**

```bash
curl -X POST "http://localhost:8000/v1/chat/completions" \
    -H "Content-Type: application/json" \
    -d '{
        "model": "mistralai/Mistral-7B-Instruct-v0.2",
        "messages": [
            {"role": "user", "content": "What is the capital of France?"}
        ],
        "max_tokens": 100
    }'
```

**Streaming:**

```bash
curl -X POST "http://localhost:8000/v1/completions" \
    -H "Content-Type: application/json" \
    -d '{
        "model": "mistralai/Mistral-7B-Instruct-v0.2",
        "prompt": "Write a story about",
        "max_tokens": 200,
        "stream": true
    }'
```

### Python Client

```python
from openai import OpenAI

# Point to vLLM server
client = OpenAI(
    base_url="http://localhost:8000/v1",
    api_key="dummy"  # vLLM doesn't require API key by default
)

# Use like OpenAI
completion = client.completions.create(
    model="mistralai/Mistral-7B-Instruct-v0.2",
    prompt="The future of AI is",
    max_tokens=100
)

print(completion.choices[0].text)
```

## 🔧 Configuration

### Environment Variables

```bash
# Model configuration (defaults to TinyLlama for testing)
export VLLM_MODEL="mistralai/Mistral-7B-Instruct-v0.2"  # Override default
export VLLM_SERVED_MODEL_NAME="mistral"  # Optional alias

# Server settings
export VLLM_HOST="0.0.0.0"
export VLLM_PORT="8000"

# Performance tuning
export VLLM_MAX_MODEL_LEN="4096"  # Max sequence length
export VLLM_GPU_MEMORY_UTILIZATION="0.9"  # 90% GPU memory

# Security
export VLLM_API_KEY="your-api-key"  # Optional API protection

# Model downloads
export HF_TOKEN="hf_..."  # For gated models
export VLLM_MODELS_DIR="$HOME/.cache/vllm/models"
```

### Popular Model Configurations

**Mistral 7B:**
```bash
export VLLM_MODEL="mistralai/Mistral-7B-Instruct-v0.2"
export VLLM_MAX_MODEL_LEN="8192"
```

**Llama 2 7B:**
```bash
export VLLM_MODEL="meta-llama/Llama-2-7b-chat-hf"
export HF_TOKEN="hf_your_token"
export VLLM_MAX_MODEL_LEN="4096"
```

**Qwen2 7B:**
```bash
export VLLM_MODEL="Qwen/Qwen2-7B-Instruct"
export VLLM_MAX_MODEL_LEN="32768"
```

**Phi-3 (Small, 8GB GPU):**
```bash
export VLLM_MODEL="microsoft/Phi-3-mini-4k-instruct"
export VLLM_MAX_MODEL_LEN="4096"
```

**Mixtral 8x7B (Multi-GPU):**
```bash
export VLLM_MODEL="mistralai/Mixtral-8x7B-Instruct-v0.1"
export VLLM_TENSOR_PARALLEL_SIZE="2"  # Use 2 GPUs
```

## 🛠️ Common Workflows

### Production Deployment

```bash
# Set production config
export VLLM_MODEL="mistralai/Mistral-7B-Instruct-v0.2"
export VLLM_API_KEY="production-key-here"
export VLLM_PORT="8080"
export VLLM_GPU_MEMORY_UTILIZATION="0.95"

# Start as service
flox activate -s

# Monitor
vllm-status
flox services logs vllm -f
```

### Multi-Model Serving

Run multiple instances on different ports:

```bash
# Terminal 1: Mistral on port 8000
export VLLM_MODEL="mistralai/Mistral-7B-Instruct-v0.2"
export VLLM_PORT="8000"
flox activate -s

# Terminal 2: Llama on port 8001
export VLLM_MODEL="meta-llama/Llama-2-7b-chat-hf"
export VLLM_PORT="8001"
flox activate
python -m vllm.entrypoints.openai.api_server \
    --model $VLLM_MODEL --port $VLLM_PORT
```

### Quantized Models

For larger models on limited VRAM:

```bash
# AWQ quantized model (4-bit)
export VLLM_MODEL="TheBloke/Llama-2-13B-chat-AWQ"
export VLLM_QUANTIZATION="awq"

# GPTQ quantized model
export VLLM_MODEL="TheBloke/Llama-2-70B-chat-GPTQ"
export VLLM_QUANTIZATION="gptq"
```

### Benchmarking

```bash
# Install benchmarking tool
pip install vllm[benchmark]

# Run benchmark
python -m vllm.benchmark.benchmark_serving \
    --backend vllm \
    --model $VLLM_MODEL \
    --dataset-path ShareGPT_V3_unfiltered_cleaned_split.json \
    --request-rate 10
```

### Integration with LangChain

```python
from langchain.llms import VLLMOpenAI

llm = VLLMOpenAI(
    openai_api_base="http://localhost:8000/v1",
    model_name="mistralai/Mistral-7B-Instruct-v0.2",
    max_tokens=100,
    temperature=0.7
)

response = llm("What is machine learning?")
print(response)
```

## 🔧 Troubleshooting

### CUDA/GPU Issues

**Problem:** "CUDA out of memory"

```bash
# Reduce GPU memory utilization
export VLLM_GPU_MEMORY_UTILIZATION="0.8"

# Reduce max model length
export VLLM_MAX_MODEL_LEN="2048"

# Use smaller model or quantization
export VLLM_MODEL="microsoft/Phi-3-mini-4k-instruct"
```

**Problem:** "No GPU detected"

```bash
# Check NVIDIA driver
nvidia-smi

# Check CUDA version
nvcc --version

# Ensure CUDA is available
python -c "import torch; print(torch.cuda.is_available())"
```

### Model Loading Issues

**Problem:** "Model not found"

```bash
# For gated models, ensure HF token is set
export HF_TOKEN="hf_your_token_here"

# Pre-download model
vllm-download $VLLM_MODEL

# Check model cache
ls -la $VLLM_MODELS_DIR
```

**Problem:** "Model too large"

```bash
# Use tensor parallelism for multi-GPU
export VLLM_TENSOR_PARALLEL_SIZE="2"

# Or use quantized version
export VLLM_MODEL="TheBloke/Mistral-7B-Instruct-v0.2-AWQ"
export VLLM_QUANTIZATION="awq"
```

### Service Management

**Problem:** Service won't start

```bash
# Check logs
flox services logs vllm

# Verify model is set
echo $VLLM_MODEL

# Try manual start for debugging
python -m vllm.entrypoints.openai.api_server \
    --model $VLLM_MODEL \
    --host 0.0.0.0 \
    --port 8000
```

**Problem:** Port already in use

```bash
# Change port
export VLLM_PORT="8001"
flox services restart vllm

# Or find process using port
lsof -i :8000
```

### Performance Issues

**Problem:** Slow inference

```bash
# Enable prefix caching
export VLLM_ENABLE_PREFIX_CACHING="true"

# Adjust batch size
export VLLM_MAX_NUM_SEQS="256"

# Use speculative decoding
export VLLM_SPECULATIVE_MODEL="microsoft/Phi-3-mini-4k-instruct"
export VLLM_NUM_SPECULATIVE_TOKENS="5"
```

## 💻 System Requirements

### Minimum Requirements
- **OS**: Linux x86_64 (Ubuntu 20.04+, RHEL 8+, etc.)
- **GPU**: NVIDIA GPU with compute capability ≥ 7.0
- **VRAM**: 8GB minimum (16GB+ recommended)
- **RAM**: 32GB system memory
- **Storage**: 50GB for models
- **CUDA**: 12.1 or later

### Recommended Setup
- **GPU**: NVIDIA A100, A6000, RTX 4090, or better
- **VRAM**: 24GB or more
- **RAM**: 64GB system memory
- **Storage**: NVMe SSD with 200GB+ free

### GPU Compatibility
- **Consumer**: RTX 3090, RTX 4090, RTX 4080
- **Professional**: A100, A6000, L4, L40
- **Data Center**: H100, A100, V100 (limited)

## 🔒 Security Considerations

### API Key Protection

```bash
# Enable API key requirement
export VLLM_API_KEY="strong-random-key-here"

# Clients must include key
curl -H "Authorization: Bearer $VLLM_API_KEY" ...
```

### Network Security

```bash
# Bind to localhost only
export VLLM_HOST="127.0.0.1"

# Or use firewall rules
sudo ufw allow from 192.168.1.0/24 to any port 8000
```

### Model Security

- Only use trusted models from Hugging Face
- Review model cards for potential issues
- Be aware of prompt injection risks
- Implement content filtering as needed

### Resource Limits

```bash
# Limit GPU memory
export VLLM_GPU_MEMORY_UTILIZATION="0.8"

# Set request limits
export VLLM_MAX_NUM_SEQS="100"
export VLLM_MAX_TOTAL_TOKENS="1000000"
```

## 📚 Additional Resources

- **vLLM Documentation**: [docs.vllm.ai](https://docs.vllm.ai)
- **GitHub Repository**: [github.com/vllm-project/vllm](https://github.com/vllm-project/vllm)
- **Paper**: [Efficient Memory Management for Large Language Model Serving with PagedAttention](https://arxiv.org/abs/2309.06180)
- **Blog Post**: [vLLM: Easy, Fast, and Cheap LLM Serving](https://vllm.ai/blog/2023/06/20/vllm.html)
- **Hugging Face Models**: [huggingface.co/models](https://huggingface.co/models)
- **Flox Documentation**: [flox.dev/docs](https://flox.dev/docs)

## 🙏 Acknowledgments

- **vLLM Team**: UC Berkeley researchers and contributors for creating vLLM
- **PagedAttention**: Revolutionary algorithm enabling efficient LLM serving
- **Open Source Community**: For continuous improvements and model support

## 🔗 About Flox

[Flox](https://flox.dev/docs) builds on [Nix](https://github.com/NixOS/nix) to provide:

- **Declarative environments** - Software, variables, services defined in human-readable TOML
- **Content-addressed storage** - Multiple package versions coexist without conflicts
- **Reproducibility** - Same environment across dev, CI, and production
- **Deterministic builds** - Same inputs always produce identical outputs
- **Huge package collection** - Access to 150,000+ packages from [Nixpkgs](https://github.com/NixOS/nixpkgs)

**Why Flox for vLLM?**

- **CUDA management**: Consistent CUDA versions across deployments
- **Service orchestration**: Manage vLLM as a proper service
- **Reproducible deployments**: Same vLLM setup across all servers
- **Environment isolation**: Multiple vLLM versions without conflicts

## 📝 License

This Flox environment configuration is provided as-is. vLLM is licensed under the Apache License 2.0 - see the [LICENSE](https://github.com/vllm-project/vllm/blob/main/LICENSE) file in the vLLM repository for details.
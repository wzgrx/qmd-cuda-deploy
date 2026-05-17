#!/bin/bash
echo "⚙️  Step 6: Compiling with CUDA..."

NODE_LLAMA_DIR="$HOME/.nvm/versions/node/$(node -v)/lib/node_modules/@tobilu/qmd/node_modules/node-llama-cpp"

export CUDACXX=/usr/local/cuda-13.2/bin/nvcc
export CUDA_PATH=/usr/local/cuda-13.2
export CUDA_HOME=/usr/local/cuda-13.2

# Clean PATH again
PATH=$(echo "$PATH" | tr ':' '\n' | grep -v '/mnt/' | tr '\n' ':')
export PATH="${PATH%:}"

cd "$NODE_LLAMA_DIR"

echo "   Starting compilation (this may take 3-5 minutes)..."
node dist/cli/cli.js source build --gpu cuda

echo "✅ Compilation complete"

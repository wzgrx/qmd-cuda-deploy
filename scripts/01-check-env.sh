#!/bin/bash
echo "🔍 Step 1: Checking environment..."

# Check CUDA
if [ ! -d "/usr/local/cuda-13.2" ]; then
    echo "❌ CUDA 13.2 not found at /usr/local/cuda-13.2"
    echo "   Install with: sudo apt install cuda-toolkit-13-2"
    exit 1
fi
echo "✅ CUDA 13.2 found"

# Check NVCC
if ! command -v nvcc &> /dev/null; then
    export PATH="/usr/local/cuda-13.2/bin:$PATH"
fi
echo "✅ NVCC available"

# Check Node.js
NODE_PATH=$(which node)
if [ -z "$NODE_PATH" ]; then
    echo "❌ Node.js not found"
    exit 1
fi
NODE_VER=$(node -v)
echo "✅ Node.js $NODE_VER found at $NODE_PATH"

# Check NVM
if [ -z "$NVM_DIR" ]; then
    echo "⚠️  NVM not loaded, loading..."
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# Check QMD
if ! command -v qmd &> /dev/null; then
    echo "❌ QMD not installed. Run: npm i -g @tobilu/qmd"
    exit 1
fi
echo "✅ QMD found: $(which qmd)"

echo ""
echo "✅ Environment check passed"

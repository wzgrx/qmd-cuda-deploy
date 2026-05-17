#!/bin/bash
echo "🚀 Step 7: Deploying and testing..."

NODE_LLAMA_DIR="$HOME/.nvm/versions/node/$(node -v)/lib/node_modules/@tobilu/qmd/node_modules/node-llama-cpp"
SRC="$NODE_LLAMA_DIR/localBuilds/linux-x64-cuda/Release/llama-addon.node"
DEST="$NODE_LLAMA_DIR/bins/linux-x64-cuda/llama-addon.node"

# Create target directory
mkdir -p "$NODE_LLAMA_DIR/bins/linux-x64-cuda/"

# Deploy
echo "   Copying compiled binary..."
cp -f "$SRC" "$DEST"
echo "✅ Binary deployed to: $DEST"

# Create lastBuild symlink
ln -sf localBuilds/linux-x64-cuda "$NODE_LLAMA_DIR/lastBuild" 2>/dev/null || true

# Set environment
export CUDA_HOME=/usr/local/cuda-13.2
export LD_LIBRARY_PATH=/usr/lib/wsl/lib:/usr/local/cuda-13.2/lib64:$LD_LIBRARY_PATH

# Test
echo ""
echo "🔍 Testing GPU status..."
qmd status

echo ""
echo "🔍 Testing embedding..."
qmd embed -f

echo ""
echo "✅ Deployment and testing complete!"

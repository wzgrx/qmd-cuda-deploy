#!/bin/bash
set -e

echo "🚀 QMD CUDA Deployment for WSL2"
echo "================================="

# Configuration
CUDA_HOME="${CUDA_HOME:-/usr/local/cuda-13.2}"
NODE_VERSION="${NODE_VERSION:-v24.15.0}"
QMD_DIR="$(dirname $(dirname $(which qmd)))"

echo ""
echo "📋 Configuration:"
echo "  CUDA Home: $CUDA_HOME"
echo "  Node Version: $NODE_VERSION"
echo "  QMD Directory: $QMD_DIR"
echo ""

# Run all steps
bash scripts/01-check-env.sh
bash scripts/02-fix-nvm-npm.sh
bash scripts/03-clean-path.sh
bash scripts/04-remove-cublas.sh
bash scripts/05-patch-source.sh
bash scripts/06-compile.sh
bash scripts/07-deploy-test.sh

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📝 Next steps:"
echo "  1. Add to ~/.bashrc if not already:"
echo "     export CUDA_HOME=$CUDA_HOME"
echo "     export LD_LIBRARY_PATH=/usr/lib/wsl/lib:\$CUDA_HOME/lib64:\$LD_LIBRARY_PATH"
echo ""
echo "  2. Test GPU acceleration:"
echo "     qmd status"
echo "     qmd embed -f"
echo ""

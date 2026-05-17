#!/bin/bash
echo "🩹 Step 5: Applying source patches..."

NODE_LLAMA_DIR="$HOME/.nvm/versions/node/$(node -v)/lib/node_modules/@tobilu/qmd/node_modules/node-llama-cpp"

# Clean old source
rm -rf "$NODE_LLAMA_DIR/llama/llama.cpp" "$NODE_LLAMA_DIR/llama/localBuilds"

# Download base source
echo "   Downloading base source via CLI..."
cd "$NODE_LLAMA_DIR"
node dist/cli/cli.js source download --gpu cuda

# Replace with latest master
echo "   Replacing with latest llama.cpp master..."
cd "$NODE_LLAMA_DIR/llama"
git clone --depth 1 https://github.com/ggml-org/llama.cpp.git

# Apply VMM fix
echo "   Applying VMM crash fix..."
sed -i '1i\add_definitions(-DGGML_CUDA_NO_VMM)' "$NODE_LLAMA_DIR/llama/llama.cpp/CMakeLists.txt"

# Apply API compatibility patches
echo "   Applying API compatibility patches..."
find "$NODE_LLAMA_DIR/llama/addon/" -name "*.cpp" -exec sed -i 's/cpu_get_num_math/common_cpu_get_num_math/g' {} \;
find "$NODE_LLAMA_DIR/llama/addon/" -name "*.cpp" -exec sed -i 's/common_common_cpu_get_num_math/common_cpu_get_num_math/g' {} \;

# Fix library naming
sed -i 's/target_link_libraries(${PROJECT_NAME} "common")/target_link_libraries(${PROJECT_NAME} "llama-common")/g' "$NODE_LLAMA_DIR/llama/CMakeLists.txt"
sed -i 's/target_link_libraries(llama-addon "common")/target_link_libraries(llama-addon "llama-common")/g' "$NODE_LLAMA_DIR/llama/CMakeLists.txt"

echo "✅ All patches applied"

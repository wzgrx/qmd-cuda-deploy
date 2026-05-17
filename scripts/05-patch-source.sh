#!/bin/bash
set -e

echo "🔧 Applying WSL2 CUDA Context Patch..."

NODE_DIR=$(npm root -g)/@tobilu/qmd/node_modules/node-llama-cpp
TARGET_FILE="$NODE_DIR/llama/addon/addon.cpp"

if [ ! -f "$TARGET_FILE" ]; then
    echo "Error: $TARGET_FILE not found. Is node-llama-cpp installed?"
    exit 1
fi

# 1. Headers
grep -q '#include <dlfcn.h>' "$TARGET_FILE" || sed -i '1i\#include <dlfcn.h>' "$TARGET_FILE"
grep -q '#include <cuda.h>' "$TARGET_FILE" || sed -i '1i\#include <cuda.h>' "$TARGET_FILE"

# 2. Python Patch
python3 -c "
import re
import sys

target_file = '$TARGET_FILE'
with open(target_file, 'r') as f: 
    content = f.read()

func_code = '''
// WSL2 Fix: Force load CUDA driver
static void wsl_cuda_preinit() {
    void* handle = dlopen("/usr/lib/wsl/lib/libcuda.so", RTLD_NOW | RTLD_GLOBAL);
    if (!handle) {
        fprintf(stderr, "[WSL2-CUDA] Failed to preload libcuda.so: %s\n", dlerror());
        return;
    }
    typedef CUresult (*cuInit_fn)(unsigned int);
    cuInit_fn my_cuInit = (cuInit_fn)dlsym(handle, "cuInit");
    if (my_cuInit) {
        CUresult res = my_cuInit(0);
        if (res == 0) {
            fprintf(stderr, "[WSL2-CUDA] Pre-init cuInit result: 0 (SUCCESS)\n");
        } else {
            fprintf(stderr, "[WSL2-CUDA] Pre-init cuInit result: %d (FAILED)\n", res);
        }
    }
}
'''

if 'wsl_cuda_preinit' not in content:
    match = re.search(r'(Napi::Object\s+registerCallback\s*\([^)]*\)\s*\{)', content)
    if match:
        content = content[:match.start()] + func_code + '\n' + content[match.start():]
        brace_pos = content.find('{', match.start() + len(func_code))
        if brace_pos != -1:
            content = content[:brace_pos+1] + '\n    // WSL2 Fix\n    wsl_cuda_preinit();' + content[brace_pos+1:]
            with open(target_file, 'w') as f: 
                f.write(content)
            print('Patch applied.')
        else:
            print('Could not find {')
    else:
        print('Could not find registerCallback')
else:
    print('Patch already applied.')
"

echo "✅ Patch complete."

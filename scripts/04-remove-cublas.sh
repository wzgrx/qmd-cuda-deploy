#!/bin/bash
echo "🔧 Step 4: Removing conflicting cuBLAS stubs..."

OLD_CUBLAS="/usr/lib/x86_64-linux-gnu/libcublas.so.10"

if [ -f "$OLD_CUBLAS" ]; then
    echo "⚠️  Found old cuBLAS 10.2 stub, moving to backup..."
    sudo mkdir -p /usr/lib/x86_64-linux-gnu/old-cublas
    sudo mv /usr/lib/x86_64-linux-gnu/libcublas* /usr/lib/x86_64-linux-gnu/old-cublas/ 2>/dev/null || true
    sudo ldconfig
    echo "✅ Old cuBLAS stubs removed"
else
    echo "✅ No conflicting cuBLAS stubs found"
fi

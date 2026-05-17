#!/bin/bash
echo "🧹 Step 3: Cleaning PATH of Windows references..."

# Remove Windows paths that cause UNC errors
PATH=$(echo "$PATH" | tr ':' '\n' | grep -v '/mnt/' | tr '\n' ':')
export PATH="${PATH%:}"

echo "✅ PATH cleaned"
echo "   Current PATH: $PATH"

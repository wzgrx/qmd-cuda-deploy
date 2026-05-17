#!/bin/bash
echo "🔧 Step 2: Fixing NVM npm symlinks..."

NVM_NODE_DIR="$HOME/.nvm/versions/node/$(node -v)"
NPM_DIR="$NVM_NODE_DIR/lib/node_modules/npm"

# Check if npm is broken
if [ ! -f "$NPM_DIR/bin/npm-cli.js" ]; then
    echo "⚠️  NVM npm is broken, restoring from official binary..."
    
    cd /tmp
    NODE_VER=$(node -v)
    NODE_URL="https://nodejs.org/dist/$NODE_VER/node-$NODE_VER-linux-x64.tar.xz"
    
    if [ ! -f "node-$NODE_VER-linux-x64.tar.xz" ]; then
        echo "   Downloading Node.js binary..."
        curl -LO "$NODE_URL"
    fi
    
    echo "   Extracting..."
    tar -xf "node-$NODE_VER-linux-x64.tar.xz"
    
    echo "   Restoring npm..."
    cp -r "node-$NODE_VER-linux-x64/lib/node_modules/npm" "$NVM_NODE_DIR/lib/node_modules/"
    cp "node-$NODE_VER-linux-x64/bin/npm" "$NVM_NODE_DIR/bin/"
    cp "node-$NODE_VER-linux-x64/bin/npx" "$NVM_NODE_DIR/bin/"
    
    echo "✅ NVM npm restored"
else
    echo "✅ NVM npm is healthy"
fi

#!/bin/bash
set -e

echo "--- OpenCode Docker Entrypoint v2 ---"
echo "Current User: $(whoami)"

# Try to update if AUTO_UPDATE is set to true
if [ "${AUTO_UPDATE}" = "true" ]; then
    echo "Checking for updates via NPM..."
    npm i -g opencode-ai@latest || echo "Warning: Update failed. Continuing with existing version."
fi

# Find the binary
OPENCODE_BIN=$(which opencode || which opencode-ai || echo "")

if [ -z "$OPENCODE_BIN" ]; then
    echo "Error: opencode binary not found in PATH."
    echo "PATH is: $PATH"
    ls -la /usr/local/bin
    exit 1
fi

echo "Using OpenCode at: $OPENCODE_BIN"
$OPENCODE_BIN --version || echo "Warning: Could not determine version."

# Git config
git config --global user.email "agent@opencode.local" || true
git config --global user.name "OpenCode Agent" || true

# Start Web Server
echo "Starting OpenCode web interface on port 4096..."
exec "$OPENCODE_BIN" web --port 4096 --host 0.0.0.0

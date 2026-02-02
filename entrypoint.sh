#!/bin/bash
set -e

# Path to opencode binary
INSTALL_DIR="/usr/local/bin"
export PATH="$INSTALL_DIR:$PATH"

echo "Checking for OpenCode updates or initial installation..."
# The official install script detects if it's already installed and its version.
# We skip shell config modification since we handle PATH ourselves in this script and Docker profile.
curl -fsSL https://opencode.ai/install | bash -s -- --no-modify-path

# Verify installation worked
if ! command -v opencode &> /dev/null; then
    echo "Error: OpenCode installation failed."
    exit 1
fi

echo "OpenCode version: $(opencode --version)"

# Configure basic Git identity for the agent if not set
git config --global user.email "agent@opencode.local" || true
git config --global user.name "OpenCode Agent" || true

# Start OpenCode web interface
echo "Starting OpenCode web interface on port 4096..."
exec opencode web --port 4096 --host 0.0.0.0

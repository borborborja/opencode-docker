#!/bin/bash
set -e

# Ensure PATH includes common locations
export PATH="/root/.opencode/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

echo "Running entrypoint script..."
echo "Current PATH: $PATH"
echo "Current User: $(whoami)"

echo "Checking for OpenCode updates or initial installation..."
# The official install script detects if it's already installed and its version.
if ! curl -fsSL https://opencode.ai/install | bash -s -- --no-modify-path; then
    echo "Warning: Installer script exited with an error. Attempting to continue anyway..."
fi

# Robust verification: check multiple paths
OPENCODE_BIN=$(which opencode || true)

if [ -z "$OPENCODE_BIN" ]; then
    # Fallback search if 'which' fails
    if [ -f "/root/.opencode/bin/opencode" ]; then
        OPENCODE_BIN="/root/.opencode/bin/opencode"
    elif [ -f "/usr/local/bin/opencode" ]; then
        OPENCODE_BIN="/usr/local/bin/opencode"
    fi
fi

if [ -z "$OPENCODE_BIN" ] || [ ! -x "$OPENCODE_BIN" ]; then
    echo "Error: OpenCode binary not found or not executable after installation."
    echo "Searching filesystem for 'opencode'..."
    find /root /usr /bin -name opencode 2>/dev/null || echo "No 'opencode' file found."
    exit 1
fi

echo "OpenCode binary found at: $OPENCODE_BIN"
echo "OpenCode version: $($OPENCODE_BIN --version || echo 'unknown')"

# Configure basic Git identity for the agent if not set
git config --global user.email "agent@opencode.local" || true
git config --global user.name "OpenCode Agent" || true

# Start OpenCode web interface
echo "Starting OpenCode web interface on port 4096..."
exec "$OPENCODE_BIN" web --port 4096 --host 0.0.0.0

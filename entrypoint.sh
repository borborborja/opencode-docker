#!/bin/bash
set -e

# Ensure PATH includes common locations
export PATH="/root/.opencode/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

echo "Running entrypoint script..."
echo "Current PATH: $PATH"
echo "Current User: $(whoami)"

echo "Checking for OpenCode updates or initial installation..."
# The official install script detects if it's already installed and its version.
# Note: we ignore the exit code as we already have a pre-installed binary in /usr/local/bin
curl -fsSL https://opencode.ai/install | bash -s -- --no-modify-path || echo "Warning: Update check failed. Using existing binary."

# If the installer put a new version in the default path, move it to our safe location
if [ -f "/root/.opencode/bin/opencode" ]; then
    echo "Found new/updated binary in default path. Moving to /usr/local/bin..."
    mv /root/.opencode/bin/opencode /usr/local/bin/opencode
fi

# Final check for the binary in our safe location
OPENCODE_BIN="/usr/local/bin/opencode"

if [ ! -x "$OPENCODE_BIN" ]; then
    echo "Error: OpenCode binary not found or not executable at $OPENCODE_BIN"
    # Fallback search as a last resort
    OPENCODE_BIN=$(which opencode || true)
    if [ -z "$OPENCODE_BIN" ] || [ ! -x "$OPENCODE_BIN" ]; then
        echo "Searching filesystem for 'opencode'..."
        find /root /usr /bin -name opencode 2>/dev/null || echo "No 'opencode' file found."
        exit 1
    fi
fi

echo "OpenCode binary found at: $OPENCODE_BIN"
echo "OpenCode version: $($OPENCODE_BIN --version || echo 'unknown')"

# Configure basic Git identity for the agent if not set
git config --global user.email "agent@opencode.local" || true
git config --global user.name "OpenCode Agent" || true

# Start OpenCode web interface
echo "Starting OpenCode web interface on port 4096..."
exec "$OPENCODE_BIN" web --port 4096 --host 0.0.0.0

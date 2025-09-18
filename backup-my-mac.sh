#!/bin/bash

# Mac Transfer Utility - Simple Launcher
# Easy one-command backup of your Mac

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Mac Transfer Utility - Quick Backup"
echo "======================================"
echo

# Check if main script exists
if [[ ! -f "$SCRIPT_DIR/mac-backup.sh" ]]; then
    echo "❌ Error: mac-backup.sh not found in $SCRIPT_DIR"
    exit 1
fi

# Run the main backup script
exec bash "$SCRIPT_DIR/mac-backup.sh" "$@"
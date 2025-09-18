#!/bin/bash

# Mac Transfer Utility - Usage Examples
# This file shows various ways to use the backup utility

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd .. && pwd)"

echo "Mac Transfer Utility - Usage Examples"
echo "===================================="
echo

# Example 1: Basic backup
echo "📝 Example 1: Basic backup to Desktop"
echo "Command: ./mac-backup.sh"
echo "Result: Creates backup in ~/Desktop/mac-migration-backup/"
echo

# Example 2: Custom output directory
echo "📝 Example 2: Backup to custom directory"
echo "Command: ./mac-backup.sh ~/Documents/MyBackups"
echo "Result: Creates backup in ~/Documents/MyBackups/mac-migration-backup/"
echo

# Example 3: Using the simple launcher
echo "📝 Example 3: Using the simple launcher"
echo "Command: ./backup-my-mac.sh"
echo "Result: Same as Example 1 but with a friendlier interface"
echo

# Example 4: With custom configuration
echo "📝 Example 4: With custom settings"
echo "Commands:"
echo "  # Edit configuration first"
echo "  nano config/backup-config.sh"
echo "  # Set BACKUP_SSH_KEYS=false for shared environments"
echo "  # Set EXPORT_MAS_APPS=false if you don't use Mac App Store"
echo "  # Then run backup"
echo "  ./mac-backup.sh"
echo

# Example 5: Verbose output
echo "📝 Example 5: Verbose output for debugging"
echo "Command: VERBOSE_LOGGING=true ./mac-backup.sh"
echo "Result: Shows detailed logging of all operations"
echo

# Example 6: Skip archive creation
echo "📝 Example 6: Skip archive creation (for local use)"
echo "Command: CREATE_ARCHIVE=false ./mac-backup.sh"
echo "Result: Creates backup directory but no compressed archive"
echo

echo "🔧 Restoration Examples"
echo "======================"
echo

# Restore example 1: Basic restore
echo "📝 Restore Example 1: Basic restoration"
echo "Commands:"
echo "  # On new Mac, after transferring backup:"
echo "  tar -xzf mac-backup-*.tar.gz"
echo "  cd mac-migration-backup"
echo "  bash restore/restore-mac-setup.sh"
echo

# Restore example 2: Partial restore
echo "📝 Restore Example 2: Manual/partial restore"
echo "Commands:"
echo "  # Install Homebrew packages only:"
echo "  brew install \$(cat apps/homebrew-formulae.txt)"
echo "  # Restore shell config only:"
echo "  cp config/.zshrc ~/.zshrc"
echo "  source ~/.zshrc"
echo

echo "⚙️  Configuration Examples"
echo "========================="
echo

# Configuration example 1: Team/Enterprise setup
echo "📝 Config Example 1: Team/Enterprise setup"
echo "Edit config/backup-config.sh:"
echo "  BACKUP_SSH_KEYS=false      # Don't backup personal SSH keys"
echo "  EXPORT_MAS_APPS=false      # Skip personal Mac App Store apps"
echo "  VERBOSE_LOGGING=true       # Enable detailed logging"
echo

# Configuration example 2: Developer-focused
echo "📝 Config Example 2: Developer environment only"
echo "Edit config/backup-config.sh:"
echo "  EXPORT_HOMEBREW=true       # Include all dev tools"
echo "  EXPORT_NPM_GLOBAL=true     # Include Node.js packages"
echo "  EXPORT_PIP_PACKAGES=true   # Include Python packages"
echo "  BACKUP_SSH_KEYS=true       # Include SSH keys for git"
echo

# Configuration example 3: Minimal backup
echo "📝 Config Example 3: Minimal backup"
echo "Edit config/backup-config.sh:"
echo "  BACKUP_SSH_KEYS=false      # Skip SSH keys"
echo "  EXPORT_MAS_APPS=false      # Skip Mac App Store"
echo "  BACKUP_MACOS_DEFAULTS=false # Skip system preferences"
echo

echo "🛡️  Security Examples"
echo "===================="
echo

echo "📝 Security Example 1: Review sensitive data"
echo "Commands:"
echo "  # Check what sensitive data is included:"
echo "  ls -la mac-migration-backup/system/"
echo "  cat mac-migration-backup/system/ssh-backup/SECURITY_NOTICE.txt"
echo

echo "📝 Security Example 2: Secure transfer"
echo "Commands:"
echo "  # Encrypt before transfer:"
echo "  gpg -c mac-backup-*.tar.gz"
echo "  # Transfer the .gpg file instead"
echo

echo "🚀 Quick Start"
echo "=============="
echo
echo "To get started right now:"
echo "1. cd $SCRIPT_DIR"
echo "2. ./backup-my-mac.sh"
echo "3. Follow the prompts!"
echo
echo "That's it! Your Mac backup will be created and ready for transfer."
#!/bin/bash

# Mac Transfer Utility - Configuration File
# Customize backup behavior by modifying these settings

# =============================================================================
# BACKUP SETTINGS
# =============================================================================

# Default output directory (can be overridden with command line argument)
DEFAULT_OUTPUT_DIR="$HOME/Desktop"

# Archive creation settings
CREATE_ARCHIVE=true                # Set to false to skip archive creation
COPY_TO_CLIPBOARD=true            # Offer to copy archive to clipboard
ARCHIVE_COMPRESSION="gz"          # Options: gz, bz2, xz

# =============================================================================
# SHELL CONFIGURATIONS
# =============================================================================

# Shell configuration files to backup
SHELL_CONFIG_FILES=(
    ".zshrc"
    ".zprofile" 
    ".bash_profile"
    ".bashrc"
    ".profile"
    ".p10k.zsh"
    ".tmux.conf"
    ".vimrc"
    ".screenrc"
    ".inputrc"
)

# Shell framework directories to backup
BACKUP_ANTIGEN=true
BACKUP_OH_MY_ZSH_CUSTOM=true      # Only custom configs, not entire framework
BACKUP_POWERLEVEL10K_CONFIG=true

# =============================================================================
# APPLICATION SETTINGS
# =============================================================================

# Package managers to export
EXPORT_HOMEBREW=true
EXPORT_NPM_GLOBAL=true
EXPORT_PIP_PACKAGES=true
EXPORT_MAS_APPS=true              # Mac App Store apps (requires 'mas' CLI)

# Additional package managers (set to true if you use them)
EXPORT_CONDA_PACKAGES=false
EXPORT_GEM_PACKAGES=false
EXPORT_CARGO_PACKAGES=false

# =============================================================================
# SYSTEM CONFIGURATIONS
# =============================================================================

# System configuration directories to backup
SYSTEM_CONFIG_DIRS=(
    ".ssh"
    ".aws"
    ".docker"
    ".cloudflared"
    ".kube"
    ".gcloud"
)

# Individual system configuration files
SYSTEM_CONFIG_FILES=(
    ".gitconfig"
    ".vimrc"
    ".tmux.conf"
    ".screenrc"
    ".inputrc"
)

# macOS system preferences
BACKUP_MACOS_DEFAULTS=true

# =============================================================================
# CUSTOM SCRIPTS AND BINARIES
# =============================================================================

# User script directories to backup
SCRIPT_DIRECTORIES=(
    "$HOME/bin"
    "$HOME/.local/bin"
    "$HOME/scripts"
)

# System directories to inventory (list only, not copy)
INVENTORY_SYSTEM_BINS=true        # List /usr/local/bin contents

# =============================================================================
# SECURITY SETTINGS
# =============================================================================

# SSH key handling
BACKUP_SSH_KEYS=true              # Set to false to skip SSH keys entirely
SSH_SECURITY_WARNING=true        # Include security warnings for SSH keys

# Sensitive directories (handle with extra care)
SENSITIVE_DIRS=(
    ".ssh"
    ".aws"
    ".cloudflared"
    ".kube"
)

# =============================================================================
# EXCLUSIONS
# =============================================================================

# Files and directories to exclude from backup
EXCLUDE_PATTERNS=(
    "*.log"
    "*.cache"
    "*node_modules*"
    "*.DS_Store"
    "*/.git/*"
    "*/cache/*"
    "*/Cache/*"
    "*/logs/*"
    "*/temp/*"
    "*/tmp/*"
)

# Large directories to skip (to keep backup size manageable)
SKIP_LARGE_DIRS=(
    ".npm"
    ".cache"
    ".local/share"
    "Library/Caches"
    "Library/Application Support/Code/logs"
)

# =============================================================================
# ADVANCED SETTINGS
# =============================================================================

# Backup metadata
INCLUDE_SYSTEM_INFO=true
INCLUDE_HARDWARE_INFO=true
INCLUDE_INSTALLED_APPS_LIST=true

# Progress and logging
SHOW_PROGRESS_BAR=true
VERBOSE_LOGGING=false
LOG_TO_FILE=false
LOG_FILE_PATH="$HOME/mac-backup.log"

# Error handling
CONTINUE_ON_ERROR=true            # Continue backup even if some items fail
MAX_RETRY_ATTEMPTS=3

# =============================================================================
# RESTORE SETTINGS
# =============================================================================

# Default restore behavior
AUTO_INSTALL_HOMEBREW=true
AUTO_INSTALL_XCODE_TOOLS=true
PROMPT_FOR_MAS_APPS=true          # Ask before installing Mac App Store apps
BACKUP_EXISTING_CONFIGS=true     # Backup existing configs before restoring

# Shell environment
AUTO_SOURCE_SHELL_CONFIG=true    # Attempt to reload shell configuration

# =============================================================================
# CUSTOM HOOKS (Advanced Users)
# =============================================================================

# Custom pre-backup hook (runs before backup starts)
# Example: custom_pre_backup_hook() { echo "Starting custom pre-backup tasks"; }
custom_pre_backup_hook() {
    return 0  # Default: do nothing
}

# Custom post-backup hook (runs after backup completes)
# Example: custom_post_backup_hook() { echo "Backup completed, running cleanup"; }
custom_post_backup_hook() {
    return 0  # Default: do nothing
}

# Custom pre-restore hook (runs before restore starts)
custom_pre_restore_hook() {
    return 0  # Default: do nothing
}

# Custom post-restore hook (runs after restore completes)
custom_post_restore_hook() {
    return 0  # Default: do nothing
}

# =============================================================================
# UTILITY FUNCTIONS
# =============================================================================

# Function to check if a pattern should be excluded
should_exclude() {
    local file_path="$1"
    for pattern in "${EXCLUDE_PATTERNS[@]}"; do
        if [[ "$file_path" == $pattern ]]; then
            return 0  # Should exclude
        fi
    done
    return 1  # Should not exclude
}

# Function to check if a directory should be skipped
should_skip_directory() {
    local dir_path="$1"
    local dir_name=$(basename "$dir_path")
    
    for skip_dir in "${SKIP_LARGE_DIRS[@]}"; do
        if [[ "$dir_path" == *"$skip_dir"* ]] || [[ "$dir_name" == "$skip_dir" ]]; then
            return 0  # Should skip
        fi
    done
    return 1  # Should not skip
}

# Function to log messages based on verbosity setting
log_verbose() {
    if [[ "$VERBOSE_LOGGING" == true ]]; then
        echo "[VERBOSE] $1"
        
        if [[ "$LOG_TO_FILE" == true ]]; then
            echo "[$(date)] [VERBOSE] $1" >> "$LOG_FILE_PATH"
        fi
    fi
}

# =============================================================================
# VALIDATION
# =============================================================================

# Validate configuration on load
validate_config() {
    # Check if output directory is writable
    if [[ ! -w "$DEFAULT_OUTPUT_DIR" ]]; then
        echo "Warning: Default output directory is not writable: $DEFAULT_OUTPUT_DIR"
        return 1
    fi
    
    # Check compression method
    if [[ ! "$ARCHIVE_COMPRESSION" =~ ^(gz|bz2|xz)$ ]]; then
        echo "Error: Invalid archive compression method: $ARCHIVE_COMPRESSION"
        return 1
    fi
    
    return 0
}

# Run validation when config is loaded
if ! validate_config; then
    echo "Configuration validation failed. Please check your settings."
fi
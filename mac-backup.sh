#!/bin/bash

# Mac Transfer Utility - Backup Script
# Creates a complete backup of Mac configuration for easy migration
# Usage: bash mac-backup.sh [output_directory]

set -e

# Version and metadata
VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
show_banner() {
    echo -e "${PURPLE}"
    echo "╔═══════════════════════════════════════╗"
    echo "║        Mac Transfer Utility          ║"
    echo "║           Backup Tool                 ║"
    echo "║            v${VERSION}                    ║"
    echo "╚═══════════════════════════════════════╝"
    echo -e "${NC}"
}

# Logging functions
log() {
    echo -e "${GREEN}[$(date +'%H:%M:%S')] ✓ $1${NC}"
}

warn() {
    echo -e "${YELLOW}[$(date +'%H:%M:%S')] ⚠ $1${NC}"
}

error() {
    echo -e "${RED}[$(date +'%H:%M:%S')] ✗ $1${NC}"
}

info() {
    echo -e "${BLUE}[$(date +'%H:%M:%S')] ℹ $1${NC}"
}

step() {
    echo -e "${CYAN}[$(date +'%H:%M:%S')] → $1${NC}"
}

# Progress bar
show_progress() {
    local current=$1
    local total=$2
    local desc=$3
    local percent=$((current * 100 / total))
    local bar_length=30
    local filled_length=$((bar_length * current / total))
    
    printf "\r${BLUE}Progress: ["
    printf "%*s" $filled_length | tr ' ' '='
    printf "%*s" $((bar_length - filled_length)) | tr ' ' '-'
    printf "] %d%% - %s${NC}" $percent "$desc"
    
    if [ $current -eq $total ]; then
        echo
    fi
}

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to get system information
get_system_info() {
    echo "# System Information" > "$BACKUP_DIR/system-info.txt"
    echo "Hostname: $(hostname)" >> "$BACKUP_DIR/system-info.txt"
    echo "macOS Version: $(sw_vers -productVersion)" >> "$BACKUP_DIR/system-info.txt"
    echo "Build Version: $(sw_vers -buildVersion)" >> "$BACKUP_DIR/system-info.txt"
    echo "Hardware: $(uname -m)" >> "$BACKUP_DIR/system-info.txt"
    echo "Kernel: $(uname -r)" >> "$BACKUP_DIR/system-info.txt"
    echo "Backup Date: $(date)" >> "$BACKUP_DIR/system-info.txt"
    echo "Backup Tool: Mac Transfer Utility v$VERSION" >> "$BACKUP_DIR/system-info.txt"
}

# Function to backup shell configurations
backup_shell_config() {
    step "Backing up shell configurations..."
    local config_dir="$BACKUP_DIR/config"
    mkdir -p "$config_dir"
    
    local files_backed_up=0
    local shell_files=(".zshrc" ".zprofile" ".bash_profile" ".bashrc" ".profile" ".p10k.zsh")
    
    for file in "${shell_files[@]}"; do
        if [[ -f "$HOME/$file" ]]; then
            cp "$HOME/$file" "$config_dir/" && ((files_backed_up++))
        fi
    done
    
    # Backup Antigen configuration
    if [[ -d "$HOME/.antigen" ]]; then
        cp -r "$HOME/.antigen" "$config_dir/" && ((files_backed_up++))
    fi
    
    # Backup Oh My Zsh configuration
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        # Only backup custom configurations, not the entire framework
        if [[ -d "$HOME/.oh-my-zsh/custom" ]]; then
            mkdir -p "$config_dir/.oh-my-zsh"
            cp -r "$HOME/.oh-my-zsh/custom" "$config_dir/.oh-my-zsh/"
            ((files_backed_up++))
        fi
    fi
    
    log "Backed up $files_backed_up shell configuration files"
    return $files_backed_up
}

# Function to export applications
backup_applications() {
    step "Exporting application lists..."
    local apps_dir="$BACKUP_DIR/apps"
    mkdir -p "$apps_dir"
    local apps_backed_up=0
    
    # Homebrew packages
    if command_exists brew; then
        brew list --formula > "$apps_dir/homebrew-formulae.txt" 2>/dev/null && ((apps_backed_up++))
        brew list --cask > "$apps_dir/homebrew-casks.txt" 2>/dev/null && ((apps_backed_up++))
        log "Exported $(wc -l < "$apps_dir/homebrew-formulae.txt") Homebrew formulae"
        log "Exported $(wc -l < "$apps_dir/homebrew-casks.txt") Homebrew casks"
    else
        warn "Homebrew not found - skipping Homebrew packages"
    fi
    
    # Mac App Store apps
    if command_exists mas; then
        mas list > "$apps_dir/mac-app-store.txt" 2>/dev/null && ((apps_backed_up++))
        log "Exported $(wc -l < "$apps_dir/mac-app-store.txt") Mac App Store applications"
    else
        touch "$apps_dir/mac-app-store.txt"
        warn "mas not found - Mac App Store apps list will be empty"
    fi
    
    # Global npm packages
    if command_exists npm; then
        npm list -g --depth=0 > "$apps_dir/npm-global.txt" 2>/dev/null && ((apps_backed_up++))
    else
        warn "npm not found - skipping global npm packages"
    fi
    
    # Python packages
    if command_exists pip; then
        pip list --format=freeze > "$apps_dir/pip-packages.txt" 2>/dev/null && ((apps_backed_up++))
    elif command_exists pip3; then
        pip3 list --format=freeze > "$apps_dir/pip-packages.txt" 2>/dev/null && ((apps_backed_up++))
    else
        warn "pip not found - skipping Python packages"
    fi
    
    # Applications folder
    ls /Applications > "$apps_dir/applications-folder.txt" && ((apps_backed_up++))
    
    log "Application lists backed up ($apps_backed_up lists created)"
    return $apps_backed_up
}

# Function to backup custom scripts
backup_scripts() {
    step "Backing up custom scripts..."
    local scripts_dir="$BACKUP_DIR/scripts"
    mkdir -p "$scripts_dir"
    local scripts_backed_up=0
    
    # User bin directories
    for bin_dir in "$HOME/bin" "$HOME/.local/bin"; do
        if [[ -d "$bin_dir" ]]; then
            local dir_name=$(basename "$bin_dir")
            cp -r "$bin_dir" "$scripts_dir/$dir_name" && ((scripts_backed_up++))
            log "Backed up $bin_dir ($(find "$bin_dir" -type f | wc -l) files)"
        fi
    done
    
    # List system binaries for reference
    if [[ -d "/usr/local/bin" ]]; then
        find /usr/local/bin -type f -perm +111 -exec ls -la {} \; > "$scripts_dir/usr-local-bin-list.txt" 2>/dev/null
    fi
    
    log "Custom scripts backed up ($scripts_backed_up directories)"
    return $scripts_backed_up
}

# Function to backup system configurations
backup_system_config() {
    step "Backing up system configurations..."
    local system_dir="$BACKUP_DIR/system"
    mkdir -p "$system_dir"
    local configs_backed_up=0
    
    # SSH configuration (with security warning)
    if [[ -d "$HOME/.ssh" ]]; then
        cp -r "$HOME/.ssh" "$system_dir/ssh-backup"
        # Create security notice
        echo "WARNING: SSH private keys are included in this backup." > "$system_dir/ssh-backup/SECURITY_NOTICE.txt"
        echo "Ensure secure transfer and consider regenerating keys on the new system." >> "$system_dir/ssh-backup/SECURITY_NOTICE.txt"
        ((configs_backed_up++))
        log "SSH configuration backed up (with security notice)"
    fi
    
    # Git configuration
    if [[ -f "$HOME/.gitconfig" ]]; then
        cp "$HOME/.gitconfig" "$system_dir/" && ((configs_backed_up++))
    fi
    
    # Other common configurations
    local config_files=(".vimrc" ".tmux.conf" ".screenrc" ".inputrc")
    for config_file in "${config_files[@]}"; do
        if [[ -f "$HOME/$config_file" ]]; then
            cp "$HOME/$config_file" "$system_dir/" && ((configs_backed_up++))
        fi
    done
    
    # Application-specific configurations
    local config_dirs=(".aws" ".docker" ".cloudflared" ".kube")
    for config_dir in "${config_dirs[@]}"; do
        if [[ -d "$HOME/$config_dir" ]]; then
            cp -r "$HOME/$config_dir" "$system_dir/${config_dir#.}-backup" && ((configs_backed_up++))
        fi
    done
    
    # macOS defaults
    defaults read > "$system_dir/macos-defaults.plist" 2>/dev/null && ((configs_backed_up++))
    
    log "System configurations backed up ($configs_backed_up items)"
    return $configs_backed_up
}

# Function to create restore script
create_restore_script() {
    step "Creating restore script..."
    local restore_dir="$BACKUP_DIR/restore"
    mkdir -p "$restore_dir"
    
    # Copy the restore script template
    if [[ -f "$SCRIPT_DIR/templates/restore-template.sh" ]]; then
        cp "$SCRIPT_DIR/templates/restore-template.sh" "$restore_dir/restore-mac-setup.sh"
        chmod +x "$restore_dir/restore-mac-setup.sh"
    else
        error "Restore template not found: $SCRIPT_DIR/templates/restore-template.sh"
        return 1
    fi
    
    log "Restore script created and made executable"
}

# Function to create README
create_readme() {
    step "Creating documentation..."
    
    cat > "$BACKUP_DIR/README.md" << EOF
# Mac Migration Backup

**Created by:** Mac Transfer Utility v$VERSION  
**Source System:** $(hostname)  
**macOS Version:** $(sw_vers -productVersion)  
**Backup Date:** $(date)  

## 🚀 Quick Restore

\`\`\`bash
# On your new Mac:
bash restore/restore-mac-setup.sh
\`\`\`

## 📁 Contents

- **config/** - Shell configurations and dotfiles
- **apps/** - Application lists and package manifests  
- **scripts/** - Custom scripts and binaries
- **system/** - System configurations and preferences
- **restore/** - Automated restore script

## 🔧 What's Included

### Shell Environment
- Zsh/Bash configurations with themes and plugins
- Aliases, functions, and custom configurations
- Terminal preferences and history settings

### Applications
- $(wc -l < "$BACKUP_DIR/apps/homebrew-formulae.txt" 2>/dev/null || echo "0") Homebrew formulae
- $(wc -l < "$BACKUP_DIR/apps/homebrew-casks.txt" 2>/dev/null || echo "0") Homebrew casks  
- $(wc -l < "$BACKUP_DIR/apps/applications-folder.txt" 2>/dev/null || echo "0") total applications
- Package manager dependencies (npm, pip)

### System Configuration
- Git and development tool configurations
- SSH keys and certificates (⚠️ **Handle securely**)
- Cloud service configurations
- macOS system preferences

## 🛡️ Security Notes

This backup may contain sensitive information including:
- SSH private keys
- API tokens and certificates
- Application passwords

**Recommendations:**
- Transfer securely (encrypted storage/transfer)
- Review and rotate sensitive credentials
- Remove backup after successful migration

## 📞 Support

Generated by Mac Transfer Utility - visit the project repository for updates and support.
EOF

    log "README.md created with backup summary"
}

# Function to create compressed archive
create_archive() {
    step "Creating compressed archive..."
    local archive_name="mac-backup-$(hostname)-$(date +%Y%m%d_%H%M%S).tar.gz"
    local archive_path="$OUTPUT_DIR/$archive_name"
    
    cd "$(dirname "$BACKUP_DIR")"
    tar -czf "$archive_path" "$(basename "$BACKUP_DIR")" 2>/dev/null
    
    local archive_size=$(ls -lh "$archive_path" | awk '{print $5}')
    log "Archive created: $archive_name ($archive_size)"
    
    echo
    info "Archive location: $archive_path"
    info "Archive size: $archive_size"
    
    # Offer to copy to clipboard
    echo
    read -p "$(echo -e ${YELLOW}Copy archive to clipboard? [y/N]:${NC} )" -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cat "$archive_path" | pbcopy
        log "Archive copied to clipboard!"
    fi
    
    return 0
}

# Main execution
main() {
    show_banner
    
    # Set output directory
    OUTPUT_DIR="${1:-$HOME/Desktop}"
    BACKUP_DIR="$OUTPUT_DIR/mac-migration-backup"
    
    info "Starting Mac backup process..."
    info "Output directory: $OUTPUT_DIR"
    
    # Check if output directory exists
    if [[ ! -d "$OUTPUT_DIR" ]]; then
        error "Output directory does not exist: $OUTPUT_DIR"
        exit 1
    fi
    
    # Create backup directory
    if [[ -d "$BACKUP_DIR" ]]; then
        warn "Backup directory exists. Creating timestamped backup..."
        BACKUP_DIR="$OUTPUT_DIR/mac-migration-backup-$(date +%Y%m%d_%H%M%S)"
    fi
    
    mkdir -p "$BACKUP_DIR"
    log "Created backup directory: $BACKUP_DIR"
    
    # Get system information
    get_system_info
    
    # Execute backup steps with progress
    local total_steps=6
    local current_step=0
    
    show_progress $((++current_step)) $total_steps "Shell configurations"
    backup_shell_config
    
    show_progress $((++current_step)) $total_steps "Applications and packages"
    backup_applications
    
    show_progress $((++current_step)) $total_steps "Custom scripts"
    backup_scripts
    
    show_progress $((++current_step)) $total_steps "System configurations"
    backup_system_config
    
    show_progress $((++current_step)) $total_steps "Restore script"
    create_restore_script
    
    show_progress $((++current_step)) $total_steps "Documentation"
    create_readme
    
    echo
    log "Backup completed successfully!"
    
    # Create archive
    create_archive
    
    echo
    echo -e "${GREEN}╔═══════════════════════════════════════╗"
    echo -e "║           Backup Complete!            ║"
    echo -e "╚═══════════════════════════════════════╝${NC}"
    echo
    info "Your Mac is ready to migrate! 🚀"
    warn "Keep your backup secure - it contains sensitive data"
}

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    error "This utility is designed for macOS only"
    exit 1
fi

# Run main function
main "$@"
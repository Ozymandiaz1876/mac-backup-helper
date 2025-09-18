# Mac Transfer Utility 🚀

A comprehensive, user-friendly tool for backing up and migrating complete Mac configurations between machines. Perfect for setting up new Macs with your exact development environment, applications, and preferences.

## ✨ Features

- **Complete Environment Backup**: Shell configs, aliases, functions, themes
- **Application Migration**: Homebrew, npm, pip, Mac App Store apps
- **System Configuration**: SSH keys, Git config, cloud service setups
- **Custom Scripts**: Personal scripts and binaries
- **Smart Restoration**: Automated setup with progress tracking
- **Security Conscious**: Handles sensitive data with care
- **Highly Configurable**: Customize what gets backed up
- **Beautiful Interface**: Progress bars and colored output

## 🎯 Quick Start

### Create a Backup

```bash
# Clone or download the utility
cd ~/Desktop/personal-work/mac-transfer-utility

# Run the backup (outputs to ~/Desktop by default)
bash mac-backup.sh

# Or specify custom output directory
bash mac-backup.sh /path/to/backup/location
```

### Restore on New Mac

```bash
# Transfer the backup archive to your new Mac
# Extract the archive
tar -xzf mac-backup-*.tar.gz

# Navigate to the backup and run restore
cd mac-migration-backup
bash restore/restore-mac-setup.sh
```

## 📁 What Gets Backed Up

### 🐚 Shell Environment
- ✅ Zsh/Bash configurations (.zshrc, .bash_profile, etc.)
- ✅ Powerlevel10k theme settings
- ✅ Antigen plugin manager
- ✅ Oh My Zsh custom configurations
- ✅ Aliases, functions, and custom configurations
- ✅ Terminal preferences and history settings

### 📦 Applications & Packages
- ✅ **Homebrew**: All formulae and casks
- ✅ **npm**: Global packages
- ✅ **pip**: Python packages  
- ✅ **Mac App Store**: Applications (with mas CLI)
- ✅ **Applications folder**: Complete inventory
- ⚙️ Optional: Conda, Gem, Cargo packages

### ⚙️ System Configuration
- ✅ **SSH**: Keys and configuration (with security warnings)
- ✅ **Git**: Global configuration
- ✅ **Cloud Services**: AWS, Docker, Kubernetes, Cloudflare
- ✅ **Development Tools**: vim, tmux, screen configurations
- ✅ **macOS Preferences**: System defaults and preferences

### 📜 Custom Scripts
- ✅ ~/bin and ~/.local/bin scripts
- ✅ Custom executable files
- ✅ Development utilities
- ✅ Proper permissions restoration

## 🛠️ Installation & Setup

### Prerequisites
- macOS (tested on macOS 10.15+)
- Bash 4.0+ or Zsh
- Internet connection (for package installations during restore)

### Quick Install
```bash
# Clone to your preferred location
git clone git@github.com:Ozymandiaz1876/mac-backup-helper.git ~/Desktop/personal-work/mac-transfer-utility
cd ~/Desktop/personal-work/mac-transfer-utility

# Make executable
chmod +x mac-backup.sh
chmod +x templates/restore-template.sh
```

## 📖 Usage Guide

### Basic Backup
```bash
# Simple backup to Desktop
./mac-backup.sh

# Backup to specific directory
./mac-backup.sh ~/Documents/Backups
```

### Advanced Usage
```bash
# Load custom configuration
source config/backup-config.sh
./mac-backup.sh

# Verbose output
VERBOSE_LOGGING=true ./mac-backup.sh

# Skip archive creation
CREATE_ARCHIVE=false ./mac-backup.sh
```

### Restoration Options
```bash
# Standard restore
bash restore/restore-mac-setup.sh

# Skip Mac App Store apps
# (modify restore script or respond 'n' when prompted)

# Custom restore location
# (backup directory is auto-detected)
```

## ⚙️ Configuration

Edit `config/backup-config.sh` to customize:

### Backup Behavior
```bash
# Archive settings
CREATE_ARCHIVE=true
COPY_TO_CLIPBOARD=true
ARCHIVE_COMPRESSION="gz"  # gz, bz2, or xz

# What to backup
BACKUP_SSH_KEYS=true
EXPORT_HOMEBREW=true
EXPORT_NPM_GLOBAL=true
```

### Security Settings
```bash
# Sensitive data handling
SSH_SECURITY_WARNING=true
BACKUP_SSH_KEYS=true  # Set false to skip SSH keys

# Exclusion patterns
EXCLUDE_PATTERNS=("*.log" "*.cache" "*node_modules*")
```

### Package Managers
```bash
# Enable/disable package manager exports
EXPORT_HOMEBREW=true
EXPORT_NPM_GLOBAL=true
EXPORT_PIP_PACKAGES=true
EXPORT_MAS_APPS=true
EXPORT_CONDA_PACKAGES=false  # Set true if you use conda
```

## 🔧 Customization

### Custom Hooks
Add custom logic by editing the configuration file:

```bash
# Pre-backup custom tasks
custom_pre_backup_hook() {
    echo "Running custom pre-backup tasks..."
    # Add your custom logic here
}

# Post-restore custom tasks
custom_post_restore_hook() {
    echo "Running custom post-restore tasks..."
    # Configure additional settings
}
```

### Adding New Package Managers
Extend the backup script to support additional package managers:

```bash
# In mac-backup.sh, add new export function
backup_cargo_packages() {
    if command_exists cargo && [[ "$EXPORT_CARGO_PACKAGES" == true ]]; then
        cargo install --list > "$apps_dir/cargo-packages.txt"
        log "Exported Cargo packages"
    fi
}
```

## 🔍 Troubleshooting

### Common Issues

**Permission Denied**
```bash
chmod +x mac-backup.sh
chmod +x templates/restore-template.sh
```

**Homebrew Installation Fails**
```bash
# Install Xcode Command Line Tools first
xcode-select --install
```

**SSH Keys Don't Work**
```bash
# Check permissions
ls -la ~/.ssh/
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_*
```

**Shell Configuration Not Applied**
```bash
# Reload shell configuration
source ~/.zshrc
# Or restart terminal
```

### Getting Help

1. **Check the logs**: Look for error messages during backup/restore
2. **Verify file permissions**: Ensure scripts are executable
3. **Review exclusions**: Check if files are being excluded unintentionally
4. **Test incrementally**: Run parts of the restore manually if needed

## 🛡️ Security Considerations

### Sensitive Data
The backup may include:
- SSH private keys
- API tokens and certificates  
- Cloud service credentials
- Application passwords

### Best Practices
- ✅ **Transfer securely**: Use encrypted storage/transfer methods
- ✅ **Review credentials**: Check what sensitive data is included
- ✅ **Rotate secrets**: Consider updating credentials after migration
- ✅ **Secure storage**: Store backups in secure locations
- ✅ **Clean up**: Remove backups after successful migration

### SSH Key Security
```bash
# The backup includes a security notice for SSH keys
cat system/ssh-backup/SECURITY_NOTICE.txt

# Verify SSH key permissions after restore
ls -la ~/.ssh/
```

## 📋 Migration Checklist

After running the restore script, review the generated checklist:

### Automatic ✅
- Homebrew and packages installed
- Shell configuration restored
- Development tools configured
- Basic macOS preferences set

### Manual Tasks ⚠️
- [ ] Sign in to Apple ID / iCloud
- [ ] Configure Touch/Face ID
- [ ] Sign in to Mac App Store (`mas signin`)
- [ ] Set up VPN connections
- [ ] Restore browser bookmarks
- [ ] Configure email accounts
- [ ] Test SSH key functionality
- [ ] Verify development environments

## 🔄 Updates & Maintenance

### Updating the Utility
```bash
# Pull latest changes
git pull origin main

# Or download latest release
# Update your local copy
```

### Regular Backups
```bash
# Set up automated backups (optional)
# Add to cron or use a scheduled task
0 0 * * 0 /path/to/mac-backup.sh /path/to/backups
```

## 📊 Examples

### Enterprise/Team Setup
```bash
# Create standardized team backup
EXPORT_HOMEBREW=true
BACKUP_SSH_KEYS=false  # Skip SSH for team setups
CREATE_ARCHIVE=true
./mac-backup.sh /shared/team-configs
```

### Personal Migration
```bash
# Full personal backup with all data
BACKUP_SSH_KEYS=true
COPY_TO_CLIPBOARD=true
./mac-backup.sh
```

### Development Environment Only
```bash
# Skip personal files, focus on dev tools
BACKUP_SSH_KEYS=false
EXPORT_HOMEBREW=true
EXPORT_NPM_GLOBAL=true
./mac-backup.sh ~/dev-environment-backup
```

## 🤝 Contributing

Contributions welcome! Areas for improvement:
- Additional package manager support
- Enhanced error handling
- GUI interface
- Cloud storage integration
- Configuration validation


## 🙋 Support

- **Issues**: Report bugs and feature requests
- **Documentation**: Suggest improvements
- **Community**: Share your migration experiences

---

**Happy Mac Migration!** 🎉

*Created with ❤️ for the Mac development community*

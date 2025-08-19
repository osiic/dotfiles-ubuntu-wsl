#!/bin/bash
set -e

# ==============================================
# WSL UBUNTU DEVELOPMENT ENVIRONMENT REINSTALL SCRIPT
# Compatible with all Ubuntu LTS versions
# ==============================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Function to print section headers
section() {
    echo -e "\n${BLUE}==================================${NC}"
    echo -e "${BLUE}>>> ${GREEN}$1${NC}"
    echo -e "${BLUE}==================================${NC}"
}

# Function to ask yes/no question
ask_yes_no() {
    while true; do
        read -p "$1 (y/n): " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done
}

# Function to check if script exists and is executable
check_script() {
    if [ ! -f "$1" ]; then
        echo -e "${RED}❌ Error: $1 not found!${NC}"
        echo -e "Please make sure you have $1 in the same directory."
        exit 1
    fi
    
    if [ ! -x "$1" ]; then
        echo -e "${YELLOW}Making $1 executable...${NC}"
        chmod +x "$1"
    fi
}

# ==============================================
# INITIAL SETUP
# ==============================================

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${CYAN}   🔄 WSL Ubuntu Development Reinstaller    ${BLUE}║${NC}"
echo -e "${BLUE}║${MAGENTA}      Update and Reinstall Environment     ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"

# Get current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_SCRIPT="$SCRIPT_DIR/install.sh"
UNINSTALL_SCRIPT="$SCRIPT_DIR/uninstall.sh"

echo -e "\n${YELLOW}This script will:${NC}"
echo -e "1. 🗑️  Run uninstallation process"
echo -e "2. 🚀 Run fresh installation process"
echo -e "3. ✨ Ensure you have the latest configuration"

echo -e "\n${CYAN}Checking required scripts...${NC}"
check_script "$INSTALL_SCRIPT"
check_script "$UNINSTALL_SCRIPT"
echo -e "${GREEN}✅ All required scripts found${NC}"

# ==============================================
# USER CONFIRMATION
# ==============================================

echo -e "\n${YELLOW}⚠️  IMPORTANT INFORMATION:${NC}"
echo -e "• This process will completely remove and reinstall your development environment"
echo -e "• All configurations will be reset to the latest version"
echo -e "• Your projects will be preserved by default (you can choose during uninstall)"
echo -e "• SSH keys and Git configuration backups will be created"

if ! ask_yes_no "Do you want to proceed with the reinstallation?"; then
    echo -e "${GREEN}✅ Reinstallation cancelled.${NC}"
    exit 0
fi

# ==============================================
# BACKUP IMPORTANT DATA
# ==============================================

section "Creating Additional Backups"

BACKUP_DIR="$HOME/.dev_backup_$(date +%Y%m%d_%H%M%S)"
echo -e "${YELLOW}Creating backup directory: $BACKUP_DIR${NC}"
mkdir -p "$BACKUP_DIR"

# Backup critical configurations
echo -e "${YELLOW}Backing up critical configurations...${NC}"

# Backup .bashrc and .zshrc
[ -f ~/.bashrc ] && cp ~/.bashrc "$BACKUP_DIR/bashrc_backup"
[ -f ~/.zshrc ] && cp ~/.zshrc "$BACKUP_DIR/zshrc_backup"
[ -f ~/.profile ] && cp ~/.profile "$BACKUP_DIR/profile_backup"

# Backup SSH config
[ -d ~/.ssh ] && cp -r ~/.ssh "$BACKUP_DIR/ssh_backup"

# Backup Git config
[ -f ~/.gitconfig ] && cp ~/.gitconfig "$BACKUP_DIR/gitconfig_backup"

# Backup Neovim config
[ -d ~/.config/nvim ] && cp -r ~/.config/nvim "$BACKUP_DIR/nvim_backup"

# Backup Tmux config
[ -d ~/.tmux ] && cp -r ~/.tmux "$BACKUP_DIR/tmux_backup"
[ -f ~/.tmux.conf ] && cp ~/.tmux.conf "$BACKUP_DIR/tmux.conf_backup"

# Backup Starship config
[ -f ~/.config/starship.toml ] && cp ~/.config/starship.toml "$BACKUP_DIR/starship_backup.toml"

# Create backup info file
cat > "$BACKUP_DIR/backup_info.txt" << EOF
Development Environment Backup
Created: $(date)
Backup Directory: $BACKUP_DIR

This backup contains:
- Shell configurations (.bashrc, .zshrc, .profile)
- SSH keys and configuration
- Git global configuration
- Neovim configuration
- Tmux configuration
- Starship configuration

To restore any configuration, copy the desired backup file back to its original location.
EOF

echo -e "${GREEN}✅ Backup created at: $BACKUP_DIR${NC}"

# ==============================================
# SAVE USER INFORMATION
# ==============================================

section "Preserving User Information"

# Try to get existing git configuration
USER_NAME=$(git config --global user.name 2>/dev/null || echo "")
USER_EMAIL=$(git config --global user.email 2>/dev/null || echo "")

# Ask user for information if not found
if [ -z "$USER_NAME" ] || [ -z "$USER_EMAIL" ]; then
    echo -e "${YELLOW}Git configuration not found or incomplete.${NC}"
    echo -e "Please provide your information for the fresh installation:"
    
    if [ -z "$USER_NAME" ]; then
        read -p "Enter your full name: " USER_NAME
    else
        echo -e "Using existing name: ${GREEN}$USER_NAME${NC}"
        if ask_yes_no "Do you want to change this name?"; then
            read -p "Enter your full name: " USER_NAME
        fi
    fi
    
    if [ -z "$USER_EMAIL" ]; then
        read -p "Enter your email address: " USER_EMAIL
    else
        echo -e "Using existing email: ${GREEN}$USER_EMAIL${NC}"
        if ask_yes_no "Do you want to change this email?"; then
            read -p "Enter your email address: " USER_EMAIL
        fi
    fi
    
    read -p "Enter your GitHub username: " GITHUB_USER
else
    echo -e "Found existing Git configuration:"
    echo -e "Name    : ${GREEN}$USER_NAME${NC}"
    echo -e "Email   : ${GREEN}$USER_EMAIL${NC}"
    
    if ask_yes_no "Do you want to use this information for reinstallation?"; then
        # Try to extract GitHub username from remote URL
        GITHUB_USER=$(git remote get-url origin 2>/dev/null | sed -n 's/.*github\.com[:/]\([^/]*\)\/.*/\1/p' || echo "")
        if [ -z "$GITHUB_USER" ]; then
            read -p "Enter your GitHub username: " GITHUB_USER
        else
            echo -e "Detected GitHub username: ${GREEN}$GITHUB_USER${NC}"
            if ask_yes_no "Is this correct?"; then
                : # Keep the detected username
            else
                read -p "Enter your GitHub username: " GITHUB_USER
            fi
        fi
    else
        read -p "Enter your full name: " USER_NAME
        read -p "Enter your email address: " USER_EMAIL
        read -p "Enter your GitHub username: " GITHUB_USER
    fi
fi

# Save user info to temporary file
USER_INFO_FILE="$BACKUP_DIR/user_info.txt"
cat > "$USER_INFO_FILE" << EOF
USER_NAME="$USER_NAME"
USER_EMAIL="$USER_EMAIL"
GITHUB_USER="$GITHUB_USER"
EOF

echo -e "${GREEN}✅ User information saved${NC}"

# ==============================================
# UNINSTALLATION PHASE
# ==============================================

section "Starting Uninstallation Phase"

echo -e "${YELLOW}Running uninstallation script...${NC}"
echo -e "${CYAN}Note: You will be prompted to choose what to remove.${NC}"
echo -e "${MAGENTA}Recommended: Keep projects directory, remove everything else for clean reinstall.${NC}"

read -p "Press Enter to continue with uninstallation..."

# Run uninstall script
if ! "$UNINSTALL_SCRIPT"; then
    echo -e "${RED}❌ Uninstallation failed!${NC}"
    echo -e "Backup is available at: $BACKUP_DIR"
    exit 1
fi

echo -e "${GREEN}✅ Uninstallation completed successfully${NC}"

# ==============================================
# PRE-INSTALLATION SETUP
# ==============================================

section "Preparing for Installation"

# Create a modified install script with user info pre-filled
TEMP_INSTALL_SCRIPT="/tmp/auto_install.sh"
cp "$INSTALL_SCRIPT" "$TEMP_INSTALL_SCRIPT"

# Modify the install script to use saved user info
sed -i '/read -p "Enter your full name: " USER_NAME/c\
USER_NAME="'"$USER_NAME"'"' "$TEMP_INSTALL_SCRIPT"

sed -i '/read -p "Enter your email address: " USER_EMAIL/c\
USER_EMAIL="'"$USER_EMAIL"'"' "$TEMP_INSTALL_SCRIPT"

sed -i '/read -p "Enter your GitHub username: " GITHUB_USER/c\
GITHUB_USER="'"$GITHUB_USER"'"' "$TEMP_INSTALL_SCRIPT"

# Skip the confirmation step
sed -i '/read -p "Is this correct? (y\/n): " confirm/,/fi/c\
confirm="y"' "$TEMP_INSTALL_SCRIPT"

chmod +x "$TEMP_INSTALL_SCRIPT"

# ==============================================
# INSTALLATION PHASE
# ==============================================

section "Starting Installation Phase"

echo -e "${YELLOW}Running fresh installation with your saved information...${NC}"
echo -e "${CYAN}Using:${NC}"
echo -e "Name    : ${GREEN}$USER_NAME${NC}"
echo -e "Email   : ${GREEN}$USER_EMAIL${NC}"
echo -e "GitHub  : ${GREEN}$GITHUB_USER${NC}"

read -p "Press Enter to continue with installation..."

# Run installation script
if ! "$TEMP_INSTALL_SCRIPT"; then
    echo -e "${RED}❌ Installation failed!${NC}"
    echo -e "You can try to restore from backup at: $BACKUP_DIR"
    echo -e "Or run the original install script manually: $INSTALL_SCRIPT"
    exit 1
fi

# Clean up temporary script
rm -f "$TEMP_INSTALL_SCRIPT"

echo -e "${GREEN}✅ Installation completed successfully${NC}"

# ==============================================
# POST-INSTALLATION VERIFICATION
# ==============================================

section "Post-Installation Verification"

echo -e "${YELLOW}Verifying installation...${NC}"

# Check if key tools are installed
VERIFICATION_PASSED=true

check_command() {
    if command -v "$1" >/dev/null 2>&1; then
        echo -e "  ✅ $1: ${GREEN}$(command -v "$1")${NC}"
    else
        echo -e "  ❌ $1: ${RED}Not found${NC}"
        VERIFICATION_PASSED=false
    fi
}

echo -e "${CYAN}Checking installed tools:${NC}"
check_command git
check_command nvim
check_command tmux
check_command node
check_command npm
check_command python3
check_command zsh
check_command starship

# Check configurations
echo -e "\n${CYAN}Checking configurations:${NC}"
[ -f ~/.zshrc ] && echo -e "  ✅ Zsh config: ${GREEN}~/.zshrc${NC}" || echo -e "  ❌ Zsh config: ${RED}Missing${NC}"
[ -d ~/.config/nvim ] && echo -e "  ✅ Neovim config: ${GREEN}~/.config/nvim${NC}" || echo -e "  ❌ Neovim config: ${RED}Missing${NC}"
[ -f ~/.gitconfig ] && echo -e "  ✅ Git config: ${GREEN}~/.gitconfig${NC}" || echo -e "  ❌ Git config: ${RED}Missing${NC}"

if [ "$VERIFICATION_PASSED" = true ]; then
    echo -e "\n${GREEN}✅ All verifications passed!${NC}"
else
    echo -e "\n${YELLOW}⚠️  Some verifications failed. You may need to check the installation.${NC}"
fi

# ==============================================
# CLEANUP AND FINAL STEPS
# ==============================================

section "Final Cleanup"

echo -e "${YELLOW}Performing final cleanup...${NC}"

# Clean up any temporary files
sudo apt autoremove -y >/dev/null 2>&1 || true
sudo apt autoclean >/dev/null 2>&1 || true

# Create reinstall summary
SUMMARY_FILE="$HOME/reinstall_summary.txt"
cat > "$SUMMARY_FILE" << EOF
╔════════════════════════════════════════════╗
║  🔄 Development Environment Reinstallation  ║
╚════════════════════════════════════════════╝

Reinstallation completed: $(date)

User Information:
• Name: $USER_NAME
• Email: $USER_EMAIL  
• GitHub: $GITHUB_USER

Backup Location: $BACKUP_DIR
Contains: SSH keys, Git config, Neovim config, Tmux config, Shell configs

Fresh Installation Includes:
• Git with your configuration
• Node.js (Latest LTS) with npm, yarn, pnpm, bun
• Python with virtual environment support
• Zsh with Oh My Zsh and plugins
• Neovim with custom configuration
• Tmux with custom configuration
• Starship prompt
• Development tools: lazygit, fzf, ripgrep, eza, bat
• GitHub CLI

Quick Start Commands:
• Open projects: proj (cd ~/projects)
• Edit with Neovim: v filename  
• Git status: g st
• Git log: glg
• Reload shell: sz

Next Steps:
1. Restart terminal: exec zsh
2. Authenticate GitHub CLI: gh auth login
3. Add SSH key to GitHub if needed
4. Start developing!

Note: If you need to restore any old configuration, 
check the backup directory above.
EOF

# ==============================================
# SUCCESS MESSAGE
# ==============================================

section "Reinstallation Complete"

echo -e "${GREEN}🎉 Development environment reinstallation successful!${NC}"
echo -e "\n${YELLOW}Summary:${NC}"
echo -e "• ✅ Previous environment completely removed"
echo -e "• ✅ Fresh installation completed with latest configurations"
echo -e "• ✅ User settings preserved and applied"
echo -e "• ✅ Backup created at: ${CYAN}$BACKUP_DIR${NC}"
echo -e "• ✅ Summary saved at: ${CYAN}$SUMMARY_FILE${NC}"

echo -e "\n${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}🚀 NEXT STEPS:${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "1. ${YELLOW}Restart your terminal:${NC} ${GREEN}exec zsh${NC}"
echo -e "2. ${YELLOW}View summary:${NC} ${GREEN}cat ~/reinstall_summary.txt${NC}"
echo -e "3. ${YELLOW}Authenticate GitHub:${NC} ${GREEN}gh auth login${NC}"
echo -e "4. ${YELLOW}Start developing:${NC} ${GREEN}proj${NC} (opens ~/projects)"

echo -e "\n${CYAN}If you encounter any issues:${NC}"
echo -e "• Check the backup at: $BACKUP_DIR"  
echo -e "• Run individual scripts manually if needed"
echo -e "• Restore specific configs from backup"

echo -e "\n${MAGENTA}🎊 Happy coding with your fresh environment! 🎊${NC}"

# ==============================================
# OPTIONAL IMMEDIATE SHELL RESTART
# ==============================================

if ask_yes_no "Would you like to restart your shell now to apply all changes?"; then
    echo -e "${GREEN}Restarting shell...${NC}"
    exec zsh
else
    echo -e "${YELLOW}Remember to restart your terminal or run 'exec zsh' to apply all changes.${NC}"
fi

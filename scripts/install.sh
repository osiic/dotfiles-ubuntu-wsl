#!/bin/bash

# Main installer script

# Source core functions
source "$(dirname "$0")/core/functions.sh"

set -e

# ==============================================
# WSL UBUNTU DEVELOPMENT ENVIRONMENT SETUP SCRIPT
# Compatible with all Ubuntu LTS versions
# ==============================================

# Create backup directory with timestamp
BACKUP_DIR=$(create_backup)

# ==============================================
# INITIAL SETUP
# ==============================================

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${CYAN}   🚀 WSL Ubuntu Development Setup Script   ${BLUE}║${NC}"
echo -e "${BLUE}║${MAGENTA}       For All Ubuntu LTS Versions        ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"

# Ask for sudo password once
echo -e "\n${YELLOW}🔑 Please enter your sudo password when prompted...${NC}"
sudo -v

# Environment validation
check_wsl
check_ubuntu_version

# Check for updates on first run
if [ ! -f ~/.setup_complete ]; then
    echo -e "\n${YELLOW}First time setup detected.${NC}"
    source "$(dirname "$0")/commands/update.sh"
    touch ~/.setup_complete
fi

# Source and run modules
source "$(dirname "$0")/modules/github.sh"
setup_github

source "$(dirname "$0")/modules/system.sh"
setup_system

source "$(dirname "$0")/modules/devtools.sh"
setup_devtools

source "$(dirname "$0")/modules/shell.sh"
setup_shell

source "$(dirname "$0")/modules/extras.sh"
setup_extras

# ==============================================
# COMPLETION
# ==============================================

section "Setup Complete"

echo -e "${GREEN}✅ Development environment setup successfully!${NC}"
echo -e "\n${YELLOW}Next steps:${NC}"
echo -e "1. Restart your shell: ${GREEN}exec zsh${NC}"
echo -e "2. Start developing in ~/projects directory just type dev in your shell"
echo -e "\n${BLUE}Happy coding! 🎉${NC}"
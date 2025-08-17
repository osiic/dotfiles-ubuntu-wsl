#!/bin/bash
set -e

# ==============================================
# WSL UBUNTU DEVELOPMENT ENVIRONMENT CLEANUP SCRIPT
# ==============================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function to print section headers
section() {
    echo -e "\n${BLUE}==================================${NC}"
    echo -e "${BLUE}>>> ${GREEN}$1${NC}"
    echo -e "${BLUE}==================================${NC}"
}

# Function to remove package if exists
remove_package() {
    if dpkg -l | grep -q "$1"; then
        echo -e "${YELLOW}[REMOVING]${NC} $1..."
        sudo apt remove -y --purge "$1"
    else
        echo -e "${YELLOW}[SKIP]${NC} $1 not installed"
    fi
}

# Function to remove directory if exists
remove_dir() {
    if [ -d "$1" ]; then
        echo -e "${YELLOW}[REMOVING]${NC} $1..."
        rm -rf "$1"
    else
        echo -e "${YELLOW}[SKIP]${NC} $1 not found"
    fi
}

# Function to remove file if exists
remove_file() {
    if [ -f "$1" ]; then
        echo -e "${YELLOW}[REMOVING]${NC} $1..."
        rm -f "$1"
    else
        echo -e "${YELLOW}[SKIP]${NC} $1 not found"
    fi
}

# ==============================================
# INITIALIZATION
# ==============================================

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${RED}   🧹 WSL Ubuntu Development Cleanup Script   ${BLUE}║${NC}"
echo -e "${BLUE}║${YELLOW}       For All Ubuntu LTS Versions        ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"

# Ask for confirmation
echo -e "\n${RED}⚠️ WARNING: This script will remove all development tools and configurations!${NC}"
read -p "Are you sure you want to continue? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
    echo -e "${GREEN}✅ Cleanup aborted. No changes were made.${NC}"
    exit 0
fi

# Ask for sudo password once
echo -e "\n${YELLOW}🔑 Please enter your sudo password when prompted...${NC}"
sudo -v

# ==============================================
# SYSTEM CLEANUP
# ==============================================

section "Cleaning System Packages"

# Remove installed packages
remove_package neovim
remove_package git
remove_package zsh
remove_package gh
remove_package bat
remove_package exa
remove_package ripgrep
remove_package fd-find
remove_package tldr
remove_package docker-ce
remove_package docker-ce-cli
remove_package containerd.io
remove_package docker-compose-plugin

# Remove Oh My Zsh
section "Removing Oh My Zsh"
remove_dir "${HOME}/.oh-my-zsh"

# Remove Starship
section "Removing Starship"
remove_file "${HOME}/.local/bin/starship"

# Remove NVM and Node.js
section "Removing Node.js Environment"
remove_dir "${HOME}/.nvm"
remove_dir "${HOME}/.npm"
remove_dir "${HOME}/.yarn"
remove_dir "${HOME}/.pnpm"
remove_dir "${HOME}/.bun"

# Remove Python packages
section "Cleaning Python Environment"
pip3 uninstall -y virtualenv pipx || true
sudo apt remove -y python3-pip

# Remove fzf
section "Removing fzf"
remove_dir "${HOME}/.fzf"

# Remove lazygit
section "Removing lazygit"
remove_file "/usr/local/bin/lazygit"

# ==============================================
# CONFIGURATION CLEANUP
# ==============================================

section "Cleaning Configuration Files"

# Remove shell configs
remove_file "${HOME}/.zshrc"
remove_file "${HOME}/.bashrc"
remove_file "${HOME}/.bash_profile"
remove_file "${HOME}/.profile"

# Remove Starship config
remove_file "${HOME}/.config/starship.toml"

# Remove Git config
remove_file "${HOME}/.gitconfig"
remove_file "${HOME}/.gitignore_global"

# Remove SSH config (keep keys)
remove_file "${HOME}/.ssh/config"
remove_file "${HOME}/.ssh/known_hosts"

# Remove development directories
remove_dir "${HOME}/.config/dotfiles"
remove_dir "${HOME}/.config/nvim"
remove_dir "${HOME}/.tmux"

# Remove welcome message
remove_file "${HOME}/.config/welcome.txt"

# ==============================================
# CACHE CLEANUP
# ==============================================

section "Cleaning Cache and Temporary Files"

# Remove cache directories
remove_dir "${HOME}/.cache/nvim"
remove_dir "${HOME}/.cache/zsh"
remove_dir "${HOME}/.cache/pip"
remove_dir "${HOME}/.cache/node_modules"

# Clean apt cache
echo -e "${YELLOW}Cleaning apt cache...${NC}"
sudo apt autoremove -y
sudo apt clean

# ==============================================
# RESET SHELL
# ==============================================

section "Resetting Default Shell"

# Reset to bash if zsh was default
if [ "$SHELL" = "/bin/zsh" ]; then
    echo -e "${YELLOW}Resetting default shell to bash...${NC}"
    chsh -s /bin/bash
fi

# ==============================================
# FINAL CLEANUP
# ==============================================

section "Final Cleanup"

# Remove custom directories (keep projects)
remove_dir "${HOME}/tools"
remove_dir "${HOME}/scripts"

# ==============================================
# COMPLETION
# ==============================================

section "Cleanup Complete"

echo -e "${GREEN}✅ System has been reset to clean state!${NC}"
echo -e "\n${YELLOW}Recommendations:${NC}"
echo -e "1. Restart your shell: ${GREEN}exec bash${NC}"
echo -e "2. Close and reopen your terminal for changes to take full effect"
echo -e "\n${BLUE}Your projects in ~/projects were not removed.${NC}"

#!/bin/bash
set -e

# ==============================================
# WSL UBUNTU DEVELOPMENT ENVIRONMENT UNINSTALL SCRIPT
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
    echo -e "${BLUE}>>> ${RED}$1${NC}"
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

# Function to remove package if exists
remove_package() {
    if dpkg -l | grep -q "$1"; then
        echo -e "${YELLOW}[REMOVE]${NC} $1..."
        sudo apt remove --purge -y "$1"
    else
        echo -e "${YELLOW}[SKIP]${NC} $1 not installed"
    fi
}

# ==============================================
# INITIAL CONFIRMATION
# ==============================================

echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
echo -e "${RED}║${CYAN}   🗑️  WSL Ubuntu Development Uninstaller    ${RED}║${NC}"
echo -e "${RED}║${MAGENTA}        Remove Development Environment      ${RED}║${NC}"
echo -e "${RED}╚════════════════════════════════════════════╝${NC}"

echo -e "\n${RED}⚠️  WARNING: This will remove development tools and configurations!${NC}"
if ! ask_yes_no "Are you sure you want to continue with uninstallation?"; then
    echo -e "${GREEN}✅ Uninstallation cancelled.${NC}"
    exit 0
fi

# ==============================================
# COLLECT UNINSTALL PREFERENCES
# ==============================================

echo -e "\n${YELLOW}Please choose what to remove:${NC}"

# SSH Configuration
echo -e "\n${CYAN}📋 SSH Configuration:${NC}"
REMOVE_SSH=false
if ask_yes_no "Remove SSH keys and configuration? (~/.ssh/)"; then
    REMOVE_SSH=true
fi

# Development Packages
echo -e "\n${CYAN}📦 Development Packages:${NC}"
REMOVE_DEV_PACKAGES=false
if ask_yes_no "Remove development packages? (git, curl, wget, build-essential, etc.)"; then
    REMOVE_DEV_PACKAGES=true
fi

# Node.js Environment
echo -e "\n${CYAN}🟢 Node.js Environment:${NC}"
REMOVE_NODE=false
if ask_yes_no "Remove Node.js, NVM, and npm packages?"; then
    REMOVE_NODE=true
fi

# Python Environment
echo -e "\n${CYAN}🐍 Python Environment:${NC}"
REMOVE_PYTHON_VENV=false
if ask_yes_no "Remove Python virtual environments? (~/.venvs/)"; then
    REMOVE_PYTHON_VENV=true
fi

REMOVE_PYTHON_PACKAGES=false
if ask_yes_no "Remove Python development packages? (python3-pip, python3-venv, etc.)"; then
    REMOVE_PYTHON_PACKAGES=true
fi

# Shell Configuration
echo -e "\n${CYAN}🐚 Shell Configuration:${NC}"
REMOVE_ZSH=false
if ask_yes_no "Remove Zsh, Oh My Zsh, and shell configurations?"; then
    REMOVE_ZSH=true
fi

RESET_SHELL=false
if [ "$REMOVE_ZSH" = true ] && ask_yes_no "Reset default shell to bash?"; then
    RESET_SHELL=true
fi

# Editor Configuration
echo -e "\n${CYAN}📝 Editor Configuration:${NC}"
REMOVE_NVIM_CONFIG=false
if ask_yes_no "Remove Neovim configuration? (~/.config/nvim/)"; then
    REMOVE_NVIM_CONFIG=true
fi

REMOVE_TMUX_CONFIG=false
if ask_yes_no "Remove Tmux configuration? (~/.tmux/)"; then
    REMOVE_TMUX_CONFIG=true
fi

# Additional Tools
echo -e "\n${CYAN}🛠️  Additional Tools:${NC}"
REMOVE_ADDITIONAL_TOOLS=false
if ask_yes_no "Remove additional tools? (lazygit, starship, fzf, tldr, etc.)"; then
    REMOVE_ADDITIONAL_TOOLS=true
fi

# Git Configuration
echo -e "\n${CYAN}📚 Git Configuration:${NC}"
REMOVE_GIT_CONFIG=false
if ask_yes_no "Remove global Git configuration?"; then
    REMOVE_GIT_CONFIG=true
fi

# Project Directory
echo -e "\n${CYAN}📁 Project Directory:${NC}"
REMOVE_PROJECTS=false
if ask_yes_no "Remove ~/projects directory and contents? (⚠️  This will delete your projects!)"; then
    REMOVE_PROJECTS=true
fi

# System cleanup
echo -e "\n${CYAN}🧹 System Cleanup:${NC}"
SYSTEM_CLEANUP=false
if ask_yes_no "Run system cleanup? (autoremove, autoclean)"; then
    SYSTEM_CLEANUP=true
fi

# Final confirmation
echo -e "\n${RED}⚠️  FINAL CONFIRMATION${NC}"
echo -e "${YELLOW}The following will be removed:${NC}"
[ "$REMOVE_SSH" = true ] && echo -e "  ❌ SSH keys and configuration"
[ "$REMOVE_DEV_PACKAGES" = true ] && echo -e "  ❌ Development packages"
[ "$REMOVE_NODE" = true ] && echo -e "  ❌ Node.js environment"
[ "$REMOVE_PYTHON_VENV" = true ] && echo -e "  ❌ Python virtual environments"
[ "$REMOVE_PYTHON_PACKAGES" = true ] && echo -e "  ❌ Python development packages"
[ "$REMOVE_ZSH" = true ] && echo -e "  ❌ Zsh and shell configurations"
[ "$REMOVE_NVIM_CONFIG" = true ] && echo -e "  ❌ Neovim configuration"
[ "$REMOVE_TMUX_CONFIG" = true ] && echo -e "  ❌ Tmux configuration"
[ "$REMOVE_ADDITIONAL_TOOLS" = true ] && echo -e "  ❌ Additional development tools"
[ "$REMOVE_GIT_CONFIG" = true ] && echo -e "  ❌ Git global configuration"
[ "$REMOVE_PROJECTS" = true ] && echo -e "  ❌ Projects directory"
[ "$RESET_SHELL" = true ] && echo -e "  ❌ Shell reset to bash"

if ! ask_yes_no "Proceed with uninstallation?"; then
    echo -e "${GREEN}✅ Uninstallation cancelled.${NC}"
    exit 0
fi

# Ask for sudo password once
echo -e "\n${YELLOW}🔑 Please enter your sudo password when prompted...${NC}"
sudo -v

# ==============================================
# START UNINSTALLATION
# ==============================================

section "Starting Uninstallation"

# ==============================================
# SSH CONFIGURATION REMOVAL
# ==============================================

if [ "$REMOVE_SSH" = true ]; then
    section "Removing SSH Configuration"
    if [ -d ~/.ssh ]; then
        echo -e "${YELLOW}Backing up SSH directory to ~/.ssh_backup...${NC}"
        cp -r ~/.ssh ~/.ssh_backup
        echo -e "${YELLOW}Removing SSH directory...${NC}"
        rm -rf ~/.ssh
        echo -e "${GREEN}✅ SSH configuration removed (backup saved to ~/.ssh_backup)${NC}"
    else
        echo -e "${YELLOW}SSH directory not found, skipping...${NC}"
    fi
fi

# ==============================================
# NODE.JS ENVIRONMENT REMOVAL
# ==============================================

if [ "$REMOVE_NODE" = true ]; then
    section "Removing Node.js Environment"
    
    # Remove NVM and Node.js
    if [ -d ~/.nvm ]; then
        echo -e "${YELLOW}Removing NVM and Node.js...${NC}"
        rm -rf ~/.nvm
        echo -e "${GREEN}✅ NVM removed${NC}"
    fi
    
    # Remove global npm packages cache
    if [ -d ~/.npm ]; then
        echo -e "${YELLOW}Removing npm cache...${NC}"
        rm -rf ~/.npm
    fi
    
    # Remove yarn cache
    if [ -d ~/.yarn ]; then
        echo -e "${YELLOW}Removing yarn cache...${NC}"
        rm -rf ~/.yarn
    fi
    
    # Remove pnpm cache
    if [ -d ~/.pnpm-store ]; then
        echo -e "${YELLOW}Removing pnpm cache...${NC}"
        rm -rf ~/.pnpm-store
    fi
    
    echo -e "${GREEN}✅ Node.js environment removed${NC}"
fi

# ==============================================
# PYTHON ENVIRONMENT REMOVAL
# ==============================================

if [ "$REMOVE_PYTHON_VENV" = true ]; then
    section "Removing Python Virtual Environments"
    if [ -d ~/.venvs ]; then
        echo -e "${YELLOW}Removing Python virtual environments...${NC}"
        rm -rf ~/.venvs
        echo -e "${GREEN}✅ Python virtual environments removed${NC}"
    fi
fi

if [ "$REMOVE_PYTHON_PACKAGES" = true ]; then
    section "Removing Python Development Packages"
    remove_package python3-pip
    remove_package python3-venv
    remove_package python3-full
    # Remove pip cache
    if [ -d ~/.cache/pip ]; then
        rm -rf ~/.cache/pip
    fi
fi

# ==============================================
# SHELL CONFIGURATION REMOVAL
# ==============================================

if [ "$REMOVE_ZSH" = true ]; then
    section "Removing Shell Configuration"
    
    # Remove Oh My Zsh
    if [ -d ~/.oh-my-zsh ]; then
        echo -e "${YELLOW}Removing Oh My Zsh...${NC}"
        rm -rf ~/.oh-my-zsh
    fi
    
    # Remove Zsh configuration files
    [ -f ~/.zshrc ] && rm ~/.zshrc
    [ -f ~/.zsh_history ] && rm ~/.zsh_history
    [ -d ~/.cache/zsh ] && rm -rf ~/.cache/zsh
    
    # Remove Zsh package
    remove_package zsh
    
    echo -e "${GREEN}✅ Zsh configuration removed${NC}"
fi

if [ "$RESET_SHELL" = true ]; then
    section "Resetting Shell to Bash"
    sudo chsh -s "$(which bash)" "$USER"
    echo -e "${GREEN}✅ Default shell reset to bash${NC}"
fi

# ==============================================
# EDITOR CONFIGURATION REMOVAL
# ==============================================

if [ "$REMOVE_NVIM_CONFIG" = true ]; then
    section "Removing Neovim Configuration"
    if [ -d ~/.config/nvim ]; then
        echo -e "${YELLOW}Backing up Neovim config to ~/.config/nvim_backup...${NC}"
        cp -r ~/.config/nvim ~/.config/nvim_backup
        echo -e "${YELLOW}Removing Neovim configuration...${NC}"
        rm -rf ~/.config/nvim
        echo -e "${GREEN}✅ Neovim configuration removed (backup saved)${NC}"
    fi
    
    # Remove Neovim cache
    [ -d ~/.cache/nvim ] && rm -rf ~/.cache/nvim
    [ -d ~/.local/share/nvim ] && rm -rf ~/.local/share/nvim
    [ -d ~/.local/state/nvim ] && rm -rf ~/.local/state/nvim
fi

if [ "$REMOVE_TMUX_CONFIG" = true ]; then
    section "Removing Tmux Configuration"
    if [ -d ~/.tmux ]; then
        echo -e "${YELLOW}Backing up Tmux config to ~/.tmux_backup...${NC}"
        cp -r ~/.tmux ~/.tmux_backup
        echo -e "${YELLOW}Removing Tmux configuration...${NC}"
        rm -rf ~/.tmux
        [ -f ~/.tmux.conf ] && rm ~/.tmux.conf
        echo -e "${GREEN}✅ Tmux configuration removed (backup saved)${NC}"
    fi
fi

# ==============================================
# ADDITIONAL TOOLS REMOVAL
# ==============================================

if [ "$REMOVE_ADDITIONAL_TOOLS" = true ]; then
    section "Removing Additional Tools"
    
    # Remove Starship
    if command -v starship >/dev/null 2>&1; then
        echo -e "${YELLOW}Removing Starship...${NC}"
        sudo rm -f /usr/local/bin/starship
        [ -f ~/.config/starship.toml ] && rm ~/.config/starship.toml
    fi
    
    # Remove lazygit
    if command -v lazygit >/dev/null 2>&1; then
        echo -e "${YELLOW}Removing lazygit...${NC}"
        sudo rm -f /usr/local/bin/lazygit
    fi
    
    # Remove fzf
    if [ -d ~/.fzf ]; then
        echo -e "${YELLOW}Removing fzf...${NC}"
        ~/.fzf/uninstall --all >/dev/null 2>&1 || true
        rm -rf ~/.fzf
    fi
    
    # Remove tldr
    remove_package tldr
    
    # Remove GitHub CLI
    remove_package gh
    
    echo -e "${GREEN}✅ Additional tools removed${NC}"
fi

# ==============================================
# DEVELOPMENT PACKAGES REMOVAL
# ==============================================

if [ "$REMOVE_DEV_PACKAGES" = true ]; then
    section "Removing Development Packages"
    
    # Core development packages
    remove_package build-essential
    remove_package cmake
    remove_package pkg-config
    remove_package libssl-dev
    remove_package libffi-dev
    remove_package zlib1g-dev
    remove_package liblzma-dev
    remove_package libreadline-dev
    remove_package libbz2-dev
    remove_package libsqlite3-dev
    remove_package libncurses-dev
    remove_package xz-utils
    remove_package tk-dev
    remove_package libxml2-dev
    remove_package libxmlsec1-dev
    remove_package llvm
    
    # Tools
    remove_package curl
    remove_package wget
    remove_package jq
    remove_package htop
    remove_package unzip
    remove_package zip
    remove_package tar
    remove_package gzip
    remove_package bzip2
    remove_package ripgrep
    remove_package fd-find
    remove_package neovim
    remove_package tmux
    remove_package luarocks
    remove_package openssh-client
    remove_package xclip
    remove_package xsel
    remove_package wl-clipboard
    remove_package eza
    remove_package bat
    
    # Remove PPAs
    sudo add-apt-repository --remove -y ppa:neovim-ppa/unstable 2>/dev/null || true
    
    echo -e "${GREEN}✅ Development packages removed${NC}"
fi

# ==============================================
# GIT CONFIGURATION REMOVAL
# ==============================================

if [ "$REMOVE_GIT_CONFIG" = true ]; then
    section "Removing Git Configuration"
    if [ -f ~/.gitconfig ]; then
        echo -e "${YELLOW}Backing up Git config to ~/.gitconfig_backup...${NC}"
        cp ~/.gitconfig ~/.gitconfig_backup
        echo -e "${YELLOW}Removing Git global configuration...${NC}"
        rm ~/.gitconfig
        echo -e "${GREEN}✅ Git configuration removed (backup saved)${NC}"
    fi
fi

# ==============================================
# PROJECT DIRECTORY REMOVAL
# ==============================================

if [ "$REMOVE_PROJECTS" = true ]; then
    section "Removing Projects Directory"
    if [ -d ~/projects ]; then
        echo -e "${RED}⚠️  This will permanently delete all your projects!${NC}"
        if ask_yes_no "Are you absolutely sure you want to delete ~/projects?"; then
            echo -e "${YELLOW}Removing projects directory...${NC}"
            rm -rf ~/projects
            echo -e "${GREEN}✅ Projects directory removed${NC}"
        else
            echo -e "${YELLOW}Skipping projects directory removal${NC}"
        fi
    fi
fi

# ==============================================
# CLEANUP REMAINING DIRECTORIES
# ==============================================

section "Cleaning Up Remaining Directories"

# Remove created directories if empty
echo -e "${YELLOW}Cleaning up empty directories...${NC}"
rmdir ~/tools 2>/dev/null || true
rmdir ~/scripts 2>/dev/null || true
rmdir ~/.cache 2>/dev/null || true
rmdir ~/.local/bin 2>/dev/null || true
rmdir ~/.local/share 2>/dev/null || true
rmdir ~/.local/lib 2>/dev/null || true
rmdir ~/.local 2>/dev/null || true

# Remove welcome message
[ -f ~/welcome.txt ] && rm ~/welcome.txt

# ==============================================
# SYSTEM CLEANUP
# ==============================================

if [ "$SYSTEM_CLEANUP" = true ]; then
    section "System Cleanup"
    echo -e "${YELLOW}Running system cleanup...${NC}"
    sudo apt autoremove -y
    sudo apt autoclean
    sudo apt update
    echo -e "${GREEN}✅ System cleanup completed${NC}"
fi

# ==============================================
# COMPLETION
# ==============================================

section "Uninstallation Complete"

echo -e "${GREEN}✅ Development environment uninstallation completed!${NC}"
echo -e "\n${YELLOW}Summary:${NC}"
[ "$REMOVE_SSH" = true ] && echo -e "  ✅ SSH configuration removed (backup: ~/.ssh_backup)"
[ "$REMOVE_DEV_PACKAGES" = true ] && echo -e "  ✅ Development packages removed"
[ "$REMOVE_NODE" = true ] && echo -e "  ✅ Node.js environment removed"
[ "$REMOVE_PYTHON_VENV" = true ] && echo -e "  ✅ Python virtual environments removed"
[ "$REMOVE_PYTHON_PACKAGES" = true ] && echo -e "  ✅ Python development packages removed"
[ "$REMOVE_ZSH" = true ] && echo -e "  ✅ Zsh and shell configurations removed"
[ "$REMOVE_NVIM_CONFIG" = true ] && echo -e "  ✅ Neovim configuration removed (backup: ~/.config/nvim_backup)"
[ "$REMOVE_TMUX_CONFIG" = true ] && echo -e "  ✅ Tmux configuration removed (backup: ~/.tmux_backup)"
[ "$REMOVE_ADDITIONAL_TOOLS" = true ] && echo -e "  ✅ Additional tools removed"
[ "$REMOVE_GIT_CONFIG" = true ] && echo -e "  ✅ Git configuration removed (backup: ~/.gitconfig_backup)"
[ "$REMOVE_PROJECTS" = true ] && echo -e "  ✅ Projects directory removed"
[ "$RESET_SHELL" = true ] && echo -e "  ✅ Shell reset to bash"

echo -e "\n${BLUE}Note: You may need to restart your terminal for all changes to take effect.${NC}"
echo -e "${GREEN}Environment successfully cleaned! 🧹${NC}"

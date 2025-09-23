#!/bin/bash

# System Setup Module

# Source core functions
source "scripts/core/functions.sh"

setup_system() {
    section "System Configuration"

    # Create directories
    echo -e "${YELLOW}Creating directory structure...${NC}"
    mkdir -p ~/{projects,tools,scripts,.config}
    mkdir -p ~/.local/{bin,share,lib}
    mkdir -p ~/.cache/{zsh,nvim}

    # Update system
    section "Updating System"
    if can_run_sudo; then
        sudo add-apt-repository -y ppa:neovim-ppa/unstable
        sudo apt update && sudo apt upgrade -y
        sudo apt autoremove -y
    else
        echo -e "${RED}[ERROR]${NC} Cannot update system: sudo requires password"
        echo -e "${YELLOW}Please run this script in an interactive terminal where you can enter your password${NC}"
        exit 1
    fi

    # Install essential packages
    section "Installing Base Packages"
    packages=(
        software-properties-common apt-transport-https ca-certificates 
        build-essential cmake pkg-config libssl-dev libffi-dev 
        zlib1g-dev liblzma-dev libreadline-dev libbz2-dev 
        libsqlite3-dev libncurses-dev 
        xz-utils tk-dev libxml2-dev libxmlsec1-dev llvm 
        git curl wget jq htop unzip zip tar gzip bzip2 
        ripgrep fd-find neovim tmux luarocks python3-pip 
        openssh-client xclip xsel wl-clipboard
    )

    for pkg in "${packages[@]}"; do
        install_package "$pkg"
    done
}
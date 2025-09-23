#!/bin/bash

# Extra Tools Setup Module

# Source core functions
source "scripts/core/functions.sh"

setup_extras() {
    section "Additional Development Tools"

    # Install fzf
    if [ ! -d ~/.fzf ]; then
        echo -e "${YELLOW}Installing fzf...${NC}"
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all --no-update-rc
    fi

    # Install lazygit
    if ! command_exists lazygit; then
        echo -e "${YELLOW}Installing lazygit...${NC}"
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        if can_run_sudo; then
            sudo install lazygit /usr/local/bin
        else
            echo -e "${RED}[ERROR]${NC} Cannot install lazygit: sudo requires password"
            echo -e "${YELLOW}Please run this script in an interactive terminal where you can enter your password${NC}"
            exit 1
        fi
        rm lazygit.tar.gz lazygit
    fi

    # Install tldr
    if ! command_exists tldr; then
        echo -e "${YELLOW}Installing tldr...${NC}"
        if can_run_sudo; then
            sudo apt install -y tldr
            tldr --update
        else
            echo -e "${RED}[ERROR]${NC} Cannot install tldr: sudo requires password"
            echo -e "${YELLOW}Please run this script in an interactive terminal where you can enter your password${NC}"
            exit 1
        fi
    fi
}
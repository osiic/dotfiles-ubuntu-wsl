#!/bin/bash

# Extra Tools Setup Module

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
        sudo install lazygit /usr/local/bin
        rm lazygit.tar.gz lazygit
    fi

    # Install tldr
    if ! command_exists tldr; then
        echo -e "${YELLOW}Installing tldr...${NC}"
        sudo apt install -y tldr
        tldr --update
    fi
}
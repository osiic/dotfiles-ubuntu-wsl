#!/bin/bash

# Development Tools Setup Module

setup_devtools() {
    section "Development Tools Setup"

    # Git configuration
    echo -e "${YELLOW}Configuring Git...${NC}"
    git config --global user.name "$USER_NAME"
    git config --global user.email "$USER_EMAIL"
    git config --global core.editor "nvim"
    git config --global init.defaultBranch "main"
    git config --global pull.rebase true
    git config --global alias.co checkout
    git config --global alias.br branch
    git config --global alias.ci commit
    git config --global alias.st status
    git config --global alias.unstage 'reset HEAD --'
    git config --global alias.last 'log -1 HEAD'
    git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

    # Node.js via NVM
    section "Node.js Environment"
    if [ ! -d "$HOME/.nvm" ]; then
        echo -e "${YELLOW}Installing NVM...${NC}"
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        
        echo -e "${YELLOW}Installing Node.js LTS...${NC}"
        nvm install --lts
        nvm alias default 'lts/*'
        npm install -g npm yarn pnpm bun
        npm install -g typescript ts-node nodemon eslint prettier
    else
        echo -e "${YELLOW}Node.js already installed${NC}"
    fi

    # ==================================
    # PYTHON ENVIRONMENT
    # ==================================

    section "PYTHON ENVIRONMENT"

    # Pastikan python3 ada
    if ! command -v python3 &>/dev/null; then
        sudo apt update
        sudo apt install -y python3 python3-pip python3-venv python3-full
    fi

    # Deteksi versi Python (misalnya 3.12)
    PY_VER=$(python3 -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')")

    # Install paket venv untuk versi Python yang sesuai
    sudo apt install -y "python${PY_VER}-venv"

    # Buat virtual environment default
    rm -rf ~/.venvs/default
    python3 -m venv ~/.venvs/default
    source ~/.venvs/default/bin/activate

    # Upgrade pip & install tools
    pip install --upgrade pip setuptools wheel
    pip install virtualenv pipx
    pipx ensurepath
}
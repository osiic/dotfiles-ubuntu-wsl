#!/bin/bash
set -e

# ==============================================
# WSL UBUNTU DEVELOPMENT ENVIRONMENT SETUP SCRIPT
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

# Function to install package if not exists
install_package() {
    if ! dpkg -l | grep -q "$1"; then
        echo -e "${YELLOW}[INSTALL]${NC} $1..."
        sudo apt install -y "$1"
    else
        echo -e "${YELLOW}[SKIP]${NC} $1 already installed"
    fi
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

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

# Get user info
section "User Configuration"
read -p "Enter your full name: " USER_NAME
read -p "Enter your email address: " USER_EMAIL
read -p "Enter your GitHub username: " GITHUB_USER

# Verify information
echo -e "\n${YELLOW}Please verify your information:${NC}"
echo -e "Name    : ${GREEN}$USER_NAME${NC}"
echo -e "Email   : ${GREEN}$USER_EMAIL${NC}"
echo -e "GitHub  : ${GREEN}$GITHUB_USER${NC}"
read -p "Is this correct? (y/n): " confirm
if [[ "$confirm" != "y" ]]; then
    echo -e "${RED}❌ Setup aborted. Please run the script again.${NC}"
    exit 1
fi

# ==============================================
# SYSTEM SETUP
# ==============================================

section "System Configuration"

# Create directories
echo -e "${YELLOW}Creating directory structure...${NC}"
mkdir -p ~/{projects,tools,scripts,.config}
mkdir -p ~/.local/{bin,share,lib}
mkdir -p ~/.cache/{zsh,nvim}

# Update system
section "Updating System"
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y

# Install essential packages
section "Installing Base Packages"
sudo apt install -y --no-install-recommends \
    software-properties-common apt-transport-https ca-certificates \
    build-essential cmake pkg-config libssl-dev libffi-dev \
    zlib1g-dev liblzma-dev libreadline-dev libbz2-dev \
    libsqlite3-dev libncurses-dev \
    xz-utils tk-dev libxml2-dev libxmlsec1-dev llvm \
    git curl wget jq htop unzip zip tar gzip bzip2 \
    ripgrep fd-find bat neovim python3-pip \
    openssh-client

# ==============================================
# DEVELOPMENT TOOLS
# ==============================================

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

# Install GitHub CLI
if ! command_exists gh; then
    echo -e "${YELLOW}Installing GitHub CLI...${NC}"
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install -y gh
fi

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

# Python setup
# Python setup
section "Python Environment"
if ! command_exists python3; then
    sudo apt install -y python3 python3-pip python3-venv python3-full
fi

# Upgrade pip dalam venv
python3 -m venv ~/.venvs/default
source ~/.venvs/default/bin/activate

pip install --upgrade pip setuptools wheel
pip install virtualenv pipx
pipx ensurepath

# ==============================================
# SHELL ENVIRONMENT
# ==============================================

section "Shell Configuration"

# Install Zsh and Oh My Zsh
if ! command_exists zsh; then
    echo -e "${YELLOW}Installing Zsh...${NC}"
    sudo apt install -y zsh
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${YELLOW}Installing Oh My Zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    chsh -s $(which zsh)
fi

# Install Starship prompt
if ! command_exists starship; then
    echo -e "${YELLOW}Installing Starship...${NC}"
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# Zsh plugins
echo -e "${YELLOW}Setting up Zsh plugins...${NC}"
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
git clone https://github.com/agkozak/zsh-z ${ZSH_CUSTOM}/plugins/zsh-z

# Zsh configuration
echo -e "${YELLOW}Configuring Zsh...${NC}"
cat > ~/.zshrc << 'EOL'
# ===== Oh My Zsh Configuration =====
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(
    git
    docker
    npm
    yarn
    node
    nvm
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-z
)

source $ZSH/oh-my-zsh.sh

# ===== Environment Variables =====
export PATH="$HOME/.local/bin:$PATH"
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export TERM="xterm-256color"
export BAT_THEME="Dracula"

# ===== Aliases =====
alias ls="exa --group-directories-first"
alias ll="exa -alF --group-directories-first --git"
alias lt="exa -T --group-directories-first --git-ignore"
alias cat="bat"
alias grep="rg"
alias find="fd"
alias v="nvim"
alias g="git"
alias d="docker"
alias dc="docker-compose"
alias sz="source ~/.zshrc"

# ===== Tool Initializations =====
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

eval "$(starship init zsh)"
EOL

# Starship configuration
cat > ~/.config/starship.toml << 'EOL'
format = """
$username\
$hostname\
$directory\
$git_branch\
$git_status\
$cmd_duration\
$line_break\
$character"""

[character]
success_symbol = "[➜](bold green)"
error_symbol = "[➜](bold red)"

[directory]
truncation_length = 3
truncation_symbol = "…/"
style = "bold blue"

[git_branch]
symbol = "🌱 "
style = "bold purple"

[git_status]
style = "bold green"
EOL

# ==============================================
# DEVELOPMENT TOOLS
# ==============================================

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

# ==============================================
# SSH CONFIGURATION
# ==============================================

section "SSH Setup"

if [ ! -f ~/.ssh/id_ed25519 ]; then
    echo -e "${YELLOW}Generating SSH key...${NC}"
    ssh-keygen -t ed25519 -C "$USER_EMAIL" -f ~/.ssh/id_ed25519 -N ""
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    
    echo -e "\n${GREEN}🔑 Public SSH Key:${NC}"
    cat ~/.ssh/id_ed25519.pub
    echo -e "\n${YELLOW}Please add this key to your GitHub account:${NC}"
    echo -e "https://github.com/settings/keys\n"
    read -p "Press Enter to continue after adding the key..."
else
    echo -e "${YELLOW}SSH key already exists${NC}"
fi

# ==============================================
# FINAL SETUP
# ==============================================

section "Final Configuration"

# Create welcome message
cat > ~/.config/welcome.txt << EOL
╔════════════════════════════════════════════╗
║   🎉 WSL Development Environment Ready!    ║
╚════════════════════════════════════════════╝

Your environment has been configured with:

• Git: $(git --version | cut -d' ' -f3)
• Node.js: $(node --version)
• npm: $(npm --version)
• Python: $(python3 --version | cut -d' ' -f2)
• Neovim: $(nvim --version | head -n1 | cut -d' ' -f2)

Quick Start:
- Projects: ~/projects
- Edit files: v filename
- Git status: g st
- Docker containers: d ps

Run 'tldr <command>' for simplified help
EOL

# ==============================================
# COMPLETION
# ==============================================

section "Setup Complete"

echo -e "${GREEN}✅ Development environment setup successfully!${NC}"
echo -e "\n${YELLOW}Next steps:${NC}"
echo -e "1. Restart your shell: ${GREEN}exec zsh${NC}"
echo -e "2. View welcome message: ${GREEN}cat ~/.config/welcome.txt${NC}"
echo -e "3. Start developing in ~/projects directory"
echo -e "\n${BLUE}Happy coding! 🎉${NC}"

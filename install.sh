#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}🚀 Starting WSL Ubuntu 24.04 setup for Node.js development...${NC}"

# Create dotfiles directory
DOTFILES_DIR="$HOME/.config/dotfiles"
mkdir -p "$DOTFILES_DIR"
# Create dotfiles directory
PROJECTS_DIR="$HOME/projects"
mkdir -p "$PROJECTS_DIR"

# Function to print section headers
section() {
    echo -e "\n${GREEN}=== $1 ===${NC}"
}

# Update and install basic packages
section "Updating system and installing basic packages"
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git tmux luarocks python3-pip ripgrep fd-find neovim unzip build-essential openssh-client wget zsh

# Install Git and configure
section "Configuring Git"
cat > "$DOTFILES_DIR/.gitconfig" << 'EOL'
[user]
    email = osiic.offcl@gmail.com
    name = Osi ic
[alias]
    type = cat-file -t
    dump = cat-file -p
[core]
    editor = nvim
    excludesfile = ~/.gitignore_global
[push]
    default = current
[pull]
    rebase = true
EOL
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"

# Install NVM and Node.js LTS
section "Installing NVM and Node.js"
export NVM_DIR="$HOME/.nvm"
if [ ! -d "$NVM_DIR" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts
    nvm alias default 'lts/*'
else
    echo -e "${YELLOW}NVM already installed. Skipping...${NC}"
fi

# Generate SSH key
section "Generating SSH key"
mkdir -p "$HOME/.ssh"
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  ssh-keygen -t ed25519 -C "osiic.offcl@gmail.com" -f "$HOME/.ssh/id_ed25519" -N ""
  eval "$(ssh-agent -s)"
  ssh-add "$HOME/.ssh/id_ed25519"
  echo -e "${GREEN}🔑 Public SSH key (add this to GitHub):${NC}"
  cat "$HOME/.ssh/id_ed25519.pub"
  echo -e "${YELLOW}📤 Silakan upload kunci ini ke GitHub (Settings > SSH and GPG keys)...${NC}"
  read -p "Tekan [Enter] setelah kamu selesai upload ke GitHub..."
else
  echo -e "${YELLOW}✅ SSH key sudah ada. Melewati proses generate...${NC}"
fi

# Install Starship prompt
section "Installing Starship prompt"
if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
else
    echo -e "${YELLOW}Starship already installed. Skipping...${NC}"
fi

# Install Zsh and Oh My Zsh
section "Installing Zsh and Oh My Zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    chsh -s $(which zsh)
else
    echo -e "${YELLOW}Oh My Zsh already installed. Skipping...${NC}"
fi

# Clone configuration repos
section "Cloning configuration repositories"
mkdir -p "$HOME/.config"

# Neovim config
if [ ! -d "$HOME/.config/nvim" ]; then
    git clone git@github.com:osiic/nvim.git "$HOME/.config/nvim"
else
    echo -e "${YELLOW}Neovim config already exists. Skipping...${NC}"
fi

# Tmux config
if [ ! -d "$HOME/.tmux" ]; then
    git clone git@github.com:osiic/tmux.git "$HOME/.tmux"
    ln -sf "$HOME/.tmux/.tmux.conf" "$HOME/.tmux.conf"
else
    echo -e "${YELLOW}Tmux config already exists. Skipping...${NC}"
fi

# Configure Zsh
section "Configuring Zsh"
cat > "$DOTFILES_DIR/.zshrc" << 'EOL'
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# === BASIC NAVIGATION ===
alias ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias dev='cd ~/projects'
alias proj='cd ~/projects'
alias c='clear'
alias e='exit'

# === FILE LISTING ===
alias ll='ls -alF'
alias la='ls -A'
alias lt='ls -ltr'
alias tree='tree -C -L 2'  # pastikan `tree` terinstall

# === GIT COMMANDS ===
alias gs='git branch && git status'
alias gb='git branch'
alias gbd='git branch -D'
alias gc='git checkout'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gac='git add . && git commit -m'
alias gca='git commit -am'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gf='git fetch'
alias gss='git status -s'
alias glg='git log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias gcp='git cherry-pick'
alias gsu='git submodule update --init --recursive'
alias gr='git restore .'
alias grs='git reset --soft HEAD~1'
alias gm='git merge'

# === TOOLS ===
alias h='history'
alias v='nvim'         # Ganti dengan `vim` jika tidak pakai neovim
alias serve='python3 -m http.server 8000'
alias s='source ~/.bashrc'  # Ganti dengan ~/.zshrc jika pakai ZSH

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Starship
eval "$(starship init zsh)"

# === CUSTOM STARTUP MESSAGE (Optional) ===
echo "✅ Shell Loaded — Happy Coding, $USER!"
EOL
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# Install Zsh plugins
section "Installing Zsh plugins"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Create basic Starship config
section "Configuring Starship"
git clone https://github.com/osiic/starship.git

mkdir -p ~/.config
cp ./startship/starship.toml ~/.config/starship.toml

# 4. Add starship to your shell config
echo 'eval "$(starship init bash)"' >> ~/.bashrc
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
echo 'eval "$(starship init bash)"' >> ~/.profile

# 5. Apply changes
source ~/.bashrc
source ~/.zshrc
source ~/.profile

# Final steps
section "Finishing setup"
echo -e "${GREEN}✅ Setup complete!${NC}"
echo -e "\nNext steps:"
echo -e "1. Add your SSH key to GitHub: https://github.com/settings/keys"
echo -e "2. Restart your shell: ${YELLOW}exec zsh${NC}"
echo -e "3. Start coding! 🎉"

#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}🚀 Starting WSL Ubuntu 24.04 setup for Node.js development...${NC}"

# Create dotfiles directory
DOTFILES_DIR="$HOME/dotfiles"
mkdir -p "$DOTFILES_DIR"

# Function to print section headers
section() {
    echo -e "\n${GREEN}=== $1 ===${NC}"
}

# Update and install basic packages
section "Updating system and installing basic packages"
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git tmux neovim unzip build-essential openssh-client wget zsh

# Install Git and configure
section "Configuring Git"
cat > "$DOTFILES_DIR/.gitconfig" << 'EOL'
[user]
    email = osiic.offcl@gmail.com
    name = Osi ic
[alias]
    co = checkout
    ci = commit
    st = status
    br = branch
    hist = log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short
    type = cat-file -t
    dump = cat-file -p
    lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
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

# Aliases
alias ll='ls -alF'
alias ..='cd ..'
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias dev='cd ~/projects'

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Starship
eval "$(starship init zsh)"
EOL
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# Install Zsh plugins
section "Installing Zsh plugins"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# Create basic Starship config
section "Configuring Starship"
mkdir -p "$HOME/.config"
cat > "$HOME/.config/starship.toml" << 'EOL'
format = """
[░▒▓](#a3aed2)\
[  ](bg:#a3aed2 fg:#090c0c)\
[](bg:#769ff0 fg:#a3aed2)\
$directory\
[](fg:#769ff0 bg:#394260)\
$git_branch\
$git_status\
[](fg:#394260 bg:#212736)\
$nodejs\
$rust\
$golang\
$php\
[](fg:#212736 bg:#1d2230)\
$time\
[ ](fg:#1d2230)\
\n$character"""

[directory]
style = "fg:#e3e5e5 bg:#769ff0"
format = "[ $path ]($style)"
truncation_length = 3
truncation_symbol = "…/"

[directory.substitutions]
"Documents" = " "
"Downloads" = " "
"Music" = " "
"Pictures" = " "

[git_branch]
symbol = ""
style = "bg:#394260"
format = '[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)'

[git_status]
style = "bg:#394260"
format = '[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)]($style)'

[nodejs]
symbol = ""
style = "bg:#212736"
format = '[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)'

[rust]
symbol = ""
style = "bg:#212736"
format = '[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)'

[golang]
symbol = "ﳑ"
style = "bg:#212736"
format = '[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)'

[php]
symbol = ""
style = "bg:#212736"
format = '[[ $symbol ($version) ](fg:#769ff0 bg:#212736)]($style)'

[time]
disabled = true
time_format = "%R" # Hour:Minute Format
style = "bg:#1d2230"
format = '[[  $time ](fg:#a0a9cb bg:#1d2230)]($style)'
EOL

# Final steps
section "Finishing setup"
echo -e "${GREEN}✅ Setup complete!${NC}"
echo -e "\nNext steps:"
echo -e "1. Add your SSH key to GitHub: https://github.com/settings/keys"
echo -e "2. Restart your shell: ${YELLOW}exec zsh${NC}"
echo -e "3. Start coding! 🎉"

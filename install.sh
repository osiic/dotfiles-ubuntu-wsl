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
mkdir -p "$HOME/.config"
cat > "$HOME/.config/starship.toml" << 'EOL'
# Get editor completions based on the config schema
"$schema" = 'https://starship.rs/config-schema.json'

# Sets user-defined palette
# Palettes must be defined _after_ this line
palette = "catppuccin_mocha"

# Starship modules
[character]
# Note the use of Catppuccin color 'peach'
success_symbol = "[[󰄛](green) ❯](peach)"
error_symbol = "[[󰄛](red) ❯](peach)"
vimcmd_symbol = "[󰄛 ❮](subtext1)" # For use with zsh-vi-mode

[git_branch]
style = "bold mauve"

[directory]
truncation_length = 4
style = "bold lavender"

# Palette definitions
[palettes.catppuccin_latte]
rosewater = "#dc8a78"
flamingo = "#dd7878"
pink = "#ea76cb"
mauve = "#8839ef"
red = "#d20f39"
maroon = "#e64553"
peach = "#fe640b"
yellow = "#df8e1d"
green = "#40a02b"
teal = "#179299"
sky = "#04a5e5"
sapphire = "#209fb5"
blue = "#1e66f5"
lavender = "#7287fd"
text = "#4c4f69"
subtext1 = "#5c5f77"
subtext0 = "#6c6f85"
overlay2 = "#7c7f93"
overlay1 = "#8c8fa1"
overlay0 = "#9ca0b0"
surface2 = "#acb0be"
surface1 = "#bcc0cc"
surface0 = "#ccd0da"
base = "#eff1f5"
mantle = "#e6e9ef"
crust = "#dce0e8"

[palettes.catppuccin_frappe]
rosewater = "#f2d5cf"
flamingo = "#eebebe"
pink = "#f4b8e4"
mauve = "#ca9ee6"
red = "#e78284"
maroon = "#ea999c"
peach = "#ef9f76"
yellow = "#e5c890"
green = "#a6d189"
teal = "#81c8be"
sky = "#99d1db"
sapphire = "#85c1dc"
blue = "#8caaee"
lavender = "#babbf1"
text = "#c6d0f5"
subtext1 = "#b5bfe2"
subtext0 = "#a5adce"
overlay2 = "#949cbb"
overlay1 = "#838ba7"
overlay0 = "#737994"
surface2 = "#626880"
surface1 = "#51576d"
surface0 = "#414559"
base = "#303446"
mantle = "#292c3c"
crust = "#232634"

[palettes.catppuccin_macchiato]
rosewater = "#f4dbd6"
flamingo = "#f0c6c6"
pink = "#f5bde6"
mauve = "#c6a0f6"
red = "#ed8796"
maroon = "#ee99a0"
peach = "#f5a97f"
yellow = "#eed49f"
green = "#a6da95"
teal = "#8bd5ca"
sky = "#91d7e3"
sapphire = "#7dc4e4"
blue = "#8aadf4"
lavender = "#b7bdf8"
text = "#cad3f5"
subtext1 = "#b8c0e0"
subtext0 = "#a5adcb"
overlay2 = "#939ab7"
overlay1 = "#8087a2"
overlay0 = "#6e738d"
surface2 = "#5b6078"
surface1 = "#494d64"
surface0 = "#363a4f"
base = "#24273a"
mantle = "#1e2030"
crust = "#181926"

[palettes.catppuccin_mocha]
rosewater = "#f5e0dc"
flamingo = "#f2cdcd"
pink = "#f5c2e7"
mauve = "#cba6f7"
red = "#f38ba8"
maroon = "#eba0ac"
peach = "#fab387"
yellow = "#f9e2af"
green = "#a6e3a1"
teal = "#94e2d5"
sky = "#89dceb"
sapphire = "#74c7ec"
blue = "#89b4fa"
lavender = "#b4befe"
text = "#cdd6f4"
subtext1 = "#bac2de"
subtext0 = "#a6adc8"
overlay2 = "#9399b2"
overlay1 = "#7f849c"
overlay0 = "#6c7086"
surface2 = "#585b70"
surface1 = "#45475a"
surface0 = "#313244"
base = "#1e1e2e"
mantle = "#181825"
crust = "#11111b"
EOL

# Final steps
section "Finishing setup"
echo -e "${GREEN}✅ Setup complete!${NC}"
echo -e "\nNext steps:"
echo -e "1. Add your SSH key to GitHub: https://github.com/settings/keys"
echo -e "2. Restart your shell: ${YELLOW}exec zsh${NC}"
echo -e "3. Start coding! 🎉"

#!/bin/bash

# Shell Environment Setup Module

# Source core functions
source "$(dirname "$0")/../core/functions.sh"

setup_shell() {
    section "Shell Configuration"

    # Install Zsh and Oh My Zsh
    if ! command_exists zsh; then
        echo -e "${YELLOW}Installing Zsh...${NC}"
        sudo apt install -y zsh
    fi

    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo -e "${YELLOW}Installing Oh My Zsh...${NC}"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        sudo chsh -s "$(which zsh)" "$USER"
    fi

    # Neovim config
    if [ ! -d "$HOME/.config/nvim" ]; then
        git clone https://github.com/osiic/nvim.git "$HOME/.config/nvim"
    else
        echo -e "${YELLOW}Neovim config already exists. Skipping...${NC}"
    fi

    # Tmux config
    if [ ! -d "$HOME/.tmux" ]; then
        git clone https://github.com/osiic/tmux.git "$HOME/.tmux"
        ln -sf "$HOME/.tmux/.tmux.conf" "$HOME/.tmux.conf"
    else
        echo -e "${YELLOW}Tmux config already exists. Skipping...${NC}"
    fi

    # Install Starship prompt
    if ! command_exists starship; then
        echo -e "${YELLOW}Installing Starship...${NC}"
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    fi

    echo -e "${YELLOW}Setting up Zsh plugins...${NC}"

    # Set ZSH custom plugins directory
    ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

    # Function to clone or update a plugin
    install_plugin() {
        local plugin_name=$1
        local plugin_url=$2
        local plugin_dir="${ZSH_CUSTOM}/plugins/${plugin_name}"
        
        if [ -d "$plugin_dir" ]; then
            echo -e "${YELLOW}Backing up existing $plugin_name...${NC}"
            mv "$plugin_dir" "$BACKUP_DIR/${plugin_name}"
            echo -e "${GREEN}Cloning fresh $plugin_name...${NC}"
            git clone "$plugin_url" "$plugin_dir"
        else
            echo -e "${GREEN}Installing $plugin_name...${NC}"
            git clone "$plugin_url" "$plugin_dir"
        fi
    }

    # Install plugins
    install_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions"
    install_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting"
    install_plugin "zsh-z" "https://github.com/agkozak/zsh-z"

    # Zsh configuration
    echo -e "${YELLOW}Configuring Zsh...${NC}"

    # Backup existing .zshrc if it exists
    if [ -f ~/.zshrc ]; then
        echo -e "${YELLOW}Backing up existing .zshrc...${NC}"
        cp ~/.zshrc "$BACKUP_DIR/.zshrc"
    fi

    # Create new .zshrc
    cat > ~/.zshrc << "EOL"
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

# ===== Function =====
dev() {
    if [ -z "$1" ]; then
        echo "Usage: dev <project_name>"
        ls -al ~/projects/
        return 1
    fi
    cd ~/projects/"$1" || return 1
    tmux .
}

_dev_complete() {
  compadd $(ls -1 ~/projects)
}
compdef _dev_complete dev

show_welcome() {
    # Get version information with fallbacks
    git_version=$(git --version 2>/dev/null | cut -d' ' -f3 || echo "Not installed")
    node_version=$(node --version 2>/dev/null || echo "Not installed")
    npm_version=$(npm --version 2>/dev/null || echo "Not installed")
    python_version=$(python3 --version 2>/dev/null | cut -d' ' -f2 || echo "Not installed")
    nvim_version=$(nvim --version 2>/dev/null | head -n1 | cut -d' ' -f2 || echo "Not installed")
    shell_type=$(echo $SHELL | rev | cut -d/ -f1 | rev)
    wsl_distro=$(grep -oP '(?<=NAME=").*(?=")' /etc/os-release 2>/dev/null || echo "Unknown")

    # Display welcome message
    cat << EOF
╔═══════════════════════════════════════════════════════════╗
║                🎉 WSL Development Environment Ready!      ║
╚═══════════════════════════════════════════════════════════╝

Your environment has been configured with:

┌───────────────────────────────────────────────────────────┐
│  • Git:        $git_version
│  • Node.js:    $node_version
│  • npm:        $npm_version
│  • Python:     $python_version
│  • Neovim:     $nvim_version
│  • Shell:      $shell_type
│  • WSL Distro: $wsl_distro
└───────────────────────────────────────────────────────────┘

📦 Project Management:
  - p:      Navigate to ~/projects directory

🛠️  Development Tools:
  - v/nvim: Open Neovim editor
  - dev <filename project>: Start development project

📝 Git Shortcuts:
  - gs:     Git status
  - gac:    Git add all changes and Git commit with message
  - gp:     Git push to current branch

📚 Help & Information:
  - welcome: Display this welcome message
  - tldr:    Simplified command help
  - cheatsheet: Show common commands for installed tools

💡 Pro Tip: Customize your environment by editing ~/.bashrc or ~/.zshrc

Run 'welcome' to see this message again at any time.
EOF
}

# Alias to the function
alias welcome=show_welcome

# Display welcome message on first login
if [ -z "$WELCOME_SHOWN" ]; then
    show_welcome
    export WELCOME_SHOWN=true
fi

# ===== Aliases =====
alias p="cd ~/projects"

# ===============================
# LS Aliases Optimal
# ===============================

# 1. List all files (termasuk hidden) dengan detail
alias la="ls -lah --color=auto"

# 2. Long list biasa (lebih readable, ukuran file manusiawi)
alias ll="ls -lh --color=auto"

# 3. List project/Git friendly:
# - Direktori selalu di atas
# - Sembunyikan file yang di-ignore Git
# - Detail + human readable size
# - Urut berdasarkan waktu modifikasi terbaru
alias lt="ls -lhT --group-directories-first --git-ignore --color=auto -t"

# 4. Quick list tanpa detail, hanya nama file
alias l="ls --color=auto"

# 5. List file tersembunyi saja
alias lh="ls -ld .* --color=auto"

# 6. List files terbaru dahulu
alias newest="ls -lt --color=auto"
alias grep="rg"
alias find="fd"
alias v="nvim"
alias g="git"
alias sz="source ~/.zshrc"

# === GIT COMMANDS ===
alias gs='git status -sb --ahead-behind'
alias gss='\
    echo -e "\n\033[1;34m== Branches ==\033[0m" && \
    git --no-pager branch --sort=-committerdate --color=always && \
    echo -e "\n\033[1;34m== Last Commits ==\033[0m" && \
    git --no-pager log --oneline -n 5 --decorate --color=always && \
    echo -e "\n\033[1;34m== Stash List ==\033[0m" && \
    git --no-pager stash list && \
    echo -e "\n\033[1;34m== Remote Info ==\033[0m" && \
    git remote -v && \
    echo -e "\n\033[1;34m== Status ==\033[0m" && \
    git status -sb --ahead-behind && \
    echo -e "\n\033[1;34m== Diff (unstaged) ==\033[0m" && \
    git --no-pager diff --stat'
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
alias glg='git log --color --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias gcp='git cherry-pick'
alias gsu='git submodule update --init --recursive'
alias gr='git restore .'
alias grs='git reset --soft HEAD~1'
alias gm='git merge'

# ===== Tool Initializations =====
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

eval "$(starship init zsh)"
EOL

    echo -e "${GREEN}New .zshrc created${NC}"

    # Starship configuration
    echo -e "${YELLOW}Configuring Starship...${NC}"

    # Create starship config directory if it doesn't exist
    mkdir -p ~/.config

    # Backup existing starship.toml if it exists
    if [ -f ~/.config/starship.toml ]; then
        echo -e "${YELLOW}Backing up existing starship.toml...${NC}"
        cp ~/.config/starship.toml "$BACKUP_DIR/starship.toml"
    fi

    # Create new starship.toml
    cat > ~/.config/starship.toml << 'EOL'
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

[username]
style_user = 'white bold'
style_root = 'black bold'
format = '[$user]($style) '
disabled = false
show_always = true
aliases = { "corpuser034g" = "matchai" }

[git_branch]
style = "bold mauve"

[directory]
truncation_length = 4
style = "bold lavender"

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

    echo -e "${GREEN}Starship configuration created${NC}"
}
#!/bin/bash

# Uninstall script functionality

# Source core functions
source "scripts/core/functions.sh"

echo -e "${RED}⚠️  WARNING: This will remove all installed components!${NC}"
read -p "Are you sure you want to uninstall? (type 'yes' to confirm): " confirm

if [[ $confirm != "yes" ]]; then
    echo -e "${YELLOW}Uninstall cancelled.${NC}"
    exit 0
fi

section "Uninstalling WSL Development Environment"

echo -e "${YELLOW}Removing installed packages...${NC}"
# Note: We won't actually remove system packages to avoid breaking other setups
echo -e "${YELLOW}Skipping system package removal to avoid breaking other setups${NC}"

echo -e "${YELLOW}Removing configuration files...${NC}"
rm -rf ~/.config/nvim
rm -rf ~/.tmux
rm -f ~/.tmux.conf
rm -rf ~/.oh-my-zsh
rm -f ~/.zshrc
rm -f ~/.config/starship.toml

echo -e "${YELLOW}Removing development tools...${NC}"
rm -rf ~/.nvm
rm -rf ~/.venvs/default
rm -rf ~/.fzf

echo -e "${YELLOW}Removing SSH keys...${NC}"
rm -f ~/.ssh/id_ed25519
rm -f ~/.ssh/id_ed25519.pub

echo -e "${YELLOW}Restoring shell to bash...${NC}"
if can_run_sudo; then
    sudo chsh -s "$(which bash)" "$USER"
else
    echo -e "${RED}[ERROR]${NC} Cannot change default shell: sudo requires password"
    echo -e "${YELLOW}Please run this script in an interactive terminal where you can enter your password${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Uninstall complete!${NC}"
echo -e "${YELLOW}Note: System packages (git, curl, etc.) were not removed${NC}"
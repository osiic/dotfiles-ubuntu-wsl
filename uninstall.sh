#!/bin/bash
set -e

echo -e "\033[1;31m🧹 Removing all configurations and packages...\033[0m"

# Remove config files
rm -rf ~/.config/nvim ~/.tmux  ~/.config/starship.toml
rm -f ~/.tmux.conf ~/.gitconfig ~/.zshrc
rm -rf ~/.oh-my-zsh ~/.nvm ~/.ssh/id_ed25519*

# Remove dotfiles directory
rm -rf ~/dotfiles

# Remove packages
sudo apt remove --purge tmux neovim zsh git build-essential unzip wget curl -y
sudo apt autoremove -y

echo -e "\033[1;32m🗑️ Environment cleaned.\033[0m"

#!/bin/bash
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}🚀 start install neovim on ubuntu${NC}"

# Setup folders
CONFIG_DIR="$HOME/.config"
PROJECT_DIR="$HOME/.config/nvim"
mkdir -p "$CONFIG_DIR" "$PROJECT_DIR"

# Section header
section() {
    echo -e "\n${GREEN}=== $1 ===${NC}"
}

# Update & install basic packages
section "Updating system and installing basic packages"
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt update && sudo apt upgrade -y
sudo apt install -y curl git luarocks python3-pip neovim 

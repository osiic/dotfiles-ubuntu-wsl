#!/bin/bash
set -e

# ==============================================
# WSL UBUNTU DEVELOPMENT ENVIRONMENT UNINSTALL SCRIPT
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
    echo -e "${BLUE}>>> ${RED}$1${NC}"
    echo -e "${BLUE}==================================${NC}"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to safely remove directory
safe_remove_dir() {
    if [ -d "$1" ]; then
        echo -e "${YELLOW}[REMOVE]${NC} Removing directory: $1"
        rm -rf "$1"
    else
        echo -e "${YELLOW}[SKIP]${NC} Directory not found: $1"
    fi
}

# Function to safely remove file
safe_remove_file() {
    if [ -f "$1" ]; then
        echo -e "${YELLOW}[REMOVE]${NC} Removing file: $1"
        rm -f "$1"
    else
        echo -e "${YELLOW}[SKIP]${NC} File not found: $1"
    fi
}

# Function to remove package if exists
remove_package() {
    if dpkg -l | grep -q "$1"; then
        echo -e "${YELLOW}[REMOVE]${NC} Removing package: $1"
        sudo apt remove -y "$1"
    else
        echo -e "${YELLOW}[SKIP]${NC} Package not installed: $1"
    fi
}

# ==============================================
# INITIAL WARNING
# ==============================================

echo -e "${RED}╔════════════════════════════════════════════╗${NC}"
echo -e "${RED}║${YELLOW}   ⚠️  WSL Development Environment Uninstall   ${RED}║${NC}"
echo -e "${RED}║${MAGENTA}          This will remove ALL components     ${RED}║${NC}"
echo -e "${RED}╚════════════════════════════════════════════╝${NC}"

echo -e "\n${RED}⚠️  WARNING: This script will remove:${NC}"
echo -e "• All development tools (Node.js, Python packages, etc.)"
echo -e "• Shell configurations (Zsh, Oh My Zsh, Starship)"
echo -e "• Git configuration"
echo -e "• SSH keys (with confirmation)"
echo -e "• Project directories and configurations"
echo -e "• Installed packages and tools"

echo -e "\n${YELLOW}What will NOT be removed:${NC}"
echo -e "• System packages (build-essential, git, curl, etc.)"
echo -e "• Your personal files outside development directories"
echo -e "• System-wide configurations"

read -p $'\n'"${RED}Are you sure you want to proceed? Type 'YES' to continue: ${NC}" confirm
if [[ "$confirm" != "YES" ]]; then
    echo -e "${GREEN}✅ Uninstall aborted. Your environment is safe.${NC}"
    exit 0
fi

# Ask for sudo password once
echo -e "\n${YELLOW}🔑 Please enter your sudo password when prompted...${NC}"
sudo -v

# ==============================================
# REMOVE DEVELOPMENT TOOLS
# ==============================================

section "Removing Development Tools"

# Remove NVM and Node.js
if [ -d "$HOME/.nvm" ]; then
    echo -e "${YELLOW}Removing NVM and Node.js...${NC}"
    # Remove global npm packages first
    if command_exists npm; then
        echo -e "${YELLOW}Removing global npm packages...${NC}"
        npm list -g --depth=0 --parseable --silent | grep -v '/npm$' | xargs -r npm uninstall -g 2>/dev/null || true
    fi
    safe_remove_dir "$HOME/.nvm"
fi

# Remove Python virtual environments
echo -e "${YELLOW}Removing Python virtual environments...${NC}"
safe_remove_dir "$HOME/.venvs"

# Remove pipx installations
if command_exists pipx; then
    echo -e "${YELLOW}Removing pipx packages...${NC}"
    pipx uninstall-all 2>/dev/null || true
fi

# ==============================================
# REMOVE SHELL CONFIGURATION
# ==============================================

section "Removing Shell Configuration"

# Remove Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${YELLOW}Removing Oh My Zsh...${NC}"
    safe_remove_dir "$HOME/.oh-my-zsh"
fi

# Remove Starship
if command_exists starship; then
    echo -e "${YELLOW}Removing Starship...${NC}"
    sudo rm -f /usr/local/bin/starship
fi

# Remove Zsh configuration files
echo -e "${YELLOW}Removing Zsh configuration...${NC}"
safe_remove_file "$HOME/.zshrc"
safe_remove_file "$HOME/.zsh_history"
safe_remove_dir "$HOME/.cache/zsh"

# Reset shell to bash
if [ "$SHELL" = "$(which zsh)" ]; then
    echo -e "${YELLOW}Resetting default shell to bash...${NC}"
    chsh -s $(which bash)
fi

# Remove Starship config
safe_remove_file "$HOME/.config/starship.toml"

# ==============================================
# REMOVE ADDITIONAL TOOLS
# ==============================================

section "Removing Additional Tools"

# Remove fzf
if [ -d "$HOME/.fzf" ]; then
    echo -e "${YELLOW}Removing fzf...${NC}"
    ~/.fzf/uninstall --no-update-rc 2>/dev/null || true
    safe_remove_dir "$HOME/.fzf"
fi

# Remove lazygit
if command_exists lazygit; then
    echo -e "${YELLOW}Removing lazygit...${NC}"
    sudo rm -f /usr/local/bin/lazygit
fi

# Remove GitHub CLI repository
if command_exists gh; then
    echo -e "${YELLOW}Removing GitHub CLI...${NC}"
    remove_package gh
    sudo rm -f /etc/apt/sources.list.d/github-cli.list
    sudo rm -f /usr/share/keyrings/githubcli-archive-keyring.gpg
fi

# ==============================================
# REMOVE GIT CONFIGURATION
# ==============================================

section "Removing Git Configuration"

echo -e "${YELLOW}Removing Git global configuration...${NC}"
git config --global --unset user.name 2>/dev/null || true
git config --global --unset user.email 2>/dev/null || true
git config --global --unset core.editor 2>/dev/null || true
git config --global --unset init.defaultBranch 2>/dev/null || true
git config --global --unset pull.rebase 2>/dev/null || true

# Remove git aliases
git config --global --unset alias.co 2>/dev/null || true
git config --global --unset alias.br 2>/dev/null || true
git config --global --unset alias.ci 2>/dev/null || true
git config --global --unset alias.st 2>/dev/null || true
git config --global --unset alias.unstage 2>/dev/null || true
git config --global --unset alias.last 2>/dev/null || true
git config --global --unset alias.lg 2>/dev/null || true

# ==============================================
# REMOVE SSH KEYS (WITH CONFIRMATION)
# ==============================================

section "SSH Keys"

if [ -f "$HOME/.ssh/id_ed25519" ] || [ -f "$HOME/.ssh/id_ed25519.pub" ]; then
    echo -e "${RED}⚠️  SSH keys found!${NC}"
    echo -e "Files found:"
    [ -f "$HOME/.ssh/id_ed25519" ] && echo -e "  • $HOME/.ssh/id_ed25519"
    [ -f "$HOME/.ssh/id_ed25519.pub" ] && echo -e "  • $HOME/.ssh/id_ed25519.pub"
    
    echo -e "\n${YELLOW}SSH key removal options:${NC}"
    echo -e "1. Keep SSH keys (recommended)"
    echo -e "2. Remove SSH keys (you'll lose access to GitHub/servers)"
    
    read -p "Choose option (1 or 2): " ssh_choice
    
    if [[ "$ssh_choice" == "2" ]]; then
        read -p $'\n'"${RED}Are you ABSOLUTELY sure? This will remove your SSH keys! Type 'DELETE' to confirm: ${NC}" ssh_confirm
        if [[ "$ssh_confirm" == "DELETE" ]]; then
            echo -e "${YELLOW}Removing SSH keys...${NC}"
            safe_remove_file "$HOME/.ssh/id_ed25519"
            safe_remove_file "$HOME/.ssh/id_ed25519.pub"
            echo -e "${RED}⚠️  SSH keys removed! You'll need to generate new ones for GitHub access.${NC}"
        else
            echo -e "${GREEN}✅ SSH keys preserved.${NC}"
        fi
    else
        echo -e "${GREEN}✅ SSH keys preserved.${NC}"
    fi
else
    echo -e "${YELLOW}No SSH keys found to remove.${NC}"
fi

# ==============================================
# REMOVE DIRECTORIES AND FILES
# ==============================================

section "Removing Project Directories and Configuration"

# Ask about project directories
if [ -d "$HOME/projects" ]; then
    echo -e "${RED}⚠️  Projects directory found: $HOME/projects${NC}"
    read -p "Do you want to remove the projects directory? (y/N): " remove_projects
    if [[ "$remove_projects" =~ ^[Yy]$ ]]; then
        safe_remove_dir "$HOME/projects"
        echo -e "${RED}⚠️  Projects directory removed!${NC}"
    else
        echo -e "${GREEN}✅ Projects directory preserved.${NC}"
    fi
fi

# Remove other directories created by setup
echo -e "${YELLOW}Removing configuration directories...${NC}"
safe_remove_dir "$HOME/tools"
safe_remove_dir "$HOME/scripts"
safe_remove_dir "$HOME/.cache/nvim"
safe_remove_file "$HOME/.config/welcome.txt"

# Clean up .local directories (but preserve the structure)
echo -e "${YELLOW}Cleaning ~/.local directories...${NC}"
rm -rf ~/.local/bin/* 2>/dev/null || true
rm -rf ~/.local/share/* 2>/dev/null || true
rm -rf ~/.local/lib/* 2>/dev/null || true

# ==============================================
# REMOVE PACKAGES
# ==============================================

section "Removing Optional Packages"

echo -e "${YELLOW}The following packages can be removed if not needed for other purposes:${NC}"
echo -e "• tldr, bat, ripgrep, fd-find, neovim"
echo -e "• zsh (if you don't use it elsewhere)"
echo -e "• Development libraries (build-essential, cmake, etc.)"

read -p "Remove optional packages? (y/N): " remove_packages

if [[ "$remove_packages" =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}Removing optional packages...${NC}"
    
    # Remove additional tools
    remove_package tldr
    remove_package bat
    remove_package ripgrep
    remove_package fd-find
    remove_package neovim
    remove_package zsh
    
    # Remove development packages (be careful with these)
    read -p "Remove development packages (build-essential, cmake, etc.)? This might affect other tools (y/N): " remove_dev
    if [[ "$remove_dev" =~ ^[Yy]$ ]]; then
        remove_package cmake
        remove_package pkg-config
        remove_package libssl-dev
        remove_package libffi-dev
        remove_package zlib1g-dev
        remove_package liblzma-dev
        remove_package libreadline-dev
        remove_package libbz2-dev
        remove_package libsqlite3-dev
        remove_package libncurses-dev
        remove_package tk-dev
        remove_package libxml2-dev
        remove_package libxmlsec1-dev
        remove_package llvm
        
        echo -e "${YELLOW}Note: build-essential left intact for system stability${NC}"
    fi
    
    # Clean up
    echo -e "${YELLOW}Cleaning up package cache...${NC}"
    sudo apt autoremove -y
    sudo apt autoclean
fi

# ==============================================
# FINAL CLEANUP
# ==============================================

section "Final Cleanup"

# Remove any remaining cache files
echo -e "${YELLOW}Cleaning remaining cache files...${NC}"
rm -rf ~/.cache/pip 2>/dev/null || true
rm -rf ~/.npm 2>/dev/null || true
rm -rf ~/.node-gyp 2>/dev/null || true
rm -rf ~/.yarn 2>/dev/null || true

# Reset environment variables in current session
unset NVM_DIR
unset BAT_THEME

echo -e "${YELLOW}Resetting terminal...${NC}"

# ==============================================
# COMPLETION
# ==============================================

section "Uninstall Complete"

echo -e "${GREEN}✅ Development environment has been uninstalled!${NC}"
echo -e "\n${YELLOW}Summary of actions taken:${NC}"
echo -e "• Removed Node.js, NVM, and npm packages"
echo -e "• Removed Python virtual environments"
echo -e "• Removed Zsh, Oh My Zsh, and Starship configuration"
echo -e "• Removed additional development tools"
echo -e "• Cleaned Git global configuration"
echo -e "• Removed project directories (if requested)"
echo -e "• Removed SSH keys (if requested)"

echo -e "\n${BLUE}What's left:${NC}"
echo -e "• Basic system packages (git, curl, wget, etc.)"
echo -e "• Your personal files outside development directories"
echo -e "• System-wide configurations"

echo -e "\n${YELLOW}Next steps:${NC}"
echo -e "1. Restart your terminal: ${GREEN}exec bash${NC}"
echo -e "2. Your shell has been reset to bash"
echo -e "3. Run 'sudo apt autoremove' if you want to clean up dependencies"

echo -e "\n${BLUE}Environment successfully reset! 🎯${NC}"

#!/bin/bash

# Core functions for the WSL Ubuntu setup

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

# Function to check if we can run sudo without password
can_run_sudo() {
    if sudo -n true 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to install package if not exists
install_package() {
    if ! dpkg -l | grep -q "$1"; then
        echo -e "${YELLOW}[INSTALL]${NC} $1..."
        if can_run_sudo; then
            sudo apt install -y "$1"
        else
            echo -e "${RED}[ERROR]${NC} Cannot install $1: sudo requires password"
            echo -e "${YELLOW}Please run this script in an interactive terminal where you can enter your password${NC}"
            exit 1
        fi
    else
        echo -e "${YELLOW}[SKIP]${NC} $1 already installed"
    fi
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to create backup
create_backup() {
    BACKUP_DIR="$HOME/.backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"
    echo -e "${YELLOW}Backup directory created: $BACKUP_DIR${NC}"
    echo "$BACKUP_DIR"
}

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Function to check Ubuntu version compatibility
check_ubuntu_version() {
    if ! command -v lsb_release >/dev/null 2>&1; then
        log_warn "lsb_release not found, skipping Ubuntu version check"
        return 0
    fi
    
    local version=$(lsb_release -rs)
    local major_version=$(echo $version | cut -d. -f1)
    
    # Check if it's an LTS version (even numbered years)
    if [[ $major_version -ge 18 && $((major_version % 2)) -eq 0 ]]; then
        log_success "Compatible Ubuntu LTS version detected: $version"
        return 0
    else
        log_warn "Non-LTS Ubuntu version detected: $version"
        log_warn "This script is optimized for Ubuntu LTS versions"
        return 1
    fi
}

# Function to check WSL environment
check_wsl() {
    if grep -q Microsoft /proc/version || grep -q microsoft /proc/version; then
        log_success "WSL environment detected"
        return 0
    else
        log_error "This script is designed for Ubuntu on WSL only"
        return 1
    fi
}

# Function to validate email format
validate_email() {
    local email=$1
    if [[ $email =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        return 0
    else
        return 1
    fi
}

# Function to validate GitHub username
validate_github_username() {
    local username=$1
    if [[ $username =~ ^[a-zA-Z0-9_-]{1,39}$ ]]; then
        return 0
    else
        return 1
    fi
}
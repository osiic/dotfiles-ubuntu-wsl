#!/bin/bash

# Utility functions for the WSL Ubuntu setup

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
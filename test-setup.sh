#!/bin/bash

# Test script for WSL Ubuntu Development Environment Setup
# This script tests the setup on different Ubuntu LTS versions

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function to print section headers
section() {
    echo -e "\n${BLUE}==================================${NC}"
    echo -e "${BLUE}>>> ${GREEN}$1${NC}"
    echo -e "${BLUE}==================================${NC}"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to test installation
test_installation() {
    local ubuntu_version=$1
    echo -e "${YELLOW}Testing on Ubuntu $ubuntu_version${NC}"
    
    # Check if running on WSL
    if ! grep -q Microsoft /proc/version && ! grep -q microsoft /proc/version; then
        echo -e "${RED}[ERROR]${NC} Not running on WSL"
        return 1
    fi
    
    # Check Ubuntu version
    local version=$(lsb_release -rs)
    if [[ "$version" != "$ubuntu_version"* ]]; then
        echo -e "${RED}[ERROR]${NC} Expected Ubuntu $ubuntu_version, but found $version"
        return 1
    fi
    
    # Test if essential commands are available
    local commands=("git" "curl" "wget" "zsh" "nvim" "tmux")
    for cmd in "${commands[@]}"; do
        if command_exists "$cmd"; then
            echo -e "${GREEN}[PASS]${NC} $cmd is available"
        else
            echo -e "${RED}[FAIL]${NC} $cmd is not available"
            return 1
        fi
    done
    
    # Test if development tools are available
    if command_exists "node"; then
        echo -e "${GREEN}[PASS]${NC} Node.js is available"
    else
        echo -e "${YELLOW}[WARN]${NC} Node.js is not available"
    fi
    
    if command_exists "python3"; then
        echo -e "${GREEN}[PASS]${NC} Python is available"
    else
        echo -e "${RED}[FAIL]${NC} Python is not available"
        return 1
    fi
    
    # Test if additional tools are available
    local tools=("fzf" "lazygit" "tldr")
    for tool in "${tools[@]}"; do
        if command_exists "$tool"; then
            echo -e "${GREEN}[PASS]${NC} $tool is available"
        else
            echo -e "${YELLOW}[WARN]${NC} $tool is not available"
        fi
    done
    
    echo -e "${GREEN}[SUCCESS]${NC} All tests passed for Ubuntu $ubuntu_version"
    return 0
}

# Main test function
main() {
    section "WSL Ubuntu Development Environment Test"
    
    # Get Ubuntu version
    local ubuntu_version=$(lsb_release -rs)
    local major_version=$(echo $ubuntu_version | cut -d. -f1)
    
    # Check if it's an LTS version
    if [[ $major_version -ge 18 && $((major_version % 2)) -eq 0 ]]; then
        echo -e "${GREEN}[INFO]${NC} Compatible Ubuntu LTS version detected: $ubuntu_version"
        test_installation "$ubuntu_version"
    else
        echo -e "${YELLOW}[WARN]${NC} Non-LTS Ubuntu version detected: $ubuntu_version"
        echo -e "${YELLOW}[INFO]${NC} This script is optimized for Ubuntu LTS versions"
        test_installation "$ubuntu_version"
    fi
}

# Run the test
main
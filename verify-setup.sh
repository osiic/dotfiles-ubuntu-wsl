#!/bin/bash

# Final verification script for WSL Ubuntu Development Environment Setup

echo "=== WSL Ubuntu Development Environment Setup Verification ==="

# Check if we're on WSL
if grep -q Microsoft /proc/version || grep -q microsoft /proc/version; then
    echo "✅ Running on WSL"
else
    echo "❌ Not running on WSL"
    exit 1
fi

# Check Ubuntu version
UBUNTU_VERSION=$(lsb_release -rs)
echo "✅ Ubuntu version: $UBUNTU_VERSION"

# Check if it's an LTS version
MAJOR_VERSION=$(echo $UBUNTU_VERSION | cut -d. -f1)
if [[ $MAJOR_VERSION -ge 18 && $((MAJOR_VERSION % 2)) -eq 0 ]]; then
    echo "✅ Compatible Ubuntu LTS version"
else
    echo "⚠️  Non-LTS Ubuntu version (script optimized for LTS versions)"
fi

# Check essential tools
echo "=== Checking Essential Tools ==="
ESSENTIAL_TOOLS=("git" "curl" "wget" "zsh")
for tool in "${ESSENTIAL_TOOLS[@]}"; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "✅ $tool is installed"
    else
        echo "❌ $tool is not installed"
    fi
done

# Check development tools
echo "=== Checking Development Tools ==="
if command -v "nvim" >/dev/null 2>&1; then
    echo "✅ Neovim is installed"
else
    echo "❌ Neovim is not installed"
fi

if command -v "tmux" >/dev/null 2>&1; then
    echo "✅ Tmux is installed"
else
    echo "❌ Tmux is not installed"
fi

if command -v "node" >/dev/null 2>&1; then
    NODE_VERSION=$(node --version)
    echo "✅ Node.js is installed ($NODE_VERSION)"
else
    echo "⚠️  Node.js is not installed"
fi

if command -v "python3" >/dev/null 2>&1; then
    PYTHON_VERSION=$(python3 --version)
    echo "✅ Python is installed ($PYTHON_VERSION)"
else
    echo "❌ Python is not installed"
fi

# Check additional tools
echo "=== Checking Additional Tools ==="
ADDITIONAL_TOOLS=("fzf" "lazygit" "tldr" "starship")
for tool in "${ADDITIONAL_TOOLS[@]}"; do
    if command -v "$tool" >/dev/null 2>&1; then
        echo "✅ $tool is installed"
    else
        echo "⚠️  $tool is not installed"
    fi
done

# Check directory structure
echo "=== Checking Directory Structure ==="
DIRECTORIES=("~/projects" "~/tools" "~/scripts" "~/.config")
for dir in "${DIRECTORIES[@]}"; do
    expanded_dir=$(eval echo $dir)
    if [ -d "$expanded_dir" ]; then
        echo "✅ $dir exists"
    else
        echo "❌ $dir does not exist"
    fi
done

echo "=== Verification Complete ==="
echo "If all essential tools are installed, your setup is working correctly."
echo "Some warnings are normal if you chose not to install certain optional components."
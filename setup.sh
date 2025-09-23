#!/bin/bash

# Main entry point for the WSL Ubuntu setup

# Check if running on Ubuntu
if ! grep -q Microsoft /proc/version && ! grep -q microsoft /proc/version; then
    echo -e "\n${RED}This script is designed for Ubuntu on WSL only.${NC}"
    exit 1
fi

# Check Ubuntu version
UBUNTU_VERSION=$(lsb_release -rs)
echo -e "\n${YELLOW}Detected Ubuntu version: $UBUNTU_VERSION${NC}"

# Source core functions
source "$(dirname "$0")/scripts/core/functions.sh"
source "$(dirname "$0")/scripts/utils/validation.sh"
source "$(dirname "$0")/scripts/utils/config.sh"

# Show help if requested
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo -e "\n${BLUE}WSL Ubuntu Development Environment Setup${NC}"
    echo -e "${YELLOW}Usage:${NC}"
    echo -e "  ./setup.sh             # Run full installation"
    echo -e "  ./setup.sh install     # Run full installation"
    echo -e "  ./setup.sh update      # Check for and apply updates"
    echo -e "  ./setup.sh uninstall   # Remove the environment"
    echo -e "  ./setup.sh --help      # Show this help message"
    echo -e "\n${YELLOW}Commands:${NC}"
    echo -e "  install     - Install the complete development environment"
    echo -e "  update      - Check for and apply updates"
    echo -e "  uninstall   - Remove all components (irreversible)"
    exit 0
fi

# Handle commands
case "$1" in
    install|"")
        source "$(dirname "$0")/scripts/install.sh"
        ;;
    update)
        source "$(dirname "$0")/scripts/commands/update.sh"
        ;;
    uninstall)
        source "$(dirname "$0")/scripts/commands/uninstall.sh"
        ;;
    *)
        echo -e "\n${RED}Unknown command: $1${NC}"
        echo -e "Use --help for usage information."
        exit 1
        ;;
esac
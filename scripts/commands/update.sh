#!/bin/bash

# Update script functionality

# Source core functions
source "scripts/core/functions.sh"

# Function to check for updates
check_for_updates() {
    echo -e "${YELLOW}Checking for updates...${NC}"
    
    # Try to fetch latest changes from remote
    if git fetch origin main 2>/dev/null; then
        # Check if we're behind
        LOCAL=$(git rev-parse HEAD)
        REMOTE=$(git rev-parse origin/main)
        
        if [ $LOCAL != $REMOTE ]; then
            echo -e "${YELLOW}Updates available!${NC}"
            echo -e "${BLUE}==================================${NC}"
            echo -e "${YELLOW}Latest commits:${NC}"
            git log --oneline HEAD..origin/main
            echo -e "${BLUE}==================================${NC}"
            
            # In non-interactive environments, we'll just notify about updates
            echo -e "${YELLOW}To apply updates, run this script in an interactive terminal${NC}"
        else
            echo -e "${GREEN}Your environment is up to date!${NC}"
        fi
    else
        echo -e "${YELLOW}Could not check for updates (possibly due to network restrictions)${NC}"
        echo -e "${YELLOW}To check for updates, run this script in an interactive terminal with internet access${NC}"
    fi
}

# Run update check
check_for_updates
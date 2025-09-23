#!/bin/bash

# Update script functionality

# Source core functions
source "../core/functions.sh"

# Function to check for updates
check_for_updates() {
    echo -e "${YELLOW}Checking for updates...${NC}"
    
    # Fetch latest changes from remote
    git fetch origin main
    
    # Check if we're behind
    LOCAL=$(git rev-parse HEAD)
    REMOTE=$(git rev-parse origin/main)
    
    if [ $LOCAL != $REMOTE ]; then
        echo -e "${YELLOW}Updates available!${NC}"
        echo -e "${BLUE}==================================${NC}"
        echo -e "${YELLOW}Latest commits:${NC}"
        git log --oneline HEAD..origin/main
        echo -e "${BLUE}==================================${NC}"
        
        read -p "Do you want to update? (y/n/view): " update_choice
        
        case $update_choice in
            y|Y)
                echo -e "${YELLOW}Updating...${NC}"
                git pull origin main
                echo -e "${GREEN}Update complete!${NC}"
                ;;
            view|VIEW)
                echo -e "${YELLOW}Showing detailed changes...${NC}"
                git log --stat HEAD..origin/main
                read -p "Update now? (y/n): " confirm_update
                if [[ $confirm_update == "y" || $confirm_update == "Y" ]]; then
                    git pull origin main
                    echo -e "${GREEN}Update complete!${NC}"
                else
                    echo -e "${YELLOW}Update skipped.${NC}"
                fi
                ;;
            *)
                echo -e "${YELLOW}Update skipped.${NC}"
                ;;
        esac
    else
        echo -e "${GREEN}Your environment is up to date!${NC}"
    fi
}

# Run update check
check_for_updates
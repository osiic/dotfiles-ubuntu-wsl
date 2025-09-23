#!/bin/bash

# GitHub Setup Module

# Source core functions
source "scripts/core/functions.sh"
source "scripts/utils/config.sh"
source "scripts/utils/validation.sh"

setup_github() {
    section "GitHub Setup"

    echo -e "${YELLOW}Choose GitHub authentication method:${NC}"
    echo "1) SSH Key (recommended)"
    echo "2) GitHub CLI login (HTTPS)"
    read -p "Enter choice [1/2]: " auth_method

    if [[ "$auth_method" == "1" ]]; then
        # ================= SSH Setup =================
        if [ -f ~/.ssh/id_ed25519 ]; then
            echo -e "${GREEN}✅ SSH key already exists, skipping SSH setup.${NC}"
        else
            section "User Configuration"
            
            # Load existing config if available
            load_config
            
            # Get user info with validation
            if [[ -z "$USER_NAME" ]]; then
                read -p "Enter your full name: " USER_NAME
            else
                read -p "Enter your full name [$USER_NAME]: " input
                USER_NAME=${input:-$USER_NAME}
            fi
            
            if [[ -z "$USER_EMAIL" ]]; then
                read -p "Enter your email address: " USER_EMAIL
                while ! validate_email "$USER_EMAIL"; do
                    echo -e "${RED}Invalid email format. Please try again.${NC}"
                    read -p "Enter your email address: " USER_EMAIL
                done
            else
                read -p "Enter your email address [$USER_EMAIL]: " input
                USER_EMAIL=${input:-$USER_EMAIL}
                while ! validate_email "$USER_EMAIL"; do
                    echo -e "${RED}Invalid email format. Please try again.${NC}"
                    read -p "Enter your email address: " USER_EMAIL
                done
            fi
            
            if [[ -z "$GITHUB_USER" ]]; then
                read -p "Enter your GitHub username: " GITHUB_USER
                while ! validate_github_username "$GITHUB_USER"; do
                    echo -e "${RED}Invalid GitHub username format. Please try again.${NC}"
                    read -p "Enter your GitHub username: " GITHUB_USER
                done
            else
                read -p "Enter your GitHub username [$GITHUB_USER]: " input
                GITHUB_USER=${input:-$GITHUB_USER}
                while ! validate_github_username "$GITHUB_USER"; do
                    echo -e "${RED}Invalid GitHub username format. Please try again.${NC}"
                    read -p "Enter your GitHub username: " GITHUB_USER
                done
            fi
            
            # Save config
            save_config
            
            echo -e "\n${YELLOW}Please verify your information:${NC}"
            echo -e "Name    : ${GREEN}$USER_NAME${NC}"
            echo -e "Email   : ${GREEN}$USER_EMAIL${NC}"
            echo -e "GitHub  : ${GREEN}$GITHUB_USER${NC}"
            read -p "Is this correct? (y/n): " confirm
            if [[ "$confirm" != "y" ]]; then
                echo -e "${RED}❌ Setup aborted. Please run the script again.${NC}"
                exit 1
            fi

            echo -e "${YELLOW}Generating SSH key...${NC}"
            ssh-keygen -t ed25519 -C "$USER_EMAIL" -f ~/.ssh/id_ed25519 -N ""
            eval "$(ssh-agent -s)"
            ssh-add ~/.ssh/id_ed25519
            
            echo -e "\n${GREEN}🔑 Public SSH Key:${NC}"
            cat ~/.ssh/id_ed25519.pub
            echo -e "\n${YELLOW}Please add this key to your GitHub account:${NC}"
            echo "https://github.com/settings/keys"
            read -p "Press Enter to continue after adding the key..."
        fi

    elif [[ "$auth_method" == "2" ]]; then
        # ================= GitHub CLI Login =================
        if ! command_exists gh; then
            echo -e "${YELLOW}Installing GitHub CLI...${NC}"
            curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            sudo apt update
            sudo apt install -y gh
        fi

        echo -e "${YELLOW}Logging in with GitHub CLI...${NC}"
        gh auth login
    else
        echo -e "${RED}❌ Invalid choice. Exiting.${NC}"
        exit 1
    fi
}
#!/bin/bash

# Configuration management utilities

# Function to load configuration
load_config() {
    local config_file="$HOME/.wsl-dev-env.conf"
    if [ -f "$config_file" ]; then
        source "$config_file"
        log_info "Configuration loaded from $config_file"
    else
        log_warn "No configuration file found, using defaults"
    fi
}

# Function to save configuration
save_config() {
    local config_file="$HOME/.wsl-dev-env.conf"
    cat > "$config_file" << EOL
# WSL Development Environment Configuration
USER_NAME="$USER_NAME"
USER_EMAIL="$USER_EMAIL"
GITHUB_USER="$GITHUB_USER"
EOL
    log_info "Configuration saved to $config_file"
}

# Function to reset configuration
reset_config() {
    local config_file="$HOME/.wsl-dev-env.conf"
    if [ -f "$config_file" ]; then
        rm "$config_file"
        log_info "Configuration reset"
    else
        log_info "No configuration file to reset"
    fi
}
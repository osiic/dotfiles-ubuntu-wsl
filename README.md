# WSL Ubuntu 24.04 Node.js Development Setup

This repository contains a one-click setup script for a complete Node.js development environment on WSL Ubuntu 24.04.

## Features

- Zsh with Oh My Zsh and plugins
- Starship prompt
- NVM with Node.js LTS
- Git configuration with custom aliases
- SSH key generation
- Neovim configuration (from your repo)
- Tmux configuration (from your repo)
- Kitty terminal configuration (from your repo)

## Installation

1. Install WSL Ubuntu 24.04
2. Clone this repository
3. Run the setup script:

```bash
git clone https://github.com/osiic/dotfiles-ubuntu-wsl.git
cd dotfiles-ubuntu-wsl
chmod +x install.sh
./install.sh
git remote set-url origin git@github.com:osiic/dotfiles-ubuntu-wsl.git
```

## Uninstallation

To remove all configurations and packages:

```bash
./uninstall.sh
```

## Post-Installation

1. Add your SSH key to GitHub: https://github.com/settings/keys
2. Restart your shell: `exec zsh`
```

## How to Use

1. Clone this repository to your WSL Ubuntu 24.04 installation
2. Make the scripts executable: `chmod +x install.sh uninstall.sh`
3. Run `./install.sh` to set up everything automatically
4. After installation, add your SSH key to GitHub (the script will show you the public key)
5. Restart your shell with `exec zsh`

This setup is completely modular and maintains all configurations in the `~/dotfiles` directory with symlinks to the appropriate locations. The uninstall script will clean everything up if you need to start fresh.
# dotfiles-ubuntu-wsl

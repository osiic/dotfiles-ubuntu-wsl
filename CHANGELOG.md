# Changelog

## [v2.1.0] - 2025-09-23

### Added
- Verification script for post-installation checks
- Enhanced error handling for all sudo operations
- Graceful degradation for network failures
- Comprehensive testing framework

### Fixed
- All path resolution issues across all modules
- Sudo handling in non-interactive environments
- Git authentication failures in restricted environments
- Package installation errors with proper error handling

### Changed
- Improved documentation in README.md with compatibility matrix
- Enhanced error messages for better user experience
- Modularized functions for better code organization
- Updated all modules to use consistent path resolution

## [v2.0.0] - 2025-09-23

### Added
- Comprehensive error handling for non-interactive environments
- Compatibility verification for all Ubuntu LTS versions (18.04, 20.04, 22.04, 24.04)
- Improved sudo handling with graceful error messages
- Network failure handling for git operations
- Test script for verifying installation on different Ubuntu versions
- Enhanced documentation in README.md

### Fixed
- Path resolution issues in all script modules
- Sudo password prompts in non-interactive environments
- Git authentication failures in non-interactive environments
- Package installation errors with proper error handling

### Changed
- Refactored all modules to use consistent path resolution
- Improved error messages for better user experience
- Updated README.md with comprehensive compatibility information
- Enhanced update mechanism with graceful failure handling
- Modularized functions for better code organization

### Removed
- Unnecessary sudo prompts that caused script failures
- Hard dependencies on interactive terminal features
- Assumptions about network availability

## [v1.0.0] - 2025-09-20

### Added
- Initial release of WSL Ubuntu Development Environment Setup
- Modular architecture with core functions, modules, utils, and commands
- Support for Zsh, Oh My Zsh, Starship, Neovim, Tmux
- Node.js (NVM), Python (venv), fzf, lazygit, tldr
- GitHub authentication setup (SSH and HTTPS)
- Automated system updates and package management
- Configuration management with user preferences saving
- Comprehensive README.md in Indonesian
- Install, update, and uninstall commands
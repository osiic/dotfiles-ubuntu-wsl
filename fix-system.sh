#!/bin/bash
set -e

# ==============================================
# WSL UBUNTU SYSTEM RECOVERY SCRIPT  
# Fix broken packages and dependencies
# ==============================================

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Function to print section headers
section() {
    echo -e "\n${BLUE}==================================${NC}"
    echo -e "${BLUE}>>> ${GREEN}$1${NC}"
    echo -e "${BLUE}==================================${NC}"
}

# Function to ask yes/no question
ask_yes_no() {
    while true; do
        read -p "$1 (y/n): " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes (y) or no (n).";;
        esac
    done
}

# ==============================================
# INITIAL SETUP
# ==============================================

echo -e "${BLUE}╔════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║${CYAN}   🔧 WSL Ubuntu System Recovery Tool       ${BLUE}║${NC}"
echo -e "${BLUE}║${MAGENTA}     Fix Broken Packages & Dependencies    ${BLUE}║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════╝${NC}"

echo -e "\n${YELLOW}This script will attempt to fix:${NC}"
echo -e "• Broken package dependencies"
echo -e "• Failed package installations/removals"
echo -e "• Corrupted package database"
echo -e "• Missing critical system packages"

if ! ask_yes_no "Do you want to proceed with system recovery?"; then
    echo -e "${GREEN}✅ Recovery cancelled.${NC}"
    exit 0
fi

# Ask for sudo password once
echo -e "\n${YELLOW}🔑 Please enter your sudo password when prompted...${NC}"
sudo -v

# ==============================================
# SYSTEM DIAGNOSIS
# ==============================================

section "System Diagnosis"

echo -e "${YELLOW}Checking system status...${NC}"

# Check for broken packages
BROKEN_PACKAGES=$(dpkg --get-selections | grep -v deinstall | awk '{print $1}' | xargs dpkg -s 2>&1 | grep -c "is not installed" || true)
echo -e "Broken packages: ${RED}$BROKEN_PACKAGES${NC}"

# Check for held packages
HELD_PACKAGES=$(apt-mark showhold | wc -l || true)
echo -e "Held packages: ${YELLOW}$HELD_PACKAGES${NC}"

# Check disk space
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
echo -e "Disk usage: ${CYAN}$DISK_USAGE%${NC}"

if [ "$DISK_USAGE" -gt 90 ]; then
    echo -e "${RED}⚠️  Warning: Disk usage is high (${DISK_USAGE}%)${NC}"
fi

# ==============================================
# PACKAGE DATABASE RECOVERY
# ==============================================

section "Package Database Recovery"

echo -e "${YELLOW}Updating package lists...${NC}"
sudo apt update || {
    echo -e "${RED}Failed to update package lists. Attempting recovery...${NC}"
    
    # Clear apt cache
    sudo apt-get clean
    sudo apt-get autoclean
    
    # Remove lock files if they exist
    sudo rm -f /var/lib/dpkg/lock-frontend
    sudo rm -f /var/lib/dpkg/lock
    sudo rm -f /var/cache/apt/archives/lock
    
    # Reconfigure dpkg
    sudo dpkg --configure -a
    
    # Try update again
    sudo apt update
}

# ==============================================
# FIX BROKEN DEPENDENCIES
# ==============================================

section "Fixing Broken Dependencies"

echo -e "${YELLOW}Fixing broken installations...${NC}"
sudo apt --fix-broken install -y || true

echo -e "${YELLOW}Reconfiguring packages...${NC}"
sudo dpkg --configure -a || true

# ==============================================
# REMOVE PROBLEMATIC PACKAGES
# ==============================================

section "Handling Problematic Packages"

# List of packages that commonly cause issues during removal
PROBLEMATIC_PACKAGES=(
    "tar"
    "gzip" 
    "bzip2"
    "zip"
    "coreutils"
    "util-linux"
)

for package in "${PROBLEMATIC_PACKAGES[@]}"; do
    if dpkg -l | grep -q "^rc.*$package"; then
        echo -e "${YELLOW}Found residual config for $package, cleaning up...${NC}"
        sudo apt purge -y "$package" 2>/dev/null || true
    fi
done

# ==============================================
# REINSTALL CRITICAL PACKAGES
# ==============================================

section "Reinstalling Critical Packages"

CRITICAL_PACKAGES=(
    "tar"
    "gzip"
    "coreutils"
    "util-linux"
    "dpkg"
    "apt"
)

for package in "${CRITICAL_PACKAGES[@]}"; do
    if ! dpkg -l | grep -q "^ii.*$package"; then
        echo -e "${YELLOW}Reinstalling critical package: $package${NC}"
        sudo apt install -y --reinstall "$package" || {
            echo -e "${RED}Failed to reinstall $package${NC}"
        }
    else
        echo -e "${GREEN}✅ $package is properly installed${NC}"
    fi
done

# ==============================================
# CLEANUP HELD PACKAGES
# ==============================================

section "Cleaning Up Held Packages"

HELD_LIST=$(apt-mark showhold)
if [ -n "$HELD_LIST" ]; then
    echo -e "${YELLOW}Found held packages:${NC}"
    echo "$HELD_LIST"
    
    if ask_yes_no "Do you want to unhold these packages?"; then
        echo "$HELD_LIST" | xargs sudo apt-mark unhold
        echo -e "${GREEN}✅ Packages unheld${NC}"
    fi
fi

# ==============================================
# SYSTEM CLEANUP
# ==============================================

section "System Cleanup"

echo -e "${YELLOW}Performing comprehensive cleanup...${NC}"

# Remove orphaned packages
sudo apt autoremove -y --purge

# Clean package cache
sudo apt autoclean
sudo apt clean

# Remove old kernels if any
if dpkg -l | grep -q linux-image; then
    echo -e "${YELLOW}Cleaning old kernels...${NC}"
    sudo apt autoremove -y --purge $(dpkg -l | grep '^rc.*linux-image' | awk '{print $2}') 2>/dev/null || true
fi

# Update package database
sudo apt update

# ==============================================
# SHELL RECOVERY
# ==============================================

section "Shell Recovery"

# Check if shell is broken
if ! command -v "$SHELL" >/dev/null 2>&1; then
    echo -e "${RED}Current shell ($SHELL) is not available${NC}"
    if ask_yes_no "Reset shell to bash?"; then
        sudo chsh -s /bin/bash "$USER"
        echo -e "${GREEN}✅ Shell reset to bash${NC}"
    fi
fi

# Fix starship if it was causing issues
if [ -f ~/.zshrc ] && grep -q "starship init" ~/.zshrc; then
    if ! command -v starship >/dev/null 2>&1; then
        echo -e "${YELLOW}Starship not found, commenting out from zshrc...${NC}"
        sed -i 's/eval "$(starship init zsh)"/#eval "$(starship init zsh)"/g' ~/.zshrc
        echo -e "${GREEN}✅ Starship initialization disabled${NC}"
    fi
fi

# ==============================================
# VERIFICATION
# ==============================================

section "System Verification"

echo -e "${YELLOW}Verifying system integrity...${NC}"

# Test basic commands
COMMANDS_TO_TEST=("tar" "gzip" "ls" "cat" "grep" "find")
FAILED_COMMANDS=()

for cmd in "${COMMANDS_TO_TEST[@]}"; do
    if command -v "$cmd" >/dev/null 2>&1; then
        echo -e "  ✅ $cmd: ${GREEN}Working${NC}"
    else
        echo -e "  ❌ $cmd: ${RED}Missing${NC}"
        FAILED_COMMANDS+=("$cmd")
    fi
done

# Check package manager
if apt list --installed >/dev/null 2>&1; then
    echo -e "  ✅ Package manager: ${GREEN}Working${NC}"
else
    echo -e "  ❌ Package manager: ${RED}Issues detected${NC}"
fi

# Final status
if [ ${#FAILED_COMMANDS[@]} -eq 0 ]; then
    echo -e "\n${GREEN}✅ System recovery completed successfully!${NC}"
    RECOVERY_SUCCESS=true
else
    echo -e "\n${YELLOW}⚠️  System recovery completed with some issues:${NC}"
    for cmd in "${FAILED_COMMANDS[@]}"; do
        echo -e "  • ${RED}$cmd still missing${NC}"
    done
    RECOVERY_SUCCESS=false
fi

# ==============================================
# COMPLETION
# ==============================================

section "Recovery Complete"

if [ "$RECOVERY_SUCCESS" = true ]; then
    echo -e "${GREEN}🎉 System successfully recovered!${NC}"
    echo -e "\n${CYAN}What was fixed:${NC}"
    echo -e "• Package dependencies resolved"
    echo -e "• Broken installations repaired"
    echo -e "• Critical system packages verified"
    echo -e "• Package database updated"
    echo -e "• System cleanup completed"
    
    echo -e "\n${YELLOW}Recommended next steps:${NC}"
    echo -e "1. Restart your terminal session"
    echo -e "2. Test basic operations (ls, cat, tar, etc.)"
    echo -e "3. If issues persist, consider running install script again"
    
else
    echo -e "${YELLOW}⚠️  System partially recovered${NC}"
    echo -e "\n${CYAN}You may need to:${NC}"
    echo -e "1. Manually install missing commands"
    echo -e "2. Check Ubuntu repositories"
    echo -e "3. Consider fresh WSL installation if problems persist"
fi

echo -e "\n${BLUE}Recovery log saved to: $(pwd)/system-recovery.log${NC}"

# Create recovery report
cat > system-recovery.log << EOF
WSL Ubuntu System Recovery Report
Generated: $(date)

Initial Issues Found:
- Broken packages: $BROKEN_PACKAGES
- Held packages: $HELD_PACKAGES  
- Disk usage: $DISK_USAGE%

Actions Taken:
- Updated package database
- Fixed broken dependencies
- Reconfigured packages
- Cleaned problematic packages
- Reinstalled critical system packages
- Performed system cleanup
- Verified command availability

Final Status: $([ "$RECOVERY_SUCCESS" = true ] && echo "SUCCESS" || echo "PARTIAL")

$([ ${#FAILED_COMMANDS[@]} -gt 0 ] && echo "Remaining Issues:" && printf "- %s\n" "${FAILED_COMMANDS[@]}")

Recommendations:
- Restart terminal session
- Test basic system operations
- Consider fresh installation if major issues persist
EOF

echo -e "${GREEN}System recovery process completed! 🔧${NC}"

# Offer to restart shell
if ask_yes_no "Would you like to restart your shell now?"; then
    exec bash
fi

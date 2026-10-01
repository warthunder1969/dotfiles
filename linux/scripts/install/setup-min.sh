#!/bin/bash
# TUI Installer for Setting up my various Linux Systems.
# Version 0.6

# === System Functions === #
# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color


# ============================================================================
# FUNCTIONS
# ============================================================================

intro() {
    clear
TITLE="Linux Setup Script"
DESCRIPTION="This is a Minimal Setup Script for fresh Debian-based Distros (like Linux Mint.) Press YES to continue or NO to exit. "


# Display the welcome screen with Yes/No buttons
dialog --title "$TITLE" \
       --yesno "$DESCRIPTION" \
       12 50

# Capture the exit status
exit_status=$?

if [ $exit_status -eq 0 ]; then
    # User pressed Yes
    clear
    echo "Continuing with the script..."
else
    # User pressed No or ESC
    clear
    echo "Operation cancelled."
    exit 1
fi 
clear

}


section_header() {
    echo -e "\n${BLUE}=== $1 ===${NC}\n"
}

get_os() {
    case "$OSTYPE" in
        linux*)
            if command -v apt > /dev/null 2>&1; then
                echo "apt is available"
            else
                echo "apt is not available"
                echo "apt is required"
                exit 0
            fi   
            ;; 
    esac
}

update_system() {
    # Apply System Updates
    sudo apt update && sudo apt upgrade -y
}


tweak_system() {
    section_header "Applying System Tweaks"
    
    echo "Optimizing swappiness" 
        echo 'vm.swappiness=10' | sudo tee /etc/sysctl.d/99-custom.conf &>/dev/null
    
    echo "Setting timezone to UTC"
        sudo timedatectl set-timezone UTC
}


install_pkgs() {
    section_header "Installing Essential Packages"
        sudo apt update
        sudo apt install -y vlc fonts-noto-color-emoji libfreetype6 fontconfig libcairo2
        sudo apt install -yy ttf-mscorefonts-installer
    
    section_header "Installing Flatpaks"
    flatpak install -y com.google.Chrome com.github.tchx84.Flatseal
}

configure_system() {
    echo "Configuring System"
    
    echo "Setting Sensible Flatpak Rules" 
        sudo flatpak override --device=dri
        sudo flatpak override --filesystem=home:ro
        sudo flatpak override --filesystem=$HOME/.local/share/applications:create
        sudo flatpak override --filesystem=$HOME/.local/share/icons:create
    
}

# ============================================================================
# MAIN EXECUTION
# ============================================================================

main() {
    # Count total steps (update this number based on what you're running)
    TOTAL_STEPS=16
    
    echo -e "${BLUE}╔════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║  System Setup & Installation Tool  ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════╝${NC}"
    
    # Run modules in order
    get_os
    intro
    update_system
    tweak_system
    install_pkgs
    configure_system
    
    # Summary
    echo -e "\n${BLUE}=== Setup Complete ===${NC}"
    echo -e "${GREEN}All tasks have been completed!${NC}\n"
}

# Run main function
main
  

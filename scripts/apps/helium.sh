#!/bin/bash
# Enhanced Installer script for Wezterm. Should work for most Debian or Ubuntu based systems
# Version 1.0
#Source: https://wezterm.org/install/linux.html#__tabbed_1_3

# Dependencies
# git
# wget
# curl
echo "Installing Depenencies"
dpkg -l | grep -qw git  || sudo apt install -yyq git
dpkg -l | grep -qw wget || sudo apt install -yyq wget
dpkg -l | grep -qw curl || sudo apt install -yyq curl


# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed. Please install it to use this script (e.g., sudo apt install dialog)."
    exit 1
fi

## Variables


# Define the menu items: "Tag" "Description"
OPTIONS=(
    1 "Community Debian Repository"
)

# Use dialog to display a menu box and capture the user's choice
CHOICE=$(dialog --clear --title "Wezterm Installation Script" \
    --menu "Select Which Version to Install:" 15 50 4 "${OPTIONS[@]}" \
    2>&1 >/dev/tty)

# Clear the dialog screen upon exit
clear

# Execute based on the user's choice
case $CHOICE in
    1)
        echo "Installing Repository..."
        
		# Add repository GPG key
		curl -fsSL https://justaguylinux.codeberg.page/helium-deb-repo/key.asc | sudo gpg --dearmor -o /usr/share/keyrings/helium-deb-repo.gpg
		
		# Add repository to sources
		echo "deb [arch=amd64 signed-by=/usr/share/keyrings/helium-deb-repo.gpg] https://justaguylinux.codeberg.page/helium-deb-repo stable main" | sudo tee /etc/apt/sources.list.d/helium-deb-repo.list
		
		# Update package list
		sudo apt update
		sudo apt install helium-browser
        ;;

    *)
        echo "Script Aborted or Cancelled."
        ;;
echo "Helium Installed!"
esac

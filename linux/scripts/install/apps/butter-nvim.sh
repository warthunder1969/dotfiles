#!/bin/bash
#Warthunder's butter-nvim installation script
#Version 1.0
#source:https://codeberg.org/justaguylinux/butter-nvim
# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed. Please install it to use this script (e.g., sudo apt install dialog)."
    exit 1
fi

# Variables
$app="butter-nvim"
# Define the Title and the Summary Message
DIALOG_TITLE="WELCOME"

# Use triple quotes for cleaner multi-line strings in the message
SCRIPT_SUMMARY="
Welcome to Warthunder's $app Install Script!

This script is for installing $app on Debian 
based systems.

This script is provided as-is. Press OK to Continue.
"
dialog --clear \
    --title "$DIALOG_TITLE" \
    --msgbox "$SCRIPT_SUMMARY" 15 60 \
    2>&1 >/dev/tty

# Clear the dialog screen upon exit
clear

OPTIONS=(
    1 "Debian Package (Deb)"
)

# Use dialog to display a menu box and capture the user's choice
CHOICE=$(dialog --clear --title "$app Installation Script" \
    --menu "Select Which Version to Install:" 15 50 4 "${OPTIONS[@]}" \
    2>&1 >/dev/tty)

# Clear the dialog screen upon exit
clear

# Execute based on the user's choice
case $CHOICE in
    1)
        echo "Installing..."
		# 1. Add ButterRepo (provides neovim)
		curl -fsSL https://justaguylinux.codeberg.page/butterrepo/key.asc | sudo gpg --dearmor -o /usr/share/keyrings/butterrepo.gpg
		echo "deb [arch=amd64 signed-by=/usr/share/keyrings/butterrepo.gpg] https://justaguylinux.codeberg.page/butterrepo stable main" | sudo tee /etc/apt/sources.list.d/butterrepo.list
		sudo apt update && sudo apt install neovim
		
		# 2. Backup existing config (if any)
		mv ~/.config/nvim ~/.config/nvim.backup
		
		# 3. Clone this config
		git clone https://codeberg.org/justaguylinux/butter-nvim ~/.config/nvim
		
		# 4. Launch - plugins auto-install
		nvim
		
		# Check if Package Installed
		if dpkg-query -W -f='${Status}' "nvim" 2>/dev/null | grep -q "ok installed"; then
		  echo "$app is installed"
		else
		  echo "$app was NOT installed"
		fi
					
        ;;
    
    *)
        echo "Script Aborted or Cancelled."
        ;;
esac




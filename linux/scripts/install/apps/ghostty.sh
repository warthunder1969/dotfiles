#!/bin/bash
#Warthunder's Ghostty installation script
#Version 1.0

# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed. Please install it to use this script (e.g., sudo apt install dialog)."
    exit 1
fi

# Variables

# Define the Title and the Summary Message
DIALOG_TITLE="WELCOME"

# Use triple quotes for cleaner multi-line strings in the message
SCRIPT_SUMMARY="
Welcome to Warthunder's Ghostty Install Script!

This script is for installing Ghostty on Debian 
based systems.

This script is provided as-is. Press OK to Continue.
"
dialog --clear \
    --title "$DIALOG_TITLE" \
    --msgbox "$SCRIPT_SUMMARY" 15 60 \
    2>&1 >/dev/tty

# Clear the dialog screen upon exit
clear
#Install Base Packages
echo "Installing Depenencies"
dpkg -l | grep -qw git  || sudo apt install -yyq git
dpkg -l | grep -qw wget || sudo apt install -yyq wget
dpkg -l | grep -qw curl || sudo apt install -yyq curl

OPTIONS=(
    1 "Appimage"
    2 "Repository (PPA)"    
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
        echo "Installing Appimage..."
        wget https://github.com/pkgforge-dev/ghostty-appimage/releases/download/v1.2.3/Ghostty-1.2.3-x86_64.AppImage
		# Grab and Make Executable
		chmod a+x Ghostty-${VERSION}-${ARCH}.appimage
		./Ghostty-${VERSION}-${ARCH}.appimage

		# Relocate Appimage to a better location
		mkdir ~/bin
		mv .Ghostty-${VERSION}-${ARCH}.appimage ~/bin/ghostty
		echo "Gostty Installed!"
		
                ;;
     
    2)
        echo "Installing Repository..."

       	sudo apt update
		#Install Packages
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
		
        echo "Ghostty Installed!"

        ;;

    *)
        echo "Script Aborted or Cancelled."
        ;;
esac




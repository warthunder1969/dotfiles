#!/bin/bash
#Warthunder's  installation script
#Version #

# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed. Please install it to use this script (e.g., sudo apt install dialog)."
    exit 1
fi

# Variables
$app=""
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
#Install Base Packages
echo "Installing Depenencies"
dpkg -l | grep -qw wget || sudo apt install -yyq wget
dpkg -l | grep -qw apt-transport-https || sudo apt install -yyq apt-transport-https

OPTIONS=(
    1 "Repository Package (Stable)"
    2 "Tarball (tar.gz)"
    3 "Flatpak (Flathub)"    
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

       echo "Installed!"
		
        ;;
    2)
       echo "Installing..."

       echo "Installed!"
		
        ;;
    3)
       echo "Installing..."

       echo "Installed!"
		
        ;;

    *)
        echo "Script Aborted or Cancelled."
        ;;
esac




#!/bin/bash
#Warthunder's Floorp Browser installation script
#Version 1.1

# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed. Please install it to use this script (e.g., sudo apt install dialog)."
    exit 1
fi

# Variables
app="Floorp"

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
    1 "Repository (PPA)"
    2 "Flatpak (Flathub)"    
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
		
		curl -fsSL https://ppa.floorp.app/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/Floorp.gpg
		sudo curl -sS --compressed -o /etc/apt/sources.list.d/Floorp.list 'https://ppa.floorp.app/Floorp.list'
		sudo apt update
		sudo apt install -yyq floorp
		

		# Check if Package Installed
		if dpkg-query -W -f='${Status}' "floorp" 2>/dev/null | grep -q "ok installed"; then
			  echo "$app is installed"
		else
			  echo "$app was NOT installed"
		fi
		
        ;;

   
    2)
         echo "Installing..."
		dpkg -l | grep -qw flatpak || sudo apt install -yyq flatpak
		flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
		flatpak install flathub one.ablaze.floorp		
		echo "Installed!"

        ;;

    *)
        echo "Script Aborted or Cancelled."
        ;;
esac

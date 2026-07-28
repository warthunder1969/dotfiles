#!/bin/bash
#Warthunder's Netbird installation script
#Version 1.1

# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed. Please install it to use this script (e.g., sudo apt install dialog)."
    exit 1
fi

# Variables
app="netbird"
depends="libgtk-4-1 libwebkitgtk-6.0-4 xdg-utils"
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
    1 "Script (Official)"
    2 "Repository (Deb)"    
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
		sudo apt install $depends
       	curl -fsSL https://pkgs.netbird.io/install.sh | sh
         
		# Check if Package Installed
		if dpkg-query -W -f='${Status}' "netbird" 2>/dev/null | grep -q "ok installed"; then
			  echo "$app is installed"
		else
			  echo "$app was NOT installed"
		fi
		
        ;;

    2)
        echo "Installing..."
		 sudo apt-get update
 		sudo apt-get install ca-certificates curl gnupg -y
 		curl -sSL https://pkgs.netbird.io/debian/public.key | sudo gpg --dearmor --output /usr/share/keyrings/netbird-archive-keyring.gpg
 		echo 'deb [signed-by=/usr/share/keyrings/netbird-archive-keyring.gpg] https://pkgs.netbird.io/debian stable main' | sudo tee /etc/apt/sources.list.d/netbird.list
		sudo apt-get install netbird netbird-ui
 		                    
		# Check if Package Installed
		if dpkg-query -W -f='${Status}' "netbird" 2>/dev/null | grep -q "ok installed"; then
			  echo "$app is installed"
		else
			  echo "$app was NOT installed"
		fi
		
        ;;


    *)
        echo "Script Aborted or Cancelled."
        ;;
esac

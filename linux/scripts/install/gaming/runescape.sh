#!/bin/bash
# Enhanced Installer script for Runescape. Should work for most Debian or Ubuntu based systems
# Version 1.0
#Source: https://www.runescape.com/launcher

# Dependencies

echo "Installing Depenencies"
dpkg -l | grep -qw wget || sudo apt install -yyq wget


# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed. Please install it to use this script (e.g., sudo apt install dialog)."
    exit 1
fi


# Define the Title and the Summary Message
DIALOG_TITLE="WELCOME"

# Use triple quotes for cleaner multi-line strings in the message
SCRIPT_SUMMARY="
Welcome to Runescape Helper Script!

This script will Assist in the install of RuneScape 
on linux. 
Please consult RuneScape for more details:
https://www.runescape.com/launcher
Press OK to Continue.
"

# ------------------------------------------------------------------
# Use the --msgbox command to display the ncurses interface
# Syntax: dialog --msgbox "text" height width
# ------------------------------------------------------------------

dialog --clear \
    --title "$DIALOG_TITLE" \
    --msgbox "$SCRIPT_SUMMARY" 15 60 \
    2>&1 >/dev/tty

# Clear the dialog screen upon exit
clear

echo "The user has acknowledged the summary."

# --- Place your main menu logic (like the 'dialog --menu' from before) here ---
# ...


# Define the menu items: "Tag" "Description"
OPTIONS=(
    1 "Ubuntu/Debian Repo"
    2 "Flatpak (Unofficial)"
   
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
# Define the Title and the Summary Message
DIALOG_TITLE="Runescape Helper Script"

# Use triple quotes for cleaner multi-line strings in the message
SCRIPT_SUMMARY="
This Script Follows the following instructions:
https://www.runescape.com/launcher
Press OK to Continue.
"        
#Add Repository
sudo -s -- << EOF
wget -O - https://content.runescape.com/downloads/ubuntu/runescape.gpg.key | apt-key add -
mkdir -p /etc/apt/sources.list.d
echo "deb https://content.runescape.com/downloads/ubuntu trusty non-free" > /etc/apt/sources.list.d/runescape.list

apt-get update
apt-get install -y runescape-launcher
EOF
		echo "Runescape Installed!"
        ;;
    2)
        echo "Installing Flatpak..."
		flatpak install flathub com.jagex.RuneScape
		echo "RuneScape Installed!"
        ;;
    *)
        echo "Script Aborted or Cancelled."
        ;;
esac

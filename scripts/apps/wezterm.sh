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
    1 "Ubuntu/Debian Repo"
    2 "Flatpak"
    3 "AppImage"
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
        
		#Add Repository
		curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
		echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
		sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
		
		#Install Package
		sudo apt update
		sudo apt install wezterm
        ;;
    2)
        echo "Installing Flatpak..."
		flatpak install flathub org.wezfurlong.wezterm
        ;;
    3)
        echo "Installing Appimage..."
        # /path/to/your/script.sh
		curl -LO https://github.com/wezterm/wezterm/releases/download/20240203-110809-5046fc22/WezTerm-20240203-110809-5046fc22-Ubuntu20.04.AppImage
		chmod +x WezTerm-20240203-110809-5046fc22-Ubuntu20.04.AppImage
		mkdir ~/bin
		mv ./WezTerm-20240203-110809-5046fc22-Ubuntu20.04.AppImage ~/bin/wezterm
        ;;

    *)
        echo "Script Aborted or Cancelled."
        ;;
echo "Wezterm Installed!"
esac

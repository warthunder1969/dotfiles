#!/bin/bash
#Warthunder's QEMU/KVM installation script
#Version 1.2

# Check for Intel VT-x (vmx) or AMD-V (svm) flags in /proc/cpuinfo
if grep -E --color 'vmx|svm' /proc/cpuinfo > /dev/null; then
    echo "Hardware virtualization (Intel VT-x or AMD-V) is ENABLED."
else
    echo "Hardware virtualization (Intel VT-x or AMD-V) is DISABLED."
	echo "Error virtualization is disabled. KVM will not work without virtualization."	
fi
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
Welcome to Warthunder's Wezterm Install Script!

This script is for installing Wezterm on Debian 
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
    1 "Flatpak"
    2 "Appimage"
    3 "Ubuntu/Debian"    
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
        echo "Installing Flatpak..."
		# Install Flatpak
       	dpkg -l | grep -qw git  || sudo apt install -yyq flatpak

		# Add the Flathub repository
       	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

		# Install Wezterm
		flatpak install -y flathub org.wezfurlong.wezterm
		echo "Wezterm Installed!"
		
        ;;

    2)
        echo "Installing Appimage..."
		# Grab and Make Executable
		curl -LO https://github.com/wezterm/wezterm/releases/download/20240203-110809-5046fc22/WezTerm-20240203-110809-5046fc22-Ubuntu20.04.AppImage
		chmod +x WezTerm-20240203-110809-5046fc22-Ubuntu20.04.AppImage

		# Relocate Appimage to a better location
		mkdir ~/bin
		mv ./WezTerm-20240203-110809-5046fc22-Ubuntu20.04.AppImage ~/bin/wezterm
		~/bin/wezterm
		echo "Wezterm Installed!"
		
                ;;
     
    3)
        echo "Installing Repository..."
        
		# Add repository GPG key
		curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
		echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
		sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg

		# Update package list and install Wezterm
		sudo apt update
		sudo apt install wezterm
		echo "Wezterm Installed!"

        ;;

    *)
        echo "Script Aborted or Cancelled."
        ;;
esac




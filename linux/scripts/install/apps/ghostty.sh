#!/bin/bash
#Warthunder's Ghostty installation script
#Version 1.0

# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed. Please install it to use this script (e.g., sudo apt install dialog)."
    exit 1
fi

# Variables
package=ghostty

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
    3 "Repository (ButterRepo)"    
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
        wget https://github.com/pkgforge-dev/ghostty-appimage/releases/download/${VERSION}/Ghostty-${VERSION}-${ARCH}.appimage
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

        if dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q "ok installed"; then
          echo "Ghostty is installed"
        else
          echo "Ghostty is not installed"
        fi

        ;;
   3)
        echo "Installing Repository..."
		sudo rm -f /etc/apt/sources.list.d/helium-deb-repo.list /etc/apt/sources.list.d/zen-deb-repo.list
		sudo rm -f /usr/share/keyrings/helium-deb-repo.gpg /usr/share/keyrings/zen-deb-repo.gpg

       	# Add repository GPG key
       	curl -fsSL https://justaguylinux.codeberg.page/butterrepo/key.asc | sudo gpg --dearmor -o /usr/share/keyrings/butterrepo.gpg
       	
       	# Add repository to sources
       	echo "deb [arch=amd64 signed-by=/usr/share/keyrings/butterrepo.gpg] https://justaguylinux.codeberg.page/butterrepo stable main" | sudo tee /etc/apt/sources.list.d/butterrepo.list
       	
       	# Update package list
       	sudo apt update
       	# Install Packages
       	sudo apt install $package
       	
        if dpkg-query -W -f='${Status}' "$package" 2>/dev/null | grep -q "ok installed"; then
          echo "Ghostty is installed"
        else
          echo "Ghostty is not installed"
        fi

        ;;

    *)
        echo "Script Aborted or Cancelled."
        ;;
esac




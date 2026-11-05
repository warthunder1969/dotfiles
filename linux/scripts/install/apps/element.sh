#!/bin/bash
#Warthunder's Simple Installation Script
#Version 1.1

# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed. Please install it to use this script (e.g., sudo apt install dialog)."
    exit 1
fi

# Variables
app="Element"


# Define Menu and Summary
HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=3
BACKTITLE="Warthunder's $app Installation Script"
TITLE="$app Installer"
MENU="Please choose an Installation Method:"

OPTIONS=(1 "Element Repository"
         2 "Flatpak (Flathub)")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
   1)
        sudo wget -O /usr/share/keyrings/element-io-archive-keyring.gpg https://packages.element.io/debian/element-io-archive-keyring.gpg
		‍
		echo "deb [signed-by=/usr/share/keyrings/element-io-archive-keyring.gpg] https://packages.element.io/debian/ default main" | sudo tee /etc/apt/sources.list.d/element-io.list
		
        sudo apt update
		sudo apt install element-desktop

        if dpkg-query -W -f='${Status}' "element-desktop" 2>/dev/null | grep -q "ok installed"; then
            echo "$app was Installed"
        else
            echo "$app was NOT Installed"
        fi
        ;;

    2)
        dpkg -l | grep -qw flatpak || sudo apt install -yyq flatpak
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        flatpak install flathub im.riot.Riot

        if flatpak install -y flathub net.waterfox.waterfox &&
           flatpak info im.riot.Riot >/dev/null 2>&1; then
            echo "$app was installed."
        else
            echo "$app wasn't installed."
        fi
        ;;

    *)
        echo "Script Aborted or Cancelled."
        ;;
esac

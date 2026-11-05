#!/bin/bash
#Warthunder's Simple Installation Script
#Version 1.1

# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed. Please install it to use this script (e.g., sudo apt install dialog)."
    exit 1
fi

# Variables
app="Fluxer"


# Define Menu and Summary
HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=3
BACKTITLE="Warthunder's $app Installation Script"
TITLE="$app Installer"
MENU="Please choose an Installation Method:"

OPTIONS=(1 "Fluxer Repository"
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
        sudo install -d -m 0755 /etc/apt/keyrings
        sudo curl -fsSL -o /etc/apt/keyrings/fluxer-archive-keyring.gpg \
  https://pkgs.fluxer.com/keys/fluxer-archive-keyring.gpg
        sudo curl -fsSL -o /etc/apt/sources.list.d/fluxer.sources \
  https://pkgs.fluxer.com/deb/fluxer.sources

        sudo apt update
        sudo apt install fluxer

        if dpkg-query -W -f='${Status}' "fluxer" 2>/dev/null | grep -q "ok installed"; then
            echo "$app was Installed"
        else
            echo "$app was NOT Installed"
        fi
        ;;

    2)
        dpkg -l | grep -qw flatpak || sudo apt install -yyq flatpak
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        flatpak install flathub app.fluxer.Fluxer

        if flatpak install -y flathub app.fluxer.Fluxer &&
           flatpak info app.fluxer.Fluxer >/dev/null 2>&1; then
            echo "$app was installed."
        else
            echo "$app wasn't installed."
        fi
        ;;

    *)
        echo "Script Aborted or Cancelled."
        ;;
esac

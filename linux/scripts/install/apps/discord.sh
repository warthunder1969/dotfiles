#!/bin/bash
#Warthunder's Simple Installation Script
#Version 1.3

# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed. Please install it to use this script (e.g., sudo apt install dialog)."
    exit 1
fi

# Variables
app="Discord"


# Define Menu and Summary
HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=5
BACKTITLE="Warthunder's $app Installation Script"
TITLE="$app Installer"
MENU="Please choose an Installation Method:"

OPTIONS=(1 "Official Package (DEB)"
         2 "Flatpak (Flathub)"
         3 "Legcord (Flathub)"
         4 "Webcord (Flathub)")

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
        wget "https://discord.com/api/download?platform=linux&format=deb" -O discord.deb
        dpkg-deb -f discord.deb

        if dpkg-query -W -f='${Status}' "discord" 2>/dev/null | grep -q "ok installed"; then
            echo "$app was Installed"
        else
            echo "$app was NOT Installed"
        fi
        ;;

    2)
        dpkg -l | grep -qw flatpak || sudo apt install -yyq flatpak
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        flatpak install flathub app.legcord.Legcord

        if flatpak install -y flathub app.legcord.Legcord &&
           flatpak info app.legcord.Legcord >/dev/null 2>&1; then
            echo "Legcord was installed."
        else
            echo "Legcord wasn't installed."
        fi
        ;;

    3)
        dpkg -l | grep -qw flatpak || sudo apt install -yyq flatpak
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        flatpak install flathub io.github.spacingbat3.webcord

        if flatpak install -y flathub io.github.spacingbat3.webcord &&
           flatpak info io.github.spacingbat3.webcord >/dev/null 2>&1; then
            echo "Webcord was installed."
        else
            echo "Webcord wasn't installed."
        fi
        ;;

    *)
        echo "Script Aborted or Cancelled."
        ;;
esac

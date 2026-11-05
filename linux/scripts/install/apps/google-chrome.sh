#!/bin/bash
#Warthunder's Simple Installation Script
#Version 1.1

# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed. Please install it to use this script (e.g., sudo apt install dialog)."
    exit 1
fi

# Variables
app="Google Chrome"


# Define Menu and Summary
HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=3
BACKTITLE="Warthunder's $app Installation Script"
TITLE="$app Installer"
MENU="Please choose an Installation Method:"

OPTIONS=(1 "Official Package (DEB)"
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
        wget "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -O chrome.deb
        dpkg-deb -f chrome.deb

        if dpkg-query -W -f='${Status}' "google-chrome-stable" 2>/dev/null | grep -q "ok installed"; then
            echo "$app was Installed"
        else
            echo "$app was NOT Installed"
        fi
        ;;

    2)
        dpkg -l | grep -qw flatpak || sudo apt install -yyq flatpak
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        flatpak install flathub com.google.Chrome

        if flatpak install -y flathub com.google.Chrome &&
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

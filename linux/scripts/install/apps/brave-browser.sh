#!/bin/bash
#Warthunder's Simple Installation Script
#Version 1.2

# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed. Please install it to use this script (e.g., sudo apt install dialog)."
    exit 1
fi

# Variables
app="Brave"


# Define Menu and Summary
HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=5
BACKTITLE="Warthunder's $app Installation Script"
TITLE="$app Installer"
MENU="Please choose an Installation Method:"

OPTIONS=(1 "Repository (Brave)"
         2 "Flatpak (Flathub)"
         3 "Repository (Brave Origon)")

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
        sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
  https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

        sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources \
  https://brave-browser-apt-release.s3.brave.com/brave-browser.sources

        sudo apt update
        sudo apt install brave-browser

        if dpkg-query -W -f='${Status}' "brave-browser-stable" 2>/dev/null | grep -q "ok installed"; then
            echo "$app was Installed"
        else
            echo "$app was NOT Installed"
        fi
        ;;

    2)
        dpkg -l | grep -qw flatpak || sudo apt install -yyq flatpak
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        flatpak install flathub com.brave.Browser

        if flatpak install -y flathub com.brave.Browser &&
           flatpak info com.brave.Browser >/dev/null 2>&1; then
            echo "$app was installed."
        else
            echo "$app wasn't installed."
        fi
        ;;

    3)
        sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
  https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

        sudo curl -fsSLo /etc/apt/sources.list.d/brave-browser-release.sources \
  https://brave-browser-apt-release.s3.brave.com/brave-browser.sources

        sudo apt update
        sudo apt install brave-origon

        if dpkg-query -W -f='${Status}' "brave-origon" 2>/dev/null | grep -q "ok installed"; then
            echo "$app was Installed"
        else
            echo "$app was NOT Installed"
        fi
        ;;

    *)
        echo "Script Aborted or Cancelled."
        ;;
esac

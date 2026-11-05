#!/bin/bash
#Warthunder's Simple Installation Script
#Version 1.0

# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed. Please install it to use this script (e.g., sudo apt install dialog)."
    exit 1
fi

# Variables
app="XFCE Docklike Taskbar"


# Define Menu and Summary
HEIGHT=15
WIDTH=40
CHOICE_HEIGHT=2
BACKTITLE="Warthunder's $app Installation Script"
TITLE="$app Installer"
MENU="Please choose an Installation Method:"

OPTIONS=(1 "Xubuntu PPA")

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
        sudo add-apt-repository ppa:xubuntu-dev/extras
        sudo apt update
        sudo apt install xfce4-docklike-plugin

        if dpkg-query -W -f='${Status}' "xfce4-docklike-plugin" 2>/dev/null | grep -q "ok installed"; then
            echo "$app was Installed"
        else
            echo "$app was NOT Installed"
        fi
        ;;

    

    *)
        echo "Script Aborted or Cancelled."
        ;;
esac

#!/bin/bash
# Post Installation script for My Linux Mint Systems.
# Useage is not recomended unless you know what you are doing. That being said Debian-Based should work just fine
# Version 0.1

# === Dependencies ===
if ! command -v dialog >/dev/null 2>&1; then
    sudo apt update && sudo apt install -y dialog
fi

if ! command -v apt >/dev/null 2>&1; then
    echo "apt not found." >&2
    exit 1
fi

# === Variables ===
## Base
pkg-base="curl git wget micro htop btop nvtop s-tui duf btm eza nala cmatrix starship fastfetch vlc fonts-noto fonts-jetbrains-mono"
flat-base="io.m51.Gelly"
## Production
pkg-prod="nextcloud-desktop keepassxc dconf-editor virt-viewer gimp"
flat-prod="com.github.tchx84.Flatseal com.notesnook.Notesnook org.localsend.localsend_app"
## Gaming
pkg-game="steam-installer"
flat-game="net.lutris.Lutris com.heroicgameslauncher.hgl net.davidotek.pupgui2"
## Coding
pkg-code="build-essential gcc make python3 python3-pip"
flat-code=""

# === Functions ===
pkgmgr(){
    if command -v apt > /dev/null 2>&1; then
        cmd="apt install -y"
    elif command -v dnf > /dev/null 2>&1; then
        cmd="dnf install -y"
    elif command -v zypper > /dev/null 2>&1; then
        cmd="zypper in -y"
    elif command -v pacman > /dev/null 2>&1; then
        cmd="pacman -S"
    else
        echo "Error.No known package manager found"
    fi
}

# === Main Menu ===
show_main_menu() {
    while true; do
        CHOICE=$(dialog --clear --backtitle "Warthunder's Post-Installation Script" \
            --title "Select Task" \
            --menu "Choose a profile to install:" 15 50 6 \
    "1" "Essentials" \
    "2" "Production Apps" \
    "3" "Gaming" \
    "4" "Coding/Development" \
    "5" "Exit" 3>&1 1>&2 2>&3
}

# Logic Loop
while true; do
    CHOICE=$(show_main_menu)

    case $CHOICE in
1)          #Essentials
    sudo $pkgmgr $pkg-base
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -O $HOME/chrome.deb
    #Chrome
	sudo $pkgmgr $HOME/chrome.deb
	rm $HOME/chrome.deb
	#Discord
	wget -O $HOME/discord.deb "https://discord.com/api/download?platform=linux"
	sudo $pkgmgr $HOME/discord.deb
	rm ~/discord.deb
	#Fluxer
	wget https://api.fluxer.app/dl/desktop/stable/linux/x64/latest/deb -O $HOME/fluxer.deb
    sudo $pkgmgr $HOME/fluxer.deb
    rm $HOME/fluxer.deb

                sleep 2
            ;;
2)         #Production
    sudo $pkgmgr $pkg-prod
    #Super Productivity
    wget https://github.com/johannesjo/super-productivity/releases/latest/download/superProductivity-amd64.deb -O $HOME/superProductivity.deb
	sudo $pkgmgr $HOME/superProductivity.deb
	rm $HOME/superProductivity.deb
            sleep 2
            ;;
3)         #Gaming
    sudo $pkgmgr $pkg-game
            sleep 2
4)         #Coding
    sudo $pkgmgr $pkg-code
    curl -f https://zed.dev/install.sh | sh
            sleep 2
            ;;
        5|"") # Exit if 4 is chosen or if the user hits 'Cancel'
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done

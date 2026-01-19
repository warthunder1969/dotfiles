#!/bin/bash
# Installer script for Linux Mint. Should work for most Debian or Ubuntu based systems
#Inspired by TheLinuxCast openSuse Install script
# Version 2.0

# Dependencies
# git
# wget
# curl
echo "Installing Depenencies"
dpkg -l | grep -qw git  || sudo apt install -yyq git
dpkg -l | grep -qw wget || sudo apt install -yyq wget
dpkg -l | grep -qw curl || sudo apt install -yyq curl

## Variables
config="$HOME/.config"
dotfiles="https://codeberg.org/warthunder1969/dotfiles.git"
packages="./packages.txt"
flatpaks="./flatpaks.txt"
scripts="$HOME/.local/share/nemo/scripts"
icons="$HOME/.icons"
themes="$HOME/.theme"

# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed. Please install it to use this script (e.g., sudo apt install dialog)."
    exit 1
fi


# Define the Title and the Summary Message
DIALOG_TITLE="WELCOME"

# Use triple quotes for cleaner multi-line strings in the message
SCRIPT_SUMMARY="
Welcome to Warthunder's Post-Install Script!

This script is for doing the following actions:

1. Provide a central menu for activating setup scripts.
2. Execute specific configuration for my Linux Mint.
3. Ensure prerequisites are met before running the main task.

This script is provided as-is. Press OK to Continue.
"

# ------------------------------------------------------------------
# Use the --msgbox command to display the ncurses interface
# Syntax: dialog --msgbox "text" height width
# ------------------------------------------------------------------

dialog --clear \
    --title "$DIALOG_TITLE" \
    --msgbox "$SCRIPT_SUMMARY" 15 60 \
    2>&1 >/dev/tty

# Clear the dialog screen upon exit
clear

echo "The user has acknowledged the summary."

# --- Place your main menu logic (like the 'dialog --menu' from before) here ---
# ...

# Define the menu items: "Tag" "Description"
OPTIONS=(
    1 "Apply System Updates & Mirrors"
    2 "Install Packages"
    3 "Load Configuration Files"
)

# Use dialog to display a menu box and capture the user's choice
CHOICE=$(dialog --clear --title "Warthunder's Post-Installation Script" \
    --menu "Choose an Action to Preform:" 15 50 4 "${OPTIONS[@]}" \
    2>&1 >/dev/tty)

# Clear the dialog screen upon exit
clear

# Execute based on the user's choice
case $CHOICE in
    1)
        echo "Applying Updates..."
        # /path/to/your/script.sh
        sudo apt update
        dpkg -l | grep -qw nala  || sudo apt install -yyq nala
        sudo nala fetch --auto -y
        sudo nala upgrade -y && sudo flatpak update -y && cinnamon-spice-updater --update-all && sudo mintupdate-cli refresh-cache

        ;;
    2)
        echo "Installing Packages..."
        
        # Repository Packages
        xargs sudo apt-get -y install < $packages
        
        # Flatpak Packages
        xargs flatpak install -y < $flatpaks

        # Compiled Apps
        # Snap Packages
        # Appimages
        # MS Fonts
        sudo apt install -yy ttf-mscorefonts-installer
        #Nerd Fonts
        wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip \
        && cd ~/.local/share/fonts \
        && unzip JetBrainsMono.zip \
        && rm JetBrainsMono.zip \
        && fc-cache -fv
        ;;
    3)
        echo "Loading System Configuration..."
        # /path/to/your/script.sh
        # Set Reasonable Flaptak gloal permissions
        sudo flatpak override --device=dri
        sudo flatpak override --filesystem=home
        
        # Load in settings through dconf
        dconf load /com/gexperts/Tilix/ < $HOME/dotfiles/config/tilix.dconf
        dconf load /org/cinnamon/ < $HOME/dotfiles/config/cinnamon/cinnamon
        dconf load /org/cinnamon/desktop/keybindings/ < $HOME/dotfiles/config/cinnamon/keybindings
        ## Themes
        gsettings set org.cinnamon.desktop.interface icon-theme "Mint-Y"
        gsettings set org.cinnamon.desktop.interface gtk-theme "Mint-Y-Dark"
        gsettings set org.cinnamon.theme name "Mint-Y-Dark"
        cp -r $HOME/dotfiles/themes/icons/lm-logo-*.png $icons
        ;;

    *)
        echo "Script Aborted or Cancelled."
        ;;
esac

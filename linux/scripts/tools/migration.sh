#!/bin/bash
# Symlink migration script for relinking all my dotfiles to the proper directories. Useage is not recomended unless you know what you are doing.
# Version 0.1

# === Dependencies ===
# Ensure whiptail is installed
if ! command -v whiptail >/dev/null 2>&1; then
    sudo apt update && sudo apt install -y whiptail
fi

# === Variables ===
config="$HOME/.config"
dotclone="https://codeberg.org/warthunder1969/dotfiles.git"
dotgit="$HOME/Nextcloud/Projects/git/dotfiles"
nextcloud="$HOME/Nextcloud"
dotconfig="$HOME/Nextcloud/Projects/configs/linux"


# === Functions ===

loc_nextcloud(){
    if [ -d "$nextcloud" ]; then
        echo "$nextcloud exists."
    else
        echo "$nextcloud is missing."
    fi
}

loc_git(){
    if [ -d "$dotgit" ]; then
        echo "$dotgit exists."
    else
        echo "$dotgit is missing."
    fi
}

loc_configs(){
    if [ -d "$dotconfig" ]; then
        echo "$dotconfig exists."
    else
        echo "$dotconfig is missing."
    fi
}


# === Main Menu ===
show_main_menu() {
    whiptail --title "Warthunder's Symlink Migration Script" --menu "Choose an action:" 15 60 4 \
    "1" "Check For Existing Directories" \
    "2" "Apply Symlinks (Nextcloud Sync)" \
    "3" "Apply Symlinks (via Git Clone)" \
    "4" "Exit" 3>&1 1>&2 2>&3
}

# Logic Loop
while true; do
    CHOICE=$(show_main_menu)

    case $CHOICE in
1)
            echo "Checking..."
            loc_nextcloud
            loc_git
            loc_configs
            read -p "Press enter to continue..."
            ;;            
        2)  
            echo "Applying Symlinks..."
            # Private Dots
            ln -sf $dotconfig/gtk-3.0/bookmarks /home/war/.config/gtk-3.0/bookmarks
            ln -sf $dotconfig/Apps $HOME/Desktop
            ln -sf $dotconfig/Games $HOME/Desktop
            # Public Dots
            ln -sf $dotgit/linux/scripts/tools $HOME/Desktop/Tools
            ln -sf $dotgit/linux/config/fastfetch/config.jsonc $config/fastfetch/config.jsonc
            ln -sf $dotgit/linux/config/bashrc $HOME/.bashrc
            ln -sf $dotgit/linux/config/starship.toml $config/starship.toml
		
            echo "Done!"
            sleep 2
            ;;
        3)  
            echo "Applying Symlinks..."
            # Public Dots
            ln -sf $dotclone/linux/scripts/tools $HOME/Desktop/Tools
            ln -sf $dotclone/linux/config/fastfetch/config.jsonc $config/fastfetch/config.jsonc
            ln -sf $dotclone/linux/config/bashrc $HOME/.bashrc
            ln -sf $dotclone/linux/config/starship.toml $config/starship.toml
		
            echo "Done!"
            sleep 2
            ;;
        4|"") # Exit if 4 is chosen or if the user hits 'Cancel'
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done


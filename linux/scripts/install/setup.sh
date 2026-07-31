#!/bin/bash
# TUI Installer for making Debian-based Distros work for me after install(like Linux Mint.) 
# Version 0.1

# === System Functions === #

get_os() {
    case "$OSTYPE" in
        linux*)
            if command -v apt > /dev/null 2>&1; then
                echo "apt is available"
            else
                echo "apt is not available"
            fi   
            ;; 
    esac
}

update_system() {
    # Apply System Updates
    sudo apt update && sudo apt upgrade -y
}

install_profile() {
    # Define profiles: Tag Description Status
    clear
    local options=(
        "basic"    "Essential Utilities and Fonts" ON
        "prod"    "Production And Communication" OFF
        "code"     "Coding Suite (git / editor)" OFF
        "gaming"   "Gaming Tools (Steam, Lutris)" OFF
        "utils"    "System Utilities (Tweak Tool, GParted)" OFF
    )

    # Show Checklist
    # --separate-output returns each selected tag on a new line
    local selections
    selections=$(whiptail --title "Install Profiles" \
        --checklist "Select profiles to install (Space to toggle):" \
        20 78 12 \
        "${options[@]}" \
        3>&1 1>&2 2>&3 --separate-output)

    local exitstatus=$?

    if [ $exitstatus = 0 ]; then
        if [ -z "$selections" ]; then
            whiptail --msgbox "No profiles selected." 8 78
            return
        fi

        # Process each selected profile
        while IFS= read -r profile; do
            case "$profile" in
                "basic")
                    echo "Installing  Essential Packages..."
                    #Repository Packages
                    sudo apt install -y git curl wget micro htop btop nvtop eza nala cmatrix cpufetch fastfetch vlc fonts-noto-color-emoji libfreetype6 fontconfig libcairo2
                    #Flatpaks
                    flatpak install -y io.m51.Gelly dev.vencord.Vesktop app.fluxer.Fluxer im.riot.Riot
                    # 3rd Party  Packages
                    #Browser
                    curl -fsS https://dl.brave.com/install.sh | FLAVOR=origin sh
                    
                    #Terminal
                    curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
                    echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
                    sudo chmod 644 /usr/share/keyrings/wezterm-fury.gpg
                    sudo apt update
                    sudo apt install wezterm -y                
                      
                    ;;
                "prod")
                    echo "Installing Production Applications..."
                    # Repository Packages
                    sudo apt install -y nextcloud-desktop keepassxc dconf-editor virt-viewer
                    #Flatpaks
                    flatpak install -y com.github.tchx84.Flatseal org.localsend.localsend_app org.gimp.GIMP
                    #3rd Party Packages
                    
                    ;;
                "code")
                    echo "Installing Coding Suite..."
                     # Repository Packages
                    sudo apt install -y build-essential gcc make python3 python3-pip
                    
                    #3td Party Packages
                    #Fresh Editor
                    curl -sL $(curl -s https://api.github.com/repos/sinelaw/fresh/releases/latest | grep "browser_download_url.*_$(dpkg --print-architecture)\.deb" | cut -d '"' -f 4) -o fresh-editor.deb && sudo dpkg -i fresh-editor.deb
                    #lazygit
                    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
                    LAZYGIT_ARCH=$(uname -m | sed -e 's/aarch64/arm64/')
                    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${LAZYGIT_ARCH}.tar.gz"
                    tar xf lazygit.tar.gz lazygit
                    sudo install lazygit -D -t /usr/local/bin/
                    ;;
                "gaming")
                    echo "Installing Gaming Tools..."
                    # Repository Packages
                    sudo apt install -y steam
                    #Flatpaks
                    flatpak net.lutris.Lutris com.heroicgameslauncher.hgl net.davidotek.pupgui2 io.github.Faugus.faugus-launcher
                    ;;
                "utils")
                    echo "Installing Utilities..."
                    sudo apt install -y s-tui duf gparted gnome-firmware
                    ;;
            esac
        done <<< "$selections"

        whiptail --msgbox "Profile installation complete." 8 78
        clear
    else
        whiptail --msgbox "Profile selection cancelled." 8 78
        clear
    fi
}   

load_config() {
    echo "Loading config..."
    
    
    # Flatpak Overrides for a Good Time
    sudo flatpak override --device=dri
    sudo flatpak override --filesystem=$HOME/Nextcloud:ro
    sudo flatpak override --filesystem=xdg-documents:ro
    sudo flatpak override --filesystem=xdg-download
    sudo flatpak override --filesystem=xdg-music:ro
    sudo flatpak override --filesystem=xdg-pictures:ro
    sudo flatpak override --filesystem=xdg-videos:ro
    
    ## Themes
    gsettings set org.cinnamon.desktop.interface icon-theme "Mint-Y"
    gsettings set org.cinnamon.desktop.interface gtk-theme "Mint-Y-Dark"
    gsettings set org.cinnamon.theme name "Mint-Y-Dark"
	##Fonts
	gsettings set org.cinnamon.desktop.interface font-name "Noto Sans Regular 10"
	gsettings set org.nemo.desktop font "Noto Sans Regular 12"
	gsettings set org.cinnamon.desktop.interface monospace-font-name "Noto Sans Mono Regular 10"
	gsettings set org.cinnamon.desktop.wm.preferences titlebar-font "Noto Sans Bold 10"
		    
    
}

cleanup() {
    # Begin Cleanup
    sudo apt autoremove --purge && sudo apt clean   
    dpkg --list | grep "^rc"
    dpkg --list | grep "^rc" | awk '{print $2}' | sudo xargs -r dpkg --purge
    flatpak uninstall --unused --delete-data   
    
}

# === Dependencies === #
if ! command -v whiptail >/dev/null 2>&1; then
    sudo apt update && sudo apt install -y whiptail
fi

# === Main Menu === #
clear
CHOICE=$(whiptail --title "System Setup" --menu "Choose an action:" 15 60 5 \
    "1" "Update System" \
    "2" "Install Package Profiles" \
    "3" "Load Settings" \
    "4" "Exit" \
    3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ]; then
    case $CHOICE in
        1) 
            echo "Updating System..." 
            update_system 
            ;;
        2) 
            echo "Loading Profiles..." 
            install_profile
            ;; 
        3) 
            echo "Load Preferences..." 
            load_config 
            ;;
        4) 
            echo "Performing Cleanup..." 
            cleanup 
            ;;
        *) 
            exit 0 
            ;;
    esac 
else
    echo "User canceled."
fi   

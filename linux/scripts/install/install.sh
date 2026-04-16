#!/bin/bash
# Installer script for Linux Mint. Should work for most Debian or Ubuntu based systems
#Inspired by TheLinuxCast openSuse Install script
# Version 3.4

# === Dependencies ===
# Ensure whiptail is installed
if ! command -v whiptail >/dev/null 2>&1; then
    sudo apt update && sudo apt install -y whiptail
fi

# Detect package manager(s)
pkg_detect(){
  if ! command -v apt >/dev/null 2>&1; then echo "apt not found." >&2; exit 1; fi
  if ! command -v flatpak >/dev/null 2>&1; then echo "flatpak not found." >&2; exit 1; fi
}

# === Variables ===
config="$HOME/.config"
dotfiles="https://codeberg.org/warthunder1969/dotfiles.git"

# === Profiles ===
## CORE
apt_core=(curl git wget micro htop btop nvtop s-tui duf eza nala cmatrix cpufetch fastfetch cheese vlc fonts-noto fonts-jetbrains-mono fonts-crosextra-carlito fonts-crosextra-caladea)
flat_core=(com.discordapp.Discord)

## PRODUCTION 
apt_prod=(nextcloud-desktop keepassxc dconf-editor virt-viewer)
flat_prod=(com.github.tchx84.Flatseal com.notesnook.Notesnook org.localsend.localsend_app org.gimp.GIMP)

## GAMING 
apt_gaming=(steam-installer)
flat_gaming=(net.lutris.Lutris com.heroicgameslauncher.hgl net.davidotek.pupgui2)

## CODING 
apt_coding=(build-essential gcc make python3 python3-pip)
flat_coding=(com.vscodium.codium)

## VIRTUALIZATION
apt_virt=(gnome-boxes qemu-kvm)

# === Main Menu ===
show_main_menu() {
    whiptail --title "Warthunder's Post-Install Script" --menu "Choose an action:" 15 60 5 \
    "1" "Update & Upgrade System" \
    "2" "Install Software Suites" \
    "3" "Configure System Settings" \
    "4" "Cleanup & Optimize" \
    "5" "Exit" 3>&1 1>&2 2>&3
}

# Logic Loop
while true; do
    CHOICE=$(show_main_menu)

    case $CHOICE in
        1)
            echo "Updating system..."
            sudo apt update && sudo apt upgrade -y && flatpak update -y && cinnamon-spice-updater --update-all && sudo mintupdate-cli refresh-cache
            read -p "Press enter to continue..."
            ;;
        2)
            clear
            CHOICES=$(whiptail --title "System Persona Selection" --checklist \
            "Select the profiles for this machine (Space to toggle):" 15 60 5 \
            "CORE" "Basic Apps, CLI tools" ON \
			"PRODUTION" "Essential Apps I Use" ON \
            "GAMING" "Steam + Lutris/Heroic" OFF \
            "CODING" "Compilers + Coding Tools" OFF \
            "VIRTUALIZATION" "Virtual Machine Managers" OFF \
            3>&1 1>&2 2>&3)

            # Exit if Cancel is pressed
            [ $? -ne 0 ] && exit 1
           # Logic Gates
            FINAL_APT=()
            FINAL_FLAT=()

            if [[ $CHOICES =~ "CORE" ]]; then
                FINAL_APT+=("${apt_core[@]}")
                FINAL_FLAT+=("${flat_core[@]}")
            fi

			if [[ $CHOICES =~ "PROD" ]]; then
                FINAL_APT+=("${apt_prod[@]}")
                FINAL_FLAT+=("${flat_prod[@]}")
            fi

            if [[ $CHOICES =~ "GAMING" ]]; then
                FINAL_APT+=("${apt_gaming[@]}")
                FINAL_FLAT+=("${flat_gaming[@]}")
            fi

            if [[ $CHOICES =~ "CODING" ]]; then
                FINAL_APT+=("${apt_coding[@]}")
                FINAL_FLAT+=("${flat_coding[@]}")
            fi
            
            if [[ $CHOICES =~ "VIRTUALIZATION" ]]; then
                            FINAL_APT+=("${apt_virt[@]}")
                        fi
            #Execute
            # Install APT Packages
            if [ ${#FINAL_APT[@]} -gt 0 ]; then
                echo "Installing System Packages..."
                sudo apt update
                sudo apt install -y "${FINAL_APT[@]}"
            fi

            # Install Flatpaks
            if [ ${#FINAL_FLAT[@]} -gt 0 ]; then
            echo "Installing Flatpaks..."
            # Ensure Flathub is enabled
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            flatpak install flathub "${FINAL_FLAT[@]}" -y
            fi

			# Non-Repository Packages
			read -p "Do you want Google Chrome? (y/n): " response
			
			if [[ "$response" == "y" || "$response" == "Y" ]]; then
			  wget -P /tmp https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
			  sudo apt install /tmp/google-chrome-stable_current_amd64.deb
			  rm /tmp/google-chrome-stable_current_amd64.deb
			else
			    echo "Chrome not installed."
			    exit 1
			fi

			read -p "Do you want Fluxer? (y/n): " response
						
			if [[ "$response" == "y" || "$response" == "Y" ]]; then
			  wget -OP fluxer.deb /tmp https://api.fluxer.app/dl/desktop/stable/linux/x64/latest/deb
			  sudo apt install /tmp/fluxer.deb
			  rm /tmp/fluxer.deb
			else
			  echo "Fluxer not installed."
			exit 1
			fi
			
            echo "Done!"
            sleep 2
            ;;
        3)
        echo "Loading System Configuration..."
        # Set Reasonable Flaptak gloal permissions
        sudo flatpak override --device=dri
        sudo flatpak override --filesystem=home
        flatpak override --user --filesystem=xdg-config/gtk-4.0
        sudo flatpak override --filesystem=xdg-config/gtk-4.0

        #Aquire dotfiles
        cd $HOME
        git clone $dotfiles

        #Import Core Settings & Keybindings:
        dconf load /org/cinnamon/ < $HOME/dotfiles/config/cinnamon/cinnamon.dconf
        dconf load /org/cinnamon/desktop/keybindings/ < $HOME/dotfiles/config/cinnamon/keybindings.dconf
		
        ## Themes
        gsettings set org.cinnamon.desktop.interface icon-theme "Mint-Y"
        gsettings set org.cinnamon.desktop.interface gtk-theme "Mint-Y-Dark"
        gsettings set org.cinnamon.theme name "Mint-Y-Dark"
		##Fonts
		gsettings set org.cinnamon.desktop.interface font-name "Noto Sans Regular 10"
		gsettings set org.nemo.desktop font "Noto Sans Regular 12"
		gsettings set org.cinnamon.desktop.interface monospace-font-name "Noto Sans Mono Regular 10"
		gsettings set org.cinnamon.desktop.wm.preferences titlebar-font "Noto Sans Bold 10"
		
        cp -r $HOME/dotfiles/themes/icons/lm-logo-*.png $HOME/.local/share/icons/

        # MS Fonts
        sudo apt install -yy ttf-mscorefonts-installer
        fc-cache -fv
            echo "Done!"
            sleep 2
            ;;
        4)
            echo "Cleaning up..."
            sudo apt autoremove -y && sudo apt clean
            flatpak uninstall --unused --delete-data
            read -p "Press enter to continue..."
            ;;
        5|"") # Exit if 5 is chosen or if the user hits 'Cancel'
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option"
            ;;
    esac
done


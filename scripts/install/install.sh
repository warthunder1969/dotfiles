#bin/bash
# Installer script for Linux Mint. Should work for most Debian or Ubuntu based systems
#Inspired by TheLinuxCast openSuse Install script
# Version 1.0

# Dependencies
# git
# wget
# curl

# Variables
config="$HOME/.config"
dotfiles="http://github.com/warthunder1969/dotfiles.git"
packages="./packages.txt"
flatpaks="./flatpaks.txt"
scripts="$HOME/.local/share/nemo/scripts"
icons="$HOME/.icons"
themes="$HOME/.theme"

# Make some Directories

mkdir -p $icons
mkdir -p $themes

# Native Packages via Apt
sudo apt update
sudo apt install -y $(< $packages) 

# Flatpaks

flatpak install -y $(< $flatpaks)

# Pull down Dotfiles

cd $HOME

git clone $dotfiles

# Pulling in dots to the right directories

cp -r $HOME/dotfiles/config/gtk-3.0 $config
cp -r $HOME/dotfiles/config/fastfetch $config
cp -r $HOME/dotfiles/config/bashrc $HOME/.bashrc
cp -r $HOME/dotfiles/scripts/tools/*.sh $scripts
cp -r $HOME/dotfiles/themes/logos/*.png $icons

# Load in cinnamon settings through dconf

dconf load /org/cinnamon/desktop/keybindings/ < $HOME/dotfiles/config/cinnamon/keybinds
dconf load /org/cinnamon/ < $HOME/dotfiles/config/cinnamon/cinnamon
#Cinnamon Applets (doesn't work yet)
#wget --directory-prefix=$config/cinnamon/spices/ https://cinnamon-spices.linuxmint.com/files/applets/scripts@paucapo.com.zip
#wget --directory-prefix=$config/cinnamon/spices/ https://cinnamon-spices.linuxmint.com/files/applets/notification-mute@jgillula.zip
#wget --directory-prefix=$config/cinnamon/spices/ https://cinnamon-spices.linuxmint.com/files/applets/weather@mockturtl.zip
#unzip $config/cinnamon/spices/scripts@paucapo.com.zip
#unzip $config/cinnamon/spices/notification-mute@jgillula.zip
#unzip $config/cinnamon/spices/weather@mockturtl.zip
#rm $config/cinnamon/spices/*.zip

#Set Theme to Dark
gsettings set org.cinnamon.desktop.interface icon-theme "Mint-Y"
gsettings set org.cinnamon.desktop.interface gtk-theme "Mint-Y-Dark"
gsettings set org.cinnamon.theme name "Mint-Y-Dark"

#Nerd Fonts
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip \
&& cd ~/.local/share/fonts \
&& unzip JetBrainsMono.zip \
&& rm JetBrainsMono.zip \
&& fc-cache -fv

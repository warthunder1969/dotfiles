#bin/bash
# Installer script for Linux Mint. Should work for most Debian or Ubuntu based systems
#Inspired by TheLinuxCast openSuse Install script
# Version 1.1

# Dependencies
# git
# wget
# curl

sudo apt update
sudo apt upgrade -y

## Variables
config="$HOME/.config"
dotfiles="http://github.com/warthunder1969/dotfiles.git"
packages="./packages.txt"
flatpaks="./flatpaks.txt"
dependencies="./dependencies.txt"
scripts="$HOME/.local/share/nemo/scripts"
icons="$HOME/.icons"
themes="$HOME/.theme"

# Make some Directories

mkdir -p $icons
mkdir -p $themes

# Native Packages via Apt
sudo apt update
xargs sudo apt-get -y install < $packages
xargs sudo apt-get -y install < $dependencies

#Install Non-Native Packages via DPKG
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.44.0/fastfetch-linux-amd64.deb
sudo dpkg -i *.deb

## Flatpaks
xargs flatpak install -y < $flatpaks

#set flaptak gloal permissions
sudo flatpak override --device=dri
sudo flatpak override --filesystem=home

## Dotfiles

cd $HOME

#git clone $dotfiles

# Pulling in dots to the right directories

cp -r $HOME/dotfiles/config/gtk-3.0 $config
cp -r $HOME/dotfiles/config/fastfetch $config
cp -r $HOME/dotfiles/config/bashrc $HOME/.bashrc
cp -r $HOME/dotfiles/config/starship.toml $config
cp -r $HOME/dotfiles/scripts/tools/*.sh $scripts
cp -r $HOME/dotfiles/themes/icons/*.png $icons

# Load in cinnamon settings through dconf

dconf load /org/cinnamon/desktop/keybindings/ < $HOME/dotfiles/config/cinnamon/keybinds
dconf load /org/cinnamon/ < $HOME/dotfiles/config/cinnamon/cinnamon
#cinnamon --replace &
## Themes
gsettings set org.cinnamon.desktop.interface icon-theme "Mint-Y"
gsettings set org.cinnamon.desktop.interface gtk-theme "Mint-Y-Dark"
gsettings set org.cinnamon.theme name "Mint-Y-Dark"

#Nerd Fonts
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip \
&& cd ~/.local/share/fonts \
&& unzip JetBrainsMono.zip \
&& rm JetBrainsMono.zip \
&& fc-cache -fv

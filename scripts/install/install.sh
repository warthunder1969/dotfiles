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

mkdir -p $HOME/{Downloads,Documents,Pictures,Music,Templates,Videos,$icons,$themes}

# Native Packages via Apt

sudo apt install -y $(< "$packages") 

# Flatpaks

flatpak install -y $(< "$flatpaks")

# Pull down Dotfiles

cd $HOME

git clone $dotfiles

# Pulling in dots to the right directories

cp -r $HOME/dotfiles/config/gtk-3.0 $config
cp -r $HOME/dotfiles/config/fastfetch $config
cp -r $HOME/dotfiles/config/bashrc $HOME/.bashrc $HOME
cp -r $HOME/dotfiles/scripts/tools/*.sh $scripts
cp -r $HOME/dotfiles/themes/logos/*.png $icons
#cp -r $HOME/dotfiles/themes/Mintyz.zip $themes
#dpkg -i $HOME/dotfiles/themes/Mint/*.deb

dconf load /org/cinnamon/desktop/keybindings/ < $HOME/dotfiles/config/cinnamon/keybinds
dconf load /org/cinnamon/ < $HOME/dotfiles/config/cinnamon/cinnamon
#figure out how to do applets, probably some wget nonsense

#Nerd Fonts
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip \
&& cd ~/.local/share/fonts \
&& unzip JetBrainsMono.zip \
&& rm JetBrainsMono.zip \
&& fc-cache -fv

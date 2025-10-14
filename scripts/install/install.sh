#bin/bash
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

sudo apt update
sudo apt upgrade -y

## Variables
config="$HOME/.config"
dotfiles="https://codeberg.org/warthunder1969/dotfiles.git"
packages="./packages.txt"
flatpaks="./flatpaks.txt"
scripts="$HOME/.local/share/nemo/scripts"
icons="$HOME/.icons"
themes="$HOME/.theme"

# Make some Directories

mkdir -p $icons
mkdir -p $themes

cd $HOME
# Go Get Dotfiles
git clone $dotfiles

# Repository Packages
xargs sudo apt-get -y install < $packages

# Deb Packages
wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.44.0/fastfetch-linux-amd64.deb #This won't be needed after LMDE 7 and Mint 23
sudo dpkg -i *.deb
sudo rm -rf *.deb


#Compiled Apps
#cd $HOME/Downloads

#cd $HOME

## Flatpak Packages
xargs flatpak install -y < $flatpaks

#set flaptak gloal permissions
sudo flatpak override --device=dri
sudo flatpak override --filesystem=home

## Snap Packages

## Appimages

## Loading Dotfiles
# Pulling in dots to the right directories

#cp -r $HOME/dotfiles/config/gtk-3.0/bookmarks $config/gtk-3.0
#cp -r $HOME/dotfiles/config/fastfetch $config
#cp -r $HOME/dotfiles/config/bashrc $HOME/.bashrc
#cp -r $HOME/dotfiles/config/starship.toml $config
#cp -r $HOME/dotfiles/scripts/tools/*.sh $scripts
cp -r $HOME/dotfiles/themes/icons/lm-logo-*.png $icons

# Symlinks
#In the Event you prefer symlinks 
#ln -sf <target_path> <link_path>

#Desktop Shortcuts
ln -s $HOME/Documents $HOME/Desktop/Documents
ln -s $HOME/Pictures $HOME/Desktop/Pictures
ln -s $HOME/Videos $HOME/Desktop/Videos

# Dotfiles
#ln -sf $HOME/Nextcloud/Projects/Linux/dotfiles $HOME #Uncommend for Systems that run Nextcloud & sync dotfiles locally
ln -sf $HOME/dotfiles/config/gtk-3.0/bookmarks $config/gtk-3.0/bookmarks
ln -sf $HOME/dotfiles/config/fastfetch $config
ln -sf $HOME/dotfiles/config/bashrc $HOME/.bashrc
ln -sf $HOME/dotfiles/config/starship.toml $config/starship.toml
ln -sf $HOME/dotfiles/scripts/tools $scripts

# Load in settings through dconf
dconf load /com/gexperts/Tilix/ < $HOME/dotfiles/config/tilix.dconf
dconf load /org/cinnamon/ < $HOME/dotfiles/config/cinnamon/cinnamon
dconf load /org/cinnamon/desktop/keybindings/ < $HOME/dotfiles/config/cinnamon/keybindings
# Restart Cinnamon Shell
cinnamon --replace >/dev/null 2>&1 &
## Themes
gsettings set org.cinnamon.desktop.interface icon-theme "Mint-Y"
gsettings set org.cinnamon.desktop.interface gtk-theme "Mint-Y-Dark"
gsettings set org.cinnamon.theme name "Mint-Y-Dark"

#MS Fonts
sudo apt install -yy ttf-mscorefonts-installer
#Nerd Fonts
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip \
&& cd ~/.local/share/fonts \
&& unzip JetBrainsMono.zip \
&& rm JetBrainsMono.zip \
&& fc-cache -fv

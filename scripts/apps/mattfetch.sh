#bin/bash
# Installer script for Mattfetch, the fetch tool for TheLinuxCast. Should work for most Debian or Ubuntu based systems
#source:https://gitlab.com/thelinuxcast/mattfetch
# Version 1.0


## Variables
config="$HOME/.config"
clonedir="$HOME"
cloneurl="https://gitlab.com/thelinuxcast/mattfetch.git"

# Dependencies
# rustup
echo "Installing Depenencies"
dpkg -l | grep -qw rustup || sudo apt install -yyq rustup
sudo apt install rustup

#Update rust to current stable - package requires something called Edition 2024 which needs Rust above 1.85
rustup update stable


# Make From Source
cd $clonedir

if [ ! -d mattfetch ]; then rm -rf mattfetch; fi

# Clone with HTTPS
git clone $cloneurl
cd mattfetch

# Build with cargo
cargo build --release

# Install to your system
cargo install --path .

#See if it Works
$HOME/.cargo/bin/mattfetch

#Generate a config for you
mattfetch generate-config


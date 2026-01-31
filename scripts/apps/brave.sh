#!/bin/bash
# Installer script for Brave. Should work for most Debian or Ubuntu based systems
# Version 1.1

# Ensure Whiptail is installed
if ! command -v whiptail &> /dev/null; then
    apt update && apt install -y newt
fi

# Show menu and capture selection
CHOICE=$(whiptail --title "Brave Installer" --menu "Choose your preferred installation method:" 15 60 4 \
"1" "Official Repository (APT) - Recommended" \
"2" "Flatpak (Sandboxed via Flathub)" \
"3" "Exit" 3>&1 1>&2 2>&3)

case $CHOICE in
    1)
        echo "Installing via Official Repository..."
        # Download the keyring and add the repository
        curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
        echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | tee /etc/apt/sources.list.d/brave-browser-release.list
        sudo apt update && apt install brave-browser -y
        ;;
    2)
        echo "Installing via Flatpak..."
        sudo apt update && sudo apt install flatpak -y
        flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        flatpak install flathub com.brave.Browser -y
        ;;
    *)
        echo "Installation cancelled."
        exit 0
        ;;
esac

        echo "Installation complete!"
















































# All the code is wrapped in a main function that gets called at the
# bottom of the file, so that a truncated partial download doesn't end
# up executing half a script.
main() {
    ## Check if the browser can run on this system

    case "$(uname)" in
        Darwin) error "Please go to https://brave.com/download/ to download the Mac app";;
        *) glibc_supported;;
    esac

    case "$(uname -m)" in
        aarch64|x86_64) ;;
        *) error "Unsupported architecture $(uname -m). Only 64-bit x86 or ARM machines are supported.";;
    esac

    ## Locate the necessary tools

    case "$(whoami)" in
        root) sudo="";;
        *) sudo="$(first_of sudo doas run0 pkexec sudo-rs)" || error "Please install sudo/doas/run0/pkexec/sudo-rs to proceed.";;
    esac

    case "$(first_of curl wget)" in
        wget) curl="wget -qO-";;
        *) curl="curl -fsS";;
    esac

    ## Install the browser

    if available apt-get && apt_supported; then
        export DEBIAN_FRONTEND=noninteractive
        if ! available curl && ! available wget; then
            show $sudo apt-get update
            show $sudo apt-get install -y curl
        fi
        show $curl "https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg"|\
            show $sudo install -DTm644 /dev/stdin /usr/share/keyrings/brave-browser-archive-keyring.gpg
        show printf "%s\n" \
            "Types: deb" \
            "URIs: https://brave-browser-apt-release.s3.brave.com" \
            "Signed-By: /usr/share/keyrings/brave-browser-archive-keyring.gpg" \
            "Architectures: amd64 arm64" \
            "Suites: stable" \
            "Components: main"|\
                show $sudo install -DTm644 /dev/stdin /etc/apt/sources.list.d/brave-browser-release.sources
        show $sudo rm -f /etc/apt/sources.list.d/brave-browser-release.list
        show $sudo apt-get update
        show $sudo apt-get install -y brave-browser

    elif available dnf; then
        if dnf --version|grep -q dnf5; then
            show $sudo dnf config-manager addrepo --overwrite --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
        else
            show $sudo dnf install -y 'dnf-command(config-manager)'
            show $sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
        fi
        show $sudo dnf install -y brave-browser

    elif available eopkg; then
        show $sudo eopkg update-repo -y
        show $sudo eopkg install -y brave

    elif available pacman; then
        if pacman -Ss brave-browser >/dev/null 2>&1; then
            show $sudo pacman -Sy --needed --noconfirm brave-browser
        else
            aur_helper="$(first_of paru pikaur yay)" ||
                error "Could not find an AUR helper. Please install paru/pikaur/yay to proceed." "" \
                      "You can find more information about AUR helpers at https://wiki.archlinux.org/title/AUR_helpers"
            show "$aur_helper" -Sy --needed --noconfirm brave-bin
        fi

    elif available zypper; then
        show $sudo zypper --non-interactive addrepo --gpgcheck --repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
        show $sudo zypper --non-interactive --gpg-auto-import-keys refresh
        show $sudo zypper --non-interactive install brave-browser

    elif available yum; then
        available yum-config-manager || show $sudo yum install yum-utils -y
        show $sudo yum-config-manager -y --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
        show $sudo yum install brave-browser -y

    elif available rpm-ostree; then
        available curl || available wget || error "Please install curl/wget to proceed."
        show $curl https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo|\
            show $sudo install -DTm644 /dev/stdin /etc/yum.repos.d/brave-browser.repo
        show $sudo rpm-ostree install -y --idempotent brave-browser

    else
        error "Could not find a supported package manager. Only apt/dnf/eopkg/pacman(+paru/pikaur/yay)/rpm-ostree/yum/zypper are supported." "" \
            "If you'd like us to support your system better, please file an issue at" \
            "https://github.com/brave/install.sh/issues and include the following information:" "" \
            "$(uname -srvmo || true)" "" \
            "$(cat /etc/os-release || true)"
    fi

    if available brave || available brave-browser; then
        printf "Installation complete! Start Brave by typing: "
        basename "$(command -v brave-browser || command -v brave)"
    else
        echo "Installation complete!"
    fi



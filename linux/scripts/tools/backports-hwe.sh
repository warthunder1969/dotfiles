#!/bin/bash
set -euo pipefail

BASE_CODENAME="trixie"
BACKPORTS_REPO="deb http://deb.debian.org/debian ${BASE_CODENAME}-backports main contrib non-free non-free-firmware"
BACKPORTS_FILE="/etc/apt/sources.list.d/${BASE_CODENAME}-backports.list"

MESA_PACKAGES=(
    mesa-vulkan-drivers
)

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (sudo ./backports-hwe.sh)"
    exit 1
fi

enable_backports() {
    echo "Enabling ${BASE_CODENAME} Backports..."
    if grep -rq "${BASE_CODENAME}-backports" /etc/apt/sources.list /etc/apt/sources.list.d/*.list 2>/dev/null; then
        echo "Backports repository is already enabled."
    else
        echo "$BACKPORTS_REPO" > "$BACKPORTS_FILE"
        apt update
        echo "Success: Backports enabled."
    fi
}

install_kernel() {
    echo "Installing Kernel & Firmware from ${BASE_CODENAME} Backports..."
    apt update
    if apt install -t "${BASE_CODENAME}-backports" -y \
        linux-image-amd64 linux-headers-amd64 \
        firmware-misc-nonfree firmware-linux-nonfree; then
        echo "Success: Kernel and Firmware installed."
        echo "IMPORTANT: Please REBOOT your system now to load the new kernel."
    else
        echo "Error: Installation failed."
    fi
}

install_mesa() {
    echo "Installing Mesa Drivers from ${BASE_CODENAME} Backports..."
    apt update
    if apt install -t "${BASE_CODENAME}-backports" -y "${MESA_PACKAGES[@]}"; then
        echo "Success: Mesa drivers updated."
    else
        echo "Error: Mesa installation failed."
    fi
}

check_versions() {
    echo "Current Kernel: $(uname -r)"
    if command -v glxinfo &>/dev/null; then
        local mesa_version
        mesa_version=$(glxinfo -B 2>/dev/null | grep "OpenGL core profile version" | cut -d' ' -f5)
        echo "Current Mesa: ${mesa_version:-unknown}"
    else
        echo "Mesa: (install mesa-utils to check)"
    fi
}

# Main Menu Loop
while true; do
    CHOICE=$(dialog --clear --title "Debian Backports Updater" \
        --menu "Select an option for ${BASE_CODENAME}:" 15 60 4 \
        1 "Enable Backports" \
        2 "Install Latest Kernel & Firmware" \
        3 "Install Latest Mesa Drivers" \
        4 "Check Current Versions" \
        2>&1 >/dev/tty)
    clear

    case "$CHOICE" in
        1) enable_backports ;;
        2) install_kernel ;;
        3) install_mesa ;;
        4) check_versions ;;
        *) echo "Invalid option." ;;
    esac

    read -rp "Press Enter to continue..." _
done

echo "=== Boot Mode ==="
[ -d /sys/firmware/efi ] && echo "Firmware Type: UEFI" || echo "Firmware Type: Legacy BIOS"

echo -e "\n=== Secure Boot Status ==="
if command -v mokutil >/dev/null 2>&1; then
    sudo mokutil --sb-state
else
    echo "mokutil is not installed."
    echo "Install it with one of the following commands:"
    
    if command -v apt >/dev/null 2>&1; then
        echo "  sudo apt install mokutil                # Ubuntu / Debian"
    elif command -v dnf >/dev/null 2>&1; then
        echo "  sudo dnf install mokutil                # Fedora / RHEL"
    elif command -v zypper >/dev/null 2>&1; then
        echo "  sudo zypper install mokutil             # openSUSE Leap / Tumbleweed"
    elif command -v pacman >/dev/null 2>&1; then
        echo "  sudo pacman -S mokutil                  # Arch / Manjaro"
    else
        echo "  Your distro is not detected. Search for 'mokutil' in your package manager."
    fi
fi

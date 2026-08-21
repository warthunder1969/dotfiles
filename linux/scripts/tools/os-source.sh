#!/bin/bash

# Source the OS information
if [ -f /etc/os-release ]; then
    . /etc/os-release
else
    echo "Error: /etc/os-release not found."
    exit 1
fi

case "$ID" in
    ubuntu|debian)
        BASE_DISTRO=$ID
        # VERSION_CODENAME is standard for Ubuntu/Debian (e.g., jammy, bookworm)
        BASE_CODENAME=$VERSION_CODENAME
        ;;
    linuxmint)
        # Check if it's Ubuntu-based Mint or Debian-based (LMDE)
        if [ -n "$UBUNTU_CODENAME" ]; then
            BASE_DISTRO="ubuntu"
            BASE_CODENAME=$UBUNTU_CODENAME
        elif [ -n "$DEBIAN_CODENAME" ]; then
            BASE_DISTRO="debian"
            BASE_CODENAME=$DEBIAN_CODENAME
        else
            # Fallback for very old versions
            BASE_DISTRO="ubuntu"
            BASE_CODENAME="unknown"
        fi
        ;;
    *)
        echo "Unsupported distribution: $ID"
        exit 1
        ;;
esac

echo "$BASE_DISTRO ($BASE_CODENAME)"

# Example: Writing to a source file
# echo "deb http://archive.example.com/$BASE_DISTRO $BASE_CODENAME main" > /etc/apt/sources.list.d/myrepo.list

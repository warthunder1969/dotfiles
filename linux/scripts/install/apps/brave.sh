#!/bin/sh
# Copyright (c) Tailscale Inc
# Copyright (c) 2024 The Brave Authors
# SPDX-License-Identifier: BSD-3-Clause
#
# This script installs the Brave browser using the OS's package manager
# Requires: coreutils, grep, sh and one of sudo/doas/run0/pkexec/sudo-rs
# Source: https://github.com/brave/install.sh

GLIBC_VER_MIN="2.26"
APT_VER_MIN="1.1"

set -eu

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
}

# Helpers
available() { command -v "${1:?}" >/dev/null; }
first_of() { for c in "${@:?}"; do if available "$c"; then echo "$c"; return 0; fi; done; return 1; }
show() { (set -x; "${@:?}"); }
error() { exec >&2; printf "Error: "; printf "%s\n" "${@:?}"; exit 1; }
newer() { [ "$(printf "%s\n%s" "$1" "$2"|sort -V|head -n1)" = "${2:?}" ]; }
supported() { newer "$2" "${3:?}" || error "Unsupported ${1:?} version ${2:-<empty>}. Only $1 versions >=$3 are supported."; }
glibc_supported() { supported glibc "$(ldd --version 2>/dev/null|head -n1|grep -oE '[0-9]+\.[0-9]+$' || true)" "${GLIBC_VER_MIN:?}"; }
apt_supported() { supported apt "$(apt-get -v|head -n1|cut -d' ' -f2)" "${APT_VER_MIN:?}"; }

main

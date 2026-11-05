#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -eq 0 ]]; then
  SUDO=""
else
  SUDO="sudo"
fi

if ! command -v apt-get >/dev/null 2>&1; then
  echo "This script is for Debian/Ubuntu-based systems with apt."
  exit 1
fi

$SUDO apt-get update
$SUDO apt-get install -y zram-tools

config=/etc/default/zramswap
if [[ -f "$config" ]]; then
  $SUDO cp -a "$config" "$config.bak.$(date +%Y%m%d-%H%M%S)"
fi

# Remove old zram size/priority settings, then add the chosen values.
$SUDO sed -i -E \
  '/^[[:space:]#]*(PERCENT|PERCENTAGE|PRIORITY)=/d' "$config"

printf '\nPERCENT=50\nPRIORITY=100\n' | $SUDO tee -a "$config" >/dev/null

$SUDO systemctl enable zramswap
$SUDO systemctl restart zramswap

echo "ZRAM status:"
swapon --show
zramctl

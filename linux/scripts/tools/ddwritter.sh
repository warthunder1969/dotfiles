#!/bin/bash
set -euo pipefail

read -rp "Enter source file (if=): " source
read -rp "Enter destination file (of=): " dest
read -rp "Enter block size (bs) [default 4M]: " bs
bs=${bs:-4M}

cmd="sudo dd if=\"$source\" of=\"$dest\" bs=\"$bs\" status=progress"

echo
echo "About to run:"
echo "  $cmd"
echo
read -rp "Are you sure you want to proceed? (y/N): " confirm
case "$confirm" in
  [yY]|[yY][eE][sS])
    eval "$cmd"
    ;;
  *)
    echo "Aborted."
    exit 1
    ;;
esac

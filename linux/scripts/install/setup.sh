#!/bin/bash
# Setup script for My personal systems to get me up and going as quickly as possible.
# Useage is not recomended unless you know what you are doing. That being said most Debian based systems
# Version 0.1

# === Dependencies ===
command -v dialog >/dev/null || { echo "Install 'dialog' and try again."; exit 1; }

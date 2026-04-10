#!/bin/bash

# --- COLOR CODES ---
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Starting MacOS Setup...${NC}\n"

# 1. Check for Homebrew, install if not found
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add brew to path for the current session
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo -e "${GREEN}Homebrew is already installed.${NC}"
fi

# 2. Update Homebrew
echo "Updating Homebrew..."
brew update

# --- APPLICATION LISTS ---
# Add or remove apps here. Use 'brew search <name>' to find the correct ID.

CORE_APPS=(
    "firefox"
    "vesktop"
    "thunderbird"
    "rectangle"
    "flameshot"
    "fastfetch"
)

PRODUCTION_APPS=(
    "element"
    "vscodium"
    "jitsi-meet"
    "nextcloud"
    "notesnook"
)

# 3. Installation Function
install_list() {
    local category_name=$1
    shift
    local apps=("$@")

    echo -e "\n${BLUE}Installing $category_name Apps...${NC}"
    for app in "${apps[@]}"; do
        if brew list --cask "$app" &> /dev/null; then
            echo -e "${GREEN}[Already Installed]${NC} $app"
        else
            echo "Installing $app..."
            brew install --cask "$app"
        fi
    done
}

# 4. Run the installation
install_list "CORE" "${CORE_APPS[@]}"
install_list "PRODUCTION" "${PRODUCTION_APPS[@]}"

echo -e "\n${GREEN}Setup Complete!${NC}"
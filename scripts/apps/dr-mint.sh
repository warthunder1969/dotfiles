!/bin/bash

# Script to Install DaVinci Resolve on Linux Mint 22
#source:https://dev.to/annietaylorchen/how-to-install-davinci-resolve-19-studio-on-linux-mint-22-with-amd-radeon-graphics-card-with-a-kd6
set -e  # Exit on any error

# Variables
ACTIVE_USER=$(logname)
HOME_DIR=$(eval echo "~$ACTIVE_USER")
DOWNLOADS_DIR="$HOME_DIR/Downloads"
EXTRACTION_DIR="/opt/resolve"
ZIP_FILE_PATTERN="DaVinci_Resolve_*.zip"

# Step 1: Ensure FUSE and libfuse.so.2 are Installed
echo "Checking for FUSE and libfuse.so.2..."
if ! dpkg -l | grep -q fuse; then
    echo "Installing FUSE..."
    sudo apt update
    sudo apt install -y fuse libfuse2
fi

if [ ! -f /lib/x86_64-linux-gnu/libfuse.so.2 ]; then
    echo "Error: libfuse.so.2 is not found. Installing libfuse2..."
    sudo apt install -y libfuse2
fi

# Step 2: Install Required Qt Libraries
echo "Installing required Qt libraries..."
sudo apt install -y qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools libqt5core5a libqt5gui5 libqt5widgets5 libqt5network5 libqt5dbus5 \
libxrender1 libxrandr2 libxi6 libxkbcommon-x11-0 libxcb-xinerama0 libxcb-xfixes0 qtwayland5 libxcb-glx0 libxcb-util1

# Step 3: Navigate to Downloads Directory
echo "Navigating to Downloads directory..."
if [ ! -d "$DOWNLOADS_DIR" ]; then
    echo "Error: Downloads directory not found at $DOWNLOADS_DIR."
    exit 1
fi
cd "$DOWNLOADS_DIR"

# Step 4: Extract DaVinci Resolve ZIP File
echo "Extracting DaVinci Resolve installer..."
ZIP_FILE=$(find . -maxdepth 1 -type f -name "$ZIP_FILE_PATTERN" | head -n 1)
if [ -z "$ZIP_FILE" ]; then
    echo "Error: DaVinci Resolve ZIP file not found in $DOWNLOADS_DIR."
    exit 1
fi

unzip -o "$ZIP_FILE" -d DaVinci_Resolve/
chown -R "$ACTIVE_USER:$ACTIVE_USER" DaVinci_Resolve
chmod -R 774 DaVinci_Resolve

# Step 5: Run the Installer or Extract AppImage
echo "Running the DaVinci Resolve installer..."
cd DaVinci_Resolve
INSTALLER_FILE=$(find . -type f -name "DaVinci_Resolve_*.run" | head -n 1)
if [ -z "$INSTALLER_FILE" ]; then
    echo "Error: DaVinci Resolve installer (.run) file not found in extracted directory."
    exit 1
fi

chmod +x "$INSTALLER_FILE"

# Set Qt platform plugin path and debug settings
export QT_DEBUG_PLUGINS=1
export QT_QPA_PLATFORM_PLUGIN_PATH=/usr/lib/x86_64-linux-gnu/qt5/plugins/platforms
export QT_PLUGIN_PATH=/usr/lib/x86_64-linux-gnu/qt5/plugins
export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu:$LD_LIBRARY_PATH

# Attempt to run the installer with FUSE; fallback to extraction
if ! SKIP_PACKAGE_CHECK=1 ./"$INSTALLER_FILE" -a; then
    echo "FUSE is not functional. Extracting AppImage contents..."
    sudo mkdir -p "$EXTRACTION_DIR"
    ./"$INSTALLER_FILE" --appimage-extract
    sudo mv squashfs-root/* "$EXTRACTION_DIR/"
    sudo chown -R root:root "$EXTRACTION_DIR"
fi

# Step 6: Resolve Library Conflicts
echo "Resolving library conflicts..."
if [ -d "$EXTRACTION_DIR/libs" ]; then
    cd "$EXTRACTION_DIR/libs"
    sudo mkdir -p not_used
    sudo mv libgio* not_used || true
    sudo mv libgmodule* not_used || true

    # Replace with system versions
    if [ -f /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0 ]; then
        sudo cp /usr/lib/x86_64-linux-gnu/libglib-2.0.so.0 "$EXTRACTION_DIR/libs/"
    else
        echo "Warning: System library libglib-2.0.so.0 not found. Ensure compatibility manually."
    fi
else
    echo "Error: Installation directory $EXTRACTION_DIR/libs not found. Skipping library conflict resolution."
fi

# Step 7: Cleanup
echo "Cleaning up installation files..."
cd "$DOWNLOADS_DIR"
rm -rf DaVinci_Resolve

echo "DaVinci Resolve installation completed successfully!"

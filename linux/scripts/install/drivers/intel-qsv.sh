#!/bin/bash
#!/bin/bash
# Enhanced Installer script for Intel QSV. Should work for most Debian or Ubuntu based systems
# Version 1.0
# Dependencies

# Ensure dialog is installed
if ! command -v dialog &> /dev/null; then
    echo "Error: 'dialog' is not installed. Please install it to use this script (e.g., sudo apt install dialog)."
    exit 1
fi

## Variables


# Define the Title and the Summary Message
DIALOG_TITLE="WELCOME"

# Use triple quotes for cleaner multi-line strings in the message
SCRIPT_SUMMARY="
Welcome to Warthunder's QSV Install Script!

This script is for doing the following actions:

1. Install Intel Non-Free Media Driver to enable QSV Support.

This script is provided as-is. Press OK to Continue.
"
dialog --clear \
    --title "$DIALOG_TITLE" \
    --msgbox "$SCRIPT_SUMMARY" 15 60 \
    2>&1 >/dev/tty

# Clear the dialog screen upon exit
clear
        echo "Installing Intel Media Driver Non-Free..."
		sudo apt install intel-media-va-driver-non-free
esac

#!/bin/bash

# Check current DPMS status
DPMS_STATUS=$(xset q | grep -i "DPMS is" | awk '{print $3}')

if [ "$DPMS_STATUS" == "Enabled" ]; then
    echo "Disabling DPMS and screen blanking..."
    xset s off          # Disable screen saver
    xset s noblank      # Prevent screen blanking
    xset -dpms          # Turn off DPMS
    echo "Screen will stay on."
    notify-send "Screen Lock On"
else
    echo "Enabling DPMS and screen blanking..."
    xset s on           # Enable screen saver
    xset s blank        # Allow screen blanking
    xset +dpms          # Turn on DPMS
    echo "Screen blanking and power management enabled."
    notify-send "Screen Lock Off"
fi

#!/bin/bash
# Script to Activate wf-recorder. Should work for most Debian or Ubuntu based systems
# Version 1.1

## Variables
TODAY=$(date +%Y-%m-%d)

# Ger Resolution
get_number() {
    local prompt_msg=$1
    local result
    
    result=$(whiptail --inputbox "$prompt_msg" 8 45 --title "Dimensions" 3>&1 1>&2 2>&3)
    
    # Check if user cancelled
    if [ $? -ne 0 ]; then
        echo "CANCELLED"
        return
    fi

    # Basic validation: check if it's a positive integer
    if [[ "$result" =~ ^[0-9]+$ ]]; then
        echo "$result"
    else
        echo "INVALID"
    fi
}

WIDTH=$(get_number "Enter the Width:")
if [[ "$WIDTH" == "CANCELLED" ]] || [[ "$WIDTH" == "INVALID" ]]; then
    echo "Exiting: Invalid width or user cancelled."
    exit 1
fi

HEIGHT=$(get_number "Enter the Height:")
if [[ "$HEIGHT" == "CANCELLED" ]] || [[ "$HEIGHT" == "INVALID" ]]; then
    echo "Exiting: Invalid height or user cancelled."
    exit 1
fi

# Combine
echo "Resolution is ${WIDTH}x${HEIGHT}."


# Where we Will Save the Recording
LOCATION=$(whiptail --inputbox "Enter Destination of the Recording:" 8 45 "$HOME/$USER" 3>&1 1>&2 2>&3)

# Check if the directory exists
if [ -d "$LOCATION" ]; then
    whiptail --msgbox "Path verified: $LOCATION" 8 45
    mkdir -p "$LOCATION"
else
    whiptail --title "Error" --msgbox "The directory '$LOCATION' does not exist." 8 45
    exit 1
fi

# Filename
while true; do
    FILENAME=$(whiptail --inputbox "Enter a name for your file (e.g., test.mkv):" 8 45 3>&1 1>&2 2>&3)
    
    # Exit if user cancels
    if [ $? -ne 0 ]; then exit; fi

    #Check for empty input
    if [ -z "$FILENAME" ]; then
        whiptail --msgbox "Error: Filename cannot be empty." 8 45
        continue
    fi

    #Check if file already exists
    FULL_PATH="$LOCATION/$FILENAME"
    if [ -f "$FULL_PATH" ]; then
        whiptail --yesno "Warning: '$FILENAME' already exists. Overwrite it?" 8 45
        if [ $? -eq 0 ]; then
            break # User said yes, proceed
        else
            continue # User said no, ask for a new name
        fi
    else
        break # File doesn't exist, name is good
    fi
done

echo "Filename: $FULL_PATH"




# Construct the summary message
# The \n creates new lines for better readability
SUMMARY_TEXT="Please confirm the following details:

  • Resolution: ${WIDTH}x${HEIGHT}
  • Save Path:  $LOCATION
  • Filename:   $FILENAME

Press OK to generate the file or ESC to quit."

# Display the summary
if whiptail --title "Final Confirmation" --msgbox "$SUMMARY_TEXT" 12 50; then
    echo "Confirmed. Full Send!"
    wf-recorder -a width=$WIDTH,height=$HEIGHT -f $FULL_PATH
else
    echo "User exited."
    exit 1
fi










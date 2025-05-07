 #!/bin/bash

echo "Existing Charge Thresholds"
echo -n "Start: " && cat /sys/class/power_supply/BAT0/charge_control_start_threshold
echo -n "Stop: " && cat /sys/class/power_supply/BAT0/charge_control_end_threshold

# Display menu options
echo "Menu:"
echo "1. Home"
echo "2. Away"
echo "3. Fullcharge"
echo "4. Exit"

# Read user input
read -p "Enter your choice: " choice

# Process user choice
case $choice in
    1)
        echo "Setting Battery to 50%"
        # Setting 50% Charge
        echo '45'| sudo tee /sys/class/power_supply/BAT0/charge_start_threshold
        echo '50' | sudo tee /sys/class/power_supply/BAT0/charge_stop_threshold
        read -n1 -r -p "Press any key to continue..." key
        ;;
    2)
        echo "Setting Battery to 80%"
        # Setting 80% Charge
        echo '75' | sudo tee /sys/class/power_supply/BAT0/charge_start_threshold
        echo '80' | sudo tee /sys/class/power_supply/BAT0/charge_stop_threshold
        read -n1 -r -p "Press any key to continue..." key
        ;;
    3)
        echo "Setting Battery to 100%"
        # Setting 50% Charge
        echo '0' | sudo tee /sys/class/power_supply/BAT0/charge_start_threshold
        echo '100' | sudo tee /sys/class/power_supply/BAT0/charge_stop_threshold
        read -n1 -r -p "Press any key to continue..." key
        ;;
    4)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice. Please try again."
        read -n1 -r -p "Press any key to continue..." key
        ;;

esac

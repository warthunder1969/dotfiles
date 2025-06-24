 #!/bin/bash
#Battery Threshold Script my Warthunder. Should work on most Linux systems.
#All items are not my own work - I combined multiple scripts I found into one
#Version 3.0

#Dependencies
# sudo
# tee
# echo
# A battery (BAT0)

## Variables
battery="/sys/class/power_supply/BAT0"

#The Code Starts Here

echo " "
echo "Current Settings:"
echo "Start Charge": `cat $battery/charge_start_threshold`
echo "Stop charge: " `cat $battery/charge_stop_threshold`

# Display menu options
echo "Menu:"
echo "1. Home"
echo "2. AC"
echo "3. Full"
echo "4. Exit"

# Read user input
read -p "Enter your choice: " choice

# Process user choice
case $choice in
    1)
        echo " Setting $choice Preset"
        # Setting Charge
        echo '75' | sudo tee $battery/charge_start_threshold >/dev/null
        echo '80' | sudo tee $battery/charge_stop_threshold >/dev/null
               

        ;;
    2)
        echo " Setting $choice Preset"
        # Setting Charge
        echo '45' | sudo tee $battery/charge_start_threshold >/dev/null
        echo '50' | sudo tee $battery/charge_stop_threshold >/dev/null
       
        ;;
    3)
        echo " Setting $choice Preset"
        # Setting Charge
        echo '0' | sudo tee $battery/charge_start_threshold >/dev/null
        echo '100' | sudo tee $battery/charge_stop_threshold >/dev/null
        
        ;;
    4)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice. Please try again."
        
        ;;

esac
echo " "
echo "Current Settings:"
echo "Start Charge": `cat $battery/charge_start_threshold`
echo "Stop charge: " `cat $battery/charge_stop_threshold`
sleep 5
exit

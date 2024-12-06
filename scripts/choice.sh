#!/bin/bash

# Display menu options
echo "Menu:"
echo "1. Option 1"
echo "2. Option 2"
echo "3. Option 3"
echo "4. Exit"

# Read user input
read -p "Enter your choice: " choice

# Process user choice
case $choice in
    1)
        echo "You chose Option 1"
        # Add your code for Option 1 here
        ;;
    2)
        echo "You chose Option 2"
        # Add your code for Option 2 here
        ;;
    3)
        echo "You chose Option 3"
        # Add your code for Option 3 here
        ;;
    4)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice. Please try again."
        ;;
esac

#!/bin/bash

# --- CONFIGURATION ---
# Set the "specified length" in days (e.g., 365 for a year, 1095 for 3 years)
TOTAL_LENGTH_DAYS=365
# ---------------------

# 1. Get the installation date in seconds since epoch.
# We use 'stat -c %W /' to get the birth time of the root directory.
# If %W returns 0 or "n/a", we fallback to the modification time of /lost+found.
INSTALL_EPOCH=$(stat -c %W /)

if [ "$INSTALL_EPOCH" = "0" ] || [ "$INSTALL_EPOCH" = "-" ] || [ -z "$INSTALL_EPOCH" ]; then
    # Fallback: Many systems don't support file birth time, so we use /lost+found
    INSTALL_EPOCH=$(stat -c %Y /lost+found 2>/dev/null || stat -c %Y /)
fi

# 2. Get current time in seconds
CURRENT_EPOCH=$(date +%s)

# 3. Calculate age in days
AGE_SECONDS=$((CURRENT_EPOCH - INSTALL_EPOCH))
AGE_DAYS=$((AGE_SECONDS / 86400))

# 4. Calculate remaining days
REMAINING_DAYS=$((TOTAL_LENGTH_DAYS - AGE_DAYS))

# 5. Output results
echo -en "\e[35m Challenge \e[0m" && echo -e "Linux Mint Distro Challenge"

#echo -en "\e[35m├󰻗 Installation Date\e[0m" && echo " $(date -d "@$INSTALL_EPOCH" '+%Y-%m-%d')"
#echo -en "\e[35m├System Age\e[0m" && echo " $AGE_DAYS days"
echo -en "\e[35m├ Challenge Length\e[0m" && echo " $TOTAL_LENGTH_DAYS days"

if [ $REMAINING_DAYS -gt 0 ]; then
    echo -en "\e[35m└󰥔 Status\e[0m" &&  echo " $REMAINING_DAYS days Remain"
else
    OVERDUE=$((AGE_DAYS - TOTAL_LENGTH_DAYS))
	echo -en "\e[35m└󰥔 Status\e[0m" &&  echo " \e[31mCHALLENGE COMPLETE!\e[0m"
fi

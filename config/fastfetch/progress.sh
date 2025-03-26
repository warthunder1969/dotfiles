# See this wiki page for more info:
# https://github.com/dylanaraps/neofetch/wiki/Customizing-Info
# Challenge script by TechnoDaft#0647

# All the Timing information
let Minute=60
let Hour=3600
let Day=86400
let Week=604800

# Year_days=365.25 days # 4 years (1461 days cause leap year) Divided by 4
# Month_days=30.4375 days # Year Divided by 12
let Month=2629800
let Year=31557600

# Year = 365 days, Month = 30 days.
# let Month=2592000
# let Year=31536000

# Calculation of everything needed
let current=$(date +%s)
let birth_install=$(stat -c %W /) # Comment out if using the custom Epoch
let challenge=(Day *730)
let challenge_length=(challenge / Day)
let diff_left=(challenge_complete - current)
let diff_done=(current - birth_install)
let Days_done=(diff_done / Day)
let Days_left=(diff_left / Day)

echo $Days_done days done

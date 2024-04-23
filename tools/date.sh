neofetch

now="$(date +'%Y-%m-%d')"
printf "Current date: %s\n" "$now"

install="$(stat / | grep "Birth" | sed 's/Birth: //g' | cut -b 2-11)"
printf "Install date: %s\n" "$install"

#Calculate age since Installed
#In days
aged="$(( ($(date --date=$now +%s) - $(date --date=$install +%s) )/(60*60*24) ))"
printf "Install age in days: %s\n" "$aged"


#!/bin/sh

sleep 10s
killall -e -u $(id -nu) conky 2>/dev/null
cd "/usr/share/mx-conky-data/themes/MX-Infinity"
conky -c "/usr/share/mx-conky-data/themes/MX-Infinity/MX-Infinity-conkyrc" &
cd "/usr/share/mx-conky-data/themes/MX-KoO"
conky -c "/usr/share/mx-conky-data/themes/MX-KoO/MX-Full" &
cd "$HOME/.conky/MX-Warthunder"
conky -c "$HOME/.conky/MX-Warthunder/MX-Full" &
exit 0

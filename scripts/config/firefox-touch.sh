#Fix Firefox Not Responding to Touch Input
##Source: https://askubuntu.com/questions/978226/how-to-make-touch-screen-scrolling-work-in-firefox-quantum
sudo sed -i "s|Exec=|Exec=env MOZ_USE_XINPUT2=1 |g" /usr/share/applications/firefox.desktop

#Source: https://forums.linuxmint.com/viewtopic.php?t=375771
#Install Required packages
sudo apt-get install pipewire wireplumber libspa-0.2-bluetooth pipewire-audio-client-libraries

#Enabling, Disabling services
systemctl --user --now disable pulseaudio.service pulseaudio.socket
systemctl --user --now enable pipewire-media-session.service
systemctl --user restart pipewire

#let'scheck to see if it worked
pactl info


#If you need to roll back, uncomment and copy belows commands
#systemctl --user unmask pulseaudio
#systemctl --user --now enable pulseaudio.service pulseaudio.socket


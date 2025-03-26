wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/3270.zip \
&& cd ~/.local/share/fonts \
&& unzip 3270.zip \
&& rm 3270.zip \
&& fc-cache -fv

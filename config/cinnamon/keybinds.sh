#source: https://forums.linuxmint.com/viewtopic.php?t=315472
#To backup to a text file called ~/mykeybindings

dconf dump /org/cinnamon/desktop/keybindings/ > mykeybindings

#To reload on another machine running Cinnamon transfer the file to ~/mykeybindings on the #other machine and run

dconf load /org/cinnamon/desktop/keybindings/ < mykeybindings

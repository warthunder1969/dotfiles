#!/bin/bash
# init
echo "**************************"
echo "*Joe's Mint Backup script*"
echo "**************************"

PS3='Choose Script to run: '
setup=("Load" "Dump" "Quit")
select fav in "${setup[@]}"; do
    case $fav in
        "Load")
	    #LOAD PROCESS
    dconf load /org/cinnamon/ < cinnamon.dconf
    dconf load /org/nemo/ < nemo.dconf
    dconf load /org/gtk/ < gtk.dconf
    dconf load /org/gnome/ < gnome.dconf
echo "***Done***"	    
        break
            ;;
        "Dump")
	    	    #DUMP PROCESS
    dconf dump /org/cinnamon/ > cinnamon.dconf
    dconf dump /org/nemo/ > nemo.dconf
    dconf dump /org/gtk/ > gtk.dconf
    dconf dump /org/gnome/ > gnome.dconf
echo "***Done***"
	    break
            ;;
	"Quit")
	    echo "***Program Terminated***"
	    exit
	    ;;
        *) echo "***invalid option $REPLY***";;
    esac
done








                

#!/bin/bash

layouts=(
    "[\\] Dwindle		  Shift+Control+1"    
    "[]= Tile		  Shift+Control+2"    
    "[C] Column Layout         Shift+Control+3"
    "|M| Centered Master       Shift+Control+4"   
    ">< Floating               Shift+Control+5"    
    "TTT Bstack                Shift+Control+6"    
    "### N-Row Grid            Shift+Control+7"    
    "H[] Deck                  Shift+Control+8"    
    "::: Gapless Grid          Shift+Control+9"    
    "[@] Spiral                Shift+Control+0"    
    "[M] Monocle               Shift+Control+-"    
    "HHH Grid                  Shift+Control+="    
)

selected=$(printf "%s\n" "${layouts[@]}" | rofi -dmenu -i -p "Select Layout" -line-padding 4 -hide-scrollbar -theme ~/.config/suckless/rofi/keybinds.rasi)

# Extract just the first two fields (layout name)
layout_name=$(echo "$selected" | cut -d ' ' -f 1-2)

case "$layout_name" in
    "[\\] Dwindle") xdotool key shift+control+1 ;;
    "[]= Tile") xdotool key shift+control+2 ;;
    "[C] Column") xdotool key shift+control+3 ;;
    "|M| Centered") xdotool key shift+control+4 ;;
    ">< Floating") xdotool key shift+control+5 ;;
    "TTT Bstack") xdotool key shift+control+6 ;;
    "### N-Row") xdotool key shift+control+7 ;;
    "H[] Deck") xdotool key shift+control+8 ;;
    "::: Gapless") xdotool key shift+control+9 ;;
    "[@] Spiral") xdotool key shift+control+0 ;;
    "[M] Monocle") xdotool key shift+control+minus ;;
    "HHH Grid") xdotool key shift+control+equal ;;
    *) exit 0 ;;  # Exit on cancel
esac

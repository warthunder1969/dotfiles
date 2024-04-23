#Thanks to https://askubuntu.com/questions/442997/how-can-i-convert-audio-from-ogg-to-mp3

parallel ffmpeg -i "{}" "{.}.mp3" ::: *.ogg

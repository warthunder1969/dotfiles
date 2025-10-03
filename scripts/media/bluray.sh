#

#Variables
dir="~/.config/aacs/"


#Installing Dependencies
sudo apt install libaacs0 libbluray-bdj libbluray2

#Setup Key file for decription
mkdir -p $dir
cd $dir && wget http://fvonline-db.bplaced.net/export/keydb_eng.zip

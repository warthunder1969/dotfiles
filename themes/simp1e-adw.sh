
#!/bin/bash
# init

#make directories if not exist
mkdir -p ~/.icons && mkdir -p ~/.themes
mkdir -p ~/Downloads/icons && mkdir -p ~/Downloads/themes

#get cursor theme
cd ~/Downloads
wget https://gitlab.com/cursors/simp1e/-/jobs/3719462594/artifacts/raw/built_themes/Simp1e-Adw-Dark.tgz
tar xvf Simp1e-Adw-Dark.tgz
mv Simp1e-Adw-Dark ~/.icons/

#Cleanup
rm -rf Simp1e-Adw-Dark.tgz







                

#source: https://askubuntu.com/questions/15433/unable-to-lock-the-administration-directory-var-lib-dpkg-is-another-process

echo "This should be used as last resort." 
echo "If you use this carelessly you can end up with a broken system." 
echo "Please try the other answers first before doing this."
pause "Press any key to continue, or CTRL+C to quit"

#Force removing apt locks
sudo rm /var/lib/apt/lists/lock
sudo rm /var/cache/apt/archives/lock
sudo rm /var/lib/dpkg/lock

sudo dpkg --configure -a

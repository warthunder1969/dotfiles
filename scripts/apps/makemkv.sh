#source: https://forum.makemkv.com/forum/viewtopic.php?t=24328

wget https://apt.benthetechguy.net/benthetechguy-archive-keyring.gpg -O /usr/share/keyrings/benthetechguy-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/benthetechguy-archive-keyring.gpg] https://apt.benthetechguy.net/debian bookworm non-free" > /etc/apt/sources.list.d/benthetechguy.list
apt update
apt install makemkv

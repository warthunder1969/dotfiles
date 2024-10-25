echo "Service tag for this system is:"
sudo dmidecode -s system-serial-number
echo "Express Service Code for $HOSTNAME is:"
echo $((36#$(sudo dmidecode -s system-serial-number)))

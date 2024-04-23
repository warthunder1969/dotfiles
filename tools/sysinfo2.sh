for d in system-manufacturer system-product-name system-serial-number bios-release-date bios-version 
do    
  echo "${d^} : " $(sudo dmidecode -s $d)
done

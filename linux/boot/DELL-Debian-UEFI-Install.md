### Description

In most older (maybe also newer?) DELL workstations and thin clients, for example: DELL Precision T5810 and DELL Wyse 3040, Debian is not able to boot after installation is completed.
This is because your workstation expects to boot from /EFI/BOOT/BOOTX64.EFI and it cannot find it.
There is a way to manually configure this in Setup page and point to the correct `grubx64.efi` location, but for some reason it keeps trying to load from `/EFI/BOOT/BOOTX64.EFI`.
The workaround provided here is basically renaming the `grubx64.efi` into `BOOTX64.EFI` and put it exactly where your workstation is expecting it.


### Installation Example on DELL Wyse 3040

Let's say the Debian installation disk has the following structure:

```
/dev/sda1 EFI partition
/dev/sda2 /
/dev/sda3 swap
```

### Method #1

After netinst is done, it does not boot. Start the debian netinst again, and press c to enter grub command line:

```
grub > set root=(hd1,gpt2)
grub > linux /boot/vmlinuz-6.1.0-18-amd64 root=/dev/sda2
grub > initrd /boot/initrd.img-6.1.0-18-amd64
grub > boot
```

Adjust `vmlinuz-6.1.0-18-amd64` with your kernel version.
Adjust `initrd.img-6.1.0-18-amd64` with your initrd version.
Adjust `root` with the type of drive: `mmcblkX` (eMMC), `sdX` (SATA).

Once successfully booted into Debian, put the grub workaround:

```
cp -R /boot/grub /boot/efi/EFI/BOOT
cp /boot/efi/EFI/debian/grubx64.efi /boot/efi/EFI/BOOT/BOOTX64.EFI
systemctl reboot
```

By now, your Debian should be able to boot normally.


### Method #2

During netinst, when it asks to reboot, DO NOT reboot!
Go Back, select Execute a shell, and run the following:

```
cp -R /target/boot/grub /target/boot/efi/EFI/BOOT
cp /target/boot/efi/EFI/debian/grubx64.efi /target/boot/efi/EFI/BOOT/BOOTX64.EFI
exit
```

Finish the installation, Reboot, Continue
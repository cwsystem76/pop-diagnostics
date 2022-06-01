# pop-diagnostics

This is a test project for packaging [memtest86plus](https://github.com/memtest86plus/memtest86plus/) so it installs to the EFI partition and is accessible through the `systemd` boot menu.

This package requires `systemd-boot` to function, and so it will also only install on UEFI systems, since `systemd-boot` doesn't support older-style BIOS hardware. Systems using BIOS or the GRUB bootloader on UEFI will see the `preinst` script exit the install; Ubuntu still uses GRUB on UEFI so it is not supported, and neither are Pop!OS installs using GRUB to boot on BIOS hardware.

This project is being set up as `pop-diagnostics` instead of just `pop-memtest` or something, because it may also be useful for adding more tools that can be run outside of the operating systsem proper.

Useful documents:
* https://systemd.io/BOOT_LOADER_INTERFACE/ - the `systemd-boot` boot loader system
* https://systemd.io/BOOT_LOADER_SPECIFICATION/ - defines the contents of the `/boot/efi/loader/entries/*.conf` files

## building

* `git clone --recursive https://github.com/cwsystem76/pop-diagnostics`
* `cd pop-diagnostics`
* `dpkg-buildpackage -us -uc`

This will result in a `.deb` file in the parent directory that can be installed in the usual ways.
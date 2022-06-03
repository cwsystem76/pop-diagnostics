This script is for copying the `memtest` files to the ESP, deleting them, or adjusting their launch parameters. It is intended to be accessible to 
both the package system and to end-users. It's written to be POSIX compliant with no bash-isms; please use `checkbashisms` before releasing if modified.

The script is run with a verb, such as:

```
memtest-util reinstall
```

The EFI executeable is copied to `/boot/efi/EFI/memtest/memtest.efi`, and the basic form of the `/boot/efi/loader/entries/memtest.conf` file is:

```
title memtest
efi /EFI/memtest/memtest.efi
```

There is also an optional "options" line which is documented at https://github.com/memtest86plus/memtest86plus/blob/main/README.md ,
and which this script can use using the "options" verb, followed by the requested options as a quoted, space-delineated string. For example:

```
memtest-util options "nosmp keyboard=legacy"
```

will add the line

```
options nosmp keyboard=legacy
```

to the `memtest.conf` file. Run `memtest-util reinstall` to remove any existing options.
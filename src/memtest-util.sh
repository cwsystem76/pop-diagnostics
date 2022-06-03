#!/bin/sh

# This script is for copying the `memtest` files to the ESP, deleting them, or adjusting their launch parameters. It is intended to be accessible to 
# both the package system and to end-users.
#
# The script is run with a verb, such as:
# ```
# memtest-util reinstall
# ```
# This script is, per deb package guidelines, written to be POSIX-compliant and avoid anything `bash`-specific. 
#
# The EFI executeable is copied to `/boot/efi/EFI/memtest/memtest.efi`, and the basic form of the `/boot/efi/loader/entries/memtest.conf` file is:
# ```
# title memtest
# efi /EFI/memtest/memtest.efi
# ```
# There is also an optional "options" line which is documented at https://github.com/memtest86plus/memtest86plus/blob/main/README.md ,
# and which this script can use using the "options" verb, followed by the requested options as a quoted, space-delineated string. For example:
# ```
# memtest-util options "nosmp keyboard=legacy"
# ```
# will add the line
# ```
# options nosmp keyboard=legacy
# ```
# to the `memtest.conf` file. Run `memtest-util reinstall` to remove any existing options.

if [ "$(id -u)" -ne 0 ];
then
    echo "Superuser privileges required, please run as root or with the sudo command." 
    exit 1
fi

argument1="$1"
script_verb=${argument1:?"Comamnd verb missing, valid verbs are 'reinstall' and 'uninstall'."}
argument2="$2"

func_copy_EFI_to_ESP () {
    echo "copying memtest.efi to ESP"
    mkdir -p /boot/efi/EFI/memtest/
    cp -f /usr/lib/pop-diagnostics/memtest/memtest.efi /boot/efi/EFI/memtest/
}

func_write_conf_to_ESP () {
    echo "removing existing memtest.conf from ESP"
    rm -f /boot/efi/loader/entries/memtest.conf
    echo "writing new default memtest.conf to ESP"
    echo "# written by memtest-util.sh" >> /boot/efi/loader/entries/memtest.conf
    echo "title memtest" >> /boot/efi/loader/entries/memtest.conf
    echo "efi /EFI/memtest/memtest.efi" >> /boot/efi/loader/entries/memtest.conf
}

func_write_conf_with_options_to_ESP () {
    echo "removing existing memtest.conf from ESP"
    rm -f /boot/efi/loader/entries/memtest.conf
    echo "writing new memtest.conf with options $1 to ESP"
    echo "# written by memtest-util.sh" >> /boot/efi/loader/entries/memtest.conf
    echo "title memtest" >> /boot/efi/loader/entries/memtest.conf
    echo "efi /EFI/memtest/memtest.efi" >> /boot/efi/loader/entries/memtest.conf
    echo "options $1" >> /boot/efi/loader/entries/memtest.conf
}

func_remove_from_ESP () {
    echo "removing memtest.efi from ESP"
    rm -rf /boot/efi/EFI/memtest/
    echo "removing memtest.conf from ESP"
    rm -f /boot/efi/loader/entries/memtest.conf
}

case "$script_verb" in
    "reinstall") func_copy_EFI_to_ESP
    func_write_conf_to_ESP
    ;;
    "uninstall") func_remove_from_ESP   
    ;;
    "options") options_string=${argument2:?"Options string missing, please use a quoted, space-delineated string."}
    func_write_conf_with_options_to_ESP "$options_string"
    ;;
    *) echo "Unrecognized verb, valid verbs are 'reinstall', 'uninstall', and 'options'."
    ;;
esac

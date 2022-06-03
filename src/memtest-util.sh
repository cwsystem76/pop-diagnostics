#!/bin/sh

# see `memtest-util.readme.md` for details about this script

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

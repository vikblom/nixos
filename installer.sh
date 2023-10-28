parted /dev/vda -- mklabel gpt
parted /dev/vda -- mkpart primary 512MiB 100%
parted /dev/vda -- mkpart ESP fat32 1MiB 512MiB
parted /dev/vda -- set 3 esp on

mkfs.ext4 -L nixos /dev/vda1
mkfs.fat -F 32 -n boot /dev/vda3

mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot

nixos-generate-config --root /mnt
cd /mnt
# Patch up SSH, root password and flakes.
nixos-install
# Reboot but remember to remove the USB device!

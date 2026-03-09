#!/usr/bin/env bash

# Script to create a swap partition for hibernation on Fedora


PARTITION=$(swapon --show | grep "/var/swap/swapfile")
# create swap size same size as RAM in GB
SWAP_SIZE=$(awk '/MemTotal:/ {printf "%d\\n", $2/1024/1024}' /proc/meminfo)

if [[ -z "$PARTITION" ]]; then
  echo "No existing swap partition, creating a $SWAP_SIZE gb swap partition in btrfs".
  sudo btrfs subvolume create /var/swap
  sudo btrfs filesystem mkswapfile --size "$SWAP_SIZE"G /var/swap/swapfile

  if [[ -z "$(swapon --show | grep "/var/swap/swapfile")" ]]; then
    echo "Error, something went wrong when creating the partition"
    return -1
  else
    echo "Activating the swap file and adding it to /etc/fstab"
    sudo swapon /var/swap/swapfile
    echo '/var/swap/swapfile none swap defaults 0 0' | sudo tee -a /etc/fstab

    # enable hibernate by adding resume and resume_offset to /etc/default/grub
    SWAP_UUID=$(findmnt -no UUID -T /var/swap/swapfile)
    SWAP_PHYSICAL_OFFSET=$(sudo btrfs inspect-internal map-swapfile -r /var/swap/swapfile)

    echo "resume=UUID=$SWAP_UUID" | sudo tee -a /etc/default/grub
    echo "resume_offset=$SWAP_PHYSICAL_OFFSET" | sudo tee -a /etc/default/grub

    # update grub
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg

    # update dracut
    sudo dracut -f

    # Fixes
    # remember to disable secure boot
    # fix SELinux permissions (critical!) 
    # https://gist.github.com/Cryptophobia/e304a04fcb156dd0959fbba6b7a26106
    sudo semanage fcontext --add --type swapfile_t /var/swap/swapfile
    sudo restorecon -RF /var/swap
  fi
fi
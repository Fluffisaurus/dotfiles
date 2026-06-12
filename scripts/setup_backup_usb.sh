# not using this script in KDE, letting KDE handle vs systemd

BACKUP_USB_UUID=$(sudo blkid -o value -s UUID $(sudo findfs LABEL="SanDisk_Ultra_Flair_64gb"))
BACKUP_FSTYPE=$(sudo blkid -o value -s TYPE $(sudo blkid -U "46BE1AA2BE1A8B17"))
MOUNT_LOCATION="/mnt/backup-usb"

echo "Setting up auto-mount for backup usb SanDisk_Ultra_Flair_64gb"
if [ ! -d "$MOUNT_LOCATION" ]; then
  echo "creating mount location $MOUNT_LOCATION..."
  sudo mkdir -p "$MOUNT_LOCATION"

  echo "configuring mount point in /etc/fstab..."
  echo "UUID=$BACKUP_USB_UUID $MOUNT_LOCATION $BACKUP_FSTYPE defaults,nofail,noatime,users,x-systemd.automount 0 0" | sudo tee -a /etc/fstab

  echo "automount everything again"
  sudo mount -a

  echo "Complete."
else
  echo "Auto-mount already setup, nothing to do."
fi
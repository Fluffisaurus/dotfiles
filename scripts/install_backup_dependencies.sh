echo "Begin backup_setup.sh..."
echo "Backup setup with snapper, btrfs-assistant, and libdnf5-plugin-snapper"

## PIKA-BACKUP FROM FLATPAK
if flatpak info org.gnome.World.PikaBackup &> /dev/null; then
    echo "Pika Backup already installed, skipping..."
else
    echo "Missing dependency: PikaBackup, installing..."
    flatpak remote-add --if-not-exists flathub https://flathub.org
    flatpak install flathub org.gnome.World.PikaBackup
fi


## SNAPPER AND BTRFS-ASSISTANT
dependencies=("snapper" "btrfs-assistant")

echo "Installing snapper and btrfs-assistant"
for pkg in "${dependencies[@]}"; do
  if ! rpm -q "$pkg" &> /dev/null; then
    echo "Missing dependency: $pkg, installing..."
    sudo dnf install -y "$pkg"
  else
    echo "$pkg already installed, skipping..."
  fi
done


## GRUB-BTRFS
echo "Installing grub-btrfs"
if ! systemctl is-active --quiet grub-btrfsd; then
  echo "Did not detect active grub-btrfsd service in background."
  echo "Missing dependency grub-btrfs, installing..."
  echo "Cloning grub-btrfs into ~/Downloads/grub-btrfs"
  git clone https://github.com/Antynea/grub-btrfs.git ~/Downloads/grub-btrfs
  cd ~/Downloads/grub-btrfs
  echo "Using make install for grub-btrfs"
  sudo make install
  echo "Start the grub-btrfsd daemon and enable at startup"
  sudo systemctl start grub-btrfsd
  sudo systemctl enable grub-btrfsd
  echo "Successfully setup grub-btrfs"
else
  echo "grub-btrfs is already installed and grub-btrfsd service is active, skipping..."
fi


## LIBDNF5-PLUGIN-SNAPPER
FEDORA_VERSION=44
PLUGIN_GITHUB_OWNER=Plenvorik
PLUGIN_GITHUB_REPO=libdnf5-plugin-snapper

echo "Installing $PLUGIN_GITHUB_REPO by $PLUGIN_GITHUB_OWNER"
if ! rpm -q "$PLUGIN_GITHUB_REPO" &> /dev/null; then
  echo "Missing dependency $PLUGIN_GITHUB_REPO, installing..."
  echo "Fetching latest ${PLUGIN_GITHUB_REPO} for Fedora ${FEDORA_VERSION}"
  curl -s https://api.github.com/repos/Plenvorik/libdnf5-plugin-snapper/releases/latest | \
    jq -r --arg ver "$FEDORA_VERSION" '.assets[] | select(.name | contains($ver) and contains ("src.rpm")) | .browser_download_url' | \
    xargs curl -LO --output-dir ~/Downloads

  echo "Installing latest ${PLUGIN_GITHUB_REPO} for Fedora ${FEDORA_VERSION}"
  sudo dnf install ~/Downloads/libdnf5-plugin-snapper-*.rpm -y
  echo "Successfully installed ${PLUGIN_GITHUB_REPO}"
else
  echo "$PLUGIN_GITHUB_REPO already installed, skipping..."
fi


## CLEANUP
echo "Cleaning up residual files..."
rm -rf ~/Downloads/grub-btrfs ~/Downloads/libdnf5-plugin-snapper-*.rpm
echo "backup_setup.sh complete"
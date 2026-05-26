echo "Begin backup_setup.sh..."
echo "Backup setup with snapper, btrfs-assistant, and libdnf5-plugin-snapper"

echo "Installing snapper and btrfs-assistant"
sudo dnf install snapper btrfs-assistant -y

echo "Cloning grub-btrfs into ~/Downloads/grub-btrfs"
git clone https://github.com/Antynea/grub-btrfs.git ~/Downloads/grub-btrfs
cd ~/Downloads/grub-btrfs
echo "Using make install for grub-btrfs"
sudo make install
echo "Start the grub-btrfsd daemon and enable at startup"
sudo systemctl start grub-btrfsd
sudo systemctl enable grub-btrfsd
echo "Successfully setup grub-btrfs"


FEDORA_VERSION=43
PLUGIN_GITHUB_OWNER=Plenvorik
PLUGIN_GITHUB_REPO=libdnf5-plugin-snapper

echo "Fetching latest ${PLUGIN_GITHUB_REPO} for Fedora ${FEDORA_VERSION}"
curl -s https://api.github.com/repos/Plenvorik/libdnf5-plugin-snapper/releases/latest | \
  jq -r --arg ver "$FEDORA_VERSION" '.assets[] | select(.name | contains($ver) and contains ("src.rpm")) | .browser_download_url' | \
  xargs curl -LO --output-dir ~/Downloads

echo "Installing latest ${PLUGIN_GITHUB_REPO} for Fedora ${FEDORA_VERSION}"
sudo dnf install ~/Downloads/libdnf5-plugin-snapper-*.rpm -y
echo "Successfully installed ${PLUGIN_GITHUB_REPO}"

echo "Cleaning up residual files..."
rm -rf ~/Downloads/grub-btrfs ~/Downloads/libdnf5-plugin-snapper-*.rpm
echo "backup_setup.sh complete"
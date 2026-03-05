#!/usr/bin/env bash

# Asus laptops have an issue with setting battery charge limit
# Tried suggestions in wiki (udev, early module loading, tlp) and 
# battery charge settings in KDE, but nothing worked. 
# bat was the only option that worked for me, results may vary
#
# confirm if bat worked after install with either:
#   cat /sys/class/power_supply/BAT*/charge_control_end_threshold
# or:
#   bat threshold
# 
# wiki: https://wiki.archlinux.org/title/Laptop/ASUS#Battery_charge_threshold
# kde issue: https://discussion.fedoraproject.org/t/kde-battery-charge-limit-reset-after-reboot/95628
# bat repo: https://github.com/tshakalekholoane/bat

# Bat repo config info
OWNER="tshakalekholoane"
REPO="bat"
ASSET_NAME_PATTERN="bat"  # desired asset file, e.g., ".*linux-amd64.tar.gz"

# install bat if asus laptop
if [[ $(hostnamectl chassis) = "laptop" || $(hostnamectl chassis) = "convertible" && $(hostnamectl | grep "Vendor" | sed "s/.*Vendor: //") =~ "ASUS" ]]; then
    echo -e "----------\nASUS LAPTOP SETUP"
    echo -e "ASUS laptop detected, installing dependency bat.\n"

    # grab the latest release information using the GitHub API
    RELEASE_INFO=$(curl -sL https://api.github.com/repos/"$OWNER"/"$REPO"/releases/latest)

    # get the version (tag name) and the download URL using jq
    VERSION=$(echo "$RELEASE_INFO" | jq -r ".tag_name")
    echo "Latest bat version: $VERSION"

    DOWNLOAD_URL=$(echo "$RELEASE_INFO" | jq -r '.assets[] | select(.name? | match("'"$ASSET_NAME_PATTERN"'")) | .browser_download_url')

    # Check if the URL was found
    if [ -z "$DOWNLOAD_URL" ]; then
        echo "Error: Could not find asset matching pattern '$ASSET_NAME_PATTERN' for version $VERSION" >&2
        exit 1
    fi

    # get the original asset filename from the URL for renaming
    ORIGINAL_FILENAME=$(basename "$DOWNLOAD_URL")

    # make the new filename with the version appended
    NEW_FILENAME="${ORIGINAL_FILENAME%.*}-${VERSION}"

    # check if current bat file is same version, if it is, skip
    if [ -f "$NEW_FILENAME" ]; then 
        echo "Current version of bat is already the latest, skipping."
    else
        echo "Downloading $ORIGINAL_FILENAME (version $VERSION) to $NEW_FILENAME"
        curl -L -o "$NEW_FILENAME" "$DOWNLOAD_URL"

        echo -e "Successfully installed bat v$VERSION.\n"

        echo "Adding $NEW_FILENAME to path..."
        chmod +x "./$NEW_FILENAME"
        sudo ln -sf ~/dotfiles/$NEW_FILENAME /usr/local/bin/asus_bat_util

        if ! command -v asus_bat_util &> /dev/null; then
            echo "Error with bat installation."
            exit 1
        fi
        echo -e "Successfully added bat to path.\n"

        echo "Setting battery charge limit threshold to 80..."
        sudo asus_bat_util threshold 80
        echo "Running suggested command to persist changes..."
        sudo asus_bat_util persist
        
        echo -e "\nSucessfully completed bat setup.\n"
    fi 

else
    echo "Device is not a laptop and/or not from vendor ASUS."
    echo -e "Nothing to do.\n"
fi

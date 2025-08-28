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

# install bat if asus laptop
if [ $(hostnamectl chassis) = "laptop" ] && [[ $(hostnamectl | grep "Vendor" | sed "s/.*Vendor: //") =~ "ASUS" ]]; then
    echo -e "----------\nASUS LAPTOP SETUP"
    echo -e "ASUS laptop detected, installing dependency bat.\n"

    if [ -f "./bat" ]; then
        echo "Dependency bat already exists, deleting to download latest."
        rm bat*
        echo -e "Successfully removed existing version of bat.\n"
    fi

    echo "Installing dependency bat for battery power management..."
    curl -sL https://api.github.com/repos/tshakalekholoane/bat/releases/latest| \
        jq -r '.assets[] | select(.name? | match("bat")) | .browser_download_url' | \
        wget -i - -nv --show-progress
    echo -e "Successfully installed bat.\n"

    echo "Adding bat to path..."
    chmod +x ./bat
    ln -s ./bat /usr/local/bin/bat
    if ! command -v bat &> /dev/null; then
        echo "Error with bat installation."
        exit 1
    fi
    echo -e "Successfully added bat to path.\n"

    echo "Setting battery charge limit threshold to 80..."
    sudo bat threshold 80
    echo "Running suggested command to persist changes..."
    sudo bat persist
    
    echo -e "\nSucessfully completed bat setup.\n"

else
    echo "Device is not a laptop and/or not from vendor ASUS."
    echo -e "Nothing to do.\n"
fi

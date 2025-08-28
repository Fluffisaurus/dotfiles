#!/usr/bin/env bash

deps=("fish" "fzf" "fd" "bat")
echo -e "----------\nDEPENDENCIES"
echo "Dependencies to install: [${deps[*]}]"

for dep in ${deps[@]}; do
    if ! command -v "$dep" &> /dev/null; then
        echo "  Installing dependency $dep..."
        sudo dnf install $dep
        echo "  Successfully installed $dep."
    else
        echo "  $dep is already installed, skipping."
    fi
done
echo -e "All dependencies installed.\n\n"

# set default shell to fish
echo -e "----------\nDEFAULT SHELL"
echo "Current default shell: $SHELL"
fish_path=$(which fish)
if [[ "$SHELL" != "$fish_path" ]]; then
    echo "Setting default shell to $fish_path..."
    chsh -s $fish_path
    echo -e "Successfully set default shell to $fish_path\n"
else
    echo -e "Default shell is already $fish_path, skipping.\n"
fi

# activate keybindings for fzf 
eval "$(fzf --bash)"

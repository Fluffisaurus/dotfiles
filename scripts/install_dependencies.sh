#!/usr/bin/env bash

deps=("fish" "fzf" "fd" "bat")
echo "Dependencies to install: [${deps[*]}]"

for dep in ${deps[@]}; do
    if ! command -v "$dep" &> /dev/null; then
        echo "Installing dependency $dep..."
        sudo dnf install $dep
        echo "Successfully installed $dep."
    else
        echo "$dep is already installed, skipping."
    fi
done
echo "All dependencies installed."


# set default shell to fish
echo "Current default shell: $SHELL"
fish_path=$(which fish)
if [[ "$SHELL" != "$fish_path" ]]; then
    echo "Setting default shell to $fish_path..."
    chsh -s $fish_path
    echo "Successfully set default shell to $fish_path"
else
    echo "Default shell is already $fish_path, skipping."
fi

# activate keybindings for fzf 
eval "$(fzf --bash)"

#!/usr/bin/env bash

echo -e "----------\nFONTS"
echo "Installing JetBrainsMono nerd font to ~/.local/share/fonts"

# check if JetBrainsMono is installed, if empty, install
if [[ -z $(fc-list | grep -i "JetBrainsMono") ]]; then 
  wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip

  echo "Successfully downloaded..."
  cd ~/.local/share/fonts
  unzip JetBrainsMono.zip
  rm JetBrainsMono.zip

  echo "Building font cache files..."
  fc-cache 
  echo "Success!"
else
  echo -e "Required fonts already installed, skipping.\n"
fi



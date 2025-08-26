# dotfiles


## quick start

Run these commands after cloning repo

```
cp -r ~/dotfiles/git/* ~/
```

## setup term dropdown
Go to `Settings`, `Keyboard`, `Shortcuts` and add a custom script. Choose `super+space` as shortcut to activate.

Edit `my_term` in `any_term_dropdown.sh` to change to desired terminal.


## fish setup
1. install fish and set as main shell
```
sudo dnf install fish
chsh -s $(which fish)
```

2. install fzf.fish dependencies
```
sudo dnf install fzf
fzf --fish | source # activate keybindings for fzf in fish

sudo dnf install fd-find

sudo dnf install bat
```

3. copy over config files
```
cp -r ~/dotfiles/fish/.config/fish/* ~/.config/fish/
cp -r ~/dotfiles/fish/.config/omf/*  ~/.config/omf/
```

4. open a new terminal and it should have fish as it's default shell. `fish.config` will automatically run and automatically install `omf`, `fisher`, and all `fisher_plugins`.


# dotfiles

My dotfiles and reminders to my future self of what to do and where everything is.

## quick start

Clone repo and run install

```
git clone git@github.com:Fluffisaurus/dotfiles.git
cd dotfiles/ && ./install
```

## setup term dropdown
Go to `Settings`, `Keyboard`, `Shortcuts` and add the custom script in `~/scripts/any_term_dropdown.sh` (script should be there after you run `./install`). Choose `Meta+Space` as shortcut to activate.

Edit `my_term` in `any_term_dropdown.sh` to change to desired terminal. 
> 💡 Reminder to edit the actual file in the cloned repo.

This script technically works in making anything a dropdown window. Just change the search to find the specific target's window pid.

## fish shortcuts, aliases, wrappers, etc
List of my fish setup tings... so I don't forget. 

### fish functions
Check 'em out in `config/fish/functions`. If I'm cooked, I also setup [fish-abbreviation-tips plugin](https://github.com/gazorby/fish-abbreviation-tips) as a reminder.

### keyboard shortcuts from `fzf.fish`
Left them all as default keybindings (can customize them, [details here](https://github.com/PatrickF1/fzf.fish?tab=readme-ov-file#customize-key-bindings)).

| function | shortcut  | description|
| -------- | ------------| ------|
 [📁 Search Directory](https://github.com/PatrickF1/fzf.fish?tab=readme-ov-file#-search-director) | `Ctrl + Alt + F` | interactive preview for searching/finding files |
| [🪵 Search Git Log](https://github.com/PatrickF1/fzf.fish?tab=readme-ov-file#-search-git-log) | `Ctrl + Alt + S` | interactive preview for `git status` |
| [📝 Search Git Status](https://github.com/PatrickF1/fzf.fish?tab=readme-ov-file#-search-git-status) | `Ctrl + Alt + L` | interactive preview for `git log` |
| [📜 Search History](https://github.com/PatrickF1/fzf.fish?tab=readme-ov-file#-search-history) | `Ctrl + R` | interactive history of all commands ran |
| [🖥️ Search Processes](https://github.com/PatrickF1/fzf.fish?tab=readme-ov-file#%EF%B8%8F-search-processes) | `Ctrl + Alt + P` | interactive list of all running processes | 
|[💲 Search Variables]() | `Ctrl + V` | Interactive list showing all shell variables along with their scope, export status, details |

## dotbot

This repo utilizes [dotbot](https://github.com/anishathalye/dotbot). I chose this since it's lightweight and minimal. It does everything I need atm. More details on how to setup `install.conf.yaml` here in [Configuration](https://github.com/anishathalye/dotbot?tab=readme-ov-file#configuration) and [Directives](https://github.com/anishathalye/dotbot?tab=readme-ov-file#directives) sections.

For more details on dotfiles, go to https://dotfiles.github.io/. There's also a convenient aggregate of [dotfile utilities](https://dotfiles.github.io/utilities/) that the community uses. 

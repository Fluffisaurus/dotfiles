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

## kde configs: portable vs per-machine


- `kde/` (`./install kde`) — the portable stuff: `kdeglobals`, konsole, GTK theming, splash/lock screen, baloo, plasmoids, and the `/etc` power/hibernate configs. These are symlinked, so edits flow both ways automatically.
- `kde/machines/<machine>/` (`./install kde <machine>`, e.g. `./install kde zenbook-duo`) — stuff glued to this exact hardware: `kcminputrc` (this keyboard/touchpad), `kwinrc` (tiling keyed by monitor UUIDs), `plasma-org.kde.plasma.desktop-appletsrc` (panel layout tied to screen IDs). These are **copied, not symlinked** (via `scripts/kde_machine_sync.sh`), because Plasma rewrites them constantly and symlinks would dump all that churn straight into the repo.

Changed a panel/tiling/input setting I actually want to keep? Pull it in on purpose:

```
~/Scripts/kde_machine_sync.sh diff     # see what changed vs the repo
~/Scripts/kde_machine_sync.sh export   # copy it into the repo
git diff kde/machines/zenbook-duo      # review, then commit
```

New machine: copy `kde/machines/zenbook-duo/` as a starting point, make a matching `<machine>.conf.yaml` at the repo root, run `./install kde <machine>`, let Plasma settle, then `kde_machine_sync.sh export <machine>` and commit.

### gotchas to rmbr

- `./install kde` tries to symlink into `/etc`, which fails as my user — and running the whole thing with `sudo` is WORSE (`~` becomes `/root`, so the cleans, `~/.config` links, and the machine-config `apply` all target root's home). Until the `/etc` bits get their own `sudo install` copy step, place those files by hand. Root-owned real files in `/etc` beat symlinks into /home anyway — snapper/systemd read them as root, possibly before /home is even mounted.
- Plasma holds configs in memory and writes them back when it exits — running `apply` mid-session can get clobbered at logout. Safest order: apply, then `systemctl --user restart plasma-plasmashell` to reload the desktop, or just log out/in for kwin + input changes.
- `export` copies the WHOLE live file — my deliberate changes and Plasma's noise together. Always read the `git diff` before committing; no blind `git add -A` on machine files.
- The portable `kde/config` files ARE still symlinked, and KDE's atomic saves can silently swap a symlink for a real file. Check `ls -la ~/.config/kdeglobals` once in a while — if it's not a link anymore, re-run `./install kde`.
- The wallpaper in `appletsrc` is just a fallback (`/usr/share/wallpapers/Next`) — superpaper autostarts and takes over at login. If an export brings in `~/.cache/superpaper/...` paths, don't keep them.
- `*.tbcache` (Dolphin cache) is gitignored on purpose. If other cache-looking files sneak into `kde/local`, ignore those too instead of committing them.
- The machine files moved out of `kde/config/` in Aug 2026 — use `git log --follow` when digging through their older history.

> 💡 Reminder: `konsave` was considered and rejected — it just zips these same files into opaque snapshots with no git history. The split above + sync script does the same job with diffs.

## dotbot

This repo utilizes [dotbot](https://github.com/anishathalye/dotbot). I chose this since it's lightweight and minimal. It does everything I need atm. More details on how to setup `install.conf.yaml` here in [Configuration](https://github.com/anishathalye/dotbot?tab=readme-ov-file#configuration) and [Directives](https://github.com/anishathalye/dotbot?tab=readme-ov-file#directives) sections.

For more details on dotfiles, go to https://dotfiles.github.io/. There's also a convenient aggregate of [dotfile utilities](https://dotfiles.github.io/utilities/) that the community uses. 

#!/bin/env fish

# Bootstrap oh-my-fish if not installed already
if not type -q omf
    echo "oh-my-fish is not installed."
    echo "Installing oh-my-fish..."

    curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install > install
    fish install --path=~/.local/share/omf --config=~/.config/omf
    echo "Finished installing oh-my-fish!"

    echo "Applying bobthefish settings..."
    set -g theme_powerline_fonts yes
    set -g theme_nerd_fonts no
    set -g theme_display_git_stashed_verbose yes
    set -g theme_display_git_master_branch yes
    set -g theme_display_git_untracked yes
    set -g theme_display_git_dirty yes
    set -g theme_display_nvm yes
    set -g theme_display_virtualenv yes
    set -g theme_color_scheme nord
    echo "Finished applying bobthefish settings!"
end

# pipenv creates .venv inside each project, https://pipenv.pypa.io/en/latest/#basic-usage
set -x PIPENV_VENV_IN_PROJECT true

if status is-interactive
    # Commands to run in interactive sessions can go here
end


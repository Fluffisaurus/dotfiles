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

# Bootstrap Fisher package manager if not installed already
if not type -q fisher
    # Download fisher
    echo "Fisher package manager is not installed."
    echo "Downloading Fisher package manager..."
    curl -sL https://git.io/fisher | source
    echo "Finished installing Fisher!"

    # Change XDG_CONFIG_HOME temporarily to prevent nonexistent commmands
    # from being executed
    set tmpdir (mktemp -d)
    set xdg_config_home_backup $XDG_CONFIG_HOME
    set -x XDG_CONFIG_HOME $tmpdir

    # Install other plugins
    fisher update

    # Delete the temporary directory and restore XDG_CONFIG_HOME
    rm -rf $tmpdir
    set -gx XDG_CONFIG_HOME $xdg_config_home_backup
end

# Try updating the plugins
if not set --query __dotfiles_fish_update
    set -x __dotfiles_fish_update 1

    diff -qw (cat $__fish_config_dir/fish_plugins | sort | psub) (fisher list | sort | psub) >/dev/null
    or fisher update
end

# pipenv creates .venv inside each project, https://pipenv.pypa.io/en/latest/#basic-usage
set -x PIPENV_VENV_IN_PROJECT true

if status is-interactive
    # Commands to run in interactive sessions can go here
end


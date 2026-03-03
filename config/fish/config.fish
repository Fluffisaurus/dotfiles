#!/bin/env fish

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

# starship setup
set -gx STARSHIP_CONFIG ~/.config/starship/custom-catppuccin-powerline.toml
starship init fish | source

if status is-interactive
    # Commands to run in interactive sessions can go here
end


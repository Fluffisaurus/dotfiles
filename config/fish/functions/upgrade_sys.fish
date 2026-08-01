#!/bin/env fish

function upgrade_sys --description 'sudo dnf upgrade --refresh && flatpak update'
    sudo dnf upgrade --refresh && flatpak update
end

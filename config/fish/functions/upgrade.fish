#!/bin/env fish

function upgrade --description 'sudo dnf upgrade --refresh && flatpak update'
    sudo dnf upgrade --refresh && flatpak update
end

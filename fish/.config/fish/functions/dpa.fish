#!/bin/env fish

# Taken from https://git.nicco.io/cupcakearmy/dotfiles/src/commit/9c9aa7d9ee7d6cef15e932813da109daad5852c7/files/fish/functions/dpa.fish
function dpa --wraps='docker system prune -af --volumes' --description 'alias dpa docker system prune -af --volumes'
  docker system prune -af --volumes $argv;
end

#!/bin/env fish

# Taken from https://github.com/cupcakearmy/dotfiles/blob/main/files/fish/functions/dc.fish
function dc --wraps=docker-compose --description 'alias dc=docker-compose'
  docker compose  $argv;
end

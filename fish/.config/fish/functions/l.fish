#!/bin/env fish

function l --wraps=ls --description 'alias l ls'
  ls $argv; 
end

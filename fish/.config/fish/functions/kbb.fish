#!/bin/env fish

function kbb --wraps="duo kbb" --description 'alias kbb duo kbb'
  duo kbb $argv; 
end

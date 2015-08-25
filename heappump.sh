#!/bin/bash

COUNTER=0

while [ 1 ]; do
  let COUNTER=COUNTER+1
  echo "Iteration #$COUNTER"

  redis-cli info memory | grep used_memory_lua
  redis-cli --eval heappump.lua , 100000000 10000
  redis-cli info memory | grep used_memory_lua

  echo
done

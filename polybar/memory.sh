#!/usr/bin/env sh

free -b | awk '/^Mem:/ {
  printf "%.1f/%.1f\n", $3 / 1073741824, $2 / 1073741824
}'

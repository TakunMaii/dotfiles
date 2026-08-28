#!/usr/bin/env sh

df -B1 / | awk 'NR == 2 {
  printf "%%{F#6CAFCE}/%%{F-} %.1f/%.1f\n", $3 / 1073741824, $2 / 1073741824
}'

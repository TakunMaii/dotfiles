#!/bin/bash

volume=$(amixer get Master | grep -oP '\d+%' | head -n 1 | tr -d '%')

echo "VOL: $volume%"

exit 0

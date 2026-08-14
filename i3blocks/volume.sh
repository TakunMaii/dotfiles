#!/bin/bash

volume=$(amixer get Master | grep -oP '\d+%' | head -n 1 | tr -d '%')

echo "   $volume%"

exit 0

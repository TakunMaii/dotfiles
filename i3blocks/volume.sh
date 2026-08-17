#!/bin/bash

volume=$(awk -v v="$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}')" 'BEGIN{printf "%.0f%%", v*100}' )

echo "   $volume"

exit 0

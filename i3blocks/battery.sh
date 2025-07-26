#!/bin/bash

BAT=$(acpi -b | grep -E -o '[0-9][0-9][0-9]?%')

# Full and short texts
echo "BAT:$BAT"

[ ${BAT%?} -le 20 ] && exit 33
[ ${BAT%?} -le 50 ] && echo "#FF8000"

exit 0

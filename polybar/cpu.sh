#!/usr/bin/env sh

state_dir="/tmp/polybar-cpu-$(id -u)"
mode_file="$state_dir/mode"
stat_file="$state_dir/stat"

mkdir -p "$state_dir"

refresh() {
  if [ -n "$1" ]; then
    polybar-msg -p "$1" action cpu hook 0 >/dev/null 2>&1
  else
    polybar-msg action cpu hook 0 >/dev/null 2>&1
  fi
}

if [ "$1" = "--toggle" ]; then
  if [ "$(cat "$mode_file" 2>/dev/null)" = "detail" ]; then
    printf 'simple\n' > "$mode_file"
  else
    printf 'detail\n' > "$mode_file"
  fi
  refresh "$2"
  exit 0
fi

mode="$(cat "$mode_file" 2>/dev/null)"
[ -n "$mode" ] || mode="simple"

read_cpu() {
  awk '/^cpu / {
    idle = $5 + $6
    total = 0
    for (i = 2; i <= NF; i++) total += $i
    print total, idle
  }' /proc/stat
}

current="$(read_cpu)"
prev="$(cat "$stat_file" 2>/dev/null)"
printf '%s\n' "$current" > "$stat_file"

total="$(printf '%s\n' "$current" | awk '{print $1}')"
idle="$(printf '%s\n' "$current" | awk '{print $2}')"
prev_total="$(printf '%s\n' "$prev" | awk '{print $1}')"
prev_idle="$(printf '%s\n' "$prev" | awk '{print $2}')"

if [ -n "$prev_total" ] && [ "$total" -gt "$prev_total" ]; then
  usage="$(awk -v total="$total" -v idle="$idle" -v prev_total="$prev_total" -v prev_idle="$prev_idle" 'BEGIN {
    total_delta = total - prev_total
    idle_delta = idle - prev_idle
    printf "%2.0f%%", (100 * (total_delta - idle_delta)) / total_delta
  }')"
else
  usage=" 0%"
fi

temperature="-"
for temp_file in /sys/class/thermal/thermal_zone0/temp /sys/class/thermal/thermal_zone*/temp; do
  [ -r "$temp_file" ] || continue
  temp_raw="$(cat "$temp_file" 2>/dev/null)"
  [ -n "$temp_raw" ] || continue
  temperature="$(awk -v temp="$temp_raw" 'BEGIN { printf "%.0fC", temp / 1000 }')"
  break
done

if [ "$mode" = "detail" ]; then
  printf '%%{F#6CAFCE}CPU %%{F-}%s %%{F#6CAFCE}TEMP %%{F-}%s\n' "$usage" "$temperature"
else
  printf '%%{F#6CAFCE}CPU %%{F-}%s\n' "$usage"
fi

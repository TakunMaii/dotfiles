#!/usr/bin/env sh

state_dir="/tmp/polybar-network-$(id -u)"
mode_file="$state_dir/mode"
speed_file="$state_dir/speed"

mkdir -p "$state_dir"

if [ "$1" = "--toggle" ]; then
  if [ "$(cat "$mode_file" 2>/dev/null)" = "detail" ]; then
    printf 'simple\n' > "$mode_file"
  else
    printf 'detail\n' > "$mode_file"
  fi
  if [ -n "$2" ]; then
    polybar-msg -p "$2" action network hook 0 >/dev/null 2>&1
  else
    polybar-msg action network hook 0 >/dev/null 2>&1
  fi
  exit 0
fi

mode="$(cat "$mode_file" 2>/dev/null)"
[ -n "$mode" ] || mode="simple"

is_wifi() {
  [ -d "/sys/class/net/$1/wireless" ]
}

is_connected() {
  iface="$1"
  [ "$iface" = "lo" ] && return 1
  [ "$(cat "/sys/class/net/$iface/operstate" 2>/dev/null)" = "up" ] && return 0
  [ "$(cat "/sys/class/net/$iface/carrier" 2>/dev/null)" = "1" ] && return 0
  return 1
}

connected_iface=""
connected_type=""

for iface_path in /sys/class/net/*; do
  iface="${iface_path##*/}"
  if is_connected "$iface" && ! is_wifi "$iface"; then
    connected_iface="$iface"
    connected_type="wired"
    break
  fi
done

if [ -z "$connected_iface" ]; then
  for iface_path in /sys/class/net/*; do
    iface="${iface_path##*/}"
    if is_connected "$iface" && is_wifi "$iface"; then
      connected_iface="$iface"
      connected_type="wifi"
      break
    fi
  done
fi

if [ -z "$connected_iface" ]; then
  if [ "$mode" = "detail" ]; then
    printf '%%{F#4FC1E9}network%%{F#707880} disconnected%%{F-}\n'
  else
    printf '%%{F#4FC1E9}Disconnect%%{F-}\n'
  fi
  exit 0
fi

if [ "$mode" != "detail" ]; then
  if [ "$connected_type" = "wifi" ]; then
    printf '%%{F#4FC1E9}Wifi%%{F-}\n'
  else
    printf '%%{F#4FC1E9}Wired%%{F-}\n'
  fi
  exit 0
fi

ip_addr="$(ip -o -4 addr show dev "$connected_iface" 2>/dev/null | awk '{sub(/\/.*/, "", $4); print $4; exit}')"
[ -n "$ip_addr" ] || ip_addr="$(hostname -I 2>/dev/null | awk '{print $1}')"
[ -n "$ip_addr" ] || ip_addr="-"

format_rate() {
  awk -v bytes="$1" 'BEGIN {
    if (bytes >= 1048576) {
      printf "%.1fMiB/s", bytes / 1048576
    } else {
      printf "%.0fKiB/s", bytes / 1024
    }
  }'
}

if [ "$connected_type" = "wifi" ]; then
  ssid="$(iwgetid "$connected_iface" -r 2>/dev/null)"
  if [ -z "$ssid" ] && command -v nmcli >/dev/null 2>&1; then
    ssid="$(nmcli -t -f active,ssid dev wifi 2>/dev/null | awk -F: '$1 == "yes" {print $2; exit}')"
  fi
  [ -n "$ssid" ] || ssid="-"
  printf '%%{F#4FC1E9}%s%%{F-} %s %s\n' "$connected_iface" "$ssid" "$ip_addr"
  exit 0
fi

now="$(date +%s)"
rx="$(cat "/sys/class/net/$connected_iface/statistics/rx_bytes" 2>/dev/null)"
tx="$(cat "/sys/class/net/$connected_iface/statistics/tx_bytes" 2>/dev/null)"
prev="$(cat "$speed_file" 2>/dev/null)"

prev_iface="$(printf '%s\n' "$prev" | awk '{print $1}')"
prev_now="$(printf '%s\n' "$prev" | awk '{print $2}')"
prev_rx="$(printf '%s\n' "$prev" | awk '{print $3}')"
prev_tx="$(printf '%s\n' "$prev" | awk '{print $4}')"

printf '%s %s %s %s\n' "$connected_iface" "$now" "$rx" "$tx" > "$speed_file"

if [ "$prev_iface" = "$connected_iface" ] && [ -n "$prev_now" ] && [ "$now" -gt "$prev_now" ]; then
  elapsed=$((now - prev_now))
  down=$(((rx - prev_rx) / elapsed))
  up=$(((tx - prev_tx) / elapsed))
else
  down=0
  up=0
fi

printf '%%{F#4FC1E9}%s%%{F-} ↑%s ↓%s\n' "$ip_addr" "$(format_rate "$up")" "$(format_rate "$down")"

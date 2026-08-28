#!/usr/bin/env sh

name="MALICE"
target="maii@maiiw.top"
state_dir="/tmp/polybar-server-$(id -u)"
mode_file="$state_dir/mode"
cache_file="$state_dir/cache"

blue="#4FC1E9"
muted="#707880"
green="#A6E22E"
red="#F92672"

mkdir -p "$state_dir"

refresh_bar() {
  if [ -n "$1" ]; then
    polybar-msg -p "$1" action server hook 0 >/dev/null 2>&1
  else
    polybar-msg action server hook 0 >/dev/null 2>&1
  fi
}

refresh_cache() {
  data="$(
    timeout 6 ssh \
      -F /dev/null \
      -o BatchMode=yes \
      -o ConnectTimeout=2 \
      -o ServerAliveInterval=2 \
      -o ServerAliveCountMax=1 \
      "$target" \
      'sh -s' 2>/dev/null <<'REMOTE'
load=$(awk '{print $1}' /proc/loadavg)
mem=$(free -b | awk '/^Mem:/ {printf "%.1f/%.1f", $3 / 1073741824, $2 / 1073741824}')
disk=$(df -B1 / | awk 'NR == 2 {printf "%.1f/%.1f", $3 / 1073741824, $2 / 1073741824}')

printf 'status=up\n'
printf 'resource=%s M %s D %s\n' "$load" "$mem" "$disk"

hermes_root="${HERMES_HOME:-$HOME/.hermes}"

json_value() {
  file="$1"
  key="$2"
  [ -r "$file" ] || return 1
  python3 -c 'import json,sys
try:
    with open(sys.argv[1], encoding="utf-8") as f:
        data=json.load(f)
    value=data.get(sys.argv[2], "")
    if isinstance(value, bool):
        value="true" if value else "false"
    print(value if value is not None else "")
except Exception:
    sys.exit(1)' "$file" "$key" 2>/dev/null
}

pid_live() {
  pid="$1"
  [ -n "$pid" ] || return 1
  case "$pid" in
    *[!0-9]*) return 1 ;;
  esac
  kill -0 "$pid" 2>/dev/null
}

profile_label() {
  profile="$1"
  home="$2"
  meta_file="$home/profile.yaml"
  display_name="$(
    [ -r "$meta_file" ] || exit 1
    python3 -c 'import re, sys
path = sys.argv[1]
try:
    import yaml
except Exception:
    yaml = None

try:
    with open(path, encoding="utf-8") as f:
        if yaml is not None:
            data = yaml.safe_load(f) or {}
            value = data.get("display_name", "") if isinstance(data, dict) else ""
        else:
            value = ""
            for line in f:
                match = re.match(r"^\s*display_name\s*:\s*(.*?)\s*$", line)
                if match:
                    value = match.group(1).strip()
                    if (
                        len(value) >= 2
                        and value[0] == value[-1]
                        and value[0] in "\"'\''"
                    ):
                        value = value[1:-1]
                    break
    value = str(value or "").strip()
    value = re.sub(r"[\t\r\n]+", " ", value)
    print(value)
except Exception:
    sys.exit(1)' "$meta_file" 2>/dev/null
  )"
  [ -n "$display_name" ] || display_name="$profile"
  printf '%s' "$display_name"
}

profile_status() {
  profile="$1"
  home="$2"
  state_file="$home/gateway_state.json"
  pid_file="$home/gateway.pid"
  lock_file="$home/gateway.lock"

  pid="$(json_value "$state_file" pid)"
  [ -n "$pid" ] || pid="$(json_value "$lock_file" pid)"
  if [ -z "$pid" ] && [ -r "$pid_file" ]; then
    pid="$(awk 'NR == 1 {print $1}' "$pid_file" 2>/dev/null)"
  fi

  pid_live "$pid" || return 0

  state="$(json_value "$state_file" gateway_state)"
  case "$state" in
    running|starting|draining|"") health="ok" ;;
    *) health="bad" ;;
  esac

  printf 'hermes\t%s\t%s\n' "$(profile_label "$profile" "$home")" "$health"
}

if [ -d "$hermes_root" ]; then
  profile_status "default" "$hermes_root"
  if [ -d "$hermes_root/profiles" ]; then
    for profile_home in "$hermes_root"/profiles/*; do
      [ -d "$profile_home" ] || continue
      profile_status "$(basename "$profile_home")" "$profile_home"
    done
  fi
fi
REMOTE
  )"

  if [ -n "$data" ]; then
    printf '%s\n' "$data" > "$cache_file"
  else
    printf 'status=down\nresource=\n' > "$cache_file"
  fi
}

open_diagnostics() {
  command="ssh -F /dev/null -t $target 'printf \"MALICE Hermes diagnostics\n\n\"; hermes status --all; printf \"\n\"; hermes gateway list; printf \"\n\"; hermes gateway status'; printf \"\nPress Enter to close...\"; read _"

  if command -v alacritty >/dev/null 2>&1; then
    alacritty -e sh -lc "$command" >/dev/null 2>&1 &
  elif command -v kitty >/dev/null 2>&1; then
    kitty sh -lc "$command" >/dev/null 2>&1 &
  elif command -v xterm >/dev/null 2>&1; then
    xterm -e sh -lc "$command" >/dev/null 2>&1 &
  else
    i3-sensible-terminal -e sh -lc "$command" >/dev/null 2>&1 &
  fi
}

if [ "$1" = "--toggle" ]; then
  case "$(cat "$mode_file" 2>/dev/null)" in
    simple|"") printf 'resource\n' > "$mode_file" ;;
    resource) printf 'hermes\n' > "$mode_file" ;;
    *) printf 'simple\n' > "$mode_file" ;;
  esac
  refresh_bar "$2"
  exit 0
fi

if [ "$1" = "--refresh" ]; then
  refresh_cache
  refresh_bar "$2"
  exit 0
fi

if [ "$1" = "--diagnose" ]; then
  open_diagnostics
  exit 0
fi

mode="$(cat "$mode_file" 2>/dev/null)"
[ -n "$mode" ] || mode="simple"

cache="$(cat "$cache_file" 2>/dev/null)"
status="$(printf '%s\n' "$cache" | awk -F= '$1 == "status" {print substr($0, index($0, "=") + 1); exit}')"
resource="$(printf '%s\n' "$cache" | awk -F= '$1 == "resource" {print substr($0, index($0, "=") + 1); exit}')"
hermes="$(printf '%s\n' "$cache" | awk -F '\t' '$1 == "hermes" {print substr($0, index($0, "\t") + 1)}')"
hermes_legacy=""
[ -n "$hermes" ] || hermes_legacy="$(printf '%s\n' "$cache" | awk -F= '$1 == "hermes" {print substr($0, index($0, "=") + 1); exit}')"

[ -n "$status" ] || status="down"

if [ "$status" != "up" ]; then
  printf '%%{F%s}%s%%{F%s} down%%{F-}\n' "$blue" "$name" "$muted"
  exit 0
fi

case "$mode" in
  resource)
    if [ -n "$resource" ]; then
      printf '%%{F%s}%s%%{F-} %s\n' "$blue" "$name" "$resource"
    else
      printf '%%{F%s}%s%%{F%s} resource err%%{F-}\n' "$blue" "$name" "$muted"
    fi
    ;;
  hermes)
    printf '%%{F%s}%s%%{F-}' "$blue" "$name"
    if [ -n "$hermes" ]; then
      printf '%s\n' "$hermes" | while IFS="$(printf '\t')" read -r profile health; do
        if [ "$health" = "ok" ]; then
          printf ' %%{F%s}%s%%{F-}' "$green" "$profile"
        else
          printf ' %%{F%s}%s%%{F-}' "$red" "$profile"
        fi
      done
      printf '\n'
    elif [ -n "$hermes_legacy" ]; then
      for item in $hermes_legacy; do
        profile="${item%%:*}"
        health="${item#*:}"
        if [ "$health" = "ok" ]; then
          printf ' %%{F%s}%s%%{F-}' "$green" "$profile"
        else
          printf ' %%{F%s}%s%%{F-}' "$red" "$profile"
        fi
      done
      printf '\n'
    else
      printf ' %%{F%s}hermes none%%{F-}\n' "$muted"
    fi
    ;;
  *)
    printf '%%{F%s}%s%%{F-} up\n' "$blue" "$name"
    ;;
esac

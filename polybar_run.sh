#!/bin/bash

# 终端可能已经有在运行的实例
killall -q polybar

# 等待进程被终止
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# 默认使用简洁网络状态
rm -f "/tmp/polybar-network-$(id -u)/mode"
rm -f "/tmp/polybar-cpu-$(id -u)/mode"
rm -f "/tmp/polybar-server-$(id -u)/mode"

# 运行Polybar，使用默认的配置文件路径 ~/.config/polybar/config
polybar &
polybar_pid=$!
last_server_refresh=0

while kill -0 "$polybar_pid" 2>/dev/null; do
  polybar-msg -p "$polybar_pid" action network hook 0 >/dev/null 2>&1
  polybar-msg -p "$polybar_pid" action cpu hook 0 >/dev/null 2>&1
  now=$(date +%s)
  if [ $((now - last_server_refresh)) -ge 60 ]; then
    /home/maii/.config/polybar/server.sh --refresh "$polybar_pid" &
    last_server_refresh=$now
  fi
  sleep 2
done &

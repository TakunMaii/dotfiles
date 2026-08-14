#!/bin/bash

# ── 获取默认路由接口 ──────────────────────────────
get_default_iface() {
    ip route get 1.1.1.1 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i=="dev") print $(i+1); exit}'
}

# ── 获取接口 IP ──────────────────────────────────
get_ip() {
    local iface="$1"
    ip addr show "$iface" 2>/dev/null | awk '/inet / {print $2}' | cut -d/ -f1 | head -1
}

# ── 获取 WiFi SSID 和信号强度 ────────────────────
get_wifi_info() {
    local iface="$1"
    if command -v iw &>/dev/null; then
        local ssid quality
        ssid=$(iw dev "$iface" link 2>/dev/null | awk -F': ' '/SSID/ {print $2}')
        quality=$(iw dev "$iface" link 2>/dev/null | awk -F'=' '/tx bitrate/ {print $2}' | awk '{print $1}')
        if [[ -n "$ssid" ]]; then
            echo "$ssid"
            return 0
        fi
    fi
    return 1
}

# ── 判断接口类型 ─────────────────────────────────
get_iface_type() {
    local iface="$1"
    local path="/sys/class/net/$iface"
    if [[ -d "$path/wireless" ]] || [[ -L "$path/phy80211" ]]; then
        echo "wifi"
    elif [[ "$(cat "$path/type" 2>/dev/null)" == "1" ]] && [[ "$(cat "$path/carrier" 2>/dev/null)" == "1" ]]; then
        echo "eth"
    else
        echo "down"
    fi
}

# ── 主逻辑 ──────────────────────────────────────
IFACE=$(get_default_iface)

# 没有默认路由 → 尝试找第一个活跃接口
if [[ -z "$IFACE" ]]; then
    for iface in /sys/class/net/*; do
        iface=$(basename "$iface")
        [[ "$iface" == "lo" ]] && continue
        carrier=$(cat "/sys/class/net/$iface/carrier" 2>/dev/null)
        [[ "$carrier" == "1" ]] && IFACE="$iface" && break
    done
fi

# 仍然没找到 → 断网
if [[ -z "$IFACE" ]]; then
    echo "⚠ no connection"
    echo "⚠ no connection"
    echo "#ee3333"
    exit 0
fi

TYPE=$(get_iface_type "$IFACE")
IP=$(get_ip "$IFACE")

# ── 输出格式 ────────────────────────────────────
case "$TYPE" in
    wifi)
        SSID=$(get_wifi_info "$IFACE")
        LABEL="󰤨  "
        TEXT="${SSID:-$IFACE} ${IP:-...}"
        COLOR=""
        ;;
    eth)
        LABEL="  "
        TEXT="${IFACE} ${IP:-...}"
        COLOR=""
        ;;
    down)
        LABEL="❌"
        TEXT="$IFACE down"
        COLOR="#ee3333"
        ;;
esac

# i3blocks 三行输出协议：
# 第1行：短文本（显示在状态栏）
# 第2行：长文本（鼠标悬停，可选；省略则复用第1行）
# 第3行：颜色（可选）
echo "${LABEL} ${TEXT}"
# echo "${LABEL} ${TEXT} (${IFACE})"
# echo "$COLOR"

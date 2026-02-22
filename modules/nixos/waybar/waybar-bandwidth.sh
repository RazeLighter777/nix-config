#!/usr/bin/env bash
set -euo pipefail

ip="${IPROUTE_BIN:-/usr/bin/ip}"
awk="${AWK_BIN:-/usr/bin/awk}"
date="${DATE_BIN:-/usr/bin/date}"

# Default network interface fallback
iface="$($ip route show default 2>/dev/null | $awk 'NR==1{for(i=1;i<=NF;i++) if($i=="dev") {print $(i+1); exit}}')"
iface="${iface:-$(ls /sys/class/net | grep -v lo | head -n1)}"

if [[ -z "$iface" || ! -d "/sys/class/net/$iface/statistics" ]]; then
    echo "🢃 0.00 Mbps 🢁 0.00 Mbps"
    exit 0
fi

rx_file="/sys/class/net/$iface/statistics/rx_bytes"
tx_file="/sys/class/net/$iface/statistics/tx_bytes"
rx_now="$(cat "$rx_file" 2>/dev/null || echo 0)"
tx_now="$(cat "$tx_file" 2>/dev/null || echo 0)"
t_now_ns="$($date +%s%N)"

state_file="/tmp/waybar-bandwidth-$iface.state"

if [[ -f "$state_file" ]]; then
    read -r rx_prev tx_prev t_prev_ns < "$state_file" || true
else
    rx_prev="$rx_now"
    tx_prev="$tx_now"
    t_prev_ns="$t_now_ns"
fi

# Atomic write
if printf '%s %s %s\n' "$rx_now" "$tx_now" "$t_now_ns" > "$state_file.tmp"; then
    mv "$state_file.tmp" "$state_file" 2>/dev/null || rm -f "$state_file.tmp"
fi

# Calculate Mbps
dt=$(( (t_now_ns - t_prev_ns) / 1000000000 ))
[[ $dt -eq 0 ]] && dt=1
drx=$(( rx_now - rx_prev ))
dtx=$(( tx_now - tx_prev ))
(( drx < 0 )) && drx=0
(( dtx < 0 )) && dtx=0

down_mbps=$(awk "BEGIN {printf \"%.2f\", ($drx*8)/($dt*1000000)}")
up_mbps=$(awk "BEGIN {printf \"%.2f\", ($dtx*8)/($dt*1000000)}")

down_icon="🢃"
up_icon="🢁"
[[ $(echo "$down_mbps > 1.0" | bc -l) -eq 1 ]] && down_icon+="🚀"
[[ $(echo "$up_mbps > 1.0" | bc -l) -eq 1 ]] && up_icon+="🚀"

printf "%s %s Mbps %s %s Mbps\n" "$down_icon" "$down_mbps" "$up_icon" "$up_mbps"

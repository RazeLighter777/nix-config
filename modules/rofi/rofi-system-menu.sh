#!/usr/bin/env bash

set -euo pipefail

rofi_dmenu() {
	local prompt="$1"
	rofi -dmenu -i -p "$prompt" -display-columns 1
}

power_menu() {
	# Uses rofi-power-menu (installed by the rofi module)
	rofi -show p -modi "p:rofi-power-menu" -replace -i
}

apps_menu() {
	rofi -show drun -replace -i -show-icons
}

network_settings() {
	nm-connection-editor &
}

rofimoji() {
	rofi -replace -i -modi 'emoji:rofimoji --action=copy' -show emoji
}

clipboard_menu() {
	cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy
}

systemd_menu() {
	rofi-systemd &
}

bluetooth_menu() {
    rofi-bluetooth &
}

screenshot() {
	# Match the Hyprland bind: `hyprshot -m region`
	hyprshot -m region
}

main_menu() {
	local power='⏻  Power'
	local apps='󰀻  Applications'
	local network='󰖩  Network settings'
	local shot='󰹑  Screenshot (region)'
	local clipboard='📝  Clipboard'
	local systemd='⚙️  Systemd'
	local rofimoji_opt='😀  Emoji picker'
    local bluetooth='󰂯  Bluetooth devices'

	local chosen
	chosen="$(printf '%s\n' \
		"$power" \
		"$apps" \
		"$network" \
		"$shot" \
		"$clipboard" \
		"$systemd" \
		"$rofimoji_opt" \
        "$bluetooth" | rofi_dmenu 'System Menu')"

	case "$chosen" in
		"$power") power_menu ;;
		"$apps") apps_menu ;;
		"$network") network_settings ;;
		"$shot") screenshot ;;
		"$clipboard") clipboard_menu ;;
		"$systemd") systemd_menu ;;
		"$rofimoji_opt") rofimoji ;;
        "$bluetooth") bluetooth_menu ;;
		*) exit 0 ;;
	esac
}

case "${1:-}" in
	--power) power_menu ;;
	--apps) apps_menu ;;
	--network) network_settings ;;
	--screenshot) screenshot ;;
	--clipboard) clipboard_menu ;;
	--systemd) systemd_menu ;;
	--emoji) rofimoji ;;
    --bluetooth) bluetooth_menu ;;
	*) main_menu ;;
esac

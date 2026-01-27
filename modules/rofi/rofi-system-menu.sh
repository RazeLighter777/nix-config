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

screenshot() {
	# Match the Hyprland bind: `hyprshot -m region`
	hyprshot -m region
}

main_menu() {
	local power='⏻  Power'
	local apps='󰀻  Applications'
	local network='󰖩  Network settings'
	local shot='󰹑  Screenshot (region)'
    local rofimoji_opt='😀  Emoji picker'

	local chosen
	chosen="$(printf '%s\n' \
		"$power" \
		"$apps" \
		"$network" \
		"$shot" \
        "$rofimoji_opt" \
	| rofi_dmenu "System")" || exit 0

	case "$chosen" in
		"$power") power_menu ;;
		"$apps") apps_menu ;;
		"$network") network_settings ;;
		"$shot") screenshot ;;
        "$rofimoji_opt") rofimoji ;;
		*) exit 0 ;;
	esac
}

case "${1:-}" in
	--power) power_menu ;;
	--apps) apps_menu ;;
	--network) network_settings ;;
	--screenshot) screenshot ;;
    --emoji) rofimoji ;;
	*) main_menu ;;
esac

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

apps_root_menu() {
	# Root app launcher using polkit.
	# We build a dmenu list from available .desktop files, then pkexec the Exec.
	local -a data_dirs
	local xdg_data_dirs="${XDG_DATA_DIRS:-/run/current-system/sw/share:/etc/profiles/per-user/$USER/share:$HOME/.nix-profile/share:/usr/local/share:/usr/share}"
	IFS=':' read -r -a data_dirs <<< "$xdg_data_dirs"

	local entries=""
	local dir desktop_file name exec_cmd

	for dir in "${data_dirs[@]}"; do
		[ -d "$dir/applications" ] || continue
		for desktop_file in "$dir"/applications/*.desktop; do
			[ -f "$desktop_file" ] || continue

			# Pull Name/Exec from [Desktop Entry]. Keep it simple/robust for common cases.
			name="$(awk -F= '
				BEGIN{in=0}
				/^\[Desktop Entry\]/{in=1; next}
				/^\[/{if(in){exit}}
				in && $1=="Name" {print $2; exit}
			' "$desktop_file" | head -n1)"

			exec_cmd="$(awk -F= '
				BEGIN{in=0}
				/^\[Desktop Entry\]/{in=1; next}
				/^\[/{if(in){exit}}
				in && $1=="Exec" {print $2; exit}
			' "$desktop_file" | head -n1)"

			[ -n "$name" ] || continue
			[ -n "$exec_cmd" ] || continue

			# Strip placeholders like %U, %u, %F, %f, %i, %c, %k
			exec_cmd="$(echo "$exec_cmd" | sed -E 's/[[:space:]]+%[a-zA-Z]//g; s/%[a-zA-Z]//g')"
			# Skip entries that are explicitly hidden
			if grep -qE '^NoDisplay=true$|^Hidden=true$' "$desktop_file"; then
				continue
			fi

			# Use a 2-column output so we can hide the command while showing the name.
			entries+="${name}\t${exec_cmd}\n"
		done
	done

	if [ -z "$entries" ]; then
		printf '%s\n' "No applications found" | rofi_dmenu "Run as root"
		return 0
	fi

	local chosen
	chosen="$(printf "%b" "$entries" | rofi -dmenu -i -p "Run as root" -display-columns 1 -replace)" || exit 0
	[ -n "$chosen" ] || exit 0

	# Extract the second column (command)
	local cmd
	cmd="$(printf '%s' "$chosen" | awk -F'\t' '{print $2}')"
	[ -n "$cmd" ] || exit 0

	# Launch with polkit. Preserve Wayland/DBus bits so GUI apps can come up.
	pkexec env \
		"DISPLAY=${DISPLAY:-}" \
		"WAYLAND_DISPLAY=${WAYLAND_DISPLAY:-}" \
		"XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR:-}" \
		"DBUS_SESSION_BUS_ADDRESS=${DBUS_SESSION_BUS_ADDRESS:-}" \
		bash -lc "$cmd" &
}

network_settings() {
	nm-connection-editor &
}

screenshot() {
	# Match the Hyprland bind: `hyprshot -m region`
	hyprshot -m region
}

main_menu() {
	local power='⏻  Power'
	local apps='󰀻  Applications'
	local apps_root='󰀻  Applications (root)'
	local network='󰖩  Network settings'
	local shot='󰹑  Screenshot (region)'

	local chosen
	chosen="$(printf '%s\n' \
		"$power" \
		"$apps" \
		"$apps_root" \
		"$network" \
		"$shot" \
	| rofi_dmenu "System")" || exit 0

	case "$chosen" in
		"$power") power_menu ;;
		"$apps") apps_menu ;;
		"$apps_root") apps_root_menu ;;
		"$network") network_settings ;;
		"$shot") screenshot ;;
		*) exit 0 ;;
	esac
}

case "${1:-}" in
	--power) power_menu ;;
	--apps) apps_menu ;;
	--apps-root) apps_root_menu ;;
	--network) network_settings ;;
	--screenshot) screenshot ;;
	*) main_menu ;;
esac

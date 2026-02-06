#!/bin/sh

lockfile="$XDG_RUNTIME_DIR/mako-brightness.lock"
exec 9>"$lockfile"
flock -n 9 || exit 0

# Get the brightness level and convert it to a percentage
brightness=$(brightnessctl get)
max_brightness=$(brightnessctl max)
brightness_percentage=$(echo "( $brightness * 100 ) / $max_brightness" | bc)

notify-send -t 1000 -a 'bctl-bright' -h string:x-canonical-private-synchronous:brightness -h int:value:$brightness_percentage "Brightness: ${brightness_percentage}%"
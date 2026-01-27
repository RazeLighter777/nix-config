#!/usr/bin/env bash

set -euo pipefail

WALLPAPER_DIR="$HOME/Images/wallpapers"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}"
LINK_PATH="$STATE_DIR/hyprlock-wallpaper"

if [ ! -d "$WALLPAPER_DIR" ]; then
  rofi -dmenu -p "Wallpapers" <<< "Directory not found: $WALLPAPER_DIR" >/dev/null || true
  exit 1
fi

# Find common image files and list by basename while keeping full path mapping.
mapfile -t files < <(
  find "$WALLPAPER_DIR" -type f \( \
    -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" -o -iname "*.bmp" -o -iname "*.gif" \
  \) -print | sort -f
)

if [ "${#files[@]}" -eq 0 ]; then
  rofi -dmenu -p "Wallpapers" <<< "No images found in $WALLPAPER_DIR" >/dev/null || true
  exit 1
fi

# Build a menu of basenames with icon set to the image path.
selected=$(for f in "${files[@]}"; do
  rel="${f#$WALLPAPER_DIR/}"
  printf '%s\0icon\x1f%s\n' "$rel" "$f"
done | rofi -dmenu -i -p "Wallpapers" -display-columns 1)

if [ -z "${selected:-}" ]; then
  exit 0
fi

chosen="$WALLPAPER_DIR/$selected"
if [ ! -f "$chosen" ]; then
  exit 1
fi

mkdir -p "$STATE_DIR"
ln -sf "$chosen" "$LINK_PATH"

systemctl --user start swww-sync.service >/dev/null 2>&1 || true

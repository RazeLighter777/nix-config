#!/usr/bin/env bash

set -euo pipefail

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}"
link_path="$state_dir/hyprlock-wallpaper"

query_output="$(swww query 2>/dev/null || true)"
image_path="$(printf '%s\n' "$query_output" | sed -n 's/.*image: //p' | head -n1)"

if [ -z "${image_path:-}" ]; then
  exit 0
fi

if [ ! -e "$image_path" ]; then
  exit 0
fi

mkdir -p "$state_dir"
ln -sf "$image_path" "$link_path"

pkill -USR2 -x hyprlock >/dev/null 2>&1 || true

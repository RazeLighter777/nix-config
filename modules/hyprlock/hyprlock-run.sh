#!/usr/bin/env bash

set -euo pipefail

# Kill any existing hyprlock instances to ensure clean PAM state
# This prevents PAM segfaults after system wake from sleep
killall -q hyprlock || true

# Sync wallpaper before starting hyprlock
systemctl --user start hyprlock-wallpaper-sync.service >/dev/null 2>&1 || true

# Start hyprlock with a clean PAM state
exec hyprlock "$@"

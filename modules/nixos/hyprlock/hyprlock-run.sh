#!/usr/bin/env bash

set -euo pipefail

# Kill any existing hyprlock instances to ensure clean PAM state
# This prevents PAM segfaults after system wake from sleep
# Get PID of any running hyprlock process
if hyprlock_pid=$(pgrep -x hyprlock); then
    # Send SIGTERM for graceful shutdown
    kill -TERM "$hyprlock_pid" 2>/dev/null || true
    sleep 0.1
    # Send SIGKILL if process still exists
    if kill -0 "$hyprlock_pid" 2>/dev/null; then
        kill -KILL "$hyprlock_pid" 2>/dev/null || true
    fi
fi

# Sync wallpaper before starting hyprlock
systemctl --user start hyprlock-wallpaper-sync.service >/dev/null 2>&1 || true

# Start hyprlock with a clean PAM state
exec hyprlock "$@"

#!/usr/bin/env bash

set -euo pipefail

systemctl --user start hyprlock-wallpaper-sync.service >/dev/null 2>&1 || true

exec hyprlock "$@"

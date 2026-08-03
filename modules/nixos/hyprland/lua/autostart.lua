hl.env("XDG_CURRENT_DESKTOP", "Hyprland")

hl.on("hyprland.start", function()
  hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP GTK_THEME")
  hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
  hl.exec_cmd("systemctl --user start graphical-session.target")
  -- X11 core bitmap fonts (10x20 etc.) for XWayland apps like sil-q
  hl.exec_cmd("sh -c 'xset +fp $HOME/.local/share/x11-fonts/misc && xset fp rehash'")
end)

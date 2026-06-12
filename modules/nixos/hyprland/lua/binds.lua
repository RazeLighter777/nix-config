local mod = "SUPER"

-- Mouse: hold mod + click to drag / resize.
hl.bind(mod         .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mod         .. " + mouse:273", hl.dsp.window.resize())
hl.bind(mod .. " + ALT + mouse:272",   hl.dsp.window.resize())

-- Audio (asymmetric on purpose: raise = no repeat, lower = repeat).
hl.bind("XF86AudioRaiseVolume",
  hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+ && ~/.local/bin/mako-volume-notify"),
  { locked = true })
hl.bind("XF86AudioLowerVolume",
  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && ~/.local/bin/mako-volume-notify"),
  { repeating = true })

-- Launchers, screenshots, clipboard, system menus.
hl.bind(mod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprpicker --autocopy"))
hl.bind(mod .. " + CTRL + C",  hl.dsp.exec_cmd("cliphist list | rofi -dmenu -display-columns 2 | cliphist decode | wl-copy"))
hl.bind(mod .. " + CTRL + S",  hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind("CTRL + ALT + T",      hl.dsp.exec_cmd("kitty"))
hl.bind("CTRL + ALT + C",      hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mod .. " + D",         hl.dsp.exec_cmd("rofi -show drun -replace -i -show-icons"))
hl.bind(mod .. " + L",         hl.dsp.exec_cmd("~/.config/hypr/hyprlock-run.sh"))
hl.bind(mod .. " + P",         hl.dsp.exec_cmd("rofi -show p -modi p:rofi-power-menu"))
hl.bind(mod .. " + SPACE",     hl.dsp.exec_cmd("~/.config/rofi/rofi-system-menu.sh"))
hl.bind("CTRL + ALT + Delete", hl.dsp.exit())
hl.bind(mod .. " + Q",         hl.dsp.window.close())

-- Layout (master).
hl.bind(mod .. " + CTRL + D",      hl.dsp.layout("removemaster"))
hl.bind(mod .. " + I",             hl.dsp.layout("addmaster"))
hl.bind(mod .. " + J",             hl.dsp.layout("cyclenext"))
hl.bind(mod .. " + K",             hl.dsp.layout("cycleprev"))
hl.bind(mod .. " + CTRL + Return", hl.dsp.layout("swapwithmaster"))
hl.bind(mod .. " + SHIFT + I",     hl.dsp.layout("togglesplit"))
hl.bind(mod .. " + SHIFT + F",     hl.dsp.window.float({ action = "toggle" }))
hl.bind(mod .. " + SHIFT + P",     hl.dsp.window.pseudo())

-- Focus / move / swap by direction.
for _, dir in ipairs({ "left", "right", "up", "down" }) do
  hl.bind(mod        .. " + " .. dir, hl.dsp.focus({       direction = dir }))
  hl.bind(mod .. " + CTRL + " .. dir, hl.dsp.window.move({ direction = dir }))
  hl.bind(mod .. " + ALT + "  .. dir, hl.dsp.window.swap({ direction = dir }))
end

-- Workspace cycling (m = on monitor, e = across enabled).
hl.bind(mod ..         " + tab",    hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mod .. " + SHIFT + tab",    hl.dsp.focus({ workspace = "m-1" }))
hl.bind(mod ..         " + period", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod ..         " + comma",  hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod ..         " + U",      hl.dsp.workspace.toggle_special(""))
hl.bind(mod .. " + SHIFT + U",      hl.dsp.window.move({ workspace = "special" }))

-- Numeric workspace switches (code:10..19 = keys 1..9,0).
for i = 1, 10 do
  local code = "code:" .. tostring(9 + i)
  hl.bind(mod         .. " + " .. code, hl.dsp.focus({ workspace = i }))
  hl.bind(mod .. " + SHIFT + " .. code, hl.dsp.window.move({ workspace = i }))
  hl.bind(mod .. " + CTRL + "  .. code, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Alt-Tab: raise the active window on release.
hl.bind("ALT + tab", hl.dsp.window.bring_to_top(), { release = true })

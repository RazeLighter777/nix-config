-- Loaded only when my.brightnessctl.enable = true.
hl.bind("XF86MonBrightnessUp",
  hl.dsp.exec_cmd("brightnessctl s +5% && ~/.local/bin/mako-brightness-notify"))
hl.bind("XF86MonBrightnessDown",
  hl.dsp.exec_cmd("brightnessctl s 5%- && ~/.local/bin/mako-brightness-notify"))

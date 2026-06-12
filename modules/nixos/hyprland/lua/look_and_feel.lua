-- general / decoration / animations / misc

hl.config({
  general = {
    gaps_in       = 4,
    gaps_out      = 8,
    border_size   = 2,
    allow_tearing = false,
  },

  decoration = {
    rounding         = 6,
    active_opacity   = 1.0,
    inactive_opacity = 0.9,
    blur = {
      enabled           = true,
      size              = 3,
      passes            = 2,
      new_optimizations = true,
      vibrancy          = 0.1696,
    },
  },

  animations = {
    enabled = true,
  },

  misc = {
    disable_hyprland_logo        = true,
    disable_splash_rendering     = true,
    focus_on_activate            = false,
    animate_manual_resizes       = false,
    animate_mouse_windowdragging = false,
  },
})

-- Bezier curves
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23,  1     }, { 0.32, 1     } } })
hl.curve("popin",        { type = "bezier", points = { { 0.175, 0.885 }, { 0.32, 1.275 } } })
hl.curve("linear",       { type = "bezier", points = { { 0,     0     }, { 1,    1     } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5,   0.5   }, { 0.75, 1     } } })
hl.curve("quick",        { type = "bezier", points = { { 0.15,  0     }, { 0.1,  1     } } })

-- Animation timings
hl.animation({ leaf = "global",        enabled = true, speed = 10,   bezier = "default"      })
hl.animation({ leaf = "border",        enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",     enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true, speed = 3.03, bezier = "quick"        })
hl.animation({ leaf = "layers",        enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

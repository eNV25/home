local wezterm = require("wezterm")

local astrodark = require("colors/astrodark")
return {
  font = wezterm.font_with_fallback({ "JetBrains Mono", "Symbols Nerd Font", "Noto Color Emoji" }),
  colors = astrodark.colors(),
  window_frame = astrodark.window_frame(),
}

local wezterm = require("wezterm")
local font_with_fallback = wezterm.font_with_fallback

local astrodark = require("colors/astrodark")
return {
  font = font_with_fallback({ "JetBrains Mono", "Symbols Nerd Font", "Noto Color Emoji" }),
  colors = astrodark.colors(),
  window_frame = astrodark.window_frame(),
  alternate_buffer_wheel_scroll_speed = 1,
}

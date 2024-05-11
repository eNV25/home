local wezterm = require("wezterm")
local astrodark = require("colors/astrodark")

return {
	font = wezterm.font_with_fallback({
		"JetBrains Mono",
		"Symbols Nerd Font",
		"Noto Color Emoji",
	}),
	colors = astrodark.colors(),
	window_frame = astrodark.window_frame(),
	use_fancy_tab_bar = false,
	alternate_buffer_wheel_scroll_speed = 1,
	prefer_to_spawn_tabs = true,
}

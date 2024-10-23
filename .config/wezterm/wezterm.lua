local wezterm = require("wezterm")

return {
	font = wezterm.font_with_fallback({
		"JetBrains Mono",
		"Symbols Nerd Font",
		"Noto Color Emoji",
	}),
	color_scheme = "astrodark",
	use_fancy_tab_bar = false,
	alternate_buffer_wheel_scroll_speed = 1,
	prefer_to_spawn_tabs = true,
}

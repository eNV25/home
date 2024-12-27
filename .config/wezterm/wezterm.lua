local wezterm = require("wezterm")
local io = require("io")
local os = require("os")
local act = wezterm.action

wezterm.on("trigger-less-with-scrollback", function(window, pane)
	-- Retrieve the current pane's text
	local text = pane:get_lines_as_escapes(pane:get_dimensions().scrollback_rows)

	-- Create a temporary file to pass to the pager
	local name = os.tmpname()
	local f = io.open(name, "w+")
	f:write(text)
	f:flush()
	f:close()

	-- Open a new window running less and tell it to open the file
	window:perform_action(
		act.SpawnCommandInNewTab({
			args = { "less", "-fr", name },
		}),
		pane
	)
end)

return {
	color_scheme = "tokyonight_night",
	use_fancy_tab_bar = false,
	--alternate_buffer_wheel_scroll_speed = 1,
	prefer_to_spawn_tabs = true,
	keys = {
		{
			key = "E",
			mods = "CTRL",
			action = act.EmitEvent("trigger-less-with-scrollback"),
		},
	},
}

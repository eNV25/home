require 'vis'

local function config_global()
	-- vis:command[[
	-- set theme gruvbox
	-- ]]
end

local function config_window(win)
	vis:command[[
	set numbers on
	]]
end

vis.events.subscribe(vis.events.INIT, config_global)
vis.events.subscribe(vis.events.WIN_OPEN, config_window)

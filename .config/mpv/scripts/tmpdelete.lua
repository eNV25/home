local mp = require("mp")
local utils = require("mp.utils")
local options = require("mp.options")

local webtorrent = { path = "./", port = 0 }
options.read_options(webtorrent, "webtorrent")
webtorrent.path = mp.command_native({ "expand-path", webtorrent.path })

local args = { "sh", "-c", [[
exec 1>/dev/null 2>/dev/null
sleep 1
rm -f "$@"
find "$0" -type d -empty -delete
rmdir "$0"
]], webtorrent.path }

mp.add_hook("on_load", 10, function()
	local function unescape(url)
		return url:gsub("%%(%x%x)", function(x)
			return string.char(tonumber(x, 16))
		end)
	end
	local path = mp.get_property("path"):match("^http://localhost:[0-9]*/webtorrent/[a-zA-Z0-9]*/(.*)$")
	if path then
		table.insert(args, utils.join_path(webtorrent.path, unescape(path)))
	end
end)

mp.register_event("shutdown", function()
	mp.command_native({
		name = "subprocess",
		args = args,
		detach = true,
		playback_only = false,
	})
end)

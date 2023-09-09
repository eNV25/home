local mp = require("mp")
mp.register_event("shutdown", function()
	mp.command_native({
		name = "subprocess",
		detach = true,
		playback_only = false,
		args = { "sh", "-c", [[ sleep 1; rm -rf ~/tmp; ]] },
	})
end)

return {
	opt = {
		autowrite = true,
		list = true,
		guifont = "JetBrains Mono:h11",
		clipboard = "",
	},
	g = {
		inlay_hints_enabled = true,
		ui_notifications_enabled = false,
		clipboard = (function()
			if vim.env.WAYLAND_DISPLAY and vim.fn.executable("wl-copy") and vim.fn.executable("wl-paste") then
				return {
					name = "wl-copy",
					copy = {
						["+"] = { "wl-copy", "--type", "text/plain" },
						["*"] = { "wl-copy", "--primary", "--type", "text/plain" },
					},
					paste = {
						["+"] = { "wl-paste", "--no-newline" },
						["*"] = { "wl-paste", "--no-newline", "--primary" },
					},
				}
			end
		end)(),
	},
}

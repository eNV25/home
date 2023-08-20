return {
	format_on_save = {
		enabled = true,
		allow_filetypes = { "go" },
	},
	filter = function(client)
		if "gopls" == client.name then
			vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
		end
		return true
	end,
}

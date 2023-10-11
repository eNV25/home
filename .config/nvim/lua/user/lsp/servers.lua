local function server(exe, name)
	if vim.fn.executable(exe) == 1 then
		return name or exe
	end
end

return {
	server("bash-language-server", "bashls"),
	server("clangd"),
	server("gopls"),
	server("julia", "julials"),
	server("lua-language-server", "lua_ls"),
	server("pylsp"),
	server("rust-analyzer", "rust_analyzer"),
	server("taplo"),
	server("texlab"),
	server("jdtls"),
	server("typescript-language-server", "tsserver"),
	server("vscode-css-languageserver", "jsonls"),
	server("vscode-json-languageserver", "jsonls"),
	server("yaml-languageserver", "yamlls"),
	server("zls"),
	server("vim-language-server", "vimls"),
}

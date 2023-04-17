local function server(exe, name)
  if vim.fn.executable(exe) == 1 then
    return name or exe
  end
end

return {
  server("bash-language-server", "bashls"),
  server("ccls"),
  server("gopls"),
  server("jdtls"),
  server("lua-language-server", "lua_ls"),
  server("pylsp"),
  server("vim-language-server", "vimls"),
  server("vscode-json-languageserver", "jsonls"),
  server("zls"),
}

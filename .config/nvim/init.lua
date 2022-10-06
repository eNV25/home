-- init.lua

local vim = assert(vim, "module vim does not exist")

_G.pprint = vim.pretty_print

local api = vim.api
local cmd = vim.cmd
local kmap = vim.keymap
local opt = vim.opt
local g = vim.g
local b = vim.b

local spread = require("config/utils/spread")

opt.autowrite = true
opt.splitbelow = true
opt.splitright = true

opt.wrap = false
opt.number = true
opt.list = true
opt.listchars:append({ trail = "·", tab = "→ ", extends = ">", precedes = "<", nbsp = "␣" })
opt.completeopt = { "menuone", "noselect", "preview" }
opt.shortmess:append({ a = true, c = true })
opt.guifont = "JetBrains Mono:h11"

g["mucomplete#minimum_prefix_length"] = 0
g["mucomplete#always_use_completeopt"] = 1

local augroup_init = api.nvim_create_augroup("init", {})
api.nvim_create_autocmd("CompleteDone", {
	group = augroup_init,
	command = "pclose",
})
api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.go", "*.rs" },
	group = augroup_init,
	callback = function()
		vim.lsp.buf.format({ async = true })
	end,
})

local augroup_nord_override = api.nvim_create_augroup("nord_override", {})
api.nvim_create_autocmd("ColorScheme", {
	pattern = "nord",
	group = augroup_nord_override,
	command = [[
		highlight Normal ctermbg=NONE guibg=NONE
		highlight NonText ctermbg=NONE guibg=NONE
	]],
})
opt.termguicolors = true
cmd("colorscheme nord")

cmd("filetype plugin indent on")
require("guess-indent").setup({})
require("hardline").setup({ bufferline = true, theme = g.colors_name })

local kmopts = { noremap = true, silent = true }
kmap.set("n", "ge", "G", kmopts)
kmap.set("n", "[b", "<Cmd>bprev<Return>", kmopts)
kmap.set("n", "]b", "<Cmd>bnext<Return>", kmopts)
kmap.set("n", "<BS>", "<Cmd>bdelete<Return>", kmopts)
kmap.set("n", "<C-G>", "11<C-G>", kmopts)
kmap.set("n", "<Return>", "<Cmd>nohlsearch|normal!<C-L><Return><Return>", kmopts)
kmap.set("n", "[d", vim.diagnostic.goto_prev, kmopts)
kmap.set("n", "]d", vim.diagnostic.goto_next, kmopts)
kmap.set("n", "<Space>e", vim.diagnostic.open_float, kmopts)
kmap.set("n", "<Space>q", vim.diagnostic.setloclist, kmopts)

local lsp_kmap = function(buffn)
	local lsp_buf = vim.lsp.buf
	local kmbufopts = { noremap = true, silent = true, buffer = buffn }
	kmap.set("n", "gD", lsp_buf.declaration, kmbufopts)
	kmap.set("n", "gd", lsp_buf.definition, kmbufopts)
	kmap.set("n", "gy", lsp_buf.type_definition, kmbufopts)
	kmap.set("n", "gi", lsp_buf.implementation, kmbufopts)
	kmap.set("n", "gr", lsp_buf.references, kmbufopts)
	kmap.set("n", "<C-k>", lsp_buf.signature_help, kmbufopts)
	kmap.set("n", "<Space>wa", lsp_buf.add_workspace_folder, kmbufopts)
	kmap.set("n", "<Space>wr", lsp_buf.remove_workspace_folder, kmbufopts)
	kmap.set("n", "<Space>wl", function()
		print(vim.inspect(lsp_buf.list_workspace_folders()))
	end, kmbufopts)
	kmap.set("n", "<space>f", function()
		lsp_buf.format({ async = true })
	end, kmbufopts)
	kmap.set("n", "<Space>k", lsp_buf.hover, kmbufopts)
	kmap.set("n", "<Space>r", lsp_buf.rename, kmbufopts)
	kmap.set("n", "<Space>a", lsp_buf.code_action, kmbufopts)
	api.nvim_buf_set_option(buffn, "omnifunc", "v:lua.vim.lsp.omnifunc")
end

local lsp_opts = {
	on_attach = function(client, buffn)
		_ = client
		lsp_kmap(buffn)
		b[buffn]["mucomplete_chain"] = { "omni" }
	end,
}

local lsp_servers = { "gopls", "sumneko_lua", "bashls", "clangd", "pylsp" }

for i = #lsp_servers, 1, -1 do
	local server = lsp_servers[i]
	table.remove(lsp_servers, i)
	require("lspconfig")[server].setup(lsp_opts)
end

for server, opts in pairs(lsp_servers) do
	require("lspconfig")[server].setup(spread(lsp_opts, opts))
end

require("rust-tools").setup({ server = lsp_opts })

require("null-ls").setup({
	sources = {
		require("null-ls").builtins.formatting.black,
		require("null-ls").builtins.formatting.jq,
		require("null-ls").builtins.formatting.shfmt,
		require("null-ls").builtins.formatting.stylua,
		require("null-ls").builtins.code_actions.shellcheck,
		require("null-ls").builtins.diagnostics.golangci_lint,
		require("null-ls").builtins.hover.dictionary,
		require("null-ls").builtins.hover.printenv,
	},
})

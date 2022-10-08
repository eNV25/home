-- init.lua

local vim = assert(vim, "module vim does not exist")

local api = vim.api
local cmd = vim.cmd
local kmap = vim.keymap
local opt = vim.opt
local fn = vim.fn
local g = vim.g

_G.pprint = vim.pretty_print
local extend = require("config/utils/extend")

opt.autowrite = true
opt.splitbelow = true
opt.splitright = true

opt.wrap = false
opt.number = true
opt.list = true
opt.listchars:append({ trail = "·", tab = "→ ", extends = ">", precedes = "<", nbsp = "␣" })
opt.completeopt = { "menu", "menuone", "noselect", "preview" }
opt.shortmess:append({ a = true, c = true })
opt.guifont = "JetBrains Mono:h11"

do
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
end

do
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
end

cmd("filetype plugin indent on")
require('indent-o-matic').setup({})
require("hardline").setup({ bufferline = true, theme = g.colors_name })

do
	local kmopts = { noremap = true, silent = true }
	kmap.set("n", "q", "<Cmd>quit<Return>", kmopts)
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
end

local lsp_kmap = function(buffn)
	local buf = vim.lsp.buf
	local kmbufopts = { noremap = true, silent = true, buffer = buffn }
	kmap.set("n", "gD", buf.declaration, kmbufopts)
	kmap.set("n", "gd", buf.definition, kmbufopts)
	kmap.set("n", "gy", buf.type_definition, kmbufopts)
	kmap.set("n", "gi", buf.implementation, kmbufopts)
	kmap.set("n", "gr", buf.references, kmbufopts)
	kmap.set("n", "<C-k>", buf.signature_help, kmbufopts)
	kmap.set("n", "<Space>wa", buf.add_workspace_folder, kmbufopts)
	kmap.set("n", "<Space>wr", buf.remove_workspace_folder, kmbufopts)
	kmap.set("n", "<Space>wl", function()
		pprint(buf.list_workspace_folders())
	end, kmbufopts)
	kmap.set("n", "<space>f", function()
		buf.format({ async = true })
	end, kmbufopts)
	kmap.set("n", "<Space>k", buf.hover, kmbufopts)
	kmap.set("n", "<Space>r", buf.rename, kmbufopts)
	kmap.set("n", "<Space>a", buf.code_action, kmbufopts)
end

do
	local cmp = require("cmp")
	cmp.setup({
		completion = { autocomplete = false },
		snippet = {
			expand = function(args)
				fn["vsnip#anonymous"](args.body)
			end,
		},
		sources = {
			{ name = "nvim_lsp" },
			{ name = "vsnip" },
		},
		mapping = cmp.config.mapping.preset.insert({
			["<C-u>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<C-d>"] = cmp.mapping(function(fallback)
				if fn["vsnip#jumpable"](1) then
					cmd("normal <Plug>(vsnip-jump-next)")
				else
					fallback()
				end
			end, { "i", "s" }),
			["<C-b>"] = cmp.mapping(function(fallback)
				if fn["vsnip#jumpable"](-1) then
					cmd("normal <Plug>(vsnip-jump-prev)")
				else
					fallback()
				end
			end, { "i", "s" }),
			["<Tab>"] = cmp.mapping(function(fallback)
				local col = fn.col(".") - 1

				if cmp.visible() then
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
				elseif col == 0 or fn.getline("."):sub(col, col):match("%s") then
					fallback()
				else
					cmp.complete()
				end
			end, { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
				else
					fallback()
				end
			end, { "i", "s" }),
		}),
	})
end

do
	local cmp_nvim_lsp = require("cmp_nvim_lsp")
	local lsp_config = require("lspconfig")
	local lsp_servers = { "gopls", "sumneko_lua", "bashls", "clangd", "pylsp" }
	local lsp_opts = {
		capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities()),
		on_attach = function(client, buffn)
			_ = client
			lsp_kmap(buffn)
		end,
	}

	for i = #lsp_servers, 1, -1 do
		local server = lsp_servers[i]
		table.remove(lsp_servers, i)
		lsp_config[server].setup(lsp_opts)
	end

	for server, opts in pairs(lsp_servers) do
		lsp_config[server].setup(extend(lsp_opts, opts))
	end

	require("rust-tools").setup({ server = lsp_opts })

	local null_ls = require("null-ls")
	null_ls.setup(extend(lsp_opts, {
		sources = {
			null_ls.builtins.formatting.black,
			null_ls.builtins.formatting.jq,
			null_ls.builtins.formatting.shfmt,
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.code_actions.shellcheck,
			null_ls.builtins.diagnostics.golangci_lint,
			null_ls.builtins.hover.dictionary,
			null_ls.builtins.hover.printenv,
		},
	}))
end

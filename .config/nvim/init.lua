-- init.lua

local vim = assert(vim, "module vim does not exist")

_G.pprint = vim.pretty_print
local contains = vim.tbl_contains
local deep_extend = function(...)
	return vim.tbl_deep_extend("force", ...)
end

vim.opt.autowrite = true
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.wrap = false
vim.opt.number = true
vim.opt.list = true
vim.opt.completeopt = { "menu", "menuone", "noselect", "preview" }
vim.opt.shortmess:append({ a = true, c = true })
vim.opt.guifont = "JetBrains Mono:h11"

do
	local augroup_init = vim.api.nvim_create_augroup("Init", {})
	vim.api.nvim_create_autocmd("CompleteDone", {
		group = augroup_init,
		command = "pclose",
	})
	vim.api.nvim_create_autocmd("ColorScheme", {
		pattern = "nord",
		group = augroup_init,
		command = [[
			highlight Normal ctermbg=NONE guibg=NONE
			highlight NonText ctermbg=NONE guibg=NONE
		]],
	})
end

local augroup_lsp_buffer_format = vim.api.nvim_create_augroup("LspBufferFormat", {})
local lsp_autocmds = function(client, bufnr)
	local buf = vim.lsp.buf
	if
		client.supports_method("textDocument/formatting")
		and contains({ "go", "rust" }, vim.bo[bufnr].filetype)
	then
		vim.api.nvim_clear_autocmds({ group = augroup_lsp_buffer_format, buffer = bufnr })
		vim.api.nvim_create_autocmd("BufWritePre", {
			group = augroup_lsp_buffer_format,
			buffer = bufnr,
			callback = function()
				buf.format({ bufnr = bufnr })
			end,
		})
	end
end

do
	local kmopts = { noremap = true, silent = true }
	vim.keymap.set("n", "q", "<Cmd>quit<Return>", kmopts)
	vim.keymap.set("n", "ge", "G", kmopts)
	vim.keymap.set("n", "[b", "<Cmd>bprev<Return>", kmopts)
	vim.keymap.set("n", "]b", "<Cmd>bnext<Return>", kmopts)
	vim.keymap.set("n", "<BS>", "<Cmd>bdelete<Return>", kmopts)
	vim.keymap.set("n", "<C-G>", "11<C-G>", kmopts)
	vim.keymap.set("n", "<Return>", "<Cmd>nohlsearch|normal!<C-L><Return><Return>", kmopts)
	vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, kmopts)
	vim.keymap.set("n", "]d", vim.diagnostic.goto_next, kmopts)
	vim.keymap.set("n", "<Space>j", vim.diagnostic.open_float, kmopts)
	vim.keymap.set("n", "<Space>q", vim.diagnostic.setloclist, kmopts)
end

local lsp_kmap = function(_, bufnr)
	local buf = vim.lsp.buf
	local kmbufopts = { noremap = true, silent = true, buffer = bufnr }
	vim.keymap.set("n", "gD", buf.declaration, kmbufopts)
	vim.keymap.set("n", "gd", buf.definition, kmbufopts)
	vim.keymap.set("n", "gy", buf.type_definition, kmbufopts)
	vim.keymap.set("n", "gi", buf.implementation, kmbufopts)
	vim.keymap.set("n", "gr", buf.references, kmbufopts)
	vim.keymap.set("n", "<C-k>", buf.signature_help, kmbufopts)
	vim.keymap.set("n", "<Space>wa", buf.add_workspace_folder, kmbufopts)
	vim.keymap.set("n", "<Space>wr", buf.remove_workspace_folder, kmbufopts)
	vim.keymap.set("n", "<Space>wl", function()
		pprint(buf.list_workspace_folders())
	end, kmbufopts)
	vim.keymap.set("n", "<space>f", function()
		buf.format({ async = true, bufnr = bufnr })
	end, kmbufopts)
	vim.keymap.set("n", "<Space>k", buf.hover, kmbufopts)
	vim.keymap.set("n", "<Space>r", buf.rename, kmbufopts)
	vim.keymap.set("n", "<Space>a", buf.code_action, kmbufopts)
end

vim.opt.termguicolors = true
vim.cmd("colorscheme nord")
require("indent-o-matic").setup({})
require("hardline").setup({ bufferline = true, theme = vim.g.colors_name })

do
	local cmp = require("cmp")
	cmp.setup({
		completion = { autocomplete = false },
		snippet = {
			expand = function(args)
				vim.fn["vsnip#anonymous"](args.body)
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
				if vim.fn["vsnip#jumpable"](1) then
					vim.cmd("normal <Plug>(vsnip-jump-next)")
				else
					fallback()
				end
			end, { "i", "s" }),
			["<C-b>"] = cmp.mapping(function(fallback)
				if vim.fn["vsnip#jumpable"](-1) then
					vim.cmd("normal <Plug>(vsnip-jump-prev)")
				else
					fallback()
				end
			end, { "i", "s" }),
			["<Tab>"] = cmp.mapping(function(fallback)
				local col = vim.fn.col(".") - 1
				if cmp.visible() then
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
				elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
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
	local lsp_config = require("lspconfig")
	local lsp_servers = { "gopls", "sumneko_lua", "bashls", "clangd", "pylsp" }
	local lsp_opts = {
		capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
		on_attach = function(client, bufnr)
			lsp_kmap(client, bufnr)
			lsp_autocmds(client, bufnr)
		end,
	}

	for i = #lsp_servers, 1, -1 do
		local server = lsp_servers[i]
		table.remove(lsp_servers, i)
		lsp_config[server].setup(lsp_opts)
	end

	for server, opts in pairs(lsp_servers) do
		lsp_config[server].setup(deep_extend(lsp_opts, opts))
	end

	require("rust-tools").setup({ server = lsp_opts })

	local null_ls = require("null-ls")
	null_ls.setup(deep_extend(lsp_opts, {
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

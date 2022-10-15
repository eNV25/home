-- init.lua

local vim = assert(vim, "module vim does not exist")
local unpack = vim.F.unpack_len

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
	local augroup = vim.api.nvim_create_augroup("Init", {})
	vim.api.nvim_create_autocmd("CompleteDone", {
		group = augroup,
		command = "pclose",
	})
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = augroup,
		callback = function(args)
			local bufnr = args.buf
			vim.lsp.buf.format({
				bufnr = bufnr,
				filter = function()
					return vim.tbl_contains({ "go", "rust" }, vim.bo[bufnr].filetype)
				end,
			})
		end,
	})
	vim.api.nvim_create_autocmd("VimEnter", {
		group = augroup,
		callback = function()
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
			vim.cmd([[aunmenu PopUp.-1-]])
			vim.cmd([[aunmenu PopUp.How-to\ disable\ mouse]])
		end,
	})
	vim.api.nvim_create_autocmd("LspAttach", {
		group = augroup,
		callback = function(args)
			local bufnr = args.buf
			local kmopts = { noremap = true, silent = true, buffer = bufnr }
			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, kmopts)
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, kmopts)
			vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, kmopts)
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, kmopts)
			vim.keymap.set("n", "gr", vim.lsp.buf.references, kmopts)
			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, kmopts)
			vim.keymap.set("n", "<Space>wa", vim.lsp.buf.add_workspace_folder, kmopts)
			vim.keymap.set("n", "<Space>wr", vim.lsp.buf.remove_workspace_folder, kmopts)
			vim.keymap.set("n", "<Space>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, kmopts)
			vim.keymap.set("n", "<space>f", function()
				vim.lsp.buf.format({ async = true, bufnr = bufnr })
			end, kmopts)
			vim.keymap.set("n", "<Space>k", vim.lsp.buf.hover, kmopts)
			vim.keymap.set("n", "<Space>r", vim.lsp.buf.rename, kmopts)
			vim.keymap.set("n", "<Space>a", vim.lsp.buf.code_action, kmopts)
		end,
	})
	vim.api.nvim_create_autocmd("ColorScheme", {
		pattern = "nord",
		group = augroup,
		command = [[
			highlight Normal ctermbg=NONE guibg=NONE
			highlight NonText ctermbg=NONE guibg=NONE
		]],
	})
end

vim.opt.termguicolors = true
vim.cmd("colorscheme nord")

require("indent-o-matic").setup({})
require("hardline").setup({ bufferline = true, theme = vim.g.colors_name })

do
	local cmp = require("cmp")
	local snippy = require("snippy")
	local at_word = function()
		local row, col = unpack(vim.api.nvim_win_get_cursor(0))
		local char = col == 0 and " " or vim.api.nvim_buf_get_text(0, row - 1, col - 1, row - 1, col, {})[1]
		return not char:match("%s")
	end
	cmp.setup({
		completion = { autocomplete = false },
		snippet = {
			expand = function(args)
				snippy.expand_snippet(args.body)
			end,
		},
		sources = {
			{ name = "nvim_lsp_signature_help" },
			{ name = "nvim_lsp" },
			{ name = "snippy" },
			{ name = "emoji" },
		},
		mapping = cmp.config.mapping.preset.insert({
			["<C-J>"] = cmp.mapping.scroll_docs(-4),
			["<C-K>"] = cmp.mapping.scroll_docs(4),
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif snippy.can_expand_or_advance() then
					snippy.expand_or_advance()
				elseif at_word() then
					cmp.complete()
				else
					fallback()
				end
			end, { "i", "s" }),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif snippy.can_jump(-1) then
					snippy.previous()
				else
					fallback()
				end
			end, { "i", "s" }),
		}),
	})
end

do
	local lsp_config = require("lspconfig")
	lsp_config.util.default_config = vim.tbl_extend("force", lsp_config.util.default_config, {
		capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()),
	})

	for server, opts in pairs({ gopls = {}, sumneko_lua = {}, bashls = {}, clangd = {}, pylsp = {} }) do
		lsp_config[server].setup(opts)
	end

	require("rust-tools").setup({})

	local null_ls = require("null-ls")
	null_ls.setup({
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
	})
end

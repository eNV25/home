-- init.lua

local vim = assert(vim, "module vim does not exist")

vim.opt.autowrite = true
vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = true
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
			vim.cmd([[ aunmenu PopUp.-1- ]])
			vim.cmd([[ aunmenu PopUp.How-to\ disable\ mouse ]])
			vim.cmd([[ command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis ]])
		end,
	})
	vim.api.nvim_create_autocmd("LspAttach", {
		group = augroup,
		callback = function(args)
			local bufnr = args.buf
			local capabilities = vim.lsp.get_client_by_id(args.data.client_id).server_capabilities
			local kmopts = { noremap = true, silent = true, buffer = bufnr }
			vim.keymap.set("n", "<Space>D", vim.lsp.buf.declaration, kmopts)
			vim.keymap.set("n", "<Space>d", vim.lsp.buf.definition, kmopts)
			vim.keymap.set("n", "<Space>y", vim.lsp.buf.type_definition, kmopts)
			vim.keymap.set("n", "<Space>i", vim.lsp.buf.implementation, kmopts)
			vim.keymap.set("n", "<Space>R", vim.lsp.buf.references, kmopts)
			vim.keymap.set("n", "<Space>K", vim.lsp.buf.signature_help, kmopts)
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
			vim.keymap.set("n", "<Space>l", vim.lsp.codelens.run, kmopts)
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "InsertLeave" }, {
				group = augroup,
				buffer = bufnr,
				callback = function()
					if capabilities.codeLensProvider then
						vim.lsp.codelens.refresh()
					end
				end,
			})
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					if
						capabilities.documentFormattingProvider
						and vim.tbl_contains({ "go", "rust" }, vim.bo[bufnr].filetype)
					then
						vim.lsp.buf.format({ async = false, bufnr = bufnr })
					end
					if capabilities.codeActionProvider and "go" == vim.bo[bufnr].filetype then
						vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
					end
				end,
			})
		end,
	})
	vim.api.nvim_create_autocmd("ColorScheme", {
		pattern = "nord",
		group = augroup,
		command = [[ highlight Normal ctermbg=NONE guibg=NONE | highlight NonText ctermbg=NONE guibg=NONE ]],
	})
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ "folke/lazy.nvim", version = "*" },
	{
		"arcticicestudio/nord-vim",
		version = "*",
		priority = math.huge,
		init = function()
			vim.opt.termguicolors = true
			vim.cmd("colorscheme nord")
		end,
	},
	{ "gpanders/editorconfig.nvim", version = "*" },
	{ "darazaki/indent-o-matic", config = true },
	{ "kylechui/nvim-surround", config = true },
	{ "m4xshen/autoclose.nvim", config = true },
	{ "nvchad/nvim-colorizer.lua", name = "colorizer", config = true },
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = "all",
			auto_install = true,
			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = { enable = true },
		},
		config = function(_, opts)
			require("nvim-treesitter.configs").setup(opts)
		end,
	},
	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"nvim-lualine/lualine.nvim",
		opts = {
			options = {
				icons_enabled = false,
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_c = { "%F" },
			},
			tabline = {
				lualine_c = { { "buffers", symbols = { alternate_file = "" } } },
			},
		},
		config = function(_, opts)
			require("lualine").setup(opts)
			vim.opt.showmode = false
		end,
	},
	{
		"folke/noice.nvim",
		version = "*",
		dependencies = { "muniftanjim/nui.nvim" },
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			cmdline = {
				view = "cmdline",
			},
		},
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-emoji",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"dcampos/cmp-snippy",
			"dcampos/nvim-snippy",
		},
		config = function()
			local cmp = require("cmp")
			local snippy = require("snippy")
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
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<C-J>"] = cmp.mapping.scroll_docs(-4),
					["<C-K>"] = cmp.mapping.scroll_docs(4),
					["<C-Space>"] = cmp.mapping.complete({}),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif snippy.can_expand_or_advance() then
							snippy.expand_or_advance()
						elseif
							(function()
								local row, col = unpack(vim.api.nvim_win_get_cursor(0))
								local char = col == 0 and " "
									or vim.api.nvim_buf_get_text(0, row - 1, col - 1, row - 1, col, {})[1]
								return not char:match("%s")
							end)()
						then
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
			require("lspconfig").util.default_config =
				vim.tbl_deep_extend("force", require("lspconfig").util.default_config, {
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
				})
		end,
	},
	{ "nvim-orgmode/orgmode", setup = true, dependencies = { "nvim-treesitter/nvim-treesitter" } },
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/nvim-cmp",
			{ "folke/neodev.nvim", version = "*", config = true },
			{ "folke/neoconf.nvim", config = true },
			{
				name = "lsp_lines",
				url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
				config = function(plugin, opts)
					require(plugin.name).setup(opts)
					vim.diagnostic.config({ virtual_text = false })
				end,
			},
			{
				"simrat39/rust-tools.nvim",
				dependencies = { "hrsh7th/nvim-cmp" },
				config = true,
			},
			{
				"jose-elias-alvarez/null-ls.nvim",
				dependencies = { "nvim-lua/plenary.nvim", "hrsh7th/nvim-cmp" },
				config = function()
					local null_ls = require("null-ls")
					local shell_filetypes = { "sh", "bash", "ksh", "zsh", "PKGBUILD" }
					null_ls.setup({
						sources = {
							null_ls.builtins.diagnostics.golangci_lint,
							null_ls.builtins.formatting.black,
							null_ls.builtins.formatting.jq,
							null_ls.builtins.formatting.stylua,
							null_ls.builtins.formatting.shfmt.with({ filetypes = shell_filetypes }),
							null_ls.builtins.code_actions.shellcheck.with({ filetypes = shell_filetypes }),
							null_ls.builtins.hover.dictionary,
							null_ls.builtins.hover.printenv,
						},
					})
				end,
			},
		},
		config = function()
			local lspconfig = require("lspconfig")
			vim.tbl_map(function(server)
				lspconfig[server].setup({})
			end, { "jsonls", "bashls", "ccls", "pylsp", "lua_ls", "gopls" })
		end,
	},
})

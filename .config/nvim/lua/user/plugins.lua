return {
	{
		"nordtheme/vim",
		name = "nord",
		version = "*",
		init = function()
			vim.opt.termguicolors = true
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "nord",
				group = vim.api.nvim_create_augroup("NordInit", {}),
				command = [[
highlight Normal ctermbg=NONE guibg=NONE
highlight SpellBad ctermbg=NONE guibg=NONE
highlight SpellCap ctermbg=NONE guibg=NONE
highlight SpellLocal ctermbg=NONE guibg=NONE
highlight SpellRare ctermbg=NONE guibg=NONE
highlight FoldColumn ctermbg=NONE guibg=NONE
highlight SignColumn ctermbg=NONE guibg=NONE
highlight VertSplit ctermbg=NONE guibg=NONE
highlight DiffAdd ctermbg=NONE guibg=NONE
highlight DiffChange ctermbg=NONE guibg=NONE
highlight DiffDelete ctermbg=NONE guibg=NONE
highlight DiffText ctermbg=NONE guibg=NONE
highlight CursorLine ctermbg=NONE guibg=NONE
highlight LspInlayHint ctermbg=NONE guibg=NONE
        ]],
			})
		end,
	},
	{
		"rcarriga/nvim-notify",
		opts = {
			background_color = "#000000",
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			auto_install = true,
			ensure_installed = "all",
		},
	},
	{ "nvim-orgmode/orgmode", setup = true, dependencies = { "nvim-treesitter/nvim-treesitter" } },
	{ "ziglang/zig.vim" },
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"folke/neoconf.nvim",
				setup = true,
			},
			{
				"creativenull/efmls-configs-nvim",
				version = "*",
				opts = function(_, opts)
					local shell = {
						require("efmls-configs.linters.shellcheck"),
						require("efmls-configs.formatters.shfmt"),
					}
					local languages = vim.tbl_extend("force", require("efmls-configs.defaults").languages(), {
						sh = shell,
						bash = shell,
						ksh = shell,
					})
					local defaults = {
						filetypes = vim.tbl_keys(languages),
						settings = {
							languages = languages,
							rootMarkers = { ".git/" },
						},
						init_options = {
							documentFormatting = true,
							documentRangeFormatting = true,
						},
					}
					return vim.tbl_extend("force", defaults, opts)
				end,
				config = function(_, opts)
					require("lspconfig").efm.setup(opts)
				end,
			},
		},
	},
	"AstroNvim/astrocommunity",
	{ import = "astrocommunity.lsp.lsp-inlayhints-nvim" },
}

local function server(exe, name)
    if vim.fn.executable(exe) == 1 then
        return name or exe
    end
end

---@type LazySpec
return {
    "AstroNvim/astrolsp",
    ---@type AstroLSPOpts
    opts = {
        features = {
            inlay_hints = true,
        },
        formatting = {
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
        },
        servers = {
            server("bash-language-server", "bashls"),
            server("clangd"),
            server("gopls"),
            server("haskell-language-server-wrapper", "hls"),
            server("julia", "julials"),
            server("lua-language-server", "lua_ls"),
            server("pylsp"),
            server("rust-analyzer", "rust_analyzer"),
            server("taplo"),
            server("texlab"),
            server("typst-lsp", "typst_lsp"),
            server("jdtls"),
            server("typescript-language-server", "ts_ls"),
            server("vscode-css-languageserver", "jsonls"),
            server("vscode-json-languageserver", "jsonls"),
            server("yaml-languageserver", "yamlls"),
            server("zls"),
            server("vim-language-server", "vimls"),
        },
    },
    dependencies = {
        "https://git.sr.ht/~p00f/clangd_extensions.nvim",
        {
            "creativenull/efmls-configs-nvim",
            version = "*",
            opts = function(_, opts)
                local shell = {
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
            dependencies = "folke/neoconf.nvim",
        },
    },
}

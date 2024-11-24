return {
  {
    "astronvim/astrotheme",
    opts = {
      highlights = {
        global = {
          modify_hl_groups = function(hl, _)
            hl.LspInlayHint.italic = true
          end,
        },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        require("tokyonight").load({ style = "night" })
        local lsp_inlay_hint = vim.api.nvim_get_hl(0, { name = "LspInlayHint", link = false })
        vim.api.nvim_set_hl(0, "LspInlayHint", vim.tbl_extend("force", lsp_inlay_hint, { italic = true }))
      end,
    },
  },
}

vim.cmd([[
aunmenu PopUp.-1-
aunmenu PopUp.How-to\ disable\ mouse
]])
vim.api.nvim_set_hl(
    0,
    "LspInlayHint",
    vim.tbl_extend("force", vim.api.nvim_get_hl(0, { name = "LspInlayHint", link = false }), { italic = true })
)


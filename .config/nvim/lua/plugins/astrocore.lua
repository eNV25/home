---@type LazySpec
return {
    "AstroNvim/astrocore",
    ---@type AstroCoreOpts
    opts = {
        options = {
            opt = {
                autowrite = true,
                list = true,
                guifont = "JetBrains Mono:h11",
                clipboard = "unnamed",
                title = false,
            },
            g = {
                inlay_hints_enabled = true,
                ui_notifications_enabled = false,
            },
        },
    },
    dependencies = {
        {
            "nvim-treesitter/nvim-treesitter",
            ---@type TSConfig
            opts = { indent = { enable = false } },
        },
    },
}

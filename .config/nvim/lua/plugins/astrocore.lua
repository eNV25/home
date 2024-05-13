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
            },
            g = {
                inlay_hints_enabled = true,
                ui_notifications_enabled = false,
            },
        },
    },
}

local wezterm = require("wezterm")

local function config_home()
  return os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")
end

return {
  font = wezterm.font_with_fallback({
    {
      family = "Monaspace Krypton",
      harfbuzz_features = { "ss01", "ss02", "ss03", "ss04", "ss05", "ss06", "ss07", "ss08", "calt", "dlig" },
    },
    "Symbols Nerd Font",
    "Noto Color Emoji",
  }),
  color_scheme = "github_dark_dimmed",
  color_schemes = {
    ["github_dark_dimmed"] = (function()
      local scheme = wezterm.color.load_scheme(config_home() .. "/wezterm/colors/github_dark_dimmed.toml")
      scheme.tab_bar = {
        background = scheme.background,
        active_tab = { bg_color = scheme.selection_bg, fg_color = scheme.selection_fg },
        inactive_tab = { bg_color = scheme.background, fg_color = scheme.foreground },
        inactive_tab_hover = { bg_color = scheme.foreground, fg_color = scheme.background },
        new_tab = { bg_color = scheme.background, fg_color = scheme.foreground },
        new_tab_hover = { bg_color = scheme.foreground, fg_color = scheme.background },
      }
      return scheme
    end)(),
  },
  use_fancy_tab_bar = false,
  alternate_buffer_wheel_scroll_speed = 1,
}

local wezterm = require("wezterm")

local function config_home()
  return os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")
end

local font = wezterm.font_with_fallback({
  "JetBrains Mono",
  "Symbols Nerd Font",
  "Noto Color Emoji",
})
local color_scheme = "github_dark_dimmed"
local color_schemes = {}
setmetatable(color_schemes, {
  __index = function(_, key)
    local scheme = wezterm.color.load_scheme(config_home() .. "/wezterm/colors/" .. key .. ".toml")
    scheme.tab_bar = {
      background = scheme.background,
      active_tab = { bg_color = scheme.selection_bg, fg_color = scheme.selection_fg },
      inactive_tab = { bg_color = scheme.background, fg_color = scheme.foreground },
      inactive_tab_hover = { bg_color = scheme.foreground, fg_color = scheme.background },
      new_tab = { bg_color = scheme.background, fg_color = scheme.foreground },
      new_tab_hover = { bg_color = scheme.foreground, fg_color = scheme.background },
    }
    return scheme
  end,
})
color_schemes[color_scheme] = color_schemes[color_scheme]

return {
  font = font,
  color_scheme = color_scheme,
  color_schemes = color_schemes,
  use_fancy_tab_bar = false,
  alternate_buffer_wheel_scroll_speed = 1,
  prefer_to_spawn_tabs = true,
}

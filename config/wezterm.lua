-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.font = wezterm.font 'JetBrains Mono'
-- You can specify some parameters to influence the font selection;
-- for example, this selects a Bold, Italic font variant.
config.font =
  wezterm.font('JetBrains Mono', { weight = 'Bold', italic = false })
-- For example, changing the color scheme:
config.color_scheme = 'MaterialDark'
config.font_size = 12
config.term = "xterm-256color"
warn_about_missing_glyphs = false

-- and finally, return the configuration to wezterm
return config

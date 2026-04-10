--------------------------------------------------------------------------------
-- 1) Wezterm Config Initialization
--------------------------------------------------------------------------------
local wezterm = require "wezterm"
local act = wezterm.action
local config = wezterm.config_builder()

--------------------------------------------------------------------------------
-- 2) Color Palette Definition
--------------------------------------------------------------------------------
-- I've defined the 'colors' table here so line 161 (and others) can find it.
local colors = {
  bg         = "#282828",
  fg         = "#ffffff",
  yellow     = "#ffd500",
  comment    = "#928374",
  red        = "#ef2929",
  caret      = "#ff9c00",
  selection  = "#ff9c00",
  invisibles = "#2f363d",
  cyan       = "#43dfc8",
  blue       = "#3571d9",
  magenta    = "#d3869b",
  green      = "#4e9a06",
}

--------------------------------------------------------------------------------
-- 3) Keybinds
--------------------------------------------------------------------------------
local function key_binding(key_table)
  local result = {}
  for _, binding in ipairs(key_table) do
    table.insert(result, {
      mods = binding[1] or "ALT",
      key = binding[2],
      action = binding[3],
    })
  end
  return result
end

config.keys = key_binding({
  -- Split and manage panes
  {"CTRL", "Enter", act.SplitHorizontal { domain = 'CurrentPaneDomain' }},
  {"CTRL", "\\", act.SplitVertical { domain = 'CurrentPaneDomain' }},
  {"CTRL", "Backspace", act.CloseCurrentPane { confirm = true }},

  -- Focus on pane by direction
  {"CTRL", "LeftArrow", act.ActivatePaneDirection 'Left'},
  {"CTRL", "RightArrow", act.ActivatePaneDirection 'Right'},
  {"CTRL", "UpArrow", act.ActivatePaneDirection 'Up'},
  {"CTRL", "DownArrow", act.ActivatePaneDirection 'Down'},

  -- Tab management
  {"ALT", "t", act.SpawnTab 'CurrentPaneDomain'},
  {"ALT", "q", act.CloseCurrentTab { confirm = true }},
  {"ALT", "1", act.ActivateTab(0)},
  {"ALT", "2", act.ActivateTab(1)},
  {"ALT", "3", act.ActivateTab(2)},
  {"ALT", "4", act.ActivateTab(3)},
  {"ALT", "5", act.ActivateTab(4)},
  {"ALT", "6", act.ActivateTab(5)},
  {"ALT", "7", act.ActivateTab(6)},
  {"ALT", "8", act.ActivateTab(7)},
  
  -- Font size
  {"ALT", "+", act.IncreaseFontSize},
  {"ALT", "-", act.DecreaseFontSize},
  {"ALT", "*", act.ResetFontSize},
})

--------------------------------------------------------------------------------
-- 4) Build the WezTerm Appearance
--------------------------------------------------------------------------------
config.initial_cols = 120
config.initial_rows = 35
config.window_background_opacity = 0.90
config.font_size = 12
config.font = wezterm.font('JetBrains Mono', { weight = 'Regular' })
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 500
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = true

-- Performance
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.max_fps = 60
config.animation_fps = 1
config.term = "xterm-256color"
config.warn_about_missing_glyphs = false

-- Uncomment for nvidia issues with wayland
-- Laggy/extra characters
--
-- -- function for nvidia_gpu
-- local function is_nvidia_gpu()
--   local handle = io.popen("lspci | grep -i nvidia")
--   local result = handle:read("*a")
--   handle:close()
--   return result ~= ""
-- end
--
-- -- NVIDIA optimization settings
-- config.enable_wayland = not is_nvidia_gpu() -- Disable Wayland if NVIDIA GPU is detected
-- config.front_end = "OpenGL"  -- More stable than WebGPU with NVIDIA
-- config.webgpu_power_preference = "HighPerformance"
-- config.prefer_egl = true
-- config.freetype_load_target = "Light"
-- config.freetype_render_target = "HorizontalLcd"

--------------------------------------------------------------------------------
-- 5) Color Scheme Application
--------------------------------------------------------------------------------
config.colors = {
  foreground = colors.fg,
  background = colors.bg,
  cursor_bg = colors.caret,
  cursor_fg = colors.bg,
  cursor_border = colors.caret,
  selection_fg = colors.fg,
  selection_bg = colors.selection,
  scrollbar_thumb = colors.invisibles,
  split = colors.invisibles,

  ansi = {
    colors.invisibles, colors.red, colors.green, colors.yellow,
    colors.blue, colors.magenta, colors.cyan, colors.fg,
  },
  
  tab_bar = {
    background = colors.bg,
    active_tab = { bg_color = colors.yellow, fg_color = colors.bg, intensity = "Bold" },
    inactive_tab = { bg_color = colors.bg, fg_color = colors.comment },
    new_tab = { bg_color = colors.bg, fg_color = colors.caret, intensity = "Bold" },
  },
}

-- Mouse interaction bindings
config.mouse_bindings = {
  -- Right-click to copy selection
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = act.CopyTo("Clipboard"),
  },
  -- Middle-click to split horizontally
  {
    event = { Down = { streak = 1, button = "Middle" } },
    mods = "NONE",
    action = act.SplitHorizontal { domain = "CurrentPaneDomain" },
  },

  -- Control+Middle-click to split horizontally
  {
    event = { Down = { streak = 1, button = "Middle" } },
    mods = "CTRL",
    action = act.SplitVertical { domain = "CurrentPaneDomain" },
  },
  -- Shift+Middle-click to close pane
  {
    event = { Down = { streak = 1, button = "Middle" } },
    mods = "SHIFT",
    action = act.CloseCurrentPane { confirm = false },
  },
}

return config

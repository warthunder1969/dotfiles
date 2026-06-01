-- Require Neovim 0.10+ (we use vim.uv, vim.hl and other 0.10 APIs). The whole
-- point of this config is rescuing folks stuck on old distro Neovim, so fail
-- loudly and kindly instead of crashing deep inside a plugin.
if vim.fn.has("nvim-0.10") == 0 then
    local v = vim.version() or {}
    local cur = (v.major and (v.major .. "." .. v.minor .. "." .. v.patch)) or "an older version"
    vim.api.nvim_echo({
        { "butter-nvim requires Neovim 0.10 or newer — you're on " .. cur .. ".\n", "ErrorMsg" },
        { "See the README for ButterRepo, which keeps Debian/Ubuntu on current stable.", "WarningMsg" },
    }, true, {})
    return
end

require("config.options")
require("config.keybinds")
require("config.autocmds")
require("manage").setup()

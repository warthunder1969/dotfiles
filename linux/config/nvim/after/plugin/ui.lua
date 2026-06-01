-- Colorscheme
vim.cmd.colorscheme("github_dark_default")

-- Lualine
local ok, lualine = pcall(require, "lualine")
if ok then
    lualine.setup({
        options = {
            theme = "auto",
            component_separators = "",
            section_separators = "",
        },
    })
end

-- Bufferline
local ok2, bufferline = pcall(require, "bufferline")
if ok2 then
    bufferline.setup({})
end

-- Indent blankline
local ok4, ibl = pcall(require, "ibl")
if ok4 then
    ibl.setup({
        indent = { char = "│" },
        scope = { enabled = false },
    })
end

-- Colorizer
local ok5, colorizer = pcall(require, "colorizer")
if ok5 then
    colorizer.setup({
        filetypes = { "*" },
        buftypes = {},
        user_commands = true,
        options = {
            parsers = {
                css = true,
                css_fn = true,
                hex = { default = true },
                names = { enable = false },
            },
            display = {
                mode = { "background", "virtualtext" },
                virtualtext = { char = "■" },
            },
        },
    })
end

-- Transparent
local ok6, transparent = pcall(require, "transparent")
if ok6 then
    transparent.setup({})
end

-- Which-key
local ok7, wk = pcall(require, "which-key")
if ok7 then
    wk.setup({
        icons = {
            breadcrumb = "»",
            separator = "→",
            group = "+",
        },
        win = {
            border = "rounded",
        },
    })
    wk.add({
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>h", group = "Hunk" },
        { "<leader>p", group = "Preview" },
    })
end

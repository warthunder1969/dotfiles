-- Oil.nvim
local ok, oil = pcall(require, "oil")
if ok then
    oil.setup({
        default_file_explorer = true,
        view_options = {
            show_hidden = true,
        },
        float = {
            padding = 2,
            max_width = 60,
            max_height = 20,
        },
        keymaps = {
            ["<Esc>"] = "actions.close",
            ["<BS>"] = "actions.parent",
        },
    })
end

-- FZF-Lua
local ok2, fzf = pcall(require, "fzf-lua")
if ok2 then
    fzf.setup({
        winopts = {
            height = 0.85,
            width = 0.80,
            preview = {
                layout = "vertical",
            },
        },
    })

    -- On bare `nvim` (no file argument), open the recent-files picker
    vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
            if vim.fn.argc() == 0 then
                vim.cmd("FzfLua oldfiles")
            end
        end,
    })
end

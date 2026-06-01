local ok, tree = pcall(require, "nvim-tree")
if not ok then return end

-- Disable netrw so nvim-tree can take over
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

tree.setup({
    view = {
        width = 32,
        side = "left",
    },
    renderer = {
        group_empty = true,
        indent_markers = { enable = true },
    },
    filters = {
        dotfiles = false,
    },
    git = {
        enable = true,
        ignore = false,
    },
    actions = {
        open_file = {
            quit_on_open = false,
        },
    },
})

-- Ctrl+B toggles the tree (Geany Alt+, equivalent / VSCode sidebar muscle memory)
vim.keymap.set("n", "<C-b>", "<cmd>NvimTreeToggle<cr>",
    { silent = true, desc = "Toggle file tree" })

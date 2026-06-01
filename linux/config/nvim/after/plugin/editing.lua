-- Autopairs
local ok, autopairs = pcall(require, "nvim-autopairs")
if ok then
    autopairs.setup({})
end

-- Autolist (markdown lists). Wire its Enter/o/O behavior buffer-locally in
-- markdown only — otherwise the global insert <CR> map clobbers nvim-autopairs'
-- bracket-aware Enter, and the list logic runs pointlessly in code files.
local ok2, autolist = pcall(require, "autolist")
if ok2 then
    autolist.setup({})
    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown" },
        callback = function(args)
            local map = function(mode, lhs, rhs)
                vim.keymap.set(mode, lhs, rhs, { buffer = args.buf, silent = true })
            end
            map("i", "<CR>", "<CR><cmd>AutolistNewBullet<cr>")
            map("n", "o", "o<cmd>AutolistNewBullet<cr>")
            map("n", "O", "O<cmd>AutolistNewBulletBefore<cr>")
        end,
    })
end

-- Render-markdown
local ok3, render_md = pcall(require, "render-markdown")
if ok3 then
    render_md.setup({})
end

-- Markdown-preview
vim.g.mkdp_filetypes = { "markdown" }
-- Keep the preview window alive when you switch buffers — otherwise mkdp
-- kills it the moment you leave the markdown file (very disruptive if you've
-- arranged the preview on a specific workspace or monitor).
vim.g.mkdp_auto_close = 0
vim.defer_fn(function()
    pcall(vim.cmd, "call mkdp#util#install()")
end, 100)

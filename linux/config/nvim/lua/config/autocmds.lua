-- Briefly highlight yanked text. vim.highlight was renamed to vim.hl in 0.11;
-- prefer the new name and fall back so we stay quiet on 0.10.
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        (vim.hl or vim.highlight).on_yank({ higroup = "IncSearch", timeout = 200 })
    end,
})

-- Enable spell check in markdown and git commit buffers
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "gitcommit" },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.spelllang = "en_us"
    end,
})

-- Trim trailing whitespace on save. Skipped in markdown because trailing
-- spaces mark hard line breaks. winsaveview/winrestview preserves scroll and
-- folds (not just the cursor), and keeppatterns keeps \s\+$ out of your search
-- history so pressing n after a save doesn't start hunting whitespace.
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        if vim.bo.filetype == "markdown" then return end
        local view = vim.fn.winsaveview()
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.fn.winrestview(view)
    end,
})

-- Wipe the empty [No Name] starting buffer once a real file is opened,
-- so the bufferline doesn't show it sitting next to your actual files.
vim.api.nvim_create_autocmd("BufAdd", {
    callback = function(args)
        if vim.api.nvim_buf_get_name(args.buf) == "" then return end
        vim.schedule(function()
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                if buf ~= args.buf
                    and vim.api.nvim_buf_is_loaded(buf)
                    and vim.api.nvim_buf_get_name(buf) == ""
                    and not vim.bo[buf].modified
                    and vim.bo[buf].buftype == ""
                    and vim.api.nvim_buf_line_count(buf) == 1
                    and vim.api.nvim_buf_get_lines(buf, 0, 1, false)[1] == ""
                then
                    pcall(vim.api.nvim_buf_delete, buf, {})
                end
            end
        end)
    end,
})

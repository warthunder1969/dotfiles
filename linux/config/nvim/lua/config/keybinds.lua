-- map leader
vim.g.mapleader = " "
local keymap = vim.keymap

local function opts(desc)
    return { silent = true, noremap = true, desc = desc }
end

-- General
keymap.set("n", "<leader>a", "gg<S-v>G", opts("Select all"))
keymap.set("v", "<", "<gv", opts("Indent left"))
keymap.set("v", ">", ">gv", opts("Indent right"))

-- Save with Ctrl+S. In insert mode, stay in insert (don't break your typing flow).
-- <C-o> runs one normal-mode command then returns to insert.
keymap.set("n", "<C-s>", ":w<CR>", opts("Save file"))
keymap.set("v", "<C-s>", "<Esc>:w<CR>", opts("Save file"))
keymap.set("i", "<C-s>", "<C-o>:w<CR>", opts("Save file (stay in insert)"))

-- GUI-style undo / redo. Default Ctrl+Z suspends nvim — terrible surprise for non-vim users.
keymap.set("n", "<C-z>", "u", opts("Undo"))
keymap.set("i", "<C-z>", "<C-o>u", opts("Undo"))
keymap.set("n", "<C-y>", "<C-r>", opts("Redo"))
keymap.set("i", "<C-y>", "<C-o><C-r>", opts("Redo"))

-- Duplicate current line (Geany Ctrl+D)
keymap.set("n", "<C-d>", ":t.<CR>", opts("Duplicate line"))
keymap.set("i", "<C-d>", "<C-o>:t.<CR>", opts("Duplicate line"))

-- Toggle comment with Ctrl+/ (Geany muscle memory), using Neovim's built-in
-- commenting. remap=true is required because gcc/gc are themselves mappings.
-- Terminals disagree on the keycode: most send <C-_>, some send <C-/>.
local comment = { silent = true, remap = true, desc = "Toggle comment" }
keymap.set("n", "<C-_>", "gcc", comment)
keymap.set("x", "<C-_>", "gc", comment)
keymap.set("i", "<C-_>", "<C-o>gcc", comment)
keymap.set("n", "<C-/>", "gcc", comment)
keymap.set("x", "<C-/>", "gc", comment)
keymap.set("i", "<C-/>", "<C-o>gcc", comment)

-- Ctrl+Tab: switch to the previously-edited buffer (Geany's Ctrl+Tab muscle memory)
keymap.set("n", "<C-Tab>", "<C-^>", opts("Last buffer"))

-- Enter in normal mode opens a new line below (like pressing Enter in a GUI
-- editor). Gated to normal file buffers so it doesn't shadow the built-in <CR>
-- in special buffers like the quickfix list, where Enter jumps to the result.
keymap.set("n", "<CR>", function()
    return vim.bo.buftype == "" and "o" or "<CR>"
end, { silent = true, noremap = true, expr = true, desc = "New line below" })

-- GUI-style copy / cut / paste. clipboard=unnamedplus means these use the system clipboard.
-- "x" = Visual only, "s" = Select only. Select mode needs <C-g> to flip to Visual first
-- (otherwise y/d are typed as characters and replace the selection).
keymap.set("x", "<C-c>", "y", opts("Copy selection"))
keymap.set("s", "<C-c>", "<C-g>y", opts("Copy selection"))
keymap.set("x", "<C-x>", "d", opts("Cut selection"))
keymap.set("s", "<C-x>", "<C-g>d", opts("Cut selection"))
keymap.set("n", "<C-v>", "p", opts("Paste"))
keymap.set("i", "<C-v>", "<C-r>+", opts("Paste"))
keymap.set("x", "<C-v>", '"_dP', opts("Paste over selection"))
keymap.set("s", "<C-v>", '<C-g>"_dP', opts("Paste over selection"))

-- Move between splits with Ctrl+h/j/k/l (no Ctrl+W prefix needed)
keymap.set("n", "<C-h>", "<C-w>h", opts("Window left"))
keymap.set("n", "<C-j>", "<C-w>j", opts("Window down"))
keymap.set("n", "<C-k>", "<C-w>k", opts("Window up"))
keymap.set("n", "<C-l>", "<C-w>l", opts("Window right"))

-- Move lines up/down with Alt+arrows (normal and visual mode)
keymap.set("n", "<A-Down>", ":m .+1<CR>==", opts("Move line down"))
keymap.set("n", "<A-Up>", ":m .-2<CR>==", opts("Move line up"))
keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv", opts("Move selection down"))
keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv", opts("Move selection up"))

-- Search QoL: center result on n/N, clear highlight with <Esc>
keymap.set("n", "n", "nzzzv", opts("Next match (centered)"))
keymap.set("n", "N", "Nzzzv", opts("Prev match (centered)"))
keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", opts("Clear search highlight"))

-- Ctrl+F to open the search prompt (GUI-style Find)
keymap.set("n", "<C-f>", "/", opts("Find in file"))
keymap.set("i", "<C-f>", "<Esc>/", opts("Find in file"))
keymap.set("v", "<C-f>", "<Esc>/", opts("Find in file"))

-- Tab bindings
keymap.set("n", "<leader>t", ":tabnew<cr>", opts("New tab"))
keymap.set("n", "<leader>x", ":tabclose<cr>", opts("Close tab"))
keymap.set("n", "<leader>j", ":tabnext<cr>", opts("Next tab"))
keymap.set("n", "<leader>k", ":tabprevious<cr>", opts("Previous tab"))

-- Buffer navigation
keymap.set("n", "<Tab>", ":bnext<cr>", opts("Next buffer"))
keymap.set("n", "<S-Tab>", ":bprevious<cr>", opts("Previous buffer"))
-- Close buffer: if dirty, prompt to save/discard/cancel (Geany-style)
keymap.set("n", "<leader>q", function()
    if vim.bo.modified then
        local name = vim.fn.expand("%:t")
        if name == "" then name = "[No Name]" end
        local choice = vim.fn.confirm(
            "Save changes to " .. name .. "?",
            "&Save\n&Discard\n&Cancel",
            1
        )
        if choice == 1 then
            vim.cmd("write")
            vim.cmd("bdelete")
        elseif choice == 2 then
            vim.cmd("bdelete!")
        end
        -- choice 0 or 3 = cancel; do nothing
    else
        vim.cmd("bdelete")
    end
end, opts("Close buffer"))

-- Ctrl+1..9: jump to the Nth buffer in the bufferline (Geany / browser style)
for i = 1, 9 do
    keymap.set("n", "<C-" .. i .. ">",
        "<Cmd>BufferLineGoToBuffer " .. i .. "<CR>",
        opts("Go to buffer " .. i))
end

-- Split generation
keymap.set("n", "<leader>v", ":vsplit<CR>", opts("Vertical split"))
keymap.set("n", "<leader>s", ":split<CR>", opts("Horizontal split"))

-- Resize splits (Alt+arrow; leaves Ctrl+arrow free for word-jumping)
keymap.set("n", "<A-Left>", ":vertical resize +3<cr>", opts("Resize left"))
keymap.set("n", "<A-Right>", ":vertical resize -3<cr>", opts("Resize right"))

-- Oil.nvim
keymap.set("n", "<leader>e", function()
    require("oil").toggle_float()
end, opts("Explorer"))

-- fzf-lua
keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>", opts("Find files"))
keymap.set("n", "<leader>fw", "<cmd>FzfLua live_grep<cr>", opts("Find word"))
keymap.set("n", "<leader>fr", "<cmd>FzfLua oldfiles<cr>", opts("Find recent files"))
keymap.set("n", "<leader>fh", "<cmd>FzfLua help_tags<cr>", opts("Find help"))

-- Find via zoxide: pick any previously-visited dir, cd there, open file picker
keymap.set("n", "<leader>fz", function()
    local handle = io.popen("zoxide query -l 2>/dev/null")
    if not handle then
        vim.notify("zoxide not found on PATH", vim.log.levels.ERROR)
        return
    end
    local dirs = {}
    for line in handle:lines() do
        table.insert(dirs, line)
    end
    handle:close()

    if #dirs == 0 then
        vim.notify("No zoxide entries yet — `cd` around in your shell to build the database", vim.log.levels.WARN)
        return
    end

    require("fzf-lua").fzf_exec(dirs, {
        prompt = "Zoxide > ",
        actions = {
            ["default"] = function(selected)
                if selected and selected[1] then
                    vim.cmd("cd " .. vim.fn.fnameescape(selected[1]))
                    require("fzf-lua").files()
                end
            end,
        },
    })
end, opts("Find via zoxide"))
keymap.set("n", "<leader>fc", function()
    require("fzf-lua").files({
        cwd = vim.fn.stdpath("config"),
    })
end, opts("Find config"))

-- Git
keymap.set("n", "<leader>gg", ":vertical Git<cr>", opts("Git status"))
keymap.set("n", "<leader>gc", "<cmd>FzfLua git_branches<cr>", opts("Git branches"))

-- Preview/Format
keymap.set("n", "<leader>pp", ":MarkdownPreviewToggle<cr>", opts("Preview markdown"))
keymap.set("n", "<leader>pf", function()
    if vim.fn.executable("prettier") == 1 then
        vim.cmd("!prettier --write " .. vim.fn.shellescape(vim.fn.expand("%")))
    else
        vim.notify("Prettier not found. Install with: npm install -g prettier", vim.log.levels.ERROR)
    end
end, opts("Format with Prettier"))

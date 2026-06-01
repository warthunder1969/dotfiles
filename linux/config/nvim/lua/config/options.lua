local opt = vim.opt

-- global statusline
opt.laststatus = 3

-- Leave guicursor at Neovim's default: block in normal mode, a thin bar in
-- insert mode. The insert-mode bar is what GUI/Geany users expect while typing,
-- so we don't force a block everywhere. (Set opt.guicursor = "" for that look.)

-- disable cmd messages
opt.showmode = false

-- enable system clipboard
opt.clipboard = "unnamedplus"

-- (optional) cursorline has no effect if transparent.nvim is enable
opt.cursorline = true

-- scrolloff for cursor
opt.scrolloff = 8

-- Indenting
opt.expandtab = true
opt.shiftwidth = 2
opt.smartindent = true
opt.tabstop = 2
opt.softtabstop = 2

-- statusline characters
opt.fillchars = { eob = " " }

-- enhance searching
opt.ignorecase = true
opt.smartcase = true

-- enable mouse in all modes (click to position cursor, click to close bufferline tabs, etc.)
opt.mouse = "a"

-- numberline
opt.number = true
-- Absolute line numbers by default — familiar to GUI users. Flip to true once
-- you're comfortable with motions; relative numbers make 5j / 3dd effortless.
opt.relativenumber = false
opt.numberwidth = 2
opt.ruler = false

-- highlight all matches while searching (press <Esc> in normal mode to clear)
opt.hlsearch = true

-- no wrap
opt.wrap = false


-- enable signcolumn
opt.signcolumn = "yes"

-- default split from bottom-right
opt.splitbelow = true
opt.splitright = true

-- enable guicolors
opt.termguicolors = true

-- file recovery
opt.undofile = true

-- interval for writing swap file to disk, also used by gitsigns
opt.updatetime = 250

-- GUI-style Shift+arrow selection: Shift+arrow starts/extends a selection,
-- plain arrow stops it, typing replaces the selected text.
opt.keymodel = "startsel,stopsel"
opt.selectmode = "key"
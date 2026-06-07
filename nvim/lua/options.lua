vim.opt.clipboard = 'unnamedplus' -- use system clipboard
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.mouse = 'a'               -- allow the mouse to be used in nvim
vim.opt.swapfile = false          -- disable swap for faster typing

-- Tab
vim.opt.tabstop = 2 -- number of visual spaces per TAB
vim.opt.softtabstop = 2 -- number of spaces in tab when editing
vim.opt.shiftwidth = 2 -- insert 4 spaces on a tab
vim.opt.expandtab = true -- tabs are spaces, mainly because of Python
vim.opt.smartindent = true -- auto indent on new lines
vim.opt.autoindent = true -- preserve indent from previous line
vim.opt.breakindent = true -- visually indent wrapped lines
vim.opt.list = true -- show invisible characters
vim.opt.listchars = { tab = "▸ ", trail = "·" } -- visual guides

-- UI config
vim.opt.number = true         -- show absolute number
vim.opt.relativenumber = true -- add numbers to each line on the left side
vim.opt.cursorline = true     -- highlight cursor line underneath the cursor horizontally
vim.opt.splitbelow = true     -- open new vertical split bottom
vim.opt.splitright = true     -- open new horizontal splits right
-- vim.opt.termguicolors = true        -- enable 24-bit RGB color in the TUI
vim.opt.showmode = false      -- we are experienced, wo don't need the "-- INSERT --" mode hint
vim.opt.signcolumn = "yes"    -- avoid shifting when adding signs
vim.opt.showmode = false
vim.opt.showcmd = true        -- show incomplete commands
vim.opt.ruler = true          -- cursor position in status line
vim.opt.laststatus = 3        -- global status line
vim.opt.colorcolumn = "80"    -- guide for line length
vim.opt.termguicolors = true
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Searching
vim.opt.incsearch = true                                    -- search as characters are entered
vim.opt.hlsearch = true                                     -- do not highlight matches
vim.opt.ignorecase = true                                   -- ignore case in searches by default
vim.opt.smartcase = true                                    -- but make it case sensitive if an uppercase is entered

vim.opt.completeopt = { "menuone", "noselect", "noinsert" } -- for nvim-cmp
vim.opt.wildmenu = true                                     -- better command-line completion
vim.opt.wildmode = "longest:full,full"
vim.opt.pumheight = 10                                      -- max completion menu height

vim.opt.lazyredraw = true                                   -- faster macro execution
vim.opt.synmaxcol = 240                                     -- max column for syntax highlighting
vim.opt.encoding = "utf-8"
vim.opt.shortmess:append("c")                               -- avoid duplicate messages from completion

vim.wo.fillchars = 'eob: '

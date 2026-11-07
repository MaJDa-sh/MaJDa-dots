vim.opt.clipboard = 'unnamedplus'
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.mouse = 'a'
vim.opt.swapfile = false

-- Tab
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.breakindent = true
vim.opt.list = true
vim.opt.listchars = { tab = "▸ ", trail = "·" }

-- UI config
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.signcolumn = "yes"
vim.opt.showmode = false
vim.opt.showcmd = true
vim.opt.ruler = true
vim.opt.laststatus = 3
vim.opt.colorcolumn = "100"
vim.opt.termguicolors = true
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Lex
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3

vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
        vim.opt_local.number = true
        vim.opt_local.relativenumber = true
    end,
})


-- Searching
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.completeopt = { "menuone", "noselect", "noinsert" }
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full,full"
vim.opt.pumheight = 10

vim.opt.lazyredraw = true
vim.opt.synmaxcol = 240
vim.opt.encoding = "utf-8"
vim.opt.shortmess:append("c")

vim.wo.fillchars = 'eob: '

-- delay while using keybinds
vim.o.timeout = true
vim.o.timeoutlen = 200
vim.o.ttimeoutlen = 10

vim.opt.path:append("**")
vim.opt.wildoptions = "pum,fuzzy"
vim.opt.wildmenu = true

-- theme
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.cmd.colorscheme("sorbet")

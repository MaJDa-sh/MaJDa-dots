-- ~/.config/nvim/plugin/keymaps.lua

-------------------------
-- Leader key setup
-------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-------------------------
-- Common options
-------------------------
local opts = {
  noremap = true, -- non-recursive
  silent = true,  -- do not show messages
}

-------------------------
-- Normal mode mappings
-------------------------

-- Move between splits (cards) using Ctrl + h/j/k/l
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Resize splits with Ctrl + Arrow keys
vim.keymap.set("n", "<C-Up>", "<cmd>resize -2<CR>", opts)
vim.keymap.set("n", "<C-Down>", "<cmd>resize +2<CR>", opts)
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts)

-- Buffer switching
vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", opts)

-- Close buffer
vim.keymap.set("n", "<leader>x", "<cmd>bdelete<CR>", opts)

-- Toggle Inlay Hints (requires Neovim 0.10+)
if vim.lsp.inlay_hint then
  vim.lsp.inlay_hint.enable(true) -- Enable by default
  vim.keymap.set("n", "<leader>h", function()
    local enabled = vim.lsp.inlay_hint.is_enabled()
    if enabled then
      vim.lsp.inlay_hint.disable()
      vim.notify("Inlay Hints Disabled")
    else
      vim.lsp.inlay_hint.enable()
      vim.notify("Inlay Hints Enabled")
    end
  end, { desc = "Toggle Inlay Hints" })
end

-- Undotree
vim.cmd("packadd nvim.undotree")
vim.keymap.set("n", "<leader>u", function()
  require("undotree").open()
end, { desc = "Open UndoTree" })

-- Nvim-tree (if installed)
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", opts)
vim.keymap.set("n", "<leader>fe", "<cmd>NvimTreeFocus<CR>", opts)
vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFile<CR>", opts)

-------------------------
-- Visual mode mappings
-------------------------

-- Keep selection after shifting
vim.keymap.set("v", "<", "<gv", opts)
vim.keymap.set("v", ">", ">gv", opts)

-- nvim-treesitter incremental selection notes
-- gss: start selection
-- gsi: increment selection
-- gsc: increment scope
-- gsd: decrement selection
--
-- Move left/right across line boundaries
vim.keymap.set("n", "h", function()
  if vim.fn.col(".") == 1 then
    vim.cmd("normal! k$")
  else
    vim.cmd("normal! h")
  end
end, { noremap = true, silent = true })

vim.keymap.set("n", "l", function()
  local col = vim.fn.col(".")
  local line_len = vim.fn.col("$") - 1

  if col == line_len then
    vim.cmd("normal! j0")
  else
    vim.cmd("normal! l")
  end
end, { noremap = true, silent = true })

-- hiding highlight search by using esc
vim.api.nvim_set_keymap('i', '<Esc>', '<Esc>:nohlsearch<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Esc>', '<Esc>:nohlsearch<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Esc>', ':nohlsearch<CR><Esc>', { noremap = true, silent = true })

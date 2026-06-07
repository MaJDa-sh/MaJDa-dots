-- Load the icons first
require("nvim-web-devicons").setup({
  default = true,
})

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit RGB color
vim.opt.termguicolors = true

require("nvim-tree").setup({
  view = {
    width = 40,
  },

  update_focused_file = {
    enable = true,
    update_root = false,
  },
})

vim.keymap.set("n", "<C-n>", ":NvimTreeToggle<CR>", { silent = true })
vim.keymap.set("n", "<leader>e", ":NvimTreeFocus<CR>", { silent = true })

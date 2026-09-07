require("telescope").setup({
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",


      "--glob=!node_modules/*",
      "--glob=!.git/*",
      "--glob=!dist/*",
      "--glob=!build/*",
      "--glob=!.next/*",
    },
  },
})

-- Keymaps (kept outside setup for clarity and flexibility)
local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files, {
  desc = "Search over files",
})

vim.keymap.set("n", "<leader>fg", builtin.git_files, {
  desc = "Search over git files",
})

vim.keymap.set("n", "<leader>fw", builtin.live_grep, {
  desc = "Live grep (uses ripgrep)",
})

vim.keymap.set("n", "<leader>fr", builtin.resume, {
  desc = "Resume Telescope",
})

require("mini.comment").setup({
  options = {
    -- Whether to check if space should be next to comment marker
    check_space = true,
  },
  mappings = {
    -- Define custom mappings if needed, but we'll use vim.keymap.set for <leader>/
    comment = "gc",
    comment_line = "gcc",
    comment_visual = "gc",
    textobject = "gc",
  },
})

local opts = { noremap = true, silent = true }

-- Normal mode: comment current line
vim.keymap.set("n", "<leader>/", "gcc", { remap = true, desc = "Comment line" })

-- Visual mode: comment selection
vim.keymap.set("v", "<leader>/", "gc", { remap = true, desc = "Comment selection" })

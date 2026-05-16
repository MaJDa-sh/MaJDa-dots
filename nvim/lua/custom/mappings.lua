local M = {}

M.fugitive = {
  plugin = true,

  n = {
    ["<leader>gs"] = { "<cmd>Git<CR>", "Git status (fugitive)" },
    ["<leader>gD"] = { "<cmd>Gdiffsplit<CR>", "Git diff split (fugitive)" },
    ["<leader>gB"] = { "<cmd>Git blame<CR>", "Git blame (fugitive)" },
    ["<leader>gS"] = { "<cmd>Git blame --root<CR>", "Git blame full file (fugitive)" },
    ["<leader>gC"] = { "<cmd>Git commit<CR>", "Git commit (fugitive)" },
    ["<leader>gl"] = { "<cmd>Git log<CR>", "Git log (fugitive)" },
    ["<leader>gL"] = { "<cmd>Gclog<CR>", "Git log for file (fugitive)" },
    ["<leader>gP"] = { "<cmd>Gdiffsplit HEAD~1<CR>", "Diff vs previous commit (fugitive)" },
    ["<leader>gH"] = { "<cmd>Gvdiffsplit HEAD<CR>", "Diff vs HEAD (fugitive)" },
    ["<leader>gk"] = { "<cmd>Telescope git_commits<CR>", "Commit picker (repo)" },
    ["<leader>gf"] = { "<cmd>Telescope git_bcommits<CR>", "Commit picker (file)" },
  },
}

return M

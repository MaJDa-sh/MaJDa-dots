return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fa", "<cmd>Telescope find_files follow=true no_ignore=true hidden=true<cr>", desc = "Find all" },
      { "<leader>fw", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help page" },
      { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Find oldfiles" },
      { "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Find in current buffer" },
      { "<leader>cm", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
      { "<leader>gt", "<cmd>Telescope git_status<cr>", desc = "Git status" },
      { "<leader>th", "<cmd>Telescope themes<cr>", desc = "Nvchad themes" },
      { "<leader>ma", "<cmd>Telescope marks<cr>", desc = "telescope bookmarks" },
    },
    opts = {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "smart" },
      },
    },
  },
}

return {
  {
    "numToStr/Comment.nvim",
    keys = {
      { "gcc", mode = "n", desc = "Toggle comment line" },
      { "gc", mode = { "n", "v" }, desc = "Toggle comment" },
      {
        "<leader>/",
        function()
          require("Comment.api").toggle.linewise.current()
        end,
        mode = "n",
        desc = "Toggle comment",
      },
      {
        "<leader>/",
        function()
          local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
          vim.api.nvim_feedkeys(esc, "nx", false)
          require("Comment.api").toggle.linewise(vim.fn.visualmode())
        end,
        mode = "x",
        desc = "Toggle comment",
      },
    },
    opts = {
      pre_hook = function()
        return vim.bo.commentstring
      end,
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufReadPost",
    opts = {
      indent = { char = "│" },
      scope = { enabled = true, show_start = false, show_end = false },
    },
    config = function(_, opts)
      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "IblScope", { fg = "#7a869a", bold = true })
      end)
      require("ibl").setup(opts)
    end,
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "zbirenbaum/nvterm",
    keys = { "<A-i>", "<A-h>", "<A-v>", "<leader>h", "<leader>v" },
    opts = {
      terminals = {
        shell = vim.o.shell,
        list = {},
        type_opts = {
          float = {
            relative = "editor",
            row = 0.2,
            col = 0.2,
            width = 0.6,
            height = 0.6,
            border = "single",
          },
          horizontal = { location = "rightbelow", split_ratio = 0.3 },
          vertical = { location = "rightbelow", split_ratio = 0.5 },
        },
      },
    },
  },
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPost",
    opts = {
      user_default_options = {
        names = false,
      },
    },
  },
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
  },
}

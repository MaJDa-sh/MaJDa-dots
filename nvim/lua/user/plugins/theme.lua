return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "storm",
      terminal_colors = true,
      on_highlights = function(hl, c)
        hl.Comment = { fg = "#7a8398", italic = true }
        hl.String = { fg = "#c3e88d" }
        hl.Function = { fg = "#82aaff" }
        hl.Keyword = { fg = "#c792ea", italic = true }
        hl.Type = { fg = "#ffcb6b" }
        hl.Identifier = { fg = "#b4c2f0" }
        hl.TabLineSel = { fg = c.bg, bg = "#82aaff", bold = true }
      end,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight")
    end,
  },
}

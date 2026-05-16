return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        [[               __     __  __               ]],
        [[              /  |   /  |/  |              ]],
        [[ _____  ____  $$ |   $$ |$$/  _____  ____  ]],
        [[/     \/    \ $$ |   $$ |/  |/     \/    \ ]],
        [[$$$$$$ $$$$  |$$  \ /$$/ $$ |$$$$$$ $$$$  |]],
        [[$$ | $$ | $$ | $$  /$$/  $$ |$$ | $$ | $$ |]],
        [[$$ | $$ | $$ |  $$ $$/   $$ |$$ | $$ | $$ |]],
        [[$$ | $$ | $$ |   $$$/    $$ |$$ | $$ | $$ |]],
        [[$$/  $$/  $$/     $/     $$/ $$/  $$/  $$/ ]],
        [[                                           ]],
      }

      dashboard.section.buttons.val = {
        dashboard.button("f f", "  Find File", "<cmd>Telescope find_files<cr>"),
        dashboard.button("f o", "󰈚  Recent Files", "<cmd>Telescope oldfiles<cr>"),
        dashboard.button("f w", "󰈭  Find Word", "<cmd>Telescope live_grep<cr>"),
        dashboard.button("m a", "  Bookmarks", "<cmd>Telescope marks<cr>"),
        dashboard.button("t h", "  Themes", "<cmd>Telescope themes<cr>"),
        dashboard.button("c h", "  Mappings", "<cmd>WhichKey<cr>"),
        dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
      }

      dashboard.section.footer.val = ""
      dashboard.opts.opts.noautocmd = true

      alpha.setup(dashboard.opts)

      vim.api.nvim_create_autocmd("VimEnter", {
        once = true,
        callback = function()
          local buf = vim.api.nvim_get_current_buf()
          local is_empty = vim.api.nvim_buf_get_name(buf) == ""
            and vim.bo[buf].buftype == ""
            and not vim.bo[buf].modified
          if vim.fn.argc() == 0 and is_empty then
            vim.cmd("Alpha")
          end
        end,
      })
    end,
  },
}

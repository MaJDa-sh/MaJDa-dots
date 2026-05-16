require("lazy").setup({
  { import = "user.plugins" },
}, {
  defaults = { lazy = true },
  change_detection = { notify = false },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = false },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

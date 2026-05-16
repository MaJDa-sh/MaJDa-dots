local plugins = {
  -- LSP client configs and setup glue.
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  -- Installer for LSP servers/formatters.
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "typescript-language-server",
        "solargraph",
        "gopls",
        "prettierd",
      },
    },
  },
  -- Bridges Mason package names to lspconfig server names.
  {
    "williamboman/mason-lspconfig.nvim",
    event = "User FilePost",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup {
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "solargraph",
          "gopls",
        },
        automatic_installation = false,
      }
    end,
  },
  -- Runs external formatters/linters through the LSP interface.
  {
    "nvimtools/none-ls.nvim",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact", "ruby", "go" },
    opts = function()
      return require "custom.configs.null-ls"
    end,
  },
  -- Full Git workflow inside Neovim.
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G" },
    init = function()
      require("core.utils").load_mappings "fugitive"
    end,
  },
  -- Fast two-character jump motion.
  {
    url = "https://codeberg.org/andyg/leap.nvim",
    keys = { "s", "S" },
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  -- Auto-close and auto-rename JSX/TSX tags.
  {
    "windwp/nvim-ts-autotag",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  -- Tree-sitter parsers for syntax and structural editing.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      local opts = require "plugins.configs.treesitter"
      opts.ensure_installed = {
        "lua",
        "javascript",
        "typescript",
        "tsx",
        "ruby",
        "go",
      }
      return opts
    end,
  },
}

return plugins

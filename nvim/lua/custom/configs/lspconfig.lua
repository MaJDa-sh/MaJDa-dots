local base = require "plugins.configs.lspconfig"

local on_attach = base.on_attach
local capabilities = base.capabilities

vim.filetype.add {
  extension = {
    jsx = "javascriptreact",
    tsx = "typescriptreact",
  },
}

local function on_attach_optimized(client, bufnr)
  if client.name == "ts_ls" then
    client.server_capabilities.documentFormattingProvider = false
  end
  on_attach(client, bufnr)
end

local function setup_server(name, opts)
  opts = opts or {}
  opts.on_attach = on_attach_optimized
  opts.capabilities = capabilities
  opts.flags = vim.tbl_extend("force", opts.flags or {}, {
    debounce_text_changes = 300,
  })
  vim.lsp.config(name, opts)
  vim.lsp.enable(name)
end

setup_server("lua_ls", {
  filetypes = { "lua" },
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
})

setup_server("ts_ls", {
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  single_file_support = true,
  cmd = { "typescript-language-server", "--stdio", "--tsserver-max-memory=1024" },
})

setup_server("solargraph", {
  filetypes = { "ruby" },
  settings = {
    solargraph = {
      diagnostics = true,
      formatting = true,
      useBundler = true,
    },
  },
})

setup_server("gopls", {
  filetypes = { "go", "gomod" },
  settings = {
    gopls = {
      analyses = {
        unusedparams = true,
      },
      staticcheck = false,
      gofumpt = true,
    },
  },
})

vim.lsp.config('ts_ls', {
  cmd = { 'typescript-language-server', '--stdio' },
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
  },
  root_markers = {
    'tsconfig.json',
    'jsconfig.json',
    'package.json',
    '.git',
  },
})

vim.lsp.config('gopls', {
  cmd = { 'gopls' },
  filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
  root_markers = { 'go.work', 'go.mod', '.git' },
})

vim.lsp.enable({ 'ts_ls', 'gopls' })

-- Built-in syntax highlighting
vim.cmd('syntax enable')

-- Show diagnostics inline and in the sign column
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  severity_sort = true,
})

-- Enable LSP completion suggestions as you type, where supported.
-- <C-y> accepts the selected suggestion.
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, event.buf, {
        autotrigger = true,
      })
    end
  end,
})

-- Format with the attached TypeScript or Go server before saving
vim.api.nvim_create_autocmd('BufWritePre', {
  callback = function(event)
    vim.lsp.buf.format({
      bufnr = event.buf,
      timeout_ms = 2000,
      filter = function(client)
        return client.name == 'ts_ls' or client.name == 'gopls'
      end,
    })
  end,
})

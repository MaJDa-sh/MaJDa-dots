local augroup = vim.api.nvim_create_augroup("user_config", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

local function create_user_command_if_missing(name, rhs, opts)
  if vim.fn.exists(":" .. name) == 0 then
    vim.api.nvim_create_user_command(name, rhs, opts or {})
  end
end

create_user_command_if_missing("LspInfo", function()
  vim.cmd("checkhealth vim.lsp")
end, { desc = "Alias to :checkhealth vim.lsp" })

create_user_command_if_missing("LspLog", function()
  vim.cmd("tabnew " .. vim.lsp.log.get_filename())
end, { desc = "Open LSP log" })

create_user_command_if_missing("LspStart", function(info)
  local targets = info.fargs
  if #targets == 0 then
    local ft = vim.bo.filetype
    local ft_servers = {
      lua = { "lua_ls" },
      javascript = { "ts_ls" },
      javascriptreact = { "ts_ls" },
      typescript = { "ts_ls" },
      typescriptreact = { "ts_ls" },
      go = { "gopls" },
      gomod = { "gopls" },
    }
    local discovered = ft_servers[ft]
    if discovered then
      targets = discovered
    else
      targets = {}
    end
  end

  if #targets > 0 then
    local allowed = {
      lua_ls = true,
      ts_ls = true,
      gopls = true,
    }
    local filtered = {}
    for _, name in ipairs(targets) do
      if allowed[name] then
        table.insert(filtered, name)
      end
    end
    if #filtered > 0 then
      vim.lsp.enable(filtered)
    end
  end
end, { desc = "Enable and launch LSP server(s)", nargs = "*" })

create_user_command_if_missing("LspStop", function(info)
  local names = info.fargs
  if #names == 0 then
    names = vim.iter(vim.lsp.get_clients()):map(function(c)
      return c.name
    end):totable()
  end

  for _, name in ipairs(names) do
    vim.lsp.enable(name, false)
    local clients = vim.lsp.get_clients({ name = name })
    for _, client in ipairs(clients) do
      client:stop(info.bang)
    end
  end
end, { desc = "Disable and stop LSP server(s)", nargs = "*", bang = true })

create_user_command_if_missing("LspRestart", function(info)
  local names = info.fargs
  if #names == 0 then
    names = vim.iter(vim.lsp.get_clients()):map(function(c)
      return c.name
    end):totable()
  end

  for _, name in ipairs(names) do
    vim.lsp.enable(name, false)
    local clients = vim.lsp.get_clients({ name = name })
    for _, client in ipairs(clients) do
      client:stop(info.bang)
    end
  end

  vim.defer_fn(function()
    if #names > 0 then
      vim.lsp.enable(names)
    else
      pcall(vim.cmd, "LspStart")
    end
  end, 250)
end, { desc = "Restart active LSP clients", nargs = "*", bang = true })

local function is_js_family_filetype(filetype)
  return vim.tbl_contains({
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  }, filetype)
end

local function is_import_like_text(text)
  text = text or ""
  if text:match("^%s*import%s") then return true end
  if text:match("^%s*from%s.*%simport%s") then return true end
  -- re-exports: "export { x } from './y'" or "export * from './y'"
  if text:match("^%s*export%s") and text:match("%sfrom%s") then return true end
  return false
end

local function jump_to_item(item)
  local bufnr = item.bufnr or vim.fn.bufadd(item.filename)
  vim.cmd("normal! m'")
  local from = { vim.fn.bufnr("%"), vim.fn.line("."), vim.fn.col("."), 0 }
  vim.fn.settagstack(
    vim.fn.win_getid(),
    { items = { { tagname = vim.fn.expand("<cword>"), from = from } } },
    "t"
  )
  vim.bo[bufnr].buflisted = true
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, bufnr)
  vim.api.nvim_win_set_cursor(win, { item.lnum, item.col - 1 })
  vim.cmd("normal! zv")
end

local function jump_to_location(location, offset_encoding)
  local uri = location.uri or location.targetUri
  local range = location.range or location.targetSelectionRange
  if not uri or not range then return false end
  local bufnr = vim.uri_to_bufnr(uri)
  vim.fn.bufload(bufnr)
  vim.cmd("normal! m'")
  local from = { vim.fn.bufnr("%"), vim.fn.line("."), vim.fn.col("."), 0 }
  vim.fn.settagstack(
    vim.fn.win_getid(),
    { items = { { tagname = vim.fn.expand("<cword>"), from = from } } },
    "t"
  )
  vim.bo[bufnr].buflisted = true
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, bufnr)
  local line = vim.api.nvim_buf_get_lines(bufnr, range.start.line, range.start.line + 1, false)[1] or ""
  local col = vim.str_byteindex(line, offset_encoding, range.start.character, false)
  vim.api.nvim_win_set_cursor(win, { range.start.line + 1, col })
  vim.cmd("normal! zv")
  return true
end

local function score_item(item, current_file, ft)
  local score = 0
  local file = item.filename or ""

  if not is_import_like_text(item.text) then
    score = score + 1000
  end

  if file ~= current_file then
    score = score + 100
  end

  if is_js_family_filetype(ft) then
    if file:match("%.d%.ts$") then
      score = score - 10000
    end
    if file:match("node_modules") then
      score = score - 5000
    end
    if file:match("%.tsx?$") or file:match("%.jsx?$") then
      score = score + 500
    end
  end

  return score
end

local function select_best_item(items, current_file, ft)
  local best = items[1]
  local best_score = score_item(best, current_file, ft)

  for i = 2, #items do
    local s = score_item(items[i], current_file, ft)
    if s > best_score then
      best = items[i]
      best_score = s
    end
  end

  return best
end

-- Use ts_ls's _typescript.goToSourceDefinition to follow through imports
local function ts_go_to_source_definition(bufnr, position, callback)
  local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "ts_ls" })
  if #clients == 0 then
    callback(nil)
    return
  end
  local client = clients[1]
  local uri = vim.uri_from_bufnr(bufnr)
  client:request("workspace/executeCommand", {
    command = "_typescript.goToSourceDefinition",
    arguments = { uri, position },
  }, function(err, result)
    if err or not result or vim.tbl_isempty(result) then
      callback(nil)
    else
      callback(result, client.offset_encoding)
    end
  end, bufnr)
end

local function make_on_list(not_found_msg, method)
  return function(result)
    local items = result.items
    if vim.tbl_isempty(items) then
      vim.notify(not_found_msg, vim.log.levels.INFO)
      return
    end

    local current_file = vim.api.nvim_buf_get_name(0)
    local ft = vim.bo.filetype
    local best = select_best_item(items, current_file, ft)

    -- If best result is an import in the current file, try to follow through
    if best.filename == current_file and is_import_like_text(best.text) then
      -- For JS/TS: use TypeScript's goToSourceDefinition
      if is_js_family_filetype(ft) then
        local bufnr = vim.api.nvim_get_current_buf()
        local win = vim.api.nvim_get_current_win()
        local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "ts_ls" })
        if #clients > 0 then
          local client = clients[1]
          local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
          ts_go_to_source_definition(bufnr, params.position, function(locations, encoding)
            if locations then
              local source_items = vim.lsp.util.locations_to_items(locations, encoding)
              local source_best = select_best_item(source_items, current_file, ft)
              jump_to_item(source_best)
            else
              jump_to_item(best)
            end
          end)
          return
        end
      end

      -- For other languages: try follow-up definition at the import position
      local location = best.user_data
      if location then
        local uri = location.uri or location.targetUri
        local range = location.range or location.targetSelectionRange
        if uri and range then
          local bufnr = vim.api.nvim_get_current_buf()
          local clients = vim.lsp.get_clients({ bufnr = bufnr, method = method })
          if #clients > 0 then
            local client = clients[1]
            client:request(method, {
              textDocument = { uri = uri },
              position = { line = range.start.line, character = range.start.character },
            }, function(err, follow_result)
              if err or not follow_result then
                jump_to_item(best)
                return
              end
              local follow_locations = vim.islist(follow_result)
                  and follow_result
                  or { follow_result }
              local follow_items = vim.lsp.util.locations_to_items(
                follow_locations, client.offset_encoding
              )
              local filtered = vim.tbl_filter(function(fi)
                return not (fi.filename == best.filename and fi.lnum == best.lnum)
              end, follow_items)
              if vim.tbl_isempty(filtered) then
                jump_to_item(best)
                return
              end
              jump_to_item(select_best_item(filtered, current_file, ft))
            end, bufnr)
            return
          end
        end
      end
    end

    jump_to_item(best)
  end
end

-- Remove Neovim default LSP mappings
pcall(vim.keymap.del, "n", "grn")
pcall(vim.keymap.del, "n", "gra")
pcall(vim.keymap.del, "n", "grr")
pcall(vim.keymap.del, "n", "gri")
pcall(vim.keymap.del, "n", "gO")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function()
    local bufopts = {
      noremap = true,
      silent = true,
    }

    vim.keymap.set("n", "gd", function()
      vim.lsp.buf.definition({
        on_list = make_on_list("No definition found", "textDocument/definition"),
      })
    end, bufopts)

    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)

    vim.keymap.set("n", "gri", function()
      vim.lsp.buf.implementation({
        on_list = make_on_list("No implementation found", "textDocument/implementation"),
      })
    end, bufopts)

    vim.keymap.set("n", "gD", function()
      local bufnr = vim.api.nvim_get_current_buf()
      local has_decl = #vim.lsp.get_clients({
        bufnr = bufnr,
        method = "textDocument/declaration",
      }) > 0
      if has_decl then
        vim.lsp.buf.declaration({
          on_list = make_on_list("No declaration found", "textDocument/declaration"),
        })
      else
        vim.lsp.buf.definition({
          on_list = make_on_list("No definition found", "textDocument/definition"),
        })
      end
    end, bufopts)

    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)

    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)

    vim.keymap.set(
      "n",
      "<leader>ca",
      vim.lsp.buf.code_action,
      bufopts
    )

    vim.keymap.set({ "n", "v" }, "<leader>f", function()
      require("conform").format({
        lsp_fallback = true,
        async = true,
        timeout_ms = 1000,
      })
    end, bufopts)
  end,
})

vim.lsp.enable({
  "clangd",
  "clojure_lsp",
  "lua_ls",
  "ty",
  "ocamllsp",
  "fennel_language_server",
  "tinymist",
  "roc_ls",
  "rust_analyzer",
  "zls",
  "gopls",
  "ts_ls",
})

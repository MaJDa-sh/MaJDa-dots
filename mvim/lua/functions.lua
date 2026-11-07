vim.api.nvim_create_user_command("Files", function(opts)
    local output = vim.fn.systemlist({
        "rg", "--files", "--hidden", "-g", "!.git",
    })

    local matches = vim.fn.matchfuzzy(output, opts.args)

    vim.fn.setqflist({}, "r", {
        title = "Files: " .. opts.args,
        lines = matches,
        efm = "%f",
    })

    vim.cmd("copen")
end, { nargs = "*" })

vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"

vim.api.nvim_create_user_command("Rg", function(opts)
    vim.cmd("silent grep! " .. vim.fn.shellescape(opts.args))
    vim.cmd("copen")
end, { nargs = "+" })


vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.keymap.set("n", "%", function()
      local dir = vim.b.netrw_curdir
      local name = vim.fn.input("New file: ")

      if name == "" then
        return
      end

      local path = dir .. "/" .. name
      local file = io.open(path, "w")

      if file then
        file:close()
        vim.fn["netrw#LocalBrowseCheck"](dir)
      else
        vim.notify("Could not create file: " .. path, vim.log.levels.ERROR)
      end
    end, { buffer = true, silent = true, desc = "Create file without opening it" })
  end,
})

vim.api.nvim_create_user_command("Lex", function()
    local target = vim.api.nvim_get_current_win()

    vim.cmd("Lexplore")

    if vim.api.nvim_win_is_valid(target) then
        vim.g.netrw_chgwin = vim.fn.win_id2win(target)
    end
end, {})


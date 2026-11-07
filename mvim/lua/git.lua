vim.api.nvim_create_user_command("GitDiffHead", function()
  local file = vim.api.nvim_buf_get_name(0)

  if file == "" then
    vim.notify("Current buffer has no file name", vim.log.levels.ERROR)
    return
  end

  local root = vim.fn.systemlist({
    "git", "-C", vim.fn.fnamemodify(file, ":h"),
    "rev-parse", "--show-toplevel"
  })[1]

  if vim.v.shell_error ~= 0 or not root then
    vim.notify("Not inside a Git repository", vim.log.levels.ERROR)
    return
  end

  local rel = vim.fs.relpath(root, file)
  local result = vim.system({
    "git", "-C", root, "show", "HEAD:" .. rel
  }, { text = true }):wait()

  if result.code ~= 0 then
    vim.notify(
      "File does not exist in HEAD (it may be untracked)",
      vim.log.levels.ERROR
    )
    return
  end

  -- Keep the current file in the left window.
  vim.cmd("diffthis")
  vim.cmd("rightbelow vertical new")

  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false,
    vim.split(result.stdout:gsub("\n$", ""), "\n", { plain = true }))

  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].buflisted = false
  vim.bo[buf].swapfile = false
  vim.api.nvim_buf_set_name(buf, "HEAD: " .. rel)

  vim.cmd("diffthis")
end, {})

vim.api.nvim_create_user_command("GitFileHistory", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("Current buffer has no file name", vim.log.levels.ERROR)
    return
  end

  local function git(args)
    return vim.system(args, { text = true }):wait()
  end

  local root_result = git({
    "git", "-C", vim.fn.fnamemodify(file, ":h"),
    "rev-parse", "--show-toplevel"
  })

  if root_result.code ~= 0 then
    vim.notify("Not inside a Git repository", vim.log.levels.ERROR)
    return
  end

  local root = vim.trim(root_result.stdout)
  local rel = vim.fs.relpath(root, file)

  local result = git({
    "git", "-C", root, "log",
    "--follow", "--format=%H%x09%h%x09%s",
    "--", rel
  })

  if result.code ~= 0 or result.stdout == "" then
    vim.notify("No commit history found for this file", vim.log.levels.WARN)
    return
  end

  local commits = {}
  for line in result.stdout:gmatch("[^\r\n]+") do
    local hash, short, subject =
      line:match("^(%S+)\t(%S+)\t(.*)$")
    if hash then
      table.insert(commits, {
        hash = hash,
        short = short,
        subject = subject,
      })
    end
  end

  local history_buf = vim.api.nvim_create_buf(false, true)
  local lines = {}

  for i, c in ipairs(commits) do
    lines[i] = c.short .. "  " .. c.subject
  end

  vim.api.nvim_buf_set_lines(history_buf, 0, -1, false, lines)
  vim.bo[history_buf].buftype = "nofile"
  vim.bo[history_buf].bufhidden = "wipe"
  vim.bo[history_buf].swapfile = false
  vim.bo[history_buf].modifiable = false
  vim.api.nvim_buf_set_name(history_buf, "Git File History")

  vim.cmd("rightbelow vertical sbuffer " .. history_buf)
  vim.api.nvim_win_set_width(0, 45)

  local history_win = vim.api.nvim_get_current_win()
  local source_win = vim.fn.win_getid(vim.fn.winnr("#"))

  local function open_diff()
    local row = vim.api.nvim_win_get_cursor(history_win)[1]
    local commit = commits[row]
    if not commit then return end

    local content = git({
      "git", "-C", root, "show", commit.hash .. ":" .. rel
    })

    if content.code ~= 0 then
      vim.notify("File did not exist in this commit", vim.log.levels.ERROR)
      return
    end

    vim.api.nvim_set_current_win(source_win)
    vim.cmd("diffthis")
    vim.cmd("rightbelow vertical new")

    local diff_buf = vim.api.nvim_get_current_buf()
    local diff_lines = vim.split(
      content.stdout:gsub("\n$", ""), "\n", { plain = true }
    )

    vim.api.nvim_buf_set_lines(diff_buf, 0, -1, false, diff_lines)
    vim.bo[diff_buf].buftype = "nofile"
    vim.bo[diff_buf].bufhidden = "wipe"
    vim.bo[diff_buf].buflisted = false
    vim.bo[diff_buf].swapfile = false
    vim.api.nvim_buf_set_name(
      diff_buf, commit.short .. ": " .. rel
    )
    vim.cmd("diffthis")
  end

  vim.keymap.set("n", "<CR>", open_diff, {
    buffer = history_buf,
    silent = true,
    desc = "Diff current file against selected commit",
  })

  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(history_win, true)
  end, { buffer = history_buf, silent = true })
end, {})

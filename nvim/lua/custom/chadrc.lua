  ---@type ChadrcConfig
  local M = {}

  M.ui = {
    theme = "ayu_dark",
    nvdash = {
      load_on_startup = true,
      header = {
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
      },
    },
  }

  M.plugins = "custom.plugins"
  M.mappings = require "custom.mappings"
  return M

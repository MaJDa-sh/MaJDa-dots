local starter = require("mini.starter")

local logo = [[
               __     __  __               
              /  |   /  |/  |              
 _____  ____  $$ |   $$ |$$/  _____  ____  
/     \/    \ $$ |   $$ |/  |/     \/    \ 
$$$$$$ $$$$  |$$  \ /$$/ $$ |$$$$$$ $$$$  |
$$ | $$ | $$ | $$  /$$/  $$ |$$ | $$ | $$ |
$$ | $$ | $$ |  $$ $$/   $$ |$$ | $$ | $$ |
$$ | $$ | $$ |   $$$/    $$ |$$ | $$ | $$ |
$$/  $$/  $$/     $/     $$/ $$/  $$/  $$/ 
]]

starter.setup({
  evaluate_single = true,
  items = {
    starter.sections.recent_files(5, false),
    starter.sections.recent_files(5, true),
    starter.sections.sessions(5, true),
    { name = "New file", action = "enew", section = "Builtin" },
    { name = "Quit", action = "qall", section = "Builtin" },
  },
  header = logo,
  footer = "",
})

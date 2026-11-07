local function center_lines(lines)
    local width = vim.api.nvim_win_get_width(0)
    local height = vim.api.nvim_win_get_height(0)

    local max_width = 0

    for _, line in ipairs(lines) do
        max_width = math.max(
            max_width,
            vim.fn.strdisplaywidth(line)
        )
    end

    local top_padding = math.max(
        0,
        math.floor((height - #lines) / 2)
    )

    local left_padding = math.max(
        0,
        math.floor((width - max_width) / 2)
    )

    local result = {}

    for _ = 1, top_padding do
        table.insert(result, "")
    end

    for _, line in ipairs(lines) do
        table.insert(
            result,
            string.rep(" ", left_padding) .. line
        )
    end

    return result
end

local function home()
    vim.cmd("enew")

    local buf = vim.api.nvim_get_current_buf()

    -- Scratch buffer settings
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].modifiable = true

    -- Home screen content
    local lines = {
        "         _    _ ",
        " _ __ ___| |  | | _  _ __ ___",
        "| '_ ` _ \\ |  | || || '_ ` _ \\",
        "| | | | | | \\/  || || | | | | |",
        "|_| |_| |_|\\___/ |_||_| |_| |_|",
        "",
        "        Your workspace",
        "",
        "   [n]  New file",
        "   [f]  Find file",
        "   [r]  Recent files",
        "   [q]  Quit",
        "",
        "Press a key to get started",
    }

    vim.api.nvim_buf_set_lines(
        buf, 0, -1, false, center_lines(lines)
    )

    vim.bo[buf].modifiable = false
    vim.bo[buf].filetype = "starter"

    -- Hide editor UI elements
    local win = vim.api.nvim_get_current_win()

    vim.wo[win].signcolumn = "no"
    vim.wo[win].cursorline = false
    vim.wo[win].wrap = false
    vim.wo[win].list = false

    -- Home screen keybindings
    local opts = {
        buffer = buf,
        silent = true,
        nowait = true,
    }

    -- New file
    vim.keymap.set("n", "n", function()
        vim.cmd("enew")
    end, opts)

    -- Find file by path
    vim.keymap.set("n", "f", function()
        vim.ui.input({ prompt = "Find file: " }, function(input)
            if input and input ~= "" then
                vim.cmd("edit " .. vim.fn.fnameescape(input))
            end
        end)
    end, opts)

    -- Recent files
    vim.keymap.set("n", "r", function()
        vim.cmd("browse oldfiles")
    end, opts)

    -- Quit Neovim
    vim.keymap.set("n", "q", function()
        vim.cmd("quit")
    end, opts)

    -- Keep cursor at the top
    vim.api.nvim_win_set_cursor(win, { 1, 0 })
end

-- Show home screen when no file is supplied
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        if vim.fn.argc() == 0
            and vim.api.nvim_buf_get_name(0) == "" then
            home()
        end
    end,
})

-- Recenter home screen when terminal is resized
vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
        local buf = vim.api.nvim_get_current_buf()

        if vim.bo[buf].filetype == "starter" then
            vim.bo[buf].modifiable = true

            local lines = {
                "         _    _ ",
                " _ __ ___| |  | | _  _ __ ___",
                "| '_ ` _ \\ |  | || || '_ ` _ \\",
                "| | | | | | \\/  || || | | | | |",
                "|_| |_| |_|\\___/ |_||_| |_| |_|",
                "",
                "        Your workspace",
                "",
                "   [n]  New file",
                "   [f]  Find file",
                "   [r]  Recent files",
                "   [q]  Quit",
                "",
                "Press a key to get started",
            }

            vim.api.nvim_buf_set_lines(
                buf, 0, -1, false, center_lines(lines)
            )

            vim.bo[buf].modifiable = false
        end
    end,
})

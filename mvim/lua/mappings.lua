vim.g.mapleader = " "

vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
        local opts = { buffer = true, remap = true, silent = true }

        vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
        vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
        vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
        vim.keymap.set("n", "<C-l>", "<C-w>l", opts)
    end,
})

vim.keymap.set("n", "<C-Up>", "<cmd>resize -2<CR>", opts)
vim.keymap.set("n", "<C-Down>", "<cmd>resize +2<CR>", opts)
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", opts)

vim.keymap.set("n", "<C-n>", function()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].filetype == "netrw" then
            vim.api.nvim_win_close(win, true)
            return
        end
    end

    local file = vim.fn.expand("%:p")
    local name = vim.fn.expand("%:t")
    local dir = vim.fn.expand("%:p:h")

    -- 1. Set the local directory so Lex opens at the file's depth
    vim.cmd("lcd " .. vim.fn.fnameescape(dir))

    -- 2. Open the Lexplore window
    vim.cmd("Lex")

    -- 3. TWEAK: Defer the search until the buffer is actually rendered
    vim.defer_fn(function()
        -- We must ensure the cursor is actually in the netrw window
        -- because Lex might not have shifted focus immediately
        local wins = vim.api.nvim_list_wins()
        for _, win in ipairs(wins) do
            if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "netrw" then
                vim.api.nvim_set_current_win(win)
                if name ~= "" then
                    -- Use a literal search for the filename
                    vim.fn.search("\\V" .. vim.fn.escape(name, "\\"))
                end
                break
            end
        end
    end, 50) -- 50ms is usually enough to let Netrw load the file list
end, { desc = "Toggle file explorer" })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
        if vim.fn.win_gettype() == "" then
            vim.cmd("vertical resize 30")
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "netrw",
    callback = function()
        if vim.fn.win_gettype() == "" then
            vim.cmd("vertical resize 30")
        end
    end,
})


vim.keymap.set("n", "<leader>x", "<cmd>bdelete<CR>", opts)
vim.keymap.set("n", "<leader>r", function()
    vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.5))
end, opts)

vim.keymap.set("n", "<leader>m", function()
    vim.cmd("vertical resize " .. 30)
end, opts)


-- hiding highlight search by using esc
vim.api.nvim_set_keymap('i', '<Esc>', '<Esc>:nohlsearch<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Esc>', '<Esc>:nohlsearch<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Esc>', ':nohlsearch<CR><Esc>', { noremap = true, silent = true })

-- Undotree
vim.cmd("packadd nvim.undotree")
vim.keymap.set("n", "<leader>u", function()
  require("undotree").open()
end, { desc = "Open UndoTree" })

-- telescope imitation
vim.keymap.set("n", "<leader>ff", function()
    vim.ui.input({ prompt = "Find files: " }, function(query)
        if query and query ~= "" then
            vim.cmd("Files " .. vim.fn.escape(query, " "))
        end
    end)
end, { desc = "Find files" })

vim.keymap.set("n", "<leader>fw", function()
    vim.ui.input({ prompt = "Find file by content: " }, function(query)
        if query and query ~= "" then
            vim.cmd("Rg " .. vim.fn.escape(query, " "))
        end
    end)
end, { desc = "Find within files" })


-- buffers
vim.keymap.set("n", "<Tab>", "<cmd>bnext<CR>", opts)
vim.keymap.set("n", "<S-Tab>", "<cmd>bprevious<CR>", opts)
vim.keymap.set("n", "<leader>ls", "<cmd>ls<CR>", opts)

vim.keymap.set("n", "<leader>ls", function()
    vim.cmd("ls", {})
    vim.ui.input({ prompt = "pick buffer: " }, function(query)
        if query and query ~= "" then
            vim.cmd("buffer " .. vim.fn.escape(query, " "))
        end
    end)
end, { desc = "Switch buffers" })

-- git functions
vim.keymap.set("n", "<leader>gd", "<cmd>GitDiffHead<CR>", { desc = "Diff this file against HEAD" })
vim.keymap.set("n", "<leader>gf", "<cmd>GitFileHistory<CR>", { desc = "Diff this file against selected commit" })


-- commenting out
vim.keymap.set("n", "<leader>/", "gcc", { remap = true })
vim.keymap.set("v", "<leader>/", "gc", { remap = true })

-- splitting windows

vim.keymap.set("n", "<leader>h", "<cmd>split<CR>", { remap = true })
vim.keymap.set("n", "<leader>v", "<cmd>vnew<CR>", { remap = true })

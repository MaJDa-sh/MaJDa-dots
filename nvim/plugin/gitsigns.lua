local ok, gs = pcall(require, "gitsigns")
if not ok then
	return
end

gs.setup({
	-------------------------
	-- SIGN COLUMN (hunks)
	-------------------------
	signs = {
		add = { text = "│" },
		change = { text = "│" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},

	signcolumn = true,

	-------------------------
	-- VISUAL HIGHLIGHTS
	-------------------------
	numhl = true, -- highlight line numbers of changed lines
	linehl = false, -- keep line background clean (set true if you want stronger effect)

	word_diff = true, -- shows inline word-level changes (very useful)

	-------------------------
	-- ALWAYS-ON BLAME
	-------------------------
	current_line_blame = true,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol", -- end of line
		delay = 200, -- fast response (lower = more “always on” feel)
		ignore_whitespace = false,
	},

	current_line_blame_formatter = " <author> • <author_time:%Y-%m-%d> • <summary>",

	-------------------------
	-- BEHAVIOR
	-------------------------
	attach_to_untracked = true,

	watch_gitdir = {
		follow_files = true,
	},
})

-------------------------
-- OPTIONAL: hunk navigation
-------------------------
vim.keymap.set("n", "]h", gs.next_hunk, { desc = "Next hunk" })
vim.keymap.set("n", "[h", gs.prev_hunk, { desc = "Prev hunk" })

-------------------------
-- HUNK ACTIONS
-------------------------
vim.keymap.set("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>ghs", gs.stage_hunk, { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>ghr", gs.reset_hunk, { desc = "Reset hunk" })

-------------------------
-- BLAME
-------------------------
vim.keymap.set("n", "<leader>gb", gs.toggle_current_line_blame, {
	desc = "Toggle inline blame",
})

vim.keymap.set("n", "<leader>gB", gs.blame_line, {
	desc = "Full blame for line",
})

local lint = require("lint")

-- NOTE: Install linters with Mason
lint.linters_by_ft = {
	python = { "mypy" },
	javascript = { "eslint_d" },
	typescript = { "eslint_d" },
	javascriptreact = { "eslint_d" },
	typescriptreact = { "eslint_d" },
}

local function command_exists(cmd)
	if type(cmd) ~= "string" or cmd == "" then
		return false
	end

	if cmd:find("/") then
		return vim.uv.fs_stat(cmd) ~= nil
	end

	return vim.fn.executable(cmd) == 1
end

local function can_lint(bufnr)
	if vim.bo[bufnr].buftype ~= "" then
		return false
	end

	if vim.api.nvim_buf_get_name(bufnr) == "" then
		return false
	end

	local linters = lint._resolve_linter_by_ft(vim.bo[bufnr].filetype)
	if not linters or vim.tbl_isempty(linters) then
		return false
	end

	for _, linter in ipairs(linters) do
		local linter_def = lint.linters[linter]
		if type(linter_def) == "function" then
			linter_def = linter_def()
		end

		local cmd = linter_def and linter_def.cmd
		if type(cmd) == "function" then
			cmd = cmd()
		end

		if not command_exists(cmd) then
			return false
		end
	end

	return true
end

-- When to trigger lint? I bind it to some events as follows:
--   BufEnter: enter a buffer.
--   BufWritePost: save a buffer.
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
	callback = function(args)
		if not can_lint(args.buf) then
			return
		end

		pcall(lint.try_lint)
	end,
})

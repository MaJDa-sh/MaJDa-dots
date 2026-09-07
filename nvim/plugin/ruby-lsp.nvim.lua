local ok, ruby_lsp = pcall(require, "ruby-lsp")
if not ok then
	return
end

ruby_lsp.setup({
	autodetect_tools = true,
	lspconfig = {
		init_options = {
			formatter = "rubocop",
			linters = { "rubocop" },
		},
	},
})

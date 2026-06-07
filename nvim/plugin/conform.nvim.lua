require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		scss = { "prettier" },
		css = { "prettier" },
		html = { "prettier" },
		json = { "prettier" },
	},
	format_on_save = {
		lsp_fallback = true,
		timeout_ms = 1000,
	},
	formatters = {
		ocamlformat = {
			prepend_args = {
				"--if-then-else",
				"vertical",
				"--break-cases",
				"fit-or-vertical",
				"--type-decl",
				"sparse",
			},
		},
	},
})

vim.lsp.config("clangd", {
	filetypes = { "c" },
	init_options = {
		fallbackFlags = { "-std=c11" },
	},
})

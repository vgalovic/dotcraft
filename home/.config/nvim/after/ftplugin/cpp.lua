vim.lsp.config("clangd", {
	filetypes = { "cpp" },
	init_options = {
		fallbackFlags = { "-std=c++17" },
	},
})

-- Configure clangd for C++ files
vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"--pch-storage=memory",
		"--clang-tidy",
		"--header-insertion=iwyu",
		"--completion-style=detailed",
		"--enable-config",
	},
	init_options = {
		fallbackFlags = { "-std=c++17" },

		compilationDatabaseDirectory = vim.fn.getcwd(),
		clangdFileStatus = true,
		usePlaceholders = true,
		completeUnimported = true,
		semanticHighlighting = true,
	},
	filetypes = { "cpp" },
})

vim.lsp.enable("clangd")

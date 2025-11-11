return {
	cmd = {
		"clangd",
		"--background-index",
		"--pch-storage=memory",
		"--clang-tidy",
		"--header-insertion=iwyu",
		"--completion-style=detailed",
		"--enable-config",
	},
	root_markers = { ".clangd", ".clang-tidy", ".clang-format", "compile_commands.json", ".git" },
	init_options = {
		clangdFileStatus = true,
		usePlaceholders = true,
		completeUnimported = true,
		semanticHighlighting = true,
	},
}

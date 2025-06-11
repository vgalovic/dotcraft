local lspconfig = require("lspconfig")

return function()
	-- Define flags for clangd based on file type
	local clangd_flags = {
		c = {
			"--std=c11", -- Use C11 standard
			"--background-index", -- Build and use a background index
			"--pch-storage=memory", -- Store precompiled headers in memory
			"--clang-tidy", -- Enable clang-tidy for linting
			"--suggest-missing-includes", -- Suggest missing includes
			"--header-insertion=iwyu", -- Include what you use
			"--completion-style=detailed", -- Provide detailed code completions
			"--enable-config", -- Enable clangd configuration
		},
		cpp = {
			"--std=c++17", -- Use C++17 standard
			"--background-index", -- Build and use a background index
			"--pch-storage=memory", -- Store precompiled headers in memory
			"--clang-tidy", -- Enable clang-tidy for linting
			"--suggest-missing-includes", -- Suggest missing includes
			"--header-insertion=iwyu", -- Include what you use
			"--completion-style=detailed", -- Provide detailed code completions
			"--enable-config", -- Enable clangd configuration
		},
	}

	-- Configure the clangd language server
	lspconfig.clangd.setup({
		init_options = {
			compilationDatabaseDirectory = vim.fn.getcwd(), -- Set the current working directory as the compilation database
			clangdFileStatus = true, -- Enable file status updates in clangd
			usePlaceholders = true, -- Use placeholders in code completions
			completeUnimported = true, -- Complete symbols from unimported files
			semanticHighlighting = true, -- Enable semantic highlighting
			fallbackFlags = clangd_flags[vim.bo.filetype] or {}, -- Use flags based on the current file type or empty if not specified

			-- Check for both .clangd and .clang-format
			clangdFile = vim.fn.filereadable(vim.fn.getcwd() .. "/.clangd") == 1 and vim.fn.getcwd() .. "/.clangd" -- Check for .clangd file in the project root
				or vim.fn.expand("~") .. "/.clangd", -- Fall back to .clangd in the home directory

			clangFormatFile = vim.fn.filereadable(vim.fn.getcwd() .. "/.clang-format") == 1
					and vim.fn.getcwd() .. "/.clang-format" -- Check for .clang-format file in the project root
				or vim.fn.expand("~") .. "/.clang-format", -- Fall back to .clang-format in the home directory
		},
		filetypes = { "c", "cpp" },
	})
end

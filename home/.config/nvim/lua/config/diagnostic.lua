vim.diagnostic.config({
	-- [[ Virtual text settings ]]
	virtual_text = {
		source = "if_many", -- Show source if multiple diagnostics exist
		spacing = 2, -- Space between diagnostic and code
		prefix = Icons.diagnostics.prefix, -- Prefix symbol from icons
		current_line = true, -- Show diagnostics only on current line
		format = function(diagnostic) -- Format function for diagnostic message
			local diagnostic_message = {
				[vim.diagnostic.severity.ERROR] = diagnostic.message,
				[vim.diagnostic.severity.WARN] = diagnostic.message,
				[vim.diagnostic.severity.INFO] = diagnostic.message,
				[vim.diagnostic.severity.HINT] = diagnostic.message,
			}
			return diagnostic_message[diagnostic.severity]
		end,
	},

	-- [[ Sign column symbols and highlighting ]]
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = Icons.diagnostics.error,
			[vim.diagnostic.severity.WARN] = Icons.diagnostics.warn,
			[vim.diagnostic.severity.INFO] = Icons.diagnostics.info,
			[vim.diagnostic.severity.HINT] = Icons.diagnostics.hint,
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg", -- Line number highlight for errors
			[vim.diagnostic.severity.WARN] = "WarningMsg", -- Line number highlight for warnings
		},
	},

	-- [[ Sorting and display behavior ]]
	severity_sort = true, -- Sort diagnostics by severity
	float = {
		border = "rounded", -- Rounded borders in floating windows
		source = "if_many", -- Show source if there are many
	},
	underline = {
		severity = vim.diagnostic.severity.ERROR, -- Only underline errors
	},
	update_in_insert = false, -- Don't update diagnostics while typing
})

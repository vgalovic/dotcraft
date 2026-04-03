---@diagnostic disable: undefined-global

-- =============================================================================================
-- Diagnostic configuration (LSP errors, warnings, hints, etc.)
-- =============================================================================================

local Icons = require("config.icons")

vim.diagnostic.config({

	-- [[ Virtual text (inline diagnostics) ]]
	virtual_text = {
		source = "if_many", -- Show source only if multiple diagnostics
		spacing = 2, -- Space between code and diagnostic text
		prefix = Icons.diagnostics.prefix, -- Custom prefix icon
		current_line = true, -- Show only on current line

		-- Format how diagnostic message is displayed
		format = function(diagnostic)
			local diagnostic_message = {
				[vim.diagnostic.severity.ERROR] = diagnostic.message,
				[vim.diagnostic.severity.WARN] = diagnostic.message,
				[vim.diagnostic.severity.INFO] = diagnostic.message,
				[vim.diagnostic.severity.HINT] = diagnostic.message,
			}
			return diagnostic_message[diagnostic.severity]
		end,
	},

	-- [[ Signs (gutter icons on the left) ]]
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = Icons.diagnostics.error,
			[vim.diagnostic.severity.WARN] = Icons.diagnostics.warn,
			[vim.diagnostic.severity.INFO] = Icons.diagnostics.info,
			[vim.diagnostic.severity.HINT] = Icons.diagnostics.hint,
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg", -- Highlight line number for errors
			[vim.diagnostic.severity.WARN] = "WarningMsg", -- Highlight line number for warnings
		},
	},

	-- [[ Sorting & behavior ]]
	severity_sort = true, -- Higher severity first

	-- [[ Floating window (hover diagnostics) ]]
	float = {
		border = "rounded",
		source = "if_many",
	},

	-- [[ Underline ]]
	underline = {
		severity = vim.diagnostic.severity.ERROR, -- Only underline errors
	},

	-- [[ Performance ]]
	update_in_insert = false, -- Don't update while typing
})

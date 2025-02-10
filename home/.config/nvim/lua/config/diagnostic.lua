-- Diagnostics configuration
vim.diagnostic.config({
	virtual_text = {
		spacing = 2,
		severity_sort = true,
		hl_mode = "combine",
		virt_text_pos = "eol",
		prefix = function(diagnostic)
			local symbols = {
				[vim.diagnostic.severity.ERROR] = " ", -- Error
				[vim.diagnostic.severity.WARN] = " ", -- Warning
				[vim.diagnostic.severity.INFO] = " ", -- Info
				[vim.diagnostic.severity.HINT] = " ", -- Hint
			}
			return symbols[diagnostic.severity] or "● " -- Default symbol
		end,
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "", -- " ",
			[vim.diagnostic.severity.WARN] = "", --" ",
			[vim.diagnostic.severity.INFO] = "", --" ",
			[vim.diagnostic.severity.HINT] = "", --" ",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
			[vim.diagnostic.severity.WARN] = "WarningMsg",
		},
	},
	underline = true,
	update_in_insert = false,
})

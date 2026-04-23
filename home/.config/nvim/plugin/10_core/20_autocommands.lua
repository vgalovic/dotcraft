-- =========================================================
-- BASIC AUTOCOMMANDS
-- =========================================================

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- =========================================================
-- CREATE LOG FILETYPE
-- =========================================================

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.log",
	callback = function()
		vim.bo.filetype = "log"
	end,
})

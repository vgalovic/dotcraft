-- =========================================================
-- Filetype / Plugin Loader
-- =========================================================

---@diagnostic disable: undefined-global

-- =========================================================
-- Log Files
-- =========================================================
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.log",
	callback = function()
		vim.bo.filetype = "log"
	end,
})

Config.on_filetype("log", function()
	vim.pack.add({ Repo.gh("mtdl9/vim-log-highlighting") })
end)

-- =========================================================
-- Kitty Terminal Files
-- =========================================================
Config.on_filetype("kitty", function()
	vim.pack.add({ Repo.gh("fladson/vim-kitty") })
end)

-- =========================================================
-- Markdown / LaTeX Files
-- =========================================================
Config.on_filetype({ "markdown", "markdown_inline", "latex" }, function()
	vim.pack.add({ Repo.gh("OXY2DEV/markview.nvim") })

	local presets = require("markview.presets")

	require("markview").setup({
		markdown = {
			headings = presets.headings.marker,
			tables = presets.tables.rounded,
		},
	})

	Map.map("<leader>m", "<cmd>Markview toggle<cr>", "Toggle Markview")
end)

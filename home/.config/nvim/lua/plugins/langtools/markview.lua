return {
	"OXY2DEV/markview.nvim",
	-- lazy = false,
	ft = { "markdown", "markdown_inline", "latex" },

	config = function()
		local presets = require("markview.presets")

		require("markview").setup({
			markdown = {
				headings = presets.headings.marker,
				tables = presets.tables.rounded,
			},
			latex = {
				inlines = {
					padding_left = "",
					padding_right = "",
				},
			},
		})
		vim.keymap.set(
			"n",
			"<leader>tm",
			"<cmd>Markview toggle<cr>",
			{ noremap = true, silent = true, desc = "Toggle Markview" }
		)
	end,
}

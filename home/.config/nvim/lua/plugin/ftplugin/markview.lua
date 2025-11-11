---@diagnostic disable: missing-fields

return {
	"OXY2DEV/markview.nvim",
	-- lazy = false,
	ft = { "markdown", "markdown_inline", "latex" },
	keys = { { "<leader>m", ft = "markdown", "<cmd>Markview toggle<cr>", desc = "Toggle Markview" } },

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
	end,
}

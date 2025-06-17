return {
	"OXY2DEV/markview.nvim",
	-- lazy = false,
	ft = { "markdown", "markdown_inline", "latex" },
	keys = { { "<leader>mm", ft = "markdown", "<cmd>Markview toggle<cr>", desc = "Toggle Markview" } },

	config = function()
		local presets = require("markview.presets")

		require("home.config.nvim.lua.plugin.ftplugin.markview").setup({
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

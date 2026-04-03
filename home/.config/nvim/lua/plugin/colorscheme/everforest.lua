-- THEMES_AVAILABLE:
-- everforest
return {
	"neanias/everforest-nvim",
	version = false,
	enabled = vim.g.colorscheme == "everforest",
	lazy = false,
	priority = 1000,
	config = function()
		require("everforest").setup({
			background = "hard",
			transparent_background_level = 0,
			italics = true,
			disable_italic_comments = false,
			inlay_hints_background = "dimmed",
		})
	end,
}

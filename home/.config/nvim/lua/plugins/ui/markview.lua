return {
	"OXY2DEV/markview.nvim",
	-- lazy = false, -- Recommended
	ft = { "markdown" }, -- If you decide to lazy-load anyway

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("markview.extras.headings").setup()
		require("markview.extras.editor").setup()
	end,
}

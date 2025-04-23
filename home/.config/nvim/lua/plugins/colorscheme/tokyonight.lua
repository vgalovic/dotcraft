return {
	"folke/tokyonight.nvim",
	enabled = vim.g.colorscheme == "tokyonight",
	lazy = false,
	priority = 1000,
	opts = {
		style = "moon",
		light_style = "day",
	},
}

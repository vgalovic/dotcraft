return {
	"bluz71/vim-moonfly-colors",
	name = "moonfly",
	enabled = vim.g.colorscheme == "moonfly",
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.moonflyVirtualTextColor = true
	end,
}

-- THEMES_AVAILABLE:
-- moonfly
return {
	"bluz71/vim-moonfly-colors",
	name = "moonfly",
	enabled = vim.g.colorscheme == "moonfly",
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.moonflyCursorColor = true
		vim.g.moonflyVirtualTextColor = true
		vim.g.moonflyNormalFloat = true
		vim.g.moonflyWinSeparator = 2
	end,
}

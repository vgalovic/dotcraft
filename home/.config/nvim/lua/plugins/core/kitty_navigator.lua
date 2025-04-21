return {
	"knubie/vim-kitty-navigator",
	keys = {
		{ "<C-h>", "<cmd>KittyNavigateLeft<cr>", mode = { "n", "t" }, desc = "Move to panel Left" },
		{ "<C-j>", "<cmd>KittyNavigateDown<cr>", mode = { "n", "t" }, desc = "Move to panel Downd" },
		{ "<C-k>", "<cmd>KittyNavigateUp<cr>", mode = { "n", "t" }, desc = "Move to panel Up" },
		{ "<C-l>", "<cmd>KittyNavigateRight<cr>", mode = { "n", "t" }, desc = "Move to panel Right" },
	},
	build = {
		"mkdir -p ~/.config/kitty/kitty_navigator",
		"cp ./*.py ~/.config/kitty/kitty_navigator",
	},
	config = function()
		vim.g.kitty_navigator_no_mappings = 1
	end,
}

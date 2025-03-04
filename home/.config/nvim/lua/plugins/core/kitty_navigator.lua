return {
	"knubie/vim-kitty-navigator",
	build = {
		"mkdir -p ~/.config/kitty/kitty_navigator",
		"cp ./*.py ~/.config/kitty/kitty_navigator",
	},
	config = function()
		vim.g.kitty_navigator_no_mappings = 1
		vim.keymap.set("n", "<C-h>", ":KittyNavigateLeft<cr>", { silent = true })
		vim.keymap.set("n", "<C-j>", ":KittyNavigateDown<cr>", { silent = true })
		vim.keymap.set("n", "<C-k>", ":KittyNavigateUp<cr>", { silent = true })
		vim.keymap.set("n", "<C-l>", ":KittyNavigateRight<cr>", { silent = true })
	end,
}

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	requires = {
		{ "nvim-tree/nvim-web-devicons" },
	},
	opts = {
		dashboard = { example = "advanced" },
		bigfile = { enabled = true },
		indent = { enabled = true },
		scroll = { enabled = true },
		scope = { enabled = true },
		input = { enabled = true },
		notifier = {
			enabled = true,
			style = "compact", -- "compact" "fancy" "minimal"
			top_down = false,

			lsp_utils = require("config/autocommands").setup_lsp_progress(),
		},
		lazygit = { configure = false },
		quickfile = { enabled = true },
		statuscolumn = {
			enabled = true,
			left = { "mark", "sign" },
			right = { "fold", "git" },
			folds = {
				open = false,
				git_hl = true,
			},
			git = {
				patterns = { "MiniDiffSign" },
			},
			refresh = 50,
		},
		words = {
			enabled = true,
			notify_jump = true,
		},
	},
}

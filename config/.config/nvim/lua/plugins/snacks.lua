return {
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		requires = {
			{ "nvim-tree/nvim-web-devicons" },
		},
		opts = {
			dashboard = {
				example = "advanced",
			},
			bigfile = { enabled = true },
			indent = { enabled = true },
			scroll = { enabled = true },
			notifier = {
				enabled = true,
				style = "fancy", -- "compact" "fancy" "minimal"
				top_down = true,

				lsp_utils = require("config/autocommand").setup_lsp_progress(),
			},
			lazygit = {
				configure = false,
			},
			quickfile = { enabled = true },
			statuscolumn = { enabled = true },
			words = {
				enabled = true,
				notify_jump = true,
			},
		},
	},
}

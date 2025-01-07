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
			scope = { enabled = false },
			input = { enabled = false },
			notifier = {
				enabled = true,
				style = "compact", -- "compact" "fancy" "minimal"
				top_down = false,

				lsp_utils = require("config/autocommands").setup_lsp_progress(),
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

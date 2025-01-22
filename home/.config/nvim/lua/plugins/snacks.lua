return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	requires = {
		{ "nvim-tree/nvim-web-devicons" },
	},
	opts = {
		dashboard = {
			preset = {
				header = require("utils.week").print_day_of_week(),
			},
			enable = true,
			width = 72,
			sections = {
				{ section = "header", padding = 2 },

				{
					align = "center",
					padding = 2,
					text = {
						{ "  Update ", hl = "@label" },
						-- { "  Sessions ", hl = "@type" },
						{ "  Config ", hl = "@function" },
						{ "  New File ", hl = "@string" },
						{ "  Files ", hl = "@number" },
						{ "  Recent ", hl = "@property" },
						{ "  Quit", hl = "@error" },
					},
				},
				{ icon = "", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
				{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },

				{ text = "", action = ":Lazy update", key = "u" },
				-- { text = "", section = "session", key = "s" },
				{
					text = "",
					action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
					key = "c",
				},
				{
					text = "",
					action = function()
						vim.cmd("enew")
						require("utils.save_as").SaveAs()
					end,
					key = "n",
				},
				{ text = "", action = ":lua Snacks.dashboard.pick('files')", key = "f" },
				{ text = "", action = ":lua Snacks.dashboard.pick('oldfiles')", key = "r" },
				{ text = "", action = ":qa", key = "q" },

				{ section = "startup", padding = 1 },
			},
		},
		bigfile = { enabled = true },
		indent = { enabled = true },
		scroll = { enabled = true },
		scope = { enabled = true },
		input = { enabled = true },
		picker = {
			enabled = true,
			layout = {
				cycle = true,
				--- Use the default layout or dropdown if the window is too narrow
				--- @default "default"
				--- @options ["default", "dropdown", "ivy", "select", "telescope", "vertical", "vscode"]
				preset = function()
					return vim.o.columns >= 120 and "default" or "dropdown"
				end,
			},
		},
		notifier = {
			enabled = true,
			--- @default "compact"
			--- @options [ "compact", "fancy", "minimal" ]
			style = "compact",
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

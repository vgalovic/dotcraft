---@diagnostic disable: undefined-global
---@diagnostic disable: undefined-field

local header = require("utils.dashboard.random_header").get_random_header()
local random_hls = require("utils.dashboard.random_hl").get_random_hl()
local buffer = require("utils.mapping_actions.buffer")

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,

	opts = {
		bigfile = { enabled = true },
		scroll = { enabled = true },
		input = { enabled = true },
		scope = { enabled = true },
		lazygit = { configure = false },
		quickfile = { enabled = true },

		dashboard = {
			preset = {
				header = header,
			},
			enable = true,
			width = 72,
			sections = {
				{ section = "header", padding = 2 },

				{
					align = "center",
					padding = 2,
					text = {
						{ "  Update ", hl = random_hls[1] },
						-- { "  Sessions ", hl = random_hls[2] },
						{ "  Config ", hl = random_hls[3] },
						{ "  New File ", hl = random_hls[4] },
						{ "  Files ", hl = random_hls[5] },
						{ "  Recent ", hl = random_hls[6] },
						{ "  Quit", hl = random_hls[7] },
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
				-- stylua: ignore
				{ text = "", action = function() buffer.new_file() end, key = "n", },
				{ text = "", action = ":lua Snacks.dashboard.pick('files')", key = "f" },
				{ text = "", action = ":lua Snacks.dashboard.pick('oldfiles')", key = "r" },
				{ text = "", action = ":qa", key = "q" },

				{ section = "startup", padding = 1 },
			},
		},
		indent = {
			scope = {
				hl = {
					"SnacksIndent1",
					"SnacksIndent2",
					"SnacksIndent3",
					"SnacksIndent4",
					"SnacksIndent5",
					"SnacksIndent6",
					"SnacksIndent7",
					"SnacksIndent8",
				},
			},
		},
		picker = {
			enabled = true,
			layout = {
				cycle = true,
				---@comment Use the default layout or dropdown if the window is too narrow
				--- @default "default"
				--- @options ["default", "dropdown", "ivy", "select", "telescope", "vertical", "vscode"]
				preset = function()
					return vim.o.columns >= 120 and "default" or "dropdown"
				end,
			},
		},
		explorer = {
			replace_netrw = true,
		},
		notifier = {
			enabled = true,
			--- @default "compact"
			--- @options [ "compact", "fancy", "minimal" ]
			style = "compact",
			top_down = false,

			-- lsp_utils = require("lsp.autocommands").setup_lsp_progress(),
		},
		statuscolumn = {
			enabled = true,
			left = { "mark", "sign" },
			right = { "fold", "git" },
			folds = {
				open = true,
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
		terminal = {
			win = {
				wo = {
					winbar = "",
				},
			},
		},
	},
}

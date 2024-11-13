--dashboard
return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	lazy = true,
	priority = 1000,
	config = function()
		local db = require("dashboard")
		db.setup({
			theme = "hyper",
			config = {
				week_header = {
					enable = true,
				},
				shortcut = {
					{ desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
					{
						icon = " ",
						icon_hl = "@variable",
						desc = "Files",
						group = "Label",
						action = "Telescope find_files",
						key = "f",
					},
					{
						icon = "",
						desc = " New file",
						group = "Command",
						key = "n",
						action = ":enew",
					},
					{
						icon = "󰠛",
						desc = " quit",
						group = "Command",
						key = "q",
						action = ":quit",
					},
				},
			},
		})
	end,
	dependencies = { { "nvim-tree/nvim-web-devicons" } },
}

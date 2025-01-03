return {
	{
		"folke/noice.nvim",
		lazy = false, -- Load this plugin immediately
		priority = 1000, -- High priority to ensure it loads first
		requires = {
			{ "MunifTanjim/nui.nvim" }, -- UI component library required by noice.nvim
		},
		config = function()
			require("noice").setup({
				notify = {
					enabled = false,
				},
				lsp = {
					signature = {
						enabled = true,
						auto_open = { enabled = true },
					},
					hover = {
						enabled = true,
						silent = true,
						border = "rounded",
					},
					progress = {
						enabled = false, -- Disable LSP progress notifications
					},
				},
				presets = {
					bottom_search = true, -- Use a classic bottom cmdline for search
					command_palette = true, -- Position the cmdline and popupmenu together
					long_message_to_split = true, -- Long messages will be sent to a split
					lsp_doc_border = true, -- Add a border to hover docs and signature help
				},
				command = {
					enable = true,
				},
				routes = {
					{
						filter = {
							event = "lsp",
							kind = "progress",
						},
						opts = { skip = true }, -- Filter out LSP progress events
					},
				},
			})
		end,
	},
}

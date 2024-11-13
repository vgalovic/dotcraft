return {
	{
		"rcarriga/nvim-notify",
		lazy = false, -- Load this plugin immediately
		priority = 1000, -- High priority to ensure it loads first
	},

	{
		"folke/noice.nvim",
		lazy = false, -- Load this plugin immediately
		priority = 1000, -- High priority to ensure it loads first

		requires = {
			{ "MunifTanjim/nui.nvim" }, -- UI component library required by noice.nvim
			{ "rcarriga/nvim-notify" }, -- Optional notification component
		},
		config = function()
			require("noice").setup({
				notify = {
					enabled = true, -- enable notify integration
					background_colour = "#1e1e2e", -- Set the background color for notifications
					history = true,
				},
				lsp = {
					signature = {
						enabled = true,
						auto_open = { enabled = true },
					},
					hover = {
						enabled = true,
						silent = true,
						border = "rounded", -- or "single", "double", etc.
					},
					progress = {
						enabled = true,
						border = "rounded",
						handler = function(msg, level)
							-- Handle the display of progress messages
							vim.notify(msg, level, { timeout = false }) -- You can customize this further
						end,
					},

					-- Override markdown rendering so that cmp and other plugins use Treesitter
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
					},
				},
				-- You can enable a preset for easier configuration
				presets = {
					bottom_search = true, -- Use a classic bottom cmdline for search
					command_palette = true, -- Position the cmdline and popupmenu together
					long_message_to_split = true, -- Long messages will be sent to a split
					lsp_doc_border = true, -- Add a border to hover docs and signature help
				},
				routes = {
					view = "notify",
					filter = { event = "msg_showmode" },
				},
				command = {
					enable = true,
				},
			})
		end,
	},
}

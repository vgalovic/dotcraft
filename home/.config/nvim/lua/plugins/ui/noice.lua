--- @diagnostic disable: missing-fields

return {
	"folke/noice.nvim",
	lazy = false, -- Load this plugin immediately
	priority = 1000, -- High priority to ensure it loads first
	requires = {
		{ "MunifTanjim/nui.nvim" }, -- UI component library required by noice.nvim
	},
	opts = {
		cmdline = {
			enabled = true,
			--- @default "cmdline_popup"
			--- @options ["cmdline_popup", "cmdline"]
			view = "cmdline_popup",
		},
		notify = {
			enabled = true,
		},
		lsp = {
			signature = {
				enabled = true,
				auto_open = { enabled = true },
			},
			hover = {
				enabled = true,
				silent = true,
			},
			progress = {
				enabled = false, -- Disable LSP progress notifications
			},
			override = {
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
			},
		},
		presets = {
			bottom_search = false, -- Use a classic bottom cmdline for search
			command_palette = true, -- Position the cmdline and popupmenu together
			lsp_doc_border = true, -- Add a border to hover docs and signature help
			-- long_message_to_split = true, -- long messages will be sent to a split
		},
		routes = {},
	},
}

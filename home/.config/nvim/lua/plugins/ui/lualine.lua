---@diagnostic disable: undefined-field, deprecated

return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		{ require("mini.icons").mock_nvim_web_devicons() },
		"arkav/lualine-lsp-progress",
	},

	config = function()
		local theme = require("config.editor").get_lualine_theme()

		require("lualine").setup({
			options = {
				theme = theme,
				component_separators = "",
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = { "snacks_dashboard" },
					winbar = {},
				},
			},
			sections = {
				lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "buffers" },
				lualine_x = {
					{
						"lsp_progress",
						timer = { progress_enddelay = 500, spinner = 150, lsp_client_name_enddelay = 1000 },
						spinner_symbols = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
					},
					{
						require("noice").api.statusline.mode.get,
						cond = require("noice").api.statusline.mode.has,
					},
					"searchcount",
					"selectioncount",
					"encoding",
					"fileformat",
				},
				lualine_y = { "progress" },
				lualine_z = {
					{ "location", separator = { right = "" }, left_padding = 2 },
				},
			},
			inactive_sections = {
				lualine_a = { "filename" },
				lualine_b = {},
				lualine_c = {},
				lualine_x = { "encoding", "fileformat" },
				lualine_y = {},
				lualine_z = { "location" },
			},
			tabline = {},
			winbar = {},
			extensions = { "lazy", "mason" },
		})
	end,
}

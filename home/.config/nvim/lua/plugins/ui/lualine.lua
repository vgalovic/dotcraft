return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", opt = true },

	config = function()
		require("lualine").setup({
			options = {
				theme = require("core.editor").get_lualine_theme(),
				component_separators = "",
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = { "snacks_dashboard" },
					winbar = {},
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "buffers" },
				lualine_x = {
					{
						---@diagnostic disable: undefined-field, deprecated
						require("noice").api.statusline.mode.get,
						cond = require("noice").api.statusline.mode.has,
					},
					"filetype",
					"encoding",
					"fileformat",
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_x = { "filetype", "encoding", "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {},
			extensions = {},
		})
	end,
}

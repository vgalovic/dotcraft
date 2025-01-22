return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", opt = true },

	init = function()
		-- Require the custom winbar functions
		local winbar = require("utils.lualine_winbar")

		require("lualine").setup({
			options = {
				theme = "catppuccin",
				component_separators = "",
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = { "snacks_dashboard" },
					winbar = { "snacks_dashboard", "snacks_terminal" },
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
				lualine_c = { winbar.get_file },
				lualine_x = { "filetype", "encoding", "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { winbar.get_relative_path },
				lualine_x = {},
				lualine_y = { winbar.get_time },
				lualine_z = { winbar.get_date },
			},
			extensions = {},
		})
	end,
}

return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons", opt = true },
	init = function()
		require("lualine").setup({
			options = {
				theme = "catppuccin",
				component_separators = "",
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { "buffers" },
				lualine_x = { "filetype", "encoding", "fileformat" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			-- tabline = {
			-- 	lualine_c = { { "filename", file_status = false, newfile_status = true, path = 4 } },
			-- 	lualine_y = { { "datetime", style = "%H:%M" } },
			-- 	lualine_z = { { "datetime", style = "%d.%m.%Y." } },
			-- },
			extensions = { "fugitive" },
		})
	end,
}

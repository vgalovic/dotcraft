---@diagnostic disable: undefined-field, deprecated

return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { { require("mini.icons").mock_nvim_web_devicons() } },

	opts = {
		options = {
			theme = vim.g.colorscheme or "auto",
			component_separators = Icons.statusline.component_separators,
			section_separators = Icons.statusline.section_separators,
			disabled_filetypes = {
				statusline = { "snacks_dashboard", "dashboard" },
				winbar = {},
			},
		},

		sections = {
			lualine_a = {
				{
					"mode",
					icon = Icons.statusline.modeicon,
				},
			},
			lualine_b = {
				{
					"diagnostics",
					symbols = {
						error = Icons.diagnostics.error,
						warn = Icons.diagnostics.warn,
						info = Icons.diagnostics.info,
						hint = Icons.diagnostics.hint,
					},
				},
			},

			lualine_c = {
				{
					"filetype",
					icon_only = true,
					colored = true,
					icon = { align = "left" },
					padding = { left = 1, right = 0 },
				},
				{
					"filename",
					path = 1,
					symbols = {
						modified = Icons.statusline.modified,
						readonly = Icons.statusline.readonly,
						unnamed = " [No Name]",
						newfile = Icons.statusline.newfile,
					},
					padding = { left = 0, right = 1 },
				},
			},
			lualine_x = {
				{
					"lsp_status",
					icon = Icons.lsp.icon,
					symbols = {
						spinner = Icons.lsp.spinner,
						done = Icons.lsp.done,
						separator = " ",
					},
					ignore_lsp = {},
				},
				"encoding",
				{
					"fileformat",
					symbols = {
						unix = Icons.statusline.unix,
						dos = Icons.statusline.dos,
						mac = Icons.statusline.mac,
					},
				},
			},
			lualine_y = {
				{
					"diff",
					symbols = {
						added = Icons.git.status_add,
						modified = Icons.git.status_change,
						removed = Icons.git.status_delete,
					},
				},
				{ "branch", icon = Icons.git.branch },
			},
			lualine_z = {
				"location",
				{
					function()
						return "|"
					end,
					padding = { left = 0, right = 0 },
				},
				{ "progress", padding = { left = 1, right = 2 } },
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
	},
}

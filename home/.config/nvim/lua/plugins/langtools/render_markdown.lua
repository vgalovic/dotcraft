---@diagnostic disable: missing-fields

return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown", "norg", "rmd", "org", "codecompanion" },

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"echasnovski/mini.nvim",
	},

	opts = {
		code = {
			sign = false,
			width = "block",
			right_pad = 1,
		},
		heading = {
			sign = false,
			icons = {},
		},
		checkbox = {
			enabled = true,
		},
		latex = {
			enabled = false,
		},
	},

	config = function(_, opts)
		require("render-markdown").setup(opts)
		require("snacks")
			.toggle({
				name = "Render Markdown",
				get = function()
					return require("render-markdown.state").enabled
				end,
				set = function(enabled)
					local m = require("render-markdown")
					if enabled then
						m.enable()
					else
						m.disable()
					end
				end,
			})
			:map("<leader>tm")
	end,
}

return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown", "latex" }, -- Restrict loading to markdown and latex filetypes
	dependencies = {
		"nvim-treesitter/nvim-treesitter", -- Syntax highlighting and parsing
		"echasnovski/mini.nvim", -- Lightweight utilities
	},
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {}, -- Customize plugin options as needed
}

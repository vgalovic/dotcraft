return {
	-- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	event = "VeryLazy",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			auto_install = true,
			ignore_install = {},
			sync_install = false,
			modules = {},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
				notify_on_error = true,
				disable = {},
			},
			indent = { enable = false },
			fold = { enable = false },
			ensure_installed = {
				"bash",
				"c",
				"cmake",
				"cpp",
				"lua",
				"make",
				"markdown",
				"markdown_inline",
				"regex",
				"rust",
				"verilog",
				"vhdl",
				"vim",
				"vimdoc",
			},
		})
	end,
}

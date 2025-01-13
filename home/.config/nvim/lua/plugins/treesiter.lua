return {
	-- Highlight, edit, and navigate code
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	init = function()
		require("nvim-treesitter.configs").setup({
			auto_install = true,
			ignore_install = {},
			sync_install = false,
			modules = {},
			ensure_installed = {
				"bash",
				"c",
				"cpp",
				"cmake",
				"cuda",
				"csv",
				"doxygen",
				"lua",
				"luadoc",
				"latex",
				"make",
				"markdown",
				"markdown_inline",
				"matlab",
				"query",
				"regex",
				"vim",
				"vimdoc",
				"vhdl",
				"verilog",
			},

			highlight = {
				enable = true, -- Enable highlighting
				additional_vim_regex_highlighting = true,
				notify_on_error = true,
			},
			indent = { enable = false },
		})
	end,
}

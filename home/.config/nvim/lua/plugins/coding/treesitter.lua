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
				"html",
				"lua",
				"luadoc",
				"latex",
				"make",
				"markdown",
				"markdown_inline",
				"matlab",
				"query",
				"typst",
				"python",
				"regex",
				"vim",
				"vimdoc",
				"vhdl",
				"verilog",
				"yaml",
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

return {
	"brianhuster/live-preview.nvim",
	dependencies = { "folke/snacks.nvim" },
	ft = { "markdown", "asciidoc", "html", "svg" },
	keys = {
		{
			"<leader>ls",
			ft = { "markdown", "asciidoc", "html", "svg" },
			"<cmd>LivePreview start<cr>",
			desc = "Live Preview start",
		},
		{
			"<leader>lc",
			ft = { "markdown", "asciidoc", "html", "svg" },
			"<cmd>LivePreview close<cr>",
			desc = "Live Preview close",
		},
	},
}

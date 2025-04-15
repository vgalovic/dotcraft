return {
	"iamcco/markdown-preview.nvim",
	ft = { "markdown" },
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	keys = {
		{ "<leader>mp", ft = "markdown", "<cmd>MarkdownPreviewToggle<cr>", desc = "Toggle Markdown Preview" },
	},
	build = "npm install --global yarn && cd app && yarn install",
	init = function()
		-- Set global variable for filetypes
		vim.g.mkdp_filetypes = { "markdown" }
	end,
}

-- Set keybinding for Markdown preview toggle
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.keymap.set(
			"n",
			"<leader>m",
			"<cmd>MarkdownPreviewToggle<cr>",
			{ noremap = true, silent = true, desc = "Markdown Preview", buffer = true }
		)
	end,
})

return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	build = "npm install --global yarn && cd app && yarn install",
	init = function()
		-- Set global variable for filetypes
		vim.g.mkdp_filetypes = { "markdown" }
	end,
	ft = { "markdown" },
}

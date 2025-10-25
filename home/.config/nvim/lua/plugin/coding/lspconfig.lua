---@diagnostic disable: duplicate-set-field

return {
	"neovim/nvim-lspconfig",
	event = {
		"BufReadPost",
		"BufNewFile",
	},

	dependencies = {
		"saghen/blink.cmp",
	},

	config = function()
		-- Setup LSP autocommands
		require("lsp.autocommands").setup_lsp_autocommands()

		local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview

		function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
			opts = opts or {}
			opts.border = opts.border or "rounded"
			opts.max_height = opts.max_height or 40
			opts.max_width = opts.max_width or 100
			return orig_util_open_floating_preview(contents, syntax, opts, ...)
		end
	end,
}

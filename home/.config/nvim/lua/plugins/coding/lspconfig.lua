---@diagnostic disable: missing-fields, duplicate-set-field

return {
	"neovim/nvim-lspconfig",
	event = {
		"BufReadPost",
		"BufNewFile",
	},

	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"saghen/blink.cmp",
	},

	config = function()
		local lspconfig = require("lspconfig")
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		local servers = require("lsp.ensure_installed").lsp

		-- Setup LSP autocommands (optimized version)
		require("lsp.autocommands").setup_lsp_autocommands()

		-- Configure Mason to ensure servers are installed
		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(servers),
			automatic_installation = false,
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					lspconfig[server_name].setup(server)
				end,
			},
		})

		require("lsp").setup()

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

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"saghen/blink.cmp",
	},

	config = function()
		local lspconfig = require("lspconfig")
		local capabilities = vim.lsp.protocol.make_client_capabilities()

		local servers = require("lsp/ensure_installed").lsp

		require("core.autocommands").setup_lsp_autocommands()

		-- Set up completion for LSP servers using the "blink.cmp" plugin
		for server, config in pairs(servers) do
			-- Merge capabilities with blink.cmp if defined
			config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
			lspconfig[server].setup(config)
		end

		-- Set up LSP server configurations without notifications
		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(servers), -- Ensure LSP servers are installed
			automatic_installation = false, -- Disable automatic installation
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})

		-- Load the LSP configurations
		require("lsp").setup()
	end,
}

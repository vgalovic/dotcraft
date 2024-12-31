return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"saghen/blink.cmp",
	},
	opts = {
		lsp_servers = {
			arduino_language_server = {},
			ast_grep = {},
			bashls = {},
			clangd = {
				-- Default init_options will try to auto-detect compile_commands.json
				init_options = {
					compilationDatabaseDirectory = vim.fn.getcwd(), -- Automatically use the current working directory (project root)
				},
				filetypes = { "c", "cpp", "objc", "objcpp" }, -- Include all relevant filetypes
			},
			cmake = {},
			ltex = {
				settings = {
					ltex = {
						language = { "en", "sr" },
					},
				},
			},
			lua_ls = {
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
					},
				},
			},
			pyright = {},
			ruff = {},
			svlangserver = {},
			svls = {},
			verible = {},
			vhdl_ls = {},
		},

		formatters = {
			beautysh = {},
			latexindent = {},
			stylua = {},
		},
	},

	config = function(_, opts)
		require("config.autocommands").setup_lsp_autocommands()

		local capabilities = vim.lsp.protocol.make_client_capabilities()

		local ensure_installed = vim.tbl_keys(opts.lsp_servers)
		vim.list_extend(ensure_installed, opts.formatters)

		local lspconfig = require("lspconfig")
		for server, config in pairs(opts.lsp_servers) do
			-- passing config.capabilities to blink.cmp merges with the capabilities in your
			-- `opts[server].capabilities, if you've defined it
			config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
			lspconfig[server].setup(config)
		end

		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		-- LSP server setup without notifications
		require("mason-lspconfig").setup({
			ensure_installed = {},
			automatic_installation = false,

			handlers = {
				function(server_name)
					local server = opts.lsp_servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}

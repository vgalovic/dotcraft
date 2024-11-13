return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		require("config.autocommand").setup_lsp_autocommands()

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		local servers = {
			-- asmfmt = {},
			arduino_language_server = {},
			ast_grep = {},
			beautysh = {},
			checkmake = {},
			cmake = {},
			svlangserver = {},
			svls = {},
			verible = {},
			vhdl_ls = {},
			pyright = {},
			ruff = {},
			latexindent = {},
			clangd = {
				-- Default init_options will try to auto-detect compile_commands.json
				init_options = {
					compilationDatabaseDirectory = vim.fn.getcwd(), -- Automatically use the current working directory (project root)
				},
				filetypes = { "c", "cpp", "objc", "objcpp" }, -- Include all relevant filetypes
			},
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
		}

		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"bash-language-server",
			"stylua",
			-- "asm-lsp",
			"clang-format",
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		-- LSP server setup without notifications
		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}

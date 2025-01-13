return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"saghen/blink.cmp",
	},

	opts = {
		lsp = {
			arduino_language_server = {},
			bashls = {},
			clangd = {
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
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
						diagnostics = {
							disable = { "missing-fields" },
						},
					},
				},
			},
			pyright = {},
			ruff = {},
			svlangserver = {},
			verible = {},
			vhdl_ls = {},
		},

		mason_extras = {
			--
			-- [[ Linters ]]
			--
			trivy = {},
			vsg = {},
			--
			-- [[ Formaters ]]
			--
			beautysh = {},
			["clang-format"] = {},
			latexindent = {},
			stylua = {},
		},
	},

	config = function(_, opts)
		require("config.autocommands").setup_lsp_autocommands()

		local capabilities = vim.lsp.protocol.make_client_capabilities()

		local ensure_installed = vim.tbl_keys(opts.lsp)
		for extra_key, _ in pairs(opts.mason_extras) do
			table.insert(ensure_installed, extra_key)
		end
		print("Ensure installed: " .. vim.inspect(ensure_installed))

		local lspconfig = require("lspconfig")
		for server, config in pairs(opts.lsp) do
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
					local server = opts.lsp[server_name] or {}
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}

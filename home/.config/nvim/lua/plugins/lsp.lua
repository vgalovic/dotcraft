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
			clangd = {},
			cmake = {},
			ltex = {
				settings = {
					ltex = { language = { "en", "sr" } },
				},
			},
			lua_ls = {
				settings = {
					Lua = {
						completion = { callSnippet = "Replace" }, -- Replace function snippets on call
						workspace = { checkThirdParty = false }, -- Disable third-party library checks
						telemetry = { enable = false }, -- Disable telemetry data collection
						diagnostics = { disable = { "missing-fields" } }, -- Disable "missing-fields" warnings
					},
				},
			},
			pyright = {},
			ruff = {},
			svlangserver = {},
			verible = {},
			vhdl_ls = {},
		},
		--
		-- NOTE: Linters are configured in `lua/plugins/lint.lua` and utilized by the "mfussenegger/nvim-lint" plugin.
		--
		linters = {
			trivy = {},
			vsg = {},
		},
		--
		-- NOTE: Formatters are configured in `lua/plugins/conform.lua` and utilized by the "stevearc/conform.nvim" plugin.
		--
		formatters = {
			beautysh = {},
			latexindent = {},
			stylua = {},
		},
	},

	config = function(_, opts)
		local lspconfig = require("lspconfig")
		local capabilities = vim.lsp.protocol.make_client_capabilities()

		require("config.autocommands").setup_lsp_autocommands()

		-- Generate a combined list of tools to ensure they are installed
		local ensure_installed = vim.tbl_keys(opts.lsp) -- Start with keys from LSP configurations

		-- Add keys from linters and formatters to the ensure_installed list
		for _, group in ipairs({ opts.linters, opts.formatters }) do
			vim.list_extend(ensure_installed, vim.tbl_keys(group))
		end

		-- NOTE: Sets up completion for LSP servers using the "blink.cmp" plugin, configured in `lua/plugins/bling_cmp.lua`
		for server, config in pairs(opts.lsp) do
			-- passing config.capabilities to blink.cmp merges with the capabilities in your
			-- opts[server].capabilities, if you've defined it
			config.capabilities = require("blink.cmp").get_lsp_capabilities(config.capabilities)
			lspconfig[server].setup(config)
		end

		-- Installs the LSPs, linters, and formatters specified in `opts`
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

		-- Define flags for clangd based on file type
		local clangd_flags = {
			c = {
				"--std=c11", -- Use C11 standard
				"--background-index", -- Build and use a background index
				"--pch-storage=memory", -- Store precompiled headers in memory
				"--clang-tidy", -- Enable clang-tidy for linting
				"--suggest-missing-includes", -- Suggest missing includes
				"--header-insertion=iwyu", -- Include what you use
				"--completion-style=detailed", -- Provide detailed code completions
				"--enable-config", -- Enable clangd configuration
			},
			cpp = {
				"--std=c++17", -- Use C++17 standard
				"--background-index", -- Build and use a background index
				"--pch-storage=memory", -- Store precompiled headers in memory
				"--clang-tidy", -- Enable clang-tidy for linting
				"--suggest-missing-includes", -- Suggest missing includes
				"--header-insertion=iwyu", -- Include what you use
				"--completion-style=detailed", -- Provide detailed code completions
				"--enable-config", -- Enable clangd configuration
			},
		}

		-- Configure the clangd language server
		lspconfig.clangd.setup({
			init_options = {
				compilationDatabaseDirectory = vim.fn.getcwd(), -- Set the current working directory as the compilation database
				clangdFileStatus = true, -- Enable file status updates in clangd
				usePlaceholders = true, -- Use placeholders in code completions
				completeUnimported = true, -- Complete symbols from unimported files
				semanticHighlighting = true, -- Enable semantic highlighting
				fallbackFlags = clangd_flags[vim.bo.filetype] -- Use flags based on the current file type or empty if not specified
					or {},
				clangdFile = vim.fn.filereadable(vim.fn.getcwd() .. "/.clang-format") == 1
						and vim.fn.getcwd() .. "/.clang-format" -- Use .clang-format in the current directory if it exists
					or vim.fn.expand("~") .. "/.clang-format", -- Otherwise, fallback to .clang-format in the home directory
			},
			filetypes = { "c", "cpp" },
		})
	end,
}

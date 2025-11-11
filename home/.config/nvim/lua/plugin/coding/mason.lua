return {
	{
		"mason-org/mason.nvim",
		keys = {
			{ "<leader>pm", "<cmd>Mason<cr>", desc = "Mason" },
		},
		opts = {
			ui = {
				icons = {
					package_installed = Icons.mason.package_installed,
					package_pending = Icons.mason.package_pending,
					package_uninstalled = Icons.mason.package_uninstalled,
				},
			},
		},
	},

	-- Mason + LSP config
	{
		"mason-org/mason-lspconfig.nvim",
		event = "VeryLazy",
		dependencies = {
			"mason-org/mason.nvim",
			{
				"neovim/nvim-lspconfig",

				config = function()
					local lsp_utils = require("utils.lsp")
					lsp_utils.setup_lsp_autocommands()
					lsp_utils.setup_floating_preview()
				end,
			},
		},
		opts = {
			ensure_installed = {
				"arduino_language_server",
				-- "asm_lsp",
				"bashls",
				"clangd",
				"cmake",
				"lua_ls",
				"pyright",
				"ruff",
				-- "rust_analyzer", -- install with rustup component add rust-analyzer
				"vhdl_ls",
				"svlangserver",
				"verible",
			},
		},
	},

	-- Mason installer for formatters/linters
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		event = "VeryLazy",
		build = ":MasonUpdate",
		opts = {
			ensure_installed = {
				-- "asmfmt",
				"beautysh",
				"latexindent",
				-- "mdformat", -- install it with pipx install mdformat && pipx inject mdformat mdformat-myst
				-- "rustfmt", -- install with rustup component add rustfmt
				"stylua",
			},
		},
		dependencies = {
			"mason-org/mason.nvim",
		},
	},
}

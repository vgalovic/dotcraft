local servers = {
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
}

local formaters = {
	-- "asmfmt",
	"beautysh",
	"latexindent",
	-- "mdformat", -- install it with pipx install mdformat && pipx inject mdformat mdformat-myst
	-- "rustfmt", -- install with rustup component add rustfmt
	"stylua",
}

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

	-- Mason installer
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		event = "VeryLazy",
		build = ":MasonUpdate",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = vim.list_extend(servers, formaters),
		},
	},

	-- LSP config
	{
		"mason-org/mason-lspconfig.nvim",
		event = "VeryLazy",
		dependencies = {
			{ "mason-org/mason.nvim" },
			{
				"neovim/nvim-lspconfig",

				config = function()
					local lsp_utils = require("utils.lsp")
					lsp_utils.setup_lsp_autocommands()
					lsp_utils.setup_floating_preview()

					vim.lsp.enable("rust_analyzer") -- added because rust_analyzer is not installed via Mason
				end,
			},
		},
		opts = {
			ensure_installed = {},
			automatic_enable = servers,
		},
	},
}

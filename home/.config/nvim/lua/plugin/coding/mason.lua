return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	event = "VeryLazy",
	build = ":MasonUpdate",
	dependencies = {
		{ "mason-org/mason-lspconfig.nvim" },
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
	},
	opts = {
		ensure_installed = {
			"arduino_language_server",
			-- "asm_lsp",
			-- "asmfmt",
			"bashls",
			"beautysh",
			"clangd",
			"cmake",
			"latexindent",
			"ltex",
			"lua_ls",
			-- "mdformat", -- install it with `pipx install mdformat && pipx inject mdformat mdformat-myst`
			"marksman",
			"pyright",
			"ruff",
			"rust_analyzer",
			-- "rustfmt", -- install with `rustup component add rustfmt`
			"stylua",
			"svlangserver",
			"verible",
			"vhdl_ls",
		},
	},
}

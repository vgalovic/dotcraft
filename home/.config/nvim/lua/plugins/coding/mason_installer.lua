return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	event = "VeryLazy",
	build = ":MasonUpdate",
	cmd = { "Mason", "MasonUpdate", "MasonInstall" },
	keys = {
		{ "<leader>pm", "<cmd>Mason<cr>", desc = "Mason" },
	},
	dependencies = {
		"williamboman/mason.nvim",
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
	config = function()
		local mason_tool_installer = require("mason-tool-installer")
		local ensure_installed = require("lsp/ensure_installed")

		-- Combine all tools (LSP, linters, and formatters) into one list and get the keys only
		local all_tools =
			vim.tbl_deep_extend("force", {}, ensure_installed.lsp, ensure_installed.linters, ensure_installed.formatter)

		-- Setup mason-tool-installer with the combined tool list
		mason_tool_installer.setup({
			ensure_installed = vim.tbl_keys(all_tools), -- Get the list of tool names directly
		})
	end,
}

return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = { "williamboman/mason.nvim", config = true },
	config = function()
		local mason_tool_installer = require("mason-tool-installer")
		local ensure_installed = require("lsp/ensure_installed")

		-- Combine all tools into one list to install
		local all_tools =
			vim.tbl_deep_extend("force", {}, ensure_installed.lsp, ensure_installed.linter, ensure_installed.formatter)

		-- Ensure all tools are installed using mason-tool-installer
		mason_tool_installer.setup({
			ensure_installed = vim.tbl_keys(all_tools), -- Automatically get the list of tools
			auto_update = true,
			run_on_start = true,
		})
	end,
}

return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	dependencies = { "williamboman/mason.nvim", config = true },
	config = function()
		local mason_tool_installer = require("mason-tool-installer")
		local ensure_installed = require("lsp/ensure_installed")

		-- Combine all tools (LSP, linters, and formatters) into one list and get the keys only
		local all_tools = vim.tbl_deep_extend("force", {}, ensure_installed.lsp, ensure_installed.formatter)

		-- Setup mason-tool-installer with the combined tool list
		mason_tool_installer.setup({
			ensure_installed = vim.tbl_keys(all_tools), -- Get the list of tool names directly
		})

		vim.keymap.set("n", "<leader>pm", "<cmd>Mason<cr>", { noremap = true, silent = true, desc = "Mason" })
	end,
}

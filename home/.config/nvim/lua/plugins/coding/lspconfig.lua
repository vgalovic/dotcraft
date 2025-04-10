---@diagnostic disable: missing-fields

return {
	"neovim/nvim-lspconfig",
	event = {
		"BufReadPre",
		"BufNewFile",
	},

	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"saghen/blink.cmp",
	},

	config = function()
		local lspconfig = require("lspconfig")
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		local servers = require("lsp.ensure_installed").lsp

		-- Setup LSP autocommands (optimized version)
		require("lsp.autocommands").setup_lsp_autocommands()

		-- Configure Mason to ensure servers are installed
		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(servers),
			automatic_installation = false,
		})

		require("mason-lspconfig").setup_handlers({
			function(server_name)
				if server_name == "rust_analyzer" then
					return
				end

				local server = servers[server_name] or {}
				server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
				lspconfig[server_name].setup(server)
			end,
		})
		require("lsp").setup()
	end,

	setup_lsp_keymaps = function(bufnr)
		local map = vim.keymap.set
		local snacks = require("snacks")

		local function lsp_map(keys, func, desc, mode)
			mode = mode or "n"
			map(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
		end

		-- Use `snacks` for LSP navigation
		-- stylua: ignore start
		lsp_map("gd", function() snacks.picker.lsp_definitions() end, "Goto Definition")
		lsp_map("gy", function() snacks.picker.lsp_type_definitions() end, "Type Definition")
		lsp_map("gR", function() snacks.picker.lsp_references() end, "Goto References")
		lsp_map("gI", function() snacks.picker.lsp_implementations() end, "Goto Implementation")
		lsp_map("gD", vim.lsp.buf.declaration, "Goto Declaration")
		lsp_map("<leader>cs", function() snacks.picker.lsp_symbols() end, "Document Symbols")
		lsp_map("<leader>cw", function() snacks.picker.lsp_symbols({ cwd = vim.fn.expand("%:p:h") }) end, "Workspace Symbols")
		lsp_map("<leader>cc", vim.lsp.buf.code_action, "Code Action", { "n", "x" })
		lsp_map("K", vim.lsp.buf.hover, "Buffer hover")
		lsp_map("<backspace>", vim.lsp.buf.rename, "Rename")
		-- stylua: ignore end
	end,
}

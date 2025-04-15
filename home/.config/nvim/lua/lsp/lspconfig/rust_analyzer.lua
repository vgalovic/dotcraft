local lspconfig = require("lspconfig")

return function()
	lspconfig.rust_analyzer.setup({
		on_attach = function(client, bufnr)
			vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
		end,
		settings = {
			["rust-analyzer"] = {
				checkOnSave = {
					command = "clippy",
				},
			},
		},
	})
end

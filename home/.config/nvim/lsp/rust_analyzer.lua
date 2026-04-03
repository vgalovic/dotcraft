return {
	on_attach = function(client, bufnr)
		-- Enable inlay hints for this buffer
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end,
	settings = {
		["rust-analyzer"] = {
			check = {
				command = "clippy", -- run `cargo clippy` on save
			},
		},
	},
	filetypes = { "rust" },
}

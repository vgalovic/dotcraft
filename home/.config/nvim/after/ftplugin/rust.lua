-- ~/.config/nvim/after/ftplugin/rust.lua

-- Define the config for rust-analyzer
vim.lsp.config("rust_analyzer", {
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
})

-- Enable the server (only when editing Rust files)
vim.lsp.enable("rust_analyzer")

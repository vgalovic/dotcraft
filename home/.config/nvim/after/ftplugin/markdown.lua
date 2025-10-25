-- Define / override the config for ltex
vim.lsp.config("ltex", {
	settings = {
		ltex = {
			language = "en",
			dictionary = {
				["en"] = { "Dotcraft", "dotfiles", "Vivado" },
			},
		},
	},
})

-- Enable the server (so it auto-starts for relevant buffers)
vim.lsp.enable("ltex")

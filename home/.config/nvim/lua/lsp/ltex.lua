local lspconfig = require("lspconfig")

return function()
	-- Configure the ltex language server
	lspconfig.ltex.setup({
		settings = {
			ltex = {
				language = "en",
				dictionary = {
					["en"] = { "Dotcraft", "dotfiles", "Vivado" },
				},
			},
		},
	})
end

local lspconfig = require("lspconfig")

return function()
	-- Configure the lua language server
	lspconfig.lua_ls.setup({
		settings = {
			Lua = {
				completion = { callSnippet = "Replace" }, -- Replace function snippets on call
				workspace = { checkThirdParty = false }, -- Disable third-party library checks
				telemetry = { enable = false }, -- Disable telemetry data collection
				diagnostics = { disable = { "missing-fields" } }, -- Disable "missing-fields" warnings
			},
		},
	})
end

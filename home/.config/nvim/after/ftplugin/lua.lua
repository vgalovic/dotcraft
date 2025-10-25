-- Define / override config for lua_ls
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			completion = { callSnippet = "Replace" }, -- Replace function snippets on call
			workspace = { checkThirdParty = false }, -- Disable third-party library checks
			telemetry = { enable = false }, -- Disable telemetry data collection
		},
	},
})

-- Enable the server (so it actually runs)
vim.lsp.enable("lua_ls")

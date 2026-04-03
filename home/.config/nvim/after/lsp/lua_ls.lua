return {
	-- Function called when LSP attaches to a buffer
	on_attach = function(client, buf_id)
		-- Reduce very long list of triggers for better 'mini.completion' experience
		client.server_capabilities.completionProvider.triggerCharacters = { ".", ":", "#", "(" }

		-- Define buffer-local mappings or behavior depending on attached client here
	end,

	-- Settings for the Lua language server
	settings = {
		Lua = {
			-- Runtime settings: use LuaJIT bundled with Neovim
			runtime = {
				version = "LuaJIT",
				path = vim.split(package.path, ";"),
			},

			-- Workspace settings
			workspace = {
				ignoreSubmodules = true, -- Don't analyze submodules
				library = { vim.env.VIMRUNTIME }, -- Include Neovim runtime files
				checkThirdParty = false, -- Disable third-party library checks
			},

			-- Completion settings
			completion = {
				callSnippet = "Replace", -- Replace function snippets on call
			},

			-- Telemetry
			telemetry = {
				enable = false, -- Disable telemetry data collection
			},
		},
	},
}

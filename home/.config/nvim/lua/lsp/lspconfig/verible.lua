local lspconfig = require("lspconfig")

return function()
	lspconfig.verible.setup({
		cmd = { "verible-verilog-ls", "--rules_config_search" },
	})
end

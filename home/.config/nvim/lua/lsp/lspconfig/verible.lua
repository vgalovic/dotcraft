local lspconfig = require("lspconfig")

return function()
	lspconfig.verible.setup({
		cmd = { "verible-verilog-ls", "--rules_config_search" },
		filetypes = { "verilog", "systemverilog" },
		root_dir = require("lspconfig.util").root_pattern(".git", ".rules.verible_lint"),
		single_file_support = true,
	})
end

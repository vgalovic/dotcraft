-- Configure Verible language server for Verilog/SystemVerilog
vim.lsp.config("verible", {
	cmd = { "verible-verilog-ls", "--rules_config_search" },
	filetypes = { "verilog", "systemverilog" },
	root_dir = vim.fs.find({ ".git", ".rules.verible_lint" }, { upward = true })[1] or vim.fn.getcwd(),
	single_file_support = true,
})

-- Enable the server (only for Verilog/SystemVerilog files)
vim.lsp.enable("verible")

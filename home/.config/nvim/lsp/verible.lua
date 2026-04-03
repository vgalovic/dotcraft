return {
	cmd = { "verible-verilog-ls", "--rules_config_search" },
	filetypes = { "verilog", "systemverilog" },
	root_markers = { ".git", ".rules.verible_lint" },
	single_file_support = true,
}

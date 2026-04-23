Config.later(function()
	vim.pack.add({ Repo.gh("stevearc/conform.nvim") })

	require("conform").setup({
		notify_on_error = false,

		format_on_save = function()
			return {
				timeout_ms = 3000,
				lsp_format = "fallback",
			}
		end,

		formatters_by_ft = {
			["bash"] = { "beautysh" },
			-- ["latex"] = { "latexindent" },
			["lua"] = { "stylua" },
			["markdown"] = { "mdformat" },
			["markdown.mdx"] = { "mdformat" },
			-- ["python"] = { "ruff" },
			["rust"] = { "rustfmt" },
			["sh"] = { "beautysh" },
			["SystemVerilog"] = { "verible" },
			["verilog"] = { "verible" },
			["zsh"] = { "beautysh" },
		},

		formatters = {
			beautysh = {
				prepend_args = { "--indent-size", "2", "--force-function-style", "paronly" },
			},
		},
	})

	Map.map_leader(
		"F",
		'<cmd>lua require("conform").format({ async = true, lsp_format = "fallback" })<cr>',
		"Format buffer",
		{ "n", "x" }
	)
end)

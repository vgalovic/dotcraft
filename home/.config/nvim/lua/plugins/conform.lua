return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			local disable_filetypes = {}
			local lsp_format_opt = disable_filetypes[vim.bo[bufnr].filetype] and "never" or "fallback"
			return {
				timeout_ms = 1000,
				lsp_format = lsp_format_opt,
			}
		end,
		formatters_by_ft = {
			bash = { "beautysh" },
			latex = { "latexindent" },
			lua = { "stylua" },
			python = { "ruff" },
			sh = { "beautysh" },
			SystemVerilog = { "verible" },
			vhdl = { "vsg" },
			zsh = { "beautysh" },
		},
	},
}

return { -- Autoformat
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			local disable_filetypes = {} -- c = true, cpp = true }
			local lsp_format_opt = disable_filetypes[vim.bo[bufnr].filetype] and "never" or "fallback"
			return {
				timeout_ms = 1000,
				lsp_format = lsp_format_opt,
			}
		end,
		formatters_by_ft = {
			sh = { "beautysh" },
			bash = { "beautysh" },
			zsh = { "beautysh" },
			lua = { "stylua" },
			c = { "clang-format" },
			cpp = { "clang-format" },
			python = { "ruff" },
			latex = { "latexindent" },
			vhdl = { "vsg" },
			SystemVerilog = { "verible" },
		},
	},
}

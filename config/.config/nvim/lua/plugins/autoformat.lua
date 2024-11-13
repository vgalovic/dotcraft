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
				timeout_ms = 500,
				lsp_format = lsp_format_opt,
			}
		end,
		formatters_by_ft = {
			ino = { "arduino_language_server" },
			sh = { "beautysh" },
			lua = { "stylua" },
			c = { "arduino_language_server", "ast-grep", "clang-format", "clanged" },
			cpp = { "arduino_language_server", "ast-grep", "clang-format", "clanged" },
			python = { "ruff", "ast-grep" },
			-- assembly = { "asmfmt" },
			latex = { "latexindent" },
			SystemVerilog = { "verible" },
		},
	},
}

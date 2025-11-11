return {
	"stevearc/conform.nvim",

	event = { "BufWritePre" },
	cmd = { "ConformInfo" },

	-- Configure Conform plugin with formatter options
	opts = {
		notify_on_error = false,
		format_on_save = function(bufnr)
			local disable_filetypes = {}
			local lsp_format_opt = disable_filetypes[vim.bo[bufnr].filetype] and "never" or "fallback"
			return {
				timeout_ms = 3000,
				lsp_format = lsp_format_opt,
			}
		end,

		formatters_by_ft = {
			["bash"] = { "beautysh" },
			["latex"] = { "latexindent" },
			["lua"] = { "stylua" },
			["markdown"] = { "mdformat" },
			["markdown.mdx"] = { "mdformat" },
			["python"] = { "ruff" },
			["rust"] = { "rustfmt" },
			["sh"] = { "beautysh" },
			["SystemVerilog"] = { "verible" },
			["verilog"] = { "verible" },
			["zsh"] = { "beautysh" },
		},

		vim.keymap.set("n", "<leader>f", function()
			require("conform").format({ async = true, lsp_format = "fallback" })
		end, { desc = "Format buffer" }),
	},
}

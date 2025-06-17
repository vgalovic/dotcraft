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
			["json"] = { "prettier" },
			["latex"] = { "latexindent" },
			["lua"] = { "stylua" },
			["markdown"] = { "prettier", "markdown-toc" },
			["markdown.mdx"] = { "prettier", "markdown-toc" },
			["python"] = { "ruff" },
			["rust"] = { "rustfmt" },
			["sh"] = { "beautysh" },
			["SystemVerilog"] = { "verible" },
			["verilog"] = { "verible" },
			["yaml"] = { "prettier" },
			["zsh"] = { "beautysh" },
		},

		---@diagnostic disable: missing-return
		formatters = {
			["markdown-toc"] = {
				condition = function(_, ctx)
					for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
						if line:find("<!%-%- toc %-%->") then
							return true
						end
					end
				end,
			},
		},
	},

	vim.keymap.set("n", "<leader>f", function()
		require("conform").format({ async = true, lsp_format = "fallback" })
	end, { desc = "Format buffer" }),
}

return {
	"mfussenegger/nvim-lint",
	enabled = true,
	event = {
		"BufReadPre",
		"BufNewFile",
	},
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			["python"] = { "ruff" },
			["systemverilog"] = { "verible" },
		}

		-- Create an autogroup for linting actions
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		-- Trigger linting actions on events like BufEnter, BufWritePost, InsertLeave
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}

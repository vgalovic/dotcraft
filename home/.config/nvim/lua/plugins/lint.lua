return {
	"mfussenegger/nvim-lint",
	enabled = true,
	event = "VeryLazy",
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			c = { "trivy" },
			cpp = { "trivy" },
			python = { "ruff" },
			systemverilog = { "verible" },
			vhdl = { "vsg" },
		}

		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}

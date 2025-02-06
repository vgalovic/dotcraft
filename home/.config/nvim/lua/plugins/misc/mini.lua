---@diagnostic disable: duplicate-set-field

return { -- Collection of various small independent plugins/modules
	"echasnovski/mini.nvim",
	version = false,
	config = function()
		require("mini.icons").setup()

		-- require("mini.tabline").setup()

		-- local statusline = require("mini.statusline")
		-- statusline.setup({ use_icons = vim.g.have_nerd_font })
		-- statusline.section_location = function()
		-- 	return "%2l:%-2v"
		-- end
		--

		-- Better Around/Inside textobjects
		--
		-- Examples:
		--  - va)  - [V]isually select [A]round [)]paren
		--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
		--  - ci'  - [C]hange [I]nside [']quote
		require("mini.ai").setup({ n_lines = 500 })
		--
		-- Add/delete/replace surroundings (brackets, quotes, etc.)
		--
		-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
		-- - sd'   - [S]urround [D]elete [']quotes
		-- - sr)'  - [S]urround [R]eplace [)] [']
		require("mini.surround").setup()

		require("mini.pairs").setup()

		require("mini.jump2d").setup({
			hooks = {
				pre = function()
					vim.api.nvim_exec_autocmds("User", { pattern = "Jump2dPre" })
				end,
			},
		})

		require("mini.sessions").setup({
			hooks = {
				pre = {
					write = function()
						vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
					end,
				},
			},
		})
		vim.keymap.set({ "n", "v" }, "<leader>z", "<cmd>mksession<CR>", { desc = "Save Session" })

		require("mini.diff").setup({
			view = {
				style = "sign", -- number | sign

				-- signs = { add = "+", change = "~", delete = "-" },
				signs = { add = "▕▏", change = "▕▏", delete = "▁▁" },
			},
		})
		vim.keymap.set("n", "<leader>gt", function()
			require("mini.diff").toggle_overlay(vim.api.nvim_get_current_buf())
		end, { desc = "Toggle Diff Overlay" })

		require("mini.git").setup()

		require("mini.hipatterns").setup({
			highlighters = {
				-- Highlight hex color strings (`#rrggbb`) using that color
				hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
			},
		})
	end,
}

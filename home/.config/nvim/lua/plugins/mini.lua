return { -- Collection of various small independent plugins/modules
	"echasnovski/mini.nvim",
	version = false,
	config = function()
		require("mini.icons").setup()
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
		--
		require("mini.pairs").setup()
		--
		require("mini.jump2d").setup({
			hooks = {
				pre = function()
					vim.api.nvim_exec_autocmds("User", { pattern = "Jump2dPre" })
				end,
			},
		})
		--
		require("mini.sessions").setup({
			hooks = {
				pre = {
					write = function()
						vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
					end,
				},
			},
		})
		--
		require("mini.diff").setup({
			view = {
				style = "sign", -- number | sign

				-- signs = { add = "+", change = "~", delete = "-" },
				signs = { add = "▕▏", change = "▕▏", delete = "▁▁" },
			},
		})
		--
		require("mini.hipatterns").setup({
			highlighters = {
				-- Highlight hex color strings (`#rrggbb`) using that color
				hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
			},
		})
		--
		require("mini.files").setup({
			mappings = {
				go_in_plus = "<CR>",
			},
			windows = {
				-- preview = true,
				-- width_preview = 50,

				width_nofocus = 30,
				width_focus = 30,
			},
		})
	end,
}

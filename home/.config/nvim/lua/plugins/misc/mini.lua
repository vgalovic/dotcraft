---@diagnostic disable: duplicate-set-field

return { -- Collection of various small independent plugins/modules
	"echasnovski/mini.nvim",
	version = false,
	lazy = false,
	keys = {
		{ "<leader>z", "<cmd>mksession<CR>", desc = "Save Session" },
		{
			"<leader>gt",
			function()
				require("mini.diff").toggle_overlay(vim.api.nvim_get_current_buf())
			end,
			desc = "Toggle Diff Overlay",
		},
		{
			"\\",
			function()
				local files = require("mini.files")
				if not files.close() then
					files.open(vim.fn.expand("%:p:h"), true)
				end
			end,
			desc = "Open Mini Files",
		},
	},

	config = function()
		require("mini.comment").setup()

		require("mini.icons").setup()

		require("mini.tabline").setup()

		-- local statusline = require("mini.statusline")
		-- statusline.setup()
		-- statusline.section_location = function()
		-- 	return "%2l:%-2v"
		-- end

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

		require("mini.jump").setup({
			mappings = {
				repeat_jump = "<C-.>",
			},
		})

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

		require("mini.diff").setup({
			view = {
				style = "sign", -- number | sign

				signs = {
					add = Icons.git.line_add,
					change = Icons.git.line_change,
					delete = Icons.git.line_delete,
				},
			},
		})

		require("mini.git").setup()

		require("mini.hipatterns").setup({
			highlighters = {
				-- Highlight hex color strings (`#rrggbb`) using that color
				hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
			},
		})

		local files = require("mini.files")
		files.setup({
			mappings = {
				close = "q",
				go_in = "l",
				go_in_plus = "<CR>",
				go_out = "h",
				go_out_plus = "H",
				mark_goto = "'",
				mark_set = "m",
				reset = "<BS>",
				reveal_cwd = ".",
				show_celp = "g?",
				synchronize = "=",
				trim_left = "<",
				trim_right = ">",
			},
		})
	end,
}

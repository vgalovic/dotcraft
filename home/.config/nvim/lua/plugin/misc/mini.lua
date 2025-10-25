---@diagnostic disable: duplicate-set-field

return { -- Collection of various small independent plugins/modules
	"nvim-mini/mini.nvim",
	version = false,
	lazy = false,
	keys = {
		{ "<leader>S", "<cmd>mksession<CR>", desc = "Save Session" },
		{
			"<leader>gt",
			function()
				require("mini.diff").toggle_overlay(vim.api.nvim_get_current_buf())
			end,
			desc = "Toggle Diff Overlay",
		},
	},

	config = function()
		require("mini.comment").setup()

		require("mini.icons").setup({
			lsp = {
				["ripgrep"] = { glyph = "", "MiniIconsGreen" },
			},
			filetype = {
				["snacks_terminal"] = { glyph = "", hl = "MiniIconsGrey" },
				["snacks_dashboard"] = { glyph = "󰕮", hl = "MiniIconsAzure" },
				["snacks_picker_input"] = { glyph = "", hl = "MiniIconsCyan" },
				["snacks_picker_list"] = { glyph = "󰙅", hl = "MiniIconsCyan" },
				["kitty"] = { glyph = "󰄛", hl = "MiniIconosGrey" },
			},
			file = {
				["kitty.conf"] = { glyph = "󰄛", hl = "MiniIconosGrey" },
				["config"] = { glyph = "", hl = "MiniIconsGrey" },
			},
		})

		require("mini.tabline").setup()

		local statusline = require("mini.statusline")
		statusline.setup()

		-- Custom display names
		local ft_names = {
			snacks_terminal = "Snacks Terminal",
			snacks_dashboard = "Snacks Dashboard",
			snacks_picker_input = "Snacks Picker",
			snacks_picker_list = "Snacks Explorer",
		}

		-- Override section_fileinfo but keep the rest of its logic
		local orig = statusline.section_fileinfo
		statusline.section_fileinfo = function(...)
			-- Get original section output
			local info = orig(...)

			-- Replace filetype name inside it
			local ft = vim.bo.filetype
			local new_name = ft_names[ft]
			if new_name then
				-- Replace only the filetype text (keep encoding, format, etc.)
				info = info:gsub(ft, new_name)
			end

			return info
		end

		statusline.section_location = function()
			return "%2l:%-2v"
		end

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

		require("mini.jump").setup({})

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

		require("mini.hipatterns").setup({
			highlighters = {
				-- Highlight hex color strings (`#rrggbb`) using that color
				hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
			},
		})
	end,
}

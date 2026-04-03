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
		local icons = require("mini.icons")
		icons.setup({
			lsp = { ["ripgrep"] = { glyph = Icons.lsp.ripgrep, "MiniIconsGreen" } },
			filetype = {
				["kitty"] = { glyph = Icons.file.kitty, hl = "MiniIconsOrange" },
				["log"] = { glyph = Icons.filetype.log, hl = "MiniIconsGrey" },
				["markdown.snacks_picker_preview"] = { glyph = Icons.filetype.picker_preview, hl = "MiniIconsGrey" },
				["sh"] = { glyph = Icons.filetype.sh, hl = "MiniIconsAzure" },
				["snacks_dashboard"] = { glyph = Icons.filetype.dashboard, hl = "MiniIconsAzure" },
				["snacks_notif_history"] = { glyph = Icons.filetype.notification_history, hl = "MiniIconsAzure" },
				["snacks_picker_input"] = { glyph = Icons.filetype.picker_input, hl = "MiniIconsCyan" },
				["snacks_picker_list"] = { glyph = Icons.filetype.picker_list, hl = "MiniIconsCyan" },
				["snacks_terminal"] = { glyph = Icons.filetype.terminal, hl = "MiniIconsGrey" },
				["verilog"] = { glyph = Icons.filetype.verilog, hl = "MiniIconsGreen" },
			},
			file = {
				["Brewfile"] = { glyph = Icons.file.brewfile, hl = "MiniIconsYellow" },
				["config"] = { glyph = Icons.file.config, hl = "MiniIconsGrey" },
				["kitty.conf"] = { glyph = Icons.file.kitty, hl = "MiniIconsOrange" },
			},
		})

		local pattern_icons = {
			{ "kitty%.conf$", { Icons.file.kitty, "MiniIconsOrange" } },
			{ "%.conf$", { Icons.file.config, "MiniIconsAzure" } },
			{ "%.tmTheme$", { Icons.filetype.tmTheme, "MiniIconsAzure" } },
			{ "%.log$", { Icons.filetype.log, "MiniIconsGrey" } },
			{ "%.sh$", { Icons.filetype.sh, "MiniIconsGrey" } },
			{ "%.v$", { Icons.filetype.verilog, "MiniIconsGreen" } },
		}

		local get_icons = icons.get
		icons.get = function(category, name)
			if category == "file" then
				for _, entry in ipairs(pattern_icons) do
					local pattern, icon_data = entry[1], entry[2]
					if name:match(pattern) then
						return unpack(icon_data)
					end
				end
			end
			return get_icons(category, name)
		end

		vim.api.nvim_create_autocmd("UIEnter", {
			once = true,
			callback = function()
				if not package.loaded["mini.tabline"] then
					require("mini.tabline").setup()
				end

				if not package.loaded["mini.statusline"] then
					local statusline = require("mini.statusline")
					statusline.setup()

					-- Custom display names
					local ft_names = {
						["markdown.snacks_picker_preview"] = "Picker preview",
						snacks_dashboard = "Dashboard",
						snacks_notif_history = "Notification History",
						snacks_picker_input = "Picker",
						snacks_picker_list = "Explorer",
						snacks_terminal = "Terminal",
					}

					-- Override section_fileinfo but keep the rest of its logic
					local orig = statusline.section_fileinfo
					statusline.section_fileinfo = function(...)
						local info = orig(...)
						local ft = vim.bo.filetype
						local new_name = ft_names[ft]
						if new_name then
							info = info:gsub(ft, new_name)
						end
						return info
					end

					statusline.section_location = function()
						return "%2l:%-2v"
					end
				end
			end,
		})

		vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
			once = true,
			callback = function()
				if not package.loaded["mini.ai"] then
					-- Better Around/Inside textobjects
					--
					-- Examples:
					--  - va)  - [V]isually select [A]round [)]paren
					--  - yinq - [Y]ank [I]nside [N]ext [Q]uote
					--  - ci'  - [C]hange [I]nside [']quote
					require("mini.ai").setup({ n_lines = 500 })
				end

				if not package.loaded["mini.comment"] then
					require("mini.comment").setup()
				end

				if not package.loaded["mini.pairs"] then
					require("mini.pairs").setup()
				end

				if not package.loaded["mini.surround"] then
					-- Add/delete/replace surroundings (brackets, quotes, etc.)
					--
					-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
					-- - sd'   - [S]urround [D]elete [']quotes
					-- - sr)'  - [S]urround [R]eplace [)] [']
					require("mini.surround").setup()
				end
			end,
		})

		vim.api.nvim_create_autocmd("BufEnter", {
			once = true, -- load only once
			callback = function()
				if not package.loaded["mini.cursorword"] then
					require("mini.cursorword").setup()
				end

				if not package.loaded["mini.diff"] then
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
				end

				if not package.loaded["mini.hipatterns"] then
					require("mini.hipatterns").setup({
						-- Highlight hex color strings (`#rrggbb`) using that color
						highlighters = { hex_color = require("mini.hipatterns").gen_highlighter.hex_color() },
					})
				end

				if not package.loaded["mini.jump"] then
					require("mini.jump").setup()
				end

				if not package.loaded["mini.jump2d"] then
					require("mini.jump2d").setup({
						-- Optional hooks if needed
						hooks = {
							pre = function()
								vim.api.nvim_exec_autocmds("User", { pattern = "Jump2dPre" })
							end,
						},
					})
				end
			end,
		})

		vim.api.nvim_create_autocmd("VimEnter", {
			once = true,
			callback = function()
				if not package.loaded["mini.sessions"] then
					require("mini.sessions").setup({
						hooks = {
							pre = {
								write = function()
									vim.api.nvim_exec_autocmds("User", { pattern = "SessionSavePre" })
								end,
							},
						},
					})
				end
			end,
		})
	end,
}

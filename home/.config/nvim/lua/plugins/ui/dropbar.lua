return {
	"Bekaboo/dropbar.nvim",

	event = { "BufReadPost", "BufNewFile" },
	dependencies = { require("mini.icons").mock_nvim_web_devicons() },

	keys = {
		{
			"<leader>w",
			function()
				require("dropbar.api").pick()
			end,
			desc = "Winbar pick",
		},
	},
	opts = function()
		local menu_utils = require("dropbar.utils.menu")

		local function close()
			local menu = menu_utils.get_current()
			while menu and menu.prev_menu do
				menu = menu.prev_menu
			end
			if menu then
				menu:close()
			end
		end

		return {
			menu = {
				win_configs = { border = "rounded" },
				keymaps = {
					["h"] = "<C-w>c",
					["l"] = function()
						local menu = menu_utils.get_current()
						if not menu then
							return
						end
						local row = vim.api.nvim_win_get_cursor(menu.win)[1]
						local component = menu.entries[row]:first_clickable()
						if component then
							menu:click_on(component, nil, 1, "l")
						end
					end,
					["o"] = function()
						local menu = menu_utils.get_current()
						if not menu then
							return
						end
						local cursor = vim.api.nvim_win_get_cursor(menu.win)
						local entry = menu.entries[cursor[1]]
						local component = entry:first_clickable(entry.padding.left + entry.components[1]:bytewidth())
						if component then
							menu:click_on(component, nil, 1, "l")
						end
					end,
					["q"] = close,
					["<esc>"] = close,
				},
			},
		}
	end,
}

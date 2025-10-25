return {
	"stevearc/oil.nvim",
	lazy = true,
	cmd = { "Oil" },
	keys = {
		{ "\\", "<cmd>Oil<cr>", desc = "Open parent directory" },
	},
	init = function()
		-- Detect if Neovim was started with a directory, and load Oil
		local function is_directory(path)
			return vim.fn.isdirectory(path) == 1
		end

		local arg = vim.fn.argv()[1]
		if arg and is_directory(arg) then
			require("lazy").load({ plugins = { "oil.nvim" } })
		end
	end,
	opts = {
		keymaps = {
			["g?"] = { "actions.show_help", mode = "n" },
			["<CR>"] = "actions.select",
			["<C-s>"] = { "actions.select", opts = { vertical = true } },
			["<C-h>"] = { "actions.select", opts = { horizontal = true } },
			["<C-t>"] = { "actions.select", opts = { tab = true } },
			["<C-p>"] = "actions.preview",
			["\\"] = { "actions.close", mode = "n" },
			["<C-l>"] = "actions.refresh",
			["<backspace>"] = { "actions.parent", mode = "n" },
			["_"] = { "actions.open_cwd", mode = "n" },
			["`"] = { "actions.cd", mode = "n" },
			["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
			["gs"] = { "actions.change_sort", mode = "n" },
			["gx"] = "actions.open_external",
			["g."] = { "actions.toggle_hidden", mode = "n" },
			["g\\"] = { "actions.toggle_trash", mode = "n" },
			["gd"] = {
				desc = "Toggle file detail view",
				callback = function()
					Detail = not Detail
					if Detail then
						require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
					else
						require("oil").set_columns({ "icon" })
					end
				end,
			},
		},
	},
}

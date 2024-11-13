-- plugin/oil.lua
return {
	"stevearc/oil.nvim",
	config = function()
		require("oil").setup({
			columns = { "icon", "size" },
			default_file_explorer = true,
			delete_to_trash = true,
			use_default_keymaps = false,
			skip_confirm_for_simple_edits = true,
			view_options = {
				show_hidden = true,
				natural_order = true,
				is_always_hidden = function(name, _)
					return name == ".." or name == ".git"
				end,
			},
			win_options = {
				wrap = true,
			},
		})
	end,
}

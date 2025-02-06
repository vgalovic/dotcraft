-- Highlight todo, notes, etc in comments
return {
	"folke/todo-comments.nvim",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {},

	vim.keymap.set("n", "[t", function()
		require("todo-comments").jump_prev({ keywords = { "TODO", "FIX", "HACK", "WARNING" } })
	end, { desc = "Previous todo comment" }),

	vim.keymap.set("n", "]t", function()
		require("todo-comments").jump_next({ keywords = { "TODO", "FIX", "HACK", "WARNING" } })
	end, { desc = "Next todo comment" }),
}

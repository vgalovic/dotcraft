return {
	"mrjones2014/smart-splits.nvim",
	build = "./kitty/install-kittens.bash",
	event = "VeryLazy",
	keys = {
    --stylua: ignore start

    -- resizing splits
    { "<A-h>", function() require("smart-splits").resize_left() end,  mode = {"n", "t"}, desc = "Resize split left" },
    { "<A-j>", function() require("smart-splits").resize_down() end,  mode = {"n", "t"}, desc = "Resize split down" },
    { "<A-k>", function() require("smart-splits").resize_up() end,    mode = {"n", "t"}, desc = "Resize split up" },
    { "<A-l>", function() require("smart-splits").resize_right() end, mode = {"n", "t"}, desc = "Resize split right" },

    -- Move between splits
    { "<C-h>", function() require("smart-splits").move_cursor_left() end,     mode = {"n", "t"}, desc = "Move to left split" },
    { "<C-j>", function() require("smart-splits").move_cursor_down() end,     mode = {"n", "t"}, desc = "Move to bottom split" },
    { "<C-k>", function() require("smart-splits").move_cursor_up() end,       mode = {"n", "t"}, desc = "Move to top split" },
    { "<C-l>", function() require("smart-splits").move_cursor_right() end,    mode = {"n", "t"}, desc = "Move to right split" },
    { "<C-'>", function() require("smart-splits").move_cursor_previous() end, mode = {"n", "t"}, desc = "Move to previous split" },

    -- Swap buffers between windows
    { "<leader>wh", function() require("smart-splits").swap_buf_left() end, desc = "Swap buffer left" },
    { "<leader>wj", function() require("smart-splits").swap_buf_down() end, desc = "Swap buffer down" },
    { "<leader>wk", function() require("smart-splits").swap_buf_up() end, desc = "Swap buffer up" },
    { "<leader>wl", function() require("smart-splits").swap_buf_right() end, desc = "Swap buffer right" },

		--staylua: ignore end
	},
}

-- =========================================================
-- KEY HINTS (mini.clue)
-- =========================================================

Config.later(function()
	require("mini.clue").setup({
		clues = {
			Config.leader_groups,
			require("mini.clue").gen_clues.builtin_completion(),
			require("mini.clue").gen_clues.g(),
			require("mini.clue").gen_clues.marks(),
			require("mini.clue").gen_clues.registers(),
			require("mini.clue").gen_clues.square_brackets(),
			require("mini.clue").gen_clues.windows({ submode_resize = true }),
			require("mini.clue").gen_clues.z(),
		},
		triggers = {
			{ mode = { "n", "x" }, keys = "<Leader>" },
			{ mode = "n", keys = "\\" },
			{ mode = { "n", "x" }, keys = "[" },
			{ mode = { "n", "x" }, keys = "]" },
			{ mode = "i", keys = "<C-x>" },
			{ mode = { "n", "x" }, keys = "g" },
			{ mode = { "n", "x" }, keys = "'" },
			{ mode = { "n", "x" }, keys = "`" },
			{ mode = { "n", "x" }, keys = '"' },
			{ mode = { "i", "c" }, keys = "<C-r>" },
			{ mode = "n", keys = "<C-w>" },
			{ mode = { "n", "x" }, keys = "s" },
			{ mode = { "n", "x" }, keys = "z" },
		},
		window = { delay = 0, config = { width = "auto" } },
	})
end)

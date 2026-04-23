---@diagnostic disable:  undefined-global

-- =========================================================
-- MISC CORE UTILITIES
-- =========================================================
local now_if_args, later = Config.now_if_args, Config.later
local Icons = require("config.icons")

now_if_args(function()
	require("mini.misc").setup()
	MiniMisc.setup_auto_root()
	MiniMisc.setup_restore_cursor()
	MiniMisc.setup_termbg_sync()
end)

-- =========================================================
-- EXTRA / TEXT OBJECTS / EDITING
-- =========================================================

later(function()
	require("mini.extra").setup()
end)

later(function()
	require("mini.ai").setup({
		custom_textobjects = {
			B = MiniExtra.gen_ai_spec.buffer(),
			F = require("mini.ai").gen_spec.treesitter({
				a = "@function.outer",
				i = "@function.inner",
			}),
		},
		search_method = "cover",
		n_lines = 500,
	})
end)

--stylua: ignore start
later(function() require("mini.align").setup() end)
later(function() require("mini.bracketed").setup() end)
later(function() require("mini.bufremove").setup() end)
--stylua: ignore end

later(function()
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
end)

--stylua: ignore start
later(function() require("mini.cmdline").setup() end)
later(function() require("mini.comment").setup() end)
later(function() require("mini.git").setup() end)
later(function() require("mini.jump").setup() end)
later(function() require("mini.keymap").setup() end)
later(function() require("mini.move").setup() end)
later(function() require("mini.operators").setup() end)
later(function() require("mini.pairs").setup({ modes = { command = true } }) end)
later(function() require("mini.pick").setup() end)
later(function() require("mini.splitjoin").setup() end)
later(function() require("mini.surround").setup() end)
later(function() require("mini.trailspace").setup() end)
later(function() require("mini.visits").setup() end)
--stylua: ignore end

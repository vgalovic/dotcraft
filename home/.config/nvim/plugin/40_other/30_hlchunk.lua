-- ============================================================================
-- hlchunk.nvim
-- ============================================================================

Config.later(function()
	vim.pack.add({ Repo.gh("shellRaining/hlchunk.nvim") })

	local random_hl = require("config.dashboard").get_random_hl()

	-- convert first highlight group to hex
	local hl = vim.api.nvim_get_hl(0, { name = random_hl[1] })
	local color = hl and hl.fg and string.format("#%06x", hl.fg)

	require("hlchunk").setup({
		chunk = {
			enable = true,
			use_treesitter = true,
			delay = 100,
			duration = 0,
			style = {
				{ fg = color },
			},
		},
		indent = { enable = true },
	})
end)

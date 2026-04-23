local add = vim.pack.add
local later = Config.later

-- ============================================================================
-- undotree
-- ============================================================================

later(function()
	add({ Repo.gh("mbbill/undotree") })
	Map.map_leader("u", "<cmd>UndotreeToggle<cr>", "Undo tree")
end)

-- ============================================================================
-- vim be good
-- ============================================================================

later(function()
	add({ Repo.gh("ThePrimeagen/vim-be-good") })
end)

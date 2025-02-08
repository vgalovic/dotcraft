local M = {}

-- Shuffle a table in-place using Fisher-Yates algorithm
---@param t table
local function shuffle(t)
	-- Seed the random generator to ensure different results each time
	math.randomseed(os.time())

	for i = #t, 2, -1 do
		local j = math.random(i)
		t[i], t[j] = t[j], t[i]
	end
end

---@return string[] groups random highlight groups from the table
M.get_random_hl = function()
	local groups = {
		--
		-- Colors in comments are highlights of catppuccin colorsscheme,
		-- for diferent colorschemes, colors might be different
		--
		"@parameter", ---- #EBA0AD
		"@property", ----- #B4BEFF
		"@symbol", ------- #F2CDCE
		"Character", ----- #94E2D6
		"Conditional", --- #CBA6F8
		"Constant", ------ #FAB388
		"Function", ------ #89B4FB
		"Label", --------- #74C7ED
		"Operator", ------ #89DCEC
		"PreProc", ------- #F5C2E8
		"Type", ---------- #F9E2B0
		"diffAdded", ----- #A6E3A2
		"diffRemoved", --- #F38BA9
		"diffchanged", --- #89B4FB
	}

	-- Shuffle the table every time the function is called
	shuffle(groups)

	-- Return the shuffled list
	return groups
end

return M

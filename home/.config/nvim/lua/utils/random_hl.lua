local M = {}

-- Function to shuffle a table randomly
local function shuffle(t)
	-- Seed the random generator to ensure different results each time
	math.randomseed(os.time())

	for i = #t, 2, -1 do
		local j = math.random(i)
		t[i], t[j] = t[j], t[i]
	end
end

M.get_random_hl = function()
	local groups = {
		"@Function",
		"@String",
		"@Keyword",
		"@Error",
		"@Type",
		"@Constant",
		"@Label",
		"@Number",
		"@Type",
		"@Operator",
	}

	-- Shuffle the table every time the function is called
	shuffle(groups)

	-- Return the shuffled list
	return groups
end

return M

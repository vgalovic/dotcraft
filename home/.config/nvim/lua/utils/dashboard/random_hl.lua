---@class utils.dashboard.hrandom_hl

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
M.get_random_hl = function(count)
	local groups = {
		"Constant",
		"String",
		"Function",
		"Identifier",
		"@keyword",
		"Operator",
		"DiagnosticError",
		"DiagnosticWarn",
	}

	shuffle(groups)

	if count and count < #groups then
		return vim.list_slice(groups, 1, count)
	end

	return groups
end

return M

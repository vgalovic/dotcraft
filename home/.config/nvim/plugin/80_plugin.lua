---@diagnostic disable: undefined-global

local add = vim.pack.add
local later = Config.later

-- ============================================================================
-- switch.vim
-- ============================================================================

later(function()
	add({ Repo.gh("AndrewRadev/switch.vim") })

	-- Set custom definitions after plugin is loaded
	local fk = [=[\<\(\l\)\(\l\+\(\u\l\+\)\+\)\>]=]
	local sk = [=[\<\(\u\l\+\)\(\u\l\+\)\+\>]=]
	local tk = [=[\<\(\l\+\)\(_\l\+\)\+\>]=]
	local fok = [=[\<\(\u\+\)\(_\u\+\)\+\>]=]
	local folk = [=[\<\(\l\+\)\(\-\l\+\)\+\>]=]
	local fik = [=[\<\(\l\+\)\(\.\l\+\)\+\>]=]

	vim.g.switch_custom_definitions = {
		vim.fn["switch#NormalizedCase"]({ "true", "false" }),
		{ "1", "0" },
		vim.fn["switch#NormalizedCase"]({ "enable", "disable" }),
		{ "FIX", "TODO", "HACK", "WARN", "PERF", "NOTE", "TEST" },
		{ "PASSED", "FAILED" },
		{ "<=", ">=" },
		{ "==", "!=" },
		{ "<", ">" },
		{ "&&", "||" },
		{
			[fk] = [=[\=toupper(submatch(1)) . submatch(2)]=],
			[sk] = [=[\=tolower(substitute(submatch(0), '\(\l\)\(\u\)', '\1_\2', 'g'))]=],
			[tk] = [=[\U\0]=],
			[fok] = [=[\=tolower(substitute(submatch(0), '_', '-', 'g'))]=],
			[folk] = [=[\=substitute(submatch(0), '-', '.', 'g')]=],
			[fik] = [=[\=substitute(submatch(0), '\.\(\l\)', '\u\1', 'g')]=],
		},
	}

	Map.map_opts("<M-r>", "<cmd>Switch<CR>", "Switch", { "n", "v" })
end)

local custom_switches = vim.api.nvim_create_augroup("CustomSwitches", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = custom_switches,
	pattern = { "markdown" },
	callback = function()
		local fk = [=[\v^(\s*[*+-] )?\[ \]]=]
		local sk = [=[\v^(\s*[*+-] )?\[x\]]=]
		local tk = [=[\v^(\s*[*+-] )?\[-\]]=]
		local fok = [=[\v^(\s*\d+\. )?\[ \]]=]
		local fik = [=[\v^(\s*\d+\. )?\[x\]]=]
		local sik = [=[\v^(\s*\d+\. )?\[-\]]=]
		vim.b.switch_custom_definitions = {
			{
				[fk] = [=[\1[x]]=],
				[sk] = [=[\1[-]]=],
				[tk] = [=[\1[ ]]=],
			},
			{
				[fok] = [=[\1[x]]=],
				[fik] = [=[\1[-]]=],
				[sik] = [=[\1[ ]]=],
			},
		}
	end,
})

-- ============================================================================
-- todo-comments.nvim
-- ============================================================================

later(function()
	vim.pack.add({
		{ src = Repo.gh("nvim-lua/plenary.nvim") },
		{ src = Repo.gh("folke/todo-comments.nvim"), name = "todo-comments" },
	})
	require("todo-comments").setup()

	Map.map("[t", function()
		todo.jump_prev({ keywords = { "TODO", "FIX", "HACK", "WARNING" } })
	end, "Previous todo comment")

	Map.map("]t", function()
		todo.jump_next({ keywords = { "TODO", "FIX", "HACK", "WARNING" } })
	end, "Next todo comment")
end)

-- ============================================================================
-- hlchunk.nvim
-- ============================================================================

later(function()
	add({ Repo.gh("shellRaining/hlchunk.nvim") })

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

-- ============================================================================
-- vim be good
-- ============================================================================

later(function()
	add({ Repo.gh("ThePrimeagen/vim-be-good") })
end)

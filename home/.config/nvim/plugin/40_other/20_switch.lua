-- ============================================================================
-- switch.vim
-- ============================================================================

Config.later(function()
	vim.pack.add({ Repo.gh("AndrewRadev/switch.vim") })

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
		{ "FIXME", "HACK", "TODO", "NOTE" },
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

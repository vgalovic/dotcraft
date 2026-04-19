---@diagnostic disable: undefined-global

-- =========================================================
-- HELPER FUNCTIONS
-- =========================================================

local pick_added_hunks_buf = '<Cmd>Pick git_hunks path="%" scope="staged"<CR>'
local pick_workspace_symbols_live = '<Cmd>Pick lsp scope="workspace_symbol_live"<CR>'

local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]
local git_log_buf_cmd = git_log_cmd .. " --follow -- %"

local explore_at_file = "<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>"

local session_new = 'MiniSessions.write(vim.fn.input("Session name: "))'

local new_scratch_buffer = function()
	vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end

local explore_quickfix = function()
	vim.cmd(vim.fn.getqflist({ winid = true }).winid ~= 0 and "cclose" or "copen")
end

local explore_locations = function()
	vim.cmd(vim.fn.getloclist(0, { winid = true }).winid ~= 0 and "lclose" or "lopen")
end

local make_pick_core = function(cwd, desc)
	return function()
		local sort_latest = MiniVisits.gen_sort.default({ recency_weight = 1 })
		local local_opts = { cwd = cwd, filter = "core", sort = sort_latest }
		MiniExtra.pickers.visit_paths(local_opts, { source = { name = desc } })
	end
end

-- =========================================================
-- BUFFER MANAGEMENT
-- =========================================================

Map.map_leader("bd", "<Cmd>lua MiniBufremove.delete()<CR>", "Delete")
Map.map_leader("bD", "<Cmd>lua MiniBufremove.delete(0, true)<CR>", "Delete!")
Map.map_leader("bs", new_scratch_buffer, "Scratch")
Map.map_leader("bw", "<Cmd>lua MiniBufremove.wipeout()<CR>", "Wipeout")
Map.map_leader("bW", "<Cmd>lua MiniBufremove.wipeout(0, true)<CR>", "Wipeout!")

-- =========================================================
-- FILE EXPLORATION
-- =========================================================

Map.map("\\", "<Cmd>lua MiniFiles.open()<CR>", "Directory")
Map.map("|", explore_at_file, "File directory")

Map.map_leader("eq", explore_quickfix, "Quickfix list")
Map.map_leader("eQ", explore_locations, "Location list")

-- =========================================================
-- NOTIFICATIONS
-- =========================================================

Map.map_leader("en", "<Cmd>lua MiniNotify.show_history()<CR>", "Notifications")

-- =========================================================
-- PICKERS
-- =========================================================

Map.map_leader(".", "<cmd>Pick oldfiles<CR>", "Recent files")
Map.map("<M-/>", '<Cmd>Pick history scope="/"<CR>', '"/" history')
Map.map("<M-;>", '<Cmd>Pick history scope=":"<CR>', '":" history')
Map.map_leader("<leader>", "<Cmd>Pick buffers<CR>", "Buffer list")

Map.map_leader("fa", '<Cmd>Pick git_hunks scope="staged"<CR>', "Added hunks (all)")
Map.map_leader("fA", pick_added_hunks_buf, "Added hunks (buf)")
Map.map_leader("fc", "<Cmd>Pick git_commits<CR>", "Commits (all)")
Map.map_leader("fC", '<Cmd>Pick git_commits path="%"<CR>', "Commits (buf)")
Map.map_leader("fd", '<Cmd>Pick diagnostic scope="all"<CR>', "Diagnostic workspace")
Map.map_leader("fD", '<Cmd>Pick diagnostic scope="current"<CR>', "Diagnostic buffer")
Map.map_leader("ff", "<Cmd>Pick files<CR>", "Files")
Map.map_leader("fg", "<Cmd>Pick grep_live<CR>", "Grep live")
Map.map_leader("fG", '<Cmd>Pick grep pattern="<cword>"<CR>', "Grep current word")
Map.map_leader("fh", "<Cmd>Pick help<CR>", "Help tags")
Map.map_leader("fH", "<Cmd>Pick hl_groups<CR>", "Highlight groups")
Map.map_leader("fl", '<Cmd>Pick buf_lines scope="all"<CR>', "Lines (all)")
Map.map_leader("fL", '<Cmd>Pick buf_lines scope="current"<CR>', "Lines (buf)")
Map.map_leader("fm", "<Cmd>Pick git_hunks<CR>", "Modified hunks (all)")
Map.map_leader("fM", '<Cmd>Pick git_hunks path="%"<CR>', "Modified hunks (buf)")
Map.map_leader("fr", "<Cmd>Pick resume<CR>", "Resume")
Map.map_leader("fR", '<Cmd>Pick lsp scope="references"<CR>', "References (LSP)")
Map.map_leader("fs", pick_workspace_symbols_live, "Symbols workspace (live)")
Map.map_leader("fS", '<Cmd>Pick lsp scope="document_symbol"<CR>', "Symbols document")
Map.map_leader("fv", '<Cmd>Pick visit_paths cwd=""<CR>', "Visit paths (all)")
Map.map_leader("fV", "<Cmd>Pick visit_paths<CR>", "Visit paths (cwd)")

-- =========================================================
-- GIT INTEGRATION
-- =========================================================

Map.map_leader("ga", "<Cmd>Git diff --cached<CR>", "Added diff")
Map.map_leader("gA", "<Cmd>Git diff --cached -- %<CR>", "Added diff buffer")
Map.map_leader("gc", "<Cmd>Git commit<CR>", "Commit")
Map.map_leader("gC", "<Cmd>Git commit --amend<CR>", "Commit amend")
Map.map_leader("gd", "<Cmd>Git diff<CR>", "Diff")
Map.map_leader("gD", "<Cmd>Git diff -- %<CR>", "Diff buffer")
Map.map_leader("gl", "<Cmd>" .. git_log_cmd .. "<CR>", "Log")
Map.map_leader("gL", "<Cmd>" .. git_log_buf_cmd .. "<CR>", "Log buffer")
Map.map_leader("go", "<Cmd>lua MiniDiff.toggle_overlay()<CR>", "Toggle overlay")
Map.map_leader("gs", "<Cmd>lua MiniGit.show_at_cursor()<CR>", "Show at cursor", { "n", "x" })

-- =========================================================
-- MISCELLANEOUS
-- =========================================================

Map.map_leader("or", "<Cmd>lua MiniMisc.resize_window()<CR>", "Resize to default width")
Map.map_leader("ot", "<Cmd>lua MiniTrailspace.trim()<CR>", "Trim trailspace")
Map.map_leader("oz", "<Cmd>lua MiniMisc.zoom()<CR>", "Zoom toggle")

-- =========================================================
-- SESSIONS
-- =========================================================

Map.map_leader("sd", '<Cmd>lua MiniSessions.select("delete")<CR>', "Delete")
Map.map_leader("sn", "<Cmd>lua " .. session_new .. "<CR>", "New")
Map.map_leader("sr", '<Cmd>lua MiniSessions.select("read")<CR>', "Read")
Map.map_leader("sw", "<Cmd>lua MiniSessions.write()<CR>", "Write current")

-- =========================================================
-- VISITS MANAGEMENT
-- =========================================================

Map.map_leader("vc", make_pick_core("", "Core visits (all)"), "Core visits (all)")
Map.map_leader("vC", make_pick_core(nil, "Core visits (cwd)"), "Core visits (cwd)")
Map.map_leader("vv", '<Cmd>lua MiniVisits.add_label("core")<CR>', 'Add "core" label')
Map.map_leader("vV", '<Cmd>lua MiniVisits.remove_label("core")<CR>', 'Remove "core" label')
Map.map_leader("vl", "<Cmd>lua MiniVisits.add_label()<CR>", "Add label")
Map.map_leader("vL", "<Cmd>lua MiniVisits.remove_label()<CR>", "Remove label")

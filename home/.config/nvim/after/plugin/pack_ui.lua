--
-- ============================================================
--  Minimalistic vim.pack UI
-- ============================================================
--
-- Floating dashboard for managing plugins:
--   - update / clean / delete
--   - inspect plugins
--   - view logs
--
-- Command: :Pack
-- Keymap : <leader>pp
-- ------------------------------------------------------------
--
-- Moust of code is taken from reddit user `u/punk8bit`.
-- Reddit post: https://www.reddit.com/r/neovim/comments/1sdatj5/pack_a_simple_vimpack_ui/
-- Link to original code:
-- https://git.cryptomilk.org/users/asn/dotfiles.git/tree/dot_config/nvim/lua/plugins/pack-ui.lua
--
-- ============================================================
--  CORE SETUP
-- ============================================================

local api = vim.api -- Neovim API
local ns = api.nvim_create_namespace("pack_ui") -- highlight namespace
local uv = vim.loop -- libuv (filesystem)
local icons = require("config.icons")

-- ============================================================
--  HIGHLIGHTS
-- ============================================================

local function setup_highlights()
	local links = {
		PackUiHeader = "Title",
		PackUiButton = "Function",
		PackUiPluginLoaded = "String",
		PackUiPluginNotLoaded = "Text",
		PackUiPluginCleanup = "Comment",
		PackUiPluginMissing = "ErrorMsg",
		PackUiVersion = "Number",
		PackUiSectionHeader = "Label",
		PackUiSeparator = "FloatBorder",
		PackUiDetail = "Comment",
		PackUiHelp = "SpecialComment",
	}
	for group, target in pairs(links) do
		api.nvim_set_hl(0, group, { link = target, default = true })
	end
end

-- ============================================================
--  STATE (UI RUNTIME DATA)
-- ============================================================

local state = {
	bufnr = nil,
	winid = nil,
	win_autocmd_id = nil, -- WinClosed autocmd ID
	line_to_plugin = {}, -- line number (1-based) => plugin name
	plugin_lines = {}, -- plugin name => line number (1-based)
	expanded = {}, -- plugin name => bool
	show_help = false,
}

-- ============================================================
--  CACHES (PERFORMANCE)
-- ============================================================

-- Cache of path => installed git tag (false = no tag found)
local tag_cache = {}
local config_cache = nil -- parsed config plugins

-- ============================================================
--  VERSION / GIT HELPERS
-- ============================================================

-- For versioned plugins, return the actual installed tag from git.
-- Results are cached for the session so git is only called once per plugin.
local function get_installed_tag(path)
	if not path then
		return nil
	end
	if tag_cache[path] ~= nil then
		return tag_cache[path] or nil
	end
	local result =
		vim.fn.system("git -C " .. vim.fn.shellescape(path) .. " describe --tags --exact-match HEAD 2>/dev/null")
	if vim.v.shell_error == 0 then
		local tag = vim.trim(result)
		tag_cache[path] = tag
		return tag
	end
	tag_cache[path] = false
	return nil
end

-- ============================================================
--  FILESYSTEM SCANNING
-- ============================================================

-- Get version string from plugin spec
local function get_version_str(p)
	local v = p.spec.version
	if v == nil then
		return ""
	end
	if type(v) == "string" then
		return v
	end
	return tostring(v)
end

local function scan_files(dir)
	local files = {}
	local function scan(path)
		local fd = uv.fs_scandir(path)
		if not fd then
			return
		end
		while true do
			local name, type = uv.fs_scandir_next(fd)
			if not name then
				break
			end
			local full_path = path .. "/" .. name
			if type == "file" and name:match("%.lua$") then
				table.insert(files, full_path)
			elseif type == "directory" then
				scan(full_path)
			end
		end
	end
	scan(dir)
	return files
end

-- ============================================================
--  CONFIG PARSING (DETECT USED PLUGINS)
-- ============================================================

-- Extract plugin names from file content
local function strip_comments(content)
	local result = {}

	for line in content:gmatch("[^\n]*\n?") do
		local cleaned = line:gsub("%-%-.*", "")
		table.insert(result, cleaned)
	end

	return table.concat(result)
end

local function normalize_name(plugin)
	if not plugin or plugin == "" then
		return nil
	end

	plugin = plugin:gsub("^%s+", ""):gsub("%s+$", "")
	plugin = plugin:gsub("/+$", "")
	plugin = plugin:gsub("%.git$", "")

	return plugin:match("([^/]+)$") or plugin
end

local function extract_names_from_content(content)
	local names = {}
	local seen = {}

	content = strip_comments(content)

	local function add_name(raw)
		local name = normalize_name(raw)
		if name and not seen[name] then
			table.insert(names, name)
			seen[name] = true
		end
	end

	----------------------------------------------------------------
	-- 1. Extract and REMOVE add({ ... }) blocks
	----------------------------------------------------------------
	content = content:gsub("[%w_%.]*add%s*%(%s*{(.-)}%s*%)", function(block)
		local name = block:match('name%s*=%s*"([^"]+)"')
		if name then
			add_name(name)
		else
			local src = block:match('src%s*=%s*"([^"]+)"')
			if src then
				add_name(src)
			else
				local first = block:match('"([^"]+)"')
				if first then
					add_name(first)
				end
			end
		end

		return ""
	end)

	----------------------------------------------------------------
	-- 2. Repo.xxx outside tables
	----------------------------------------------------------------
	for plugin in content:gmatch('Repo%.[%w_]+%(%s*"([^"]+)"%s*%)') do
		add_name(plugin)
	end

	----------------------------------------------------------------
	-- 3. add("...") / vim.pack.add("...")
	----------------------------------------------------------------
	for plugin in content:gmatch('[%w_%.]*add%s*%(%s*"([^"]+)"%s*%)') do
		add_name(plugin)
	end

	return names
end

-- Main function: get all plugin names
local function get_plugin_names()
	if config_cache then
		return config_cache
	end

	local plugin_dir = vim.fn.stdpath("config") .. "/plugin"
	local after_plugin_dir = vim.fn.stdpath("config") .. "/after/plugin"
	local init_file = vim.fn.stdpath("config") .. "/init.lua"

	local files = scan_files(plugin_dir)
	for _, f in ipairs(scan_files(after_plugin_dir)) do
		table.insert(files, f)
	end
	table.insert(files, init_file)

	local result = {}

	for _, file in ipairs(files) do
		local f = io.open(file, "r")
		if f then
			local content = f:read("*a")
			f:close()
			for _, name in ipairs(extract_names_from_content(content)) do
				table.insert(result, name)
			end
		end
	end

	config_cache = result
	return result
end

-- ============================================================
--  SORTING
-- ============================================================

-- Sort function
local function sort_by_name(t)
	table.sort(t, function(a, b)
		return a.spec.name < b.spec.name
	end)
end

-- ============================================================
--  UI BUILDING (CONTENT + HIGHLIGHTS)
-- ============================================================

-- Build lines and highlights for the buffer
local function build_content()
	local plugins = vim.pack.get(nil, { info = false })
	local conf_plugins = get_plugin_names()
	local loaded = {}
	local not_loaded = {}
	local to_cleanup = {}

	-- Build lookup table for config plugins
	local conf_lookup = {}
	for _, name in ipairs(conf_plugins) do
		conf_lookup[name] = true
	end

	for _, p in ipairs(plugins) do
		local name = p.spec.name
		if p.active then
			table.insert(loaded, p)
		elseif conf_lookup[name] then
			table.insert(not_loaded, p)
		else
			table.insert(to_cleanup, p)
		end
	end

	sort_by_name(loaded)
	sort_by_name(not_loaded)
	sort_by_name(to_cleanup)

	local lines = {}
	local hls = {} -- { line, col_start, col_end, hl_group }
	local line_to_plugin = {}
	local plugin_lines = {}

	local function add(text, hl)
		local lnum = #lines
		lines[#lines + 1] = text
		if hl then
			table.insert(hls, { lnum, 0, #text, hl })
		end
	end

	local function add_hl(lnum, col_start, col_end, hl)
		table.insert(hls, { lnum, col_start, col_end, hl })
	end

	-- Header
	local header = string.format(" vim.pack -- %d plugins | %d loaded", #plugins, #loaded)
	add(header, "PackUiHeader")

	-- Separator (fill the window width minus the leading space)
	local win_width = state.winid and vim.api.nvim_win_get_width(state.winid) or 80
	local sep = " " .. string.rep("─", win_width - 1)
	add(sep, "PackUiSeparator")

	-- Action bar
	local bar = " [U]pdate All  [u] Update  [X] Clean  [D]elete  [L] Log  [?] Help"
	add(bar)
	-- Highlight the bracket keys (gmatch () captures are 1-based;
	-- the end capture points one past the match, which is exactly
	-- the exclusive end_col that extmarks expect)
	local lnum = #lines - 1
	for s, e in bar:gmatch("()%[.-%]()") do
		add_hl(lnum, s - 1, e - 1, "PackUiButton")
	end

	-- Help section (toggled)
	if state.show_help then
		add("")
		add(" Keymaps:", "PackUiHelp")
		add("   U       Update all plugins", "PackUiHelp")
		add("   u       Update plugin under cursor", "PackUiHelp")
		add("   X       Clean non-active plugins", "PackUiHelp")
		add("   D       Delete plugin under cursor (non-active only)", "PackUiHelp")
		add("   L       Open update log file", "PackUiHelp")
		add("   <CR>    Toggle plugin details", "PackUiHelp")
		add("   ]]      Jump to next plugin", "PackUiHelp")
		add("   [[      Jump to previous plugin", "PackUiHelp")
		add("   q/Esc   Close window", "PackUiHelp")
	end

	-- Compute max name width for alignment
	local max_name = 0
	for _, p in ipairs(plugins) do
		max_name = math.max(max_name, #p.spec.name)
	end

	-- Render a plugin line
	-- Format: '   %s %s%s%s' => 3 spaces, icon, 1 space, name, pad, version
	-- Byte offsets: icon starts at 3, name starts at 3 + #icon_bytes + 1
	local function render_plugin(p, icon, hl_group)
		local name = p.spec.name
		local pad = string.rep(" ", max_name - #name + 2)
		local version = get_version_str(p)
		local tag = p.spec.version and get_installed_tag(p.path) or nil
		local rev_short = p.rev and p.rev:sub(1, 7) or ""

		local ver_display = tag or (rev_short ~= "" and rev_short or version)
		local line = string.format("   %s %s%s%s", icon, name, pad, ver_display)
		local lnum_cur = #lines
		add(line)

		-- Byte offsets for highlights
		local icon_bytes = #icon
		local icon_start = 3
		local name_start = icon_start + icon_bytes + 1

		add_hl(lnum_cur, icon_start, icon_start + icon_bytes, hl_group)
		add_hl(lnum_cur, name_start, name_start + #name, hl_group)
		if #ver_display > 0 then
			local ver_start = name_start + #name + #pad
			add_hl(lnum_cur, ver_start, ver_start + #ver_display, "PackUiVersion")
		end

		-- Track plugin position (1-based line number for cursor operations)
		line_to_plugin[lnum_cur + 1] = name
		plugin_lines[name] = lnum_cur + 1

		-- Expanded details
		if state.expanded[name] then
			local details = {
				string.format("     Path:    %s", p.path),
				string.format("     Source:  %s", p.spec.src),
			}
			if p.rev then
				table.insert(details, string.format("     Rev:     %s", p.rev))
			end
			for _, d in ipairs(details) do
				add(d, "PackUiDetail")
			end
		end
	end

	-- Loaded section
	add("")
	add(string.format(" Loaded (%d)", #loaded), "PackUiSectionHeader")
	for _, p in ipairs(loaded) do
		render_plugin(p, icons.pack.loaded, "PackUiPluginLoaded")
	end

	-- Not Loaded section
	if #not_loaded > 0 then
		add("")
		add(string.format(" Not Loaded (%d)", #not_loaded), "PackUiSectionHeader")
		for _, p in ipairs(not_loaded) do
			render_plugin(p, icons.pack.not_loaded, "PackUiPluginNotLoaded")
		end
	end

	if #to_cleanup > 0 then
		add("")
		add(string.format(" To Cleanup (%d)", #to_cleanup), "PackUiSectionHeader")
		for _, p in ipairs(to_cleanup) do
			render_plugin(p, icons.pack.to_cleanup, "PackUiPluginCleanup")
		end
	end

	state.line_to_plugin = line_to_plugin
	state.plugin_lines = plugin_lines

	return lines, hls
end

-- ============================================================
--  RENDERING
-- ============================================================

-- Render content into the buffer
local function render()
	if not state.bufnr or not api.nvim_buf_is_valid(state.bufnr) then
		return
	end

	local lines, hls = build_content()

	vim.bo[state.bufnr].modifiable = true
	api.nvim_buf_set_lines(state.bufnr, 0, -1, false, lines)
	vim.bo[state.bufnr].modifiable = false
	vim.bo[state.bufnr].modified = false

	-- Apply highlights
	api.nvim_buf_clear_namespace(state.bufnr, ns, 0, -1)
	for _, hl in ipairs(hls) do
		api.nvim_buf_set_extmark(state.bufnr, ns, hl[1], hl[2], {
			end_col = hl[3],
			hl_group = hl[4],
		})
	end
end

-- ============================================================
--  CURSOR / NAVIGATION
-- ============================================================

-- Get plugin name at cursor
local function plugin_at_cursor()
	if not state.winid or not api.nvim_win_is_valid(state.winid) then
		return nil
	end
	local row = api.nvim_win_get_cursor(state.winid)[1]
	return state.line_to_plugin[row]
end

-- Jump to next/prev plugin line
local function jump_plugin(direction)
	if not state.winid or not api.nvim_win_is_valid(state.winid) then
		return
	end
	local row = api.nvim_win_get_cursor(state.winid)[1]

	-- Collect sorted plugin line numbers
	local plines = {}
	for lnum, _ in pairs(state.line_to_plugin) do
		table.insert(plines, lnum)
	end
	table.sort(plines)

	if direction > 0 then
		for _, lnum in ipairs(plines) do
			if lnum > row then
				api.nvim_win_set_cursor(state.winid, { lnum, 0 })
				return
			end
		end
		-- Wrap around
		if #plines > 0 then
			api.nvim_win_set_cursor(state.winid, { plines[1], 0 })
		end
	else
		for i = #plines, 1, -1 do
			if plines[i] < row then
				api.nvim_win_set_cursor(state.winid, { plines[i], 0 })
				return
			end
		end
		-- Wrap around
		if #plines > 0 then
			api.nvim_win_set_cursor(state.winid, { plines[#plines], 0 })
		end
	end
end

-- ============================================================
--  WINDOW MANAGEMENT
-- ============================================================

-- Close the floating window
local function close()
	-- Remove autocmd first to prevent it from corrupting state on re-open
	if state.win_autocmd_id then
		pcall(api.nvim_del_autocmd, state.win_autocmd_id)
		state.win_autocmd_id = nil
	end
	if state.winid and api.nvim_win_is_valid(state.winid) then
		api.nvim_win_close(state.winid, true)
	end
	-- Buffer has bufhidden=wipe, so it is wiped when the window closes.
	-- No need to explicitly delete it.
	state.winid = nil
	state.bufnr = nil
	state.expanded = {}
	state.show_help = false
end

-- Forward declaration so keymap closures can reference open() before it is
-- defined (Lua closures capture locals by reference, but the local must be
-- declared in an enclosing scope at the point where the closure is created).
local open

-- ============================================================
--  KEYMAPS / ACTIONS
-- ============================================================

-- Setup buffer keymaps (buffer-local, survive re-focus since buffer persists)
local function setup_keymaps()
	local buf = state.bufnr
	local opts = { buffer = buf, silent = true, nowait = true }

	-- Close
	vim.keymap.set("n", "q", close, opts)
	vim.keymap.set("n", "<Esc>", close, opts)

	-- Update all
	vim.keymap.set("n", "U", function()
		close()
		vim.pack.update()
	end, opts)

	-- Update plugin under cursor
	vim.keymap.set("n", "u", function()
		local name = plugin_at_cursor()
		if name then
			close()
			vim.pack.update({ name })
		end
	end, opts)

	-- Clean non-active plugins
	vim.keymap.set("n", "X", function()
		-- Get all plugins
		local all_plugins = vim.pack.get(nil, { info = false })

		-- Build a lookup table for config plugins
		local conf_plugins = get_plugin_names()
		local conf_lookup = {}
		for _, name in ipairs(conf_plugins) do
			conf_lookup[name] = true
		end

		-- Filter for "to cleanup": inactive AND not in config
		local to_clean = {}
		for _, p in ipairs(all_plugins) do
			local name = p.spec.name
			if not p.active and not conf_lookup[name] then
				table.insert(to_clean, name)
			end
		end

		if #to_clean == 0 then
			vim.notify("vim.pack: nothing to clean", vim.log.levels.INFO)
			return
		end

		-- Ask for confirmation
		local msg = string.format(
			"Remove %d non-active plugin(s) not in config?\n\n%s",
			#to_clean,
			table.concat(to_clean, "\n")
		)
		local choice = vim.fn.confirm(msg, "&Yes\n&No", 2, "Question")
		if choice == 1 then
			close() -- close your plugin buffer if needed
			local ok, err = pcall(vim.pack.del, to_clean)
			if ok then
				vim.notify(string.format("vim.pack: removed %d plugin(s)", #to_clean), vim.log.levels.INFO)
			else
				vim.notify("vim.pack: " .. tostring(err), vim.log.levels.ERROR)
			end
		end
	end, opts)

	-- Delete plugin under cursor
	vim.keymap.set("n", "D", function()
		local name = plugin_at_cursor()
		if not name then
			return
		end

		-- Check if active
		local ok, pdata = pcall(vim.pack.get, { name }, { info = false })
		if not ok then
			vim.notify(string.format("vim.pack: %s is not installed", name), vim.log.levels.WARN)
			return
		end
		if #pdata > 0 and pdata[1].active then
			vim.notify(string.format("vim.pack: %s is active, remove from config first", name), vim.log.levels.WARN)
			return
		end

		local choice = vim.fn.confirm(string.format("Delete plugin %s?", name), "&Yes\n&No", 2, "Question")
		if choice == 1 then
			close()
			local del_ok, err = pcall(vim.pack.del, { name })
			if del_ok then
				vim.notify(string.format("vim.pack: removed %s", name), vim.log.levels.INFO)
			else
				vim.notify("vim.pack: " .. tostring(err), vim.log.levels.ERROR)
			end
		end
	end, opts)

	-- Open log
	vim.keymap.set("n", "L", function()
		close()
		local log_path = vim.fs.joinpath(vim.fn.stdpath("log"), "nvim-pack.log")
		if vim.uv.fs_stat(log_path) then
			vim.cmd.edit(log_path)
		else
			vim.notify("vim.pack: no log file yet", vim.log.levels.INFO)
		end
	end, opts)

	-- Toggle details
	vim.keymap.set("n", "<CR>", function()
		local name = plugin_at_cursor()
		if name then
			state.expanded[name] = not state.expanded[name]
			render()
			-- Restore cursor to the plugin line
			if state.plugin_lines[name] then
				api.nvim_win_set_cursor(state.winid, { state.plugin_lines[name], 0 })
			end
		end
	end, opts)

	-- Navigation
	vim.keymap.set("n", "]]", function()
		jump_plugin(1)
	end, opts)
	vim.keymap.set("n", "[[", function()
		jump_plugin(-1)
	end, opts)

	-- Help toggle
	vim.keymap.set("n", "?", function()
		state.show_help = not state.show_help
		render()
	end, opts)
end

-- ============================================================
--  OPEN WINDOW
-- ============================================================

-- Open the Pack UI
open = function()
	-- If already open, focus it
	if state.winid and api.nvim_win_is_valid(state.winid) then
		api.nvim_set_current_win(state.winid)
		return
	end

	setup_highlights()

	-- Create buffer
	state.bufnr = api.nvim_create_buf(false, true)
	vim.bo[state.bufnr].buftype = "nofile"
	vim.bo[state.bufnr].bufhidden = "wipe"
	vim.bo[state.bufnr].swapfile = false
	vim.bo[state.bufnr].filetype = "nvim-pack"

	-- Calculate window size
	local cols = vim.o.columns
	local lines = vim.o.lines
	local width = math.min(cols - 4, math.max(math.floor(cols * 0.8), 60))
	local height = math.min(lines - 4, math.max(math.floor(lines * 0.7), 20))
	local row = math.floor((lines - height) / 2)
	local col = math.floor((cols - width) / 2)

	-- Create floating window
	state.winid = api.nvim_open_win(state.bufnr, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = " vim.pack ",
		title_pos = "center",
	})

	vim.wo[state.winid].cursorline = true
	vim.wo[state.winid].wrap = false

	-- Render content
	render()

	-- Setup keymaps
	setup_keymaps()

	-- Track WinClosed to clean up state if the window is closed externally
	-- (e.g., :quit, <C-w>c). Store the autocmd ID so close() can remove it
	-- to prevent races when re-opening immediately after an explicit close.
	local captured_winid = state.winid
	state.win_autocmd_id = api.nvim_create_autocmd("WinClosed", {
		buffer = state.bufnr,
		once = true,
		callback = function(ev)
			-- Only clean up if the closed window matches the one we opened
			if vim._tointeger(ev.match) ~= captured_winid then
				return
			end
			state.winid = nil
			state.bufnr = nil
			state.win_autocmd_id = nil
			state.expanded = {}
			state.show_help = false
		end,
	})
end

-- ============================================================
--  COMMANDS / KEYMAP ENTRYPOINT
-- ============================================================

-- Register :Pack command
vim.api.nvim_create_user_command("Pack", function()
	open()
end, { desc = "Open vim.pack plugin manager UI" })
Map.map_leader("pp", open, "vim.pack manager")

--[[
Shows a list of available color themes by scanning
all files under <nvim_config>/lua/plugin/colorscheme for
the marker `-- THEMES_AVAILABLE:`. Lets you persist a choice
by editing init.lua (vim.g.colorscheme)
and then asks user to restart Neovim to apply the colorscheme.

Usage:
  :ThemesAvailable

Controls:
  <CR>  → Persist to setup.lua
  q     → Close window
  <Esc> → Close window
]]

-- Main function to show available themes in a floating window
local function show_themes_available()
	-- Neovim config directory
	local config_dir = vim.fn.stdpath("config")
	-- Folder where theme files are located
	local themes_dir = config_dir .. "/plugin/70_colorscheme.lua"
	-- File where the chosen theme is persisted
	local init_file = config_dir .. "/init.lua"

	-- Function to update vim.g.colorscheme in setup.lua
	local function persist_theme_to_setup(theme)
		-- Check if setup.lua exists
		if vim.fn.filereadable(init_file) == 0 then
			vim.notify("init.lua not found at: " .. init_file, vim.log.levels.ERROR, { title = "Theme Persist" })
			return false
		end

		-- Read all lines from setup.lua
		local lines = vim.fn.readfile(init_file)
		if not lines then
			vim.notify("Failed to read init.lua", vim.log.levels.ERROR, { title = "Theme Persist" })
			return false
		end

		-- Flag to check if theme line was replaced
		local replaced = false
		local pattern = [[^%s*vim%.g%.colorscheme%s*=%s*['"].*['"]%s*$]]
		local replacement = ([[vim.g.colorscheme = %q]]):format(theme)

		-- Search for existing vim.g.colorscheme and replace
		for i, l in ipairs(lines) do
			if l:match(pattern) then
				lines[i] = replacement
				replaced = true
				break
			end
		end

		-- If no existing theme line, append it at the end
		if not replaced then
			table.insert(lines, "")
			table.insert(lines, "-- Added by ThemesAvailable")
			table.insert(lines, replacement)
		end

		-- Write updated lines back to init.lua
		local ok, err = pcall(vim.fn.writefile, lines, init_file)
		if not ok then
			vim.notify("Failed to write init.lua: " .. (err or ""), vim.log.levels.ERROR, { title = "Theme Persist" })
			return false
		end

		return true
	end

	-- ===============================
	-- Step 1: Collect all available themes
	-- ===============================
	local themes, seen = {}, {}
	-- Find all files containing marker "-- THEMES_AVAILABLE:"
	local grep_files = vim.fn.systemlist({ "grep", "-l", "THEMES_AVAILABLE:", "-r", themes_dir })

	-- No themes found? Warn user
	if vim.v.shell_error ~= 0 or vim.tbl_isempty(grep_files) then
		vim.notify("No THEMES_AVAILABLE marker found.", vim.log.levels.WARN)
		return
	end

	-- Parse each file for theme names
	for _, filepath in ipairs(grep_files) do
		local lines = vim.fn.readfile(filepath)
		local in_marker = false
		for _, line in ipairs(lines) do
			-- Detect the marker line
			if line:match("THEMES_AVAILABLE:") then
				in_marker = true
			elseif in_marker then
				-- Extract lines starting with comment "-- "
				local theme_line = line:match("^%s*%-%-%s*(.+)")
				if theme_line and theme_line ~= "" then
					-- Remove trailing comma if any
					theme_line = theme_line:gsub(",%s*$", "")
					-- Split by comma and add unique themes
					for theme in theme_line:gmatch("[^,%s]+") do
						local key = theme:lower()
						if not seen[key] then
							seen[key] = true
							table.insert(themes, theme)
						end
					end
				else
					-- Stop collecting when the comment block ends
					in_marker = false
				end
			end
		end
	end

	-- Warn if no themes were parsed
	if #themes == 0 then
		vim.notify("No themes parsed from THEMES_AVAILABLE.", vim.log.levels.WARN)
		return
	end

	-- Sort themes alphabetically and add header lines
	table.sort(themes)
	table.insert(themes, 1, "Available Themes:")
	table.insert(themes, 2, string.rep("─", 30))

	-- ===============================
	-- Step 2: Create floating window
	-- ===============================
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, themes)

	local width = math.floor(vim.o.columns * 0.3)
	local height = math.min(#themes + 2, math.floor(vim.o.lines * 0.5))
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})

	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].modifiable = false

	-- ===============================
	-- Step 3: Keymaps for floating window
	-- ===============================
	-- Close window mappings
	vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, nowait = true })
	vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, nowait = true })

	-- Persist theme on <CR> (Enter)
	vim.keymap.set("n", "<CR>", function()
		local old_theme = vim.g.colorscheme
		local theme = vim.api.nvim_get_current_line()

		-- Ignore header lines
		if theme:match("^Available") or theme:match("^─") then
			return
		end
		-- Persist selected theme
		if not persist_theme_to_setup(theme) then
			return
		end

		-- Close floating window
		vim.cmd("close")

		if old_theme:find("^github_") and theme:find("^github_") then
			old_theme = nil
		elseif old_theme:find("^github_") then
			old_theme = "github_theme"
		end

		vim.cmd.colorscheme("default")
		vim.pack.del({ old_theme }, { force = true })
		vim.cmd("source " .. init_file)
		vim.cmd("restart")
	end, { buffer = buf, nowait = true })
end

-- ===============================
-- Command: Show theme picker
-- ===============================
vim.api.nvim_create_user_command("ThemesAvailable", show_themes_available, {})

-- ===============================
-- Keymap: Show theme picker
-- ===============================
vim.keymap.set("n", "<leader\\t", "<cmd>ThemesAvailable<cr>", { desc = "Change theme" })

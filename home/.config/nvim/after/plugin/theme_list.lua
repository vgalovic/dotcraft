--[[
  Shows a list of available color themes by scanning
  all files under ~/.config/nvim/lua/plugin/colorscheme for
  the marker `-- THEMES_AVAILABLE:`.

  It collects theme names from the commented lines below that marker,
  parses them, sorts them alphabetically, and displays them
  in a floating window.

  Usage:
    :ThemesAvailable

  Note:
  - Theme lines must start with `-- ` after the marker line.
  - Themes can be comma separated and span multiple lines.
]]

local function show_themes_available()
	-- Path to colorscheme folder
	local themes_dir = vim.fn.expand("$HOME/.config/nvim/lua/plugin/colorscheme")
	local themes = {}
	local seen = {}

	-- Find all files containing the marker line
	local grep_files = vim.fn.systemlist({
		"grep",
		"-l",
		"THEMES_AVAILABLE:",
		"-r",
		themes_dir,
	})

	if vim.v.shell_error ~= 0 or vim.tbl_isempty(grep_files) then
		vim.notify("No THEMES_AVAILABLE marker found.", vim.log.levels.WARN)
		return
	end

	-- Parse each file for theme names
	for _, filepath in ipairs(grep_files) do
		local lines = vim.fn.readfile(filepath)
		local in_marker = false

		for _, line in ipairs(lines) do
			if line:match("THEMES_AVAILABLE:") then
				in_marker = true
			elseif in_marker then
				-- Check if line starts with comment marker and capture rest
				local theme_line = line:match("^%s*%-%-%s*(.+)")
				if theme_line and theme_line ~= "" then
					-- Remove trailing commas and whitespace
					theme_line = theme_line:gsub(",%s*$", "")
					-- Split by comma and add themes uniquely
					for theme in theme_line:gmatch("[^,%s]+") do
						if not seen[theme] then
							seen[theme] = true
							table.insert(themes, theme)
						end
					end
				else
					-- Stop collecting when line is empty or no longer a comment
					in_marker = false
				end
			end
		end
	end

	if #themes == 0 then
		vim.notify("No themes parsed from THEMES_AVAILABLE.", vim.log.levels.WARN)
		return
	end

	-- Sort themes alphabetically
	table.sort(themes)

	-- Create floating buffer and window
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
end

-- Create user command to trigger the function
vim.api.nvim_create_user_command("ThemesAvailable", show_themes_available, {})

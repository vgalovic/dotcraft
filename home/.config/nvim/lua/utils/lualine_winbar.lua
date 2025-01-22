local M = {}
-- Load the devicons module
local devicons = require("nvim-web-devicons")

-- Function to get the file name with its icon
M.get_file = function()
	local filename = vim.fn.expand("%:t") -- Get the file name
	local file_extension = vim.fn.expand("%:e") -- Get the file extension
	-- Get the icon for the file type
	local icon = devicons.get_icon(filename, file_extension) or " "
	return icon .. " " .. filename -- Return the icon and the file name
end

-- Function to get the relative path of the current file with icons and handle ~ as a directory
M.get_relative_path = function()
	local file_path = vim.fn.expand("%:p") -- Get the full path of the current file
	local cwd = vim.fn.getcwd() -- Get the current working directory
	local relative_path = vim.fn.fnamemodify(file_path, ":~:.") -- Convert to relative path

	local path_parts = {}
	local current_path = cwd -- Start with the current working directory

	-- Handle the case for '~' (home directory) as a directory
	if relative_path:sub(1, 1) == "~" then
		relative_path = "~" .. relative_path:sub(2) -- Ensure it remains as '~'
	end

	-- Loop over the parts of the relative path
	for part in relative_path:gmatch("[^/]+") do
		current_path = current_path .. "/" .. part -- Build the path as we go

		local icon
		-- Check if the part is a directory or file
		if part == "~" or vim.fn.isdirectory(current_path) == 1 then
			icon = " "
		else
			local extension = part:match("%.(%w+)$") -- Extract file extension
			icon = devicons.get_icon(part, extension, { default = true }) or " "
		end

		-- Add the icon and the part to the path parts table
		table.insert(path_parts, icon .. " " .. part)
	end

	return table.concat(path_parts, " > ")
end

-- Function to get the current time in HH:MM format
M.get_time = function()
	return os.date("%H:%M")
end

-- Function to get the current date in dd.MM.yyyy format
M.get_date = function()
	return os.date("%d.%m.%Y")
end

return M

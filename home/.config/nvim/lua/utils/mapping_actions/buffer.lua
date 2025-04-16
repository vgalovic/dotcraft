---@diagnostic disable: param-type-mismatch
---@class utils.mapping_actions.buffer

local M = {}

-- If it is a new file, prompt for a filename and save it, otherwise, save the current file
local SaveAs = function()
	local current_file = vim.fn.expand("%:p") -- Get the current file path
	if current_file ~= "" then
		vim.cmd("write") -- If a file already exists, just save it
	else
		vim.ui.input({ prompt = "Save As: " }, function(new_file)
			if not new_file or new_file == "" then
				vim.notify("No filename provided. Save canceled.", vim.log.levels.WARN, { title = "Save" })
				return
			end

			-- Check if the file exists
			if vim.fn.filereadable(new_file) == 1 then
				vim.ui.input({ prompt = "File exists. Overwrite? (y/N): " }, function(confirm)
					if confirm and confirm:lower() == "y" then
						local ok, err = pcall(vim.cmd, "write! " .. vim.fn.fnameescape(new_file))
						if not ok then
							vim.notify("Error saving file: " .. err, vim.log.levels.ERROR, { title = "Save" })
						else
							vim.notify("File saved successfully.", vim.log.levels.INFO, { title = "Save" })
						end
					else
						vim.notify("File not saved.", vim.log.levels.WARN, { title = "Save" })
					end
				end)
			else
				-- Save to the new file if it doesn't exist
				local ok, err = pcall(vim.cmd, "write! " .. vim.fn.fnameescape(new_file))
				if not ok then
					vim.notify("Error saving file: " .. err, vim.log.levels.ERROR, { title = "Save" })
				else
					vim.notify("File saved successfully.", vim.log.levels.INFO, { title = "Save" })
				end
			end
		end)
	end
end

-- Save on open empty buffer
vim.api.nvim_create_user_command("NewFile", function()
	vim.cmd("enew")
	SaveAs()
end, {
	nargs = 0,
	desc = "Creates new file and prompt a popup to save it",
})

-- Save the current buffer
M.save = function()
	-- Check if the current mode is insert mode
	local mode = vim.api.nvim_get_mode().mode
	if mode == "i" then
		-- Save and return to insert mode
		SaveAs()
		vim.cmd("startinsert")
	else
		-- Just save
		SaveAs()
	end
end

-- Delete all buffers except the current one
M.delete_other_buffers = function()
	local current_buf = vim.api.nvim_get_current_buf() -- Get the current buffer number
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) then
			vim.api.nvim_buf_delete(buf, { force = true }) -- Delete the buffer
		end
	end
end

return M

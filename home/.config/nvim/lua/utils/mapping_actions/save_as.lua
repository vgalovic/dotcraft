---@diagnostic disable: param-type-mismatch
---@class save_as

local M = {}

-- If it is a new file, prompt for a filename and save it, otherwise, save the current file
M.SaveAs = function()
	local current_file = vim.fn.expand("%:p") -- Get the current file path
	if current_file ~= "" then
		vim.cmd("write") -- If a file already exists, just save it
	else
		vim.ui.input({ prompt = " Save As: " }, function(new_file)
			if not new_file or new_file == "" then
				print("No filename provided. Save canceled.")
				return
			end

			-- Check if the file exists
			if vim.fn.filereadable(new_file) == 1 then
				vim.ui.input({ prompt = "󰽂 File exists. Overwrite? (y/N): " }, function(confirm)
					if confirm and confirm:lower() == "y" then
						---@diagnostic disable: assign-type-mismatch
						local ok, err = pcall(vim.cmd, "write! " .. vim.fn.fnameescape(new_file))
						if not ok then
							print("Error saving file: " .. err)
						else
							print("File saved successfully.")
						end
					else
						print("Save canceled.")
					end
				end)
			else
				-- Save to the new file if it doesn't exist
				local ok, err = pcall(vim.cmd, "write! " .. vim.fn.fnameescape(new_file))
				if not ok then
					print("Error saving file: " .. err)
				else
					print("File saved successfully.")
				end
			end
		end)
	end
end

return M

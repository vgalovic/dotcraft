function SaveAs()
	-- Get the current file path of the active buffer
	local current_file = vim.fn.expand("%:p")
	local new_file

	-- If the buffer has a file name, save it directly
	if current_file ~= "" then
		vim.cmd("write")
	else
		-- Prompt for a new file name if the buffer is unsaved
		new_file = vim.fn.input("Save As: ")

		-- Check if the user entered a valid new file name
		if new_file and new_file ~= "" then
			-- Confirm overwrite only if the file already exists
			if vim.fn.filereadable(new_file) == 1 then
				local confirm = vim.fn.input("File exists. Overwrite? (y/N): ")
				if confirm:lower() ~= "y" then
					print("Save canceled.")
					return
				end
			end
			-- Save the buffer to the specified new file
			vim.cmd("write! " .. new_file)
		else
			print("No filename provided.")
		end
	end
end

function FindAndReplaceConfirm()
	-- Prompt for the text to find
	local old_text = vim.fn.input("Find: ")
	if old_text and old_text ~= "" then
		-- Prompt for the replacement text
		local new_text = vim.fn.input("Replace with: ")
		if new_text and new_text ~= "" then
			-- Escape the old and new text to handle special characters
			local escaped_old_text = vim.fn.escape(old_text, "/")
			local escaped_new_text = vim.fn.escape(new_text, "/")
			vim.cmd(":%s/" .. escaped_old_text .. "/" .. escaped_new_text .. "/gc") -- Global replace with confirmation
		else
			vim.notify("Replacement text cannot be empty", vim.log.levels.WARN)
		end
	else
		vim.notify("Find text cannot be empty", vim.log.levels.WARN)
	end
end

function FindAndReplaceAll()
	-- Prompt for the text to find
	local old_text = vim.fn.input("Find: ")
	if old_text and old_text ~= "" then
		-- Prompt for the replacement text
		local new_text = vim.fn.input("Replace with: ")
		if new_text and new_text ~= "" then
			-- Escape the old and new text to handle special characters
			local escaped_old_text = vim.fn.escape(old_text, "/")
			local escaped_new_text = vim.fn.escape(new_text, "/")
			vim.cmd(":%s/" .. escaped_old_text .. "/" .. escaped_new_text .. "/g") -- Global replace without confirmation
		else
			vim.notify("Replacement text cannot be empty", vim.log.levels.WARN)
		end
	else
		vim.notify("Find text cannot be empty", vim.log.levels.WARN)
	end
end

function FindAndDeleteConfirm()
	-- Prompt for the text to find and delete
	local old_text = vim.fn.input("Find and delete: ")
	if old_text and old_text ~= "" then
		-- Escape the old text to handle special characters
		local escaped_old_text = vim.fn.escape(old_text, "/")
		-- Execute the deletion command with confirmation
		vim.cmd(":%s/" .. escaped_old_text .. "//gc") -- 'g' for global, 'c' for confirmation
	else
		vim.notify("Find text cannot be empty", vim.log.levels.WARN)
	end
end

function FindAndDeleteAll()
	-- Prompt for the text to find and delete
	local old_text = vim.fn.input("Find and delete: ")
	if old_text and old_text ~= "" then
		-- Escape the old text to handle special characters
		local escaped_old_text = vim.fn.escape(old_text, "/")
		-- Execute the deletion command with confirmation
		vim.cmd(":%s/" .. escaped_old_text .. "//g") -- 'g' for global, 'c' for confirmation
	else
		vim.notify("Find text cannot be empty", vim.log.levels.WARN)
	end
end

vim.api.nvim_create_user_command("SaveAs", SaveAs, {})
vim.api.nvim_create_user_command("FindAndReplaceConfirm", FindAndReplaceConfirm, {})
vim.api.nvim_create_user_command("FindAndReplaceAll", FindAndReplaceAll, {})
vim.api.nvim_create_user_command("FindAndDeleteConfirm", FindAndReplaceConfirm, {})
vim.api.nvim_create_user_command("FindAndReplaceAll", FindAndDeleteAll, {})

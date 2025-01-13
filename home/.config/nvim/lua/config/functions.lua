function ToggleTheme()
	if vim.opt.background:get() == "dark" then
		vim.opt.background = "light"
	else
		vim.opt.background = "dark"
	end
end

function SaveAs()
	local current_file = vim.fn.expand("%:p")
	if current_file ~= "" then
		vim.cmd("write")
	else
		vim.ui.input({ prompt = " Save As: " }, function(new_file)
			if new_file and new_file ~= "" then
				if vim.fn.filereadable(new_file) == 1 then
					vim.ui.input({ prompt = "󰽂 File exists. Overwrite? (y/N): " }, function(confirm)
						if confirm and confirm:lower() == "y" then
							vim.cmd("write! " .. new_file)
						else
							print("Save canceled.")
						end
					end)
				else
					vim.cmd("write! " .. new_file)
				end
			else
				print("No filename provided.")
			end
		end)
	end
end

function FindAndReplaceConfirm()
	vim.ui.input({ prompt = "  Find: " }, function(old_text)
		if old_text and old_text ~= "" then
			vim.ui.input({ prompt = " Replace with: " }, function(new_text)
				if new_text and new_text ~= "" then
					local escaped_old_text = vim.fn.escape(old_text, "/")
					local escaped_new_text = vim.fn.escape(new_text, "/")
					vim.cmd(":%s/" .. escaped_old_text .. "/" .. escaped_new_text .. "/gc")
				else
					vim.notify("Replacement text cannot be empty", vim.log.levels.WARN)
				end
			end)
		else
			vim.notify("Find text cannot be empty", vim.log.levels.WARN)
		end
	end)
end

function FindAndReplaceAll()
	vim.ui.input({ prompt = "  Find: " }, function(old_text)
		if old_text and old_text ~= "" then
			vim.ui.input({ prompt = " Replace with: " }, function(new_text)
				if new_text and new_text ~= "" then
					local escaped_old_text = vim.fn.escape(old_text, "/")
					local escaped_new_text = vim.fn.escape(new_text, "/")
					vim.cmd(":%s/" .. escaped_old_text .. "/" .. escaped_new_text .. "/g")
				else
					vim.notify("Replacement text cannot be empty", vim.log.levels.WARN)
				end
			end)
		else
			vim.notify("Find text cannot be empty", vim.log.levels.WARN)
		end
	end)
end

function FindAndDeleteConfirm()
	vim.ui.input({ prompt = "󰆴 Find and delete: " }, function(old_text)
		if old_text and old_text ~= "" then
			local escaped_old_text = vim.fn.escape(old_text, "/")
			vim.cmd(":%s/" .. escaped_old_text .. "//gc")
		else
			vim.notify("Find text cannot be empty", vim.log.levels.WARN)
		end
	end)
end

function FindAndDeleteAll()
	vim.ui.input({ prompt = "󰆴 Find and delete: " }, function(old_text)
		if old_text and old_text ~= "" then
			local escaped_old_text = vim.fn.escape(old_text, "/")
			vim.cmd(":%s/" .. escaped_old_text .. "//g")
		else
			vim.notify("Find text cannot be empty", vim.log.levels.WARN)
		end
	end)
end

vim.api.nvim_create_user_command("ToggleTheme", ToggleTheme, {})
vim.api.nvim_create_user_command("SaveAs", SaveAs, {})
vim.api.nvim_create_user_command("FindAndReplaceConfirm", FindAndReplaceConfirm, {})
vim.api.nvim_create_user_command("FindAndReplaceAll", FindAndReplaceAll, {})
vim.api.nvim_create_user_command("FindAndDeleteConfirm", FindAndDeleteConfirm, {})
vim.api.nvim_create_user_command("FindAndDeleteAll", FindAndDeleteAll, {})

local M = {}

M.FindAndReplaceConfirm = function()
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

M.FindAndReplaceAll = function()
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

M.FindAndDeleteConfirm = function()
	vim.ui.input({ prompt = "󰆴 Find and delete: " }, function(old_text)
		if old_text and old_text ~= "" then
			local escaped_old_text = vim.fn.escape(old_text, "/")
			vim.cmd(":%s/" .. escaped_old_text .. "//gc")
		else
			vim.notify("Find text cannot be empty", vim.log.levels.WARN)
		end
	end)
end

M.FindAndDeleteAll = function()
	vim.ui.input({ prompt = "󰆴 Find and delete: " }, function(old_text)
		if old_text and old_text ~= "" then
			local escaped_old_text = vim.fn.escape(old_text, "/")
			vim.cmd(":%s/" .. escaped_old_text .. "//g")
		else
			vim.notify("Find text cannot be empty", vim.log.levels.WARN)
		end
	end)
end

return M

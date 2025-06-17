-- Find/Replace/Delete with optional confirmation in the current buffer

local function input_text(prompt, callback)
	vim.ui.input({ prompt = prompt }, function(text)
		if text and text ~= "" then
			callback(text)
		else
			vim.notify(prompt .. " cannot be empty", vim.log.levels.WARN)
		end
	end)
end

local function find_and_replace(confirm)
	input_text("Find: ", function(old_text)
		input_text("Replace with: ", function(new_text)
			local escaped_old = vim.fn.escape(old_text, "/")
			local escaped_new = vim.fn.escape(new_text, "/")
			local flag = confirm and "gc" or "g"
			vim.cmd(":%s/" .. escaped_old .. "/" .. escaped_new .. "/" .. flag)
		end)
	end)
end

local function find_and_delete(confirm)
	input_text("Find and delete: ", function(old_text)
		local escaped = vim.fn.escape(old_text, "/")
		local flag = confirm and "gc" or "g"
		vim.cmd(":%s/" .. escaped .. "//" .. flag)
	end)
end

-- Keymaps
local function map(mode, lhs, rhs, opts)
	opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
	vim.keymap.set(mode, lhs, rhs, opts)
end

-- [[ Find and Replace ]]
map({ "n", "v" }, "<leader>ra", function()
	find_and_replace(false)
end, { desc = "Find and replace all occurrences" })

map({ "n", "v" }, "<leader>rc", function()
	find_and_replace(true)
end, { desc = "Find and replace with confirmation" })

-- [[ Find and Delete ]]
map({ "n", "v" }, "<leader>da", function()
	find_and_delete(false)
end, { desc = "Find and delete all occurrences" })

map({ "n", "v" }, "<leader>dc", function()
	find_and_delete(true)
end, { desc = "Find and delete with confirmation" })

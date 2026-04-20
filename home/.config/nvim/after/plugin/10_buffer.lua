---@diagnostic disable: param-type-mismatch

-- Buffer-related utilities: save, new file, delete other buffers

local function SaveAs()
	local current_file = vim.fn.expand("%:p")
	if current_file ~= "" then
		vim.cmd("write")
	else
		vim.ui.input({ prompt = "Save As: " }, function(new_file)
			if not new_file or new_file == "" then
				vim.notify("No filename provided. Save canceled.", vim.log.levels.WARN, { title = "Save" })
				return
			end

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

local M = {}

M.save = function()
	local mode = vim.api.nvim_get_mode().mode
	if mode == "i" then
		SaveAs()
		vim.cmd("startinsert")
	else
		SaveAs()
	end
end

M.delete_other_buffers = function()
	local current_buf = vim.api.nvim_get_current_buf()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) then
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end
end

-- Create NewFile command (enew + SaveAs prompt)
vim.api.nvim_create_user_command("NewFile", function()
	vim.cmd("enew")
	SaveAs()
end, {
	nargs = 0,
	desc = "Create new file and prompt for save",
})

-- Keymap helper
local function map(mode, lhs, rhs, opts)
	opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
	vim.keymap.set(mode, lhs, rhs, opts)
end

map({ "n", "v", "i" }, "<C-s>", function()
	M.save()
end, { desc = "Save file" })

map("n", "<leader>+", "<cmd>NewFile<cr>", { desc = "New file" })

map({ "n", "v" }, "<M-Q>", function()
	M.delete_other_buffers()
end, { desc = "Delete all buffers except the current one" })

return M

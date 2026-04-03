-- Detect if a buffer contains binary content (non-printable ASCII)
local function is_binary_file(bufnr)
	bufnr = bufnr or 0
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 100, false)
	local text = table.concat(lines, "\n")

	for i = 1, #text do
		local byte = string.byte(text, i)
		if byte < 9 or (byte > 13 and byte < 32) then
			return true
		end
	end

	return false
end

-- Autocommand: when reading any file, check if it's a binary (machine code) file
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function(args)
		local buf = args.buf
		if is_binary_file(buf) then
			vim.bo[buf].binary = true
			vim.bo[buf].eol = false
			vim.bo[buf].fileencoding = ""
			vim.cmd("filetype off")

			-- Hex view mapping (xxd -g 1)
			vim.api.nvim_buf_set_keymap(buf, "n", "<leader>xv", ":%!xxd -g 1<CR>:setfiletype xxd<CR>:w<CR>", {
				noremap = true,
				silent = true,
				desc = "Hex view of current file",
			})

			-- Revert hex view (xxd -r)
			vim.api.nvim_buf_set_keymap(buf, "n", "<leader>xr", ":%!xxd -r<CR>:setfiletype NONE<CR>:w<CR>", {
				noremap = true,
				silent = true,
				desc = "Revert hex view of current file",
			})

			vim.notify("Machine code file detected. Hex view mappings enabled.", vim.log.levels.INFO)
		end
	end,
})

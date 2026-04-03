---@diagnostic disable: unused-local
---@class ftplugin.xxd

local ns = vim.api.nvim_create_namespace("xxdHighlight")

local function highlight_all(bufnr)
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	-- Clear all extmarks in our namespace
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

	for l, line in ipairs(lines) do
		-- 1) Address (cols 0–8)
		vim.api.nvim_buf_set_extmark(bufnr, ns, l - 1, 0, {
			end_col = 9,
			hl_group = "Constant",
		})

		-- 2) Find ASCII start (two spaces)
		local ascii_start = line:find("%s%s")
		local hex_limit = ascii_start and (ascii_start - 1) or #line

		-- 3) Hex bytes before ASCII
		for s, hexbyte, e in line:gmatch("()([0-9A-Fa-f][0-9A-Fa-f])()") do
			-- s and e are strings, convert safely to numbers for arithmetic
			local s_num = tonumber(s)
			local e_num = tonumber(e)
			if s_num and e_num and s_num > 9 and s_num <= hex_limit then
				vim.api.nvim_buf_set_extmark(bufnr, ns, l - 1, s_num - 1, {
					end_col = e_num - 1,
					hl_group = "Boolean",
				})
			end
		end

		-- 4) ASCII display
		if ascii_start then
			vim.api.nvim_buf_set_extmark(bufnr, ns, l - 1, ascii_start - 1, {
				end_col = #line,
				hl_group = "String",
			})
		end
	end
end

-- Auto-highlight on load and on changes
vim.api.nvim_create_autocmd({ "BufRead", "BufEnter", "TextChanged", "TextChangedI" }, {
	pattern = "*.xxd",
	callback = function(args)
		highlight_all(args.buf)
	end,
})

-- Also run once on startup (for already-open buffers)
highlight_all(0)

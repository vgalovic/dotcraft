---@diagnostic disable: unused-local

-- ============================================================================
-- toggleterm.nvim
-- ============================================================================

Config.later(function()
	vim.pack.add({ Repo.gh("akinsho/toggleterm.nvim") })
	require("toggleterm").setup({
		open_mapping = "<C-/>",
		direction = "float",
		float_opts = {
			border = "rounded",
		},
	})

	local Terminal = require("toggleterm.terminal").Terminal
	local lazygit = Terminal:new({
		cmd = "lazygit",
		dir = "git_dir",
		direction = "float",
		float_opts = {
			border = "rounded",
		},
		-- function to run on opening the terminal
		on_open = function(term)
			vim.cmd("startinsert!")
			vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
		end,
		-- function to run on closing the terminal
		on_close = function(term)
			vim.cmd("startinsert!")
		end,
	})

	function _LazygitToggle()
		lazygit:toggle()
	end

	Map.map_opts("<leader>gg", "<cmd>lua _LazygitToggle()<CR>", "Toggle lazygit")
end)

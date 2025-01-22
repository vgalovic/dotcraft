local M = {}
M.ToggleTheme = function()
	---@diagnostic disable: undefined-field
	if vim.opt.background:get() == "dark" then
		vim.opt.background = "light"
	else
		vim.opt.background = "dark"
	end
end

return M

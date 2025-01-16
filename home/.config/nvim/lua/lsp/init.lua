local M = {}

M.setup = function()
	require("lsp.clangd")()
	require("lsp.lua_ls")()
	require("lsp.ltex")()
end

return M

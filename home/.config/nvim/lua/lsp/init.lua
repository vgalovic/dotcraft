-------------------------------------------------------------------------------
--
--    ██╗     ███████╗██████╗  ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗
--    ██║     ██╔════╝██╔══██╗██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝
--    ██║     ███████╗██████╔╝██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗
--    ██║     ╚════██║██╔═══╝ ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║
--    ███████╗███████║██║     ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝
--    ╚══════╝╚══════╝╚═╝      ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝
--
-------------------------------------------------------------------------------

local M = {}

-- Setup LSP configurations
M.setup = function()
	require("lsp.lspconfig.clangd")()
	require("lsp.lspconfig.lua_ls")()
	require("lsp.lspconfig.ltex")()
end

return M

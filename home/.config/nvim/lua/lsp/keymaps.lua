---@class lsp.kymaps

local M = {}

function M.setup_lsp_keymaps(bufnr)
	local map = vim.keymap.set
	local snacks = require("snacks")

	local function lsp_map(keys, func, desc, mode)
		mode = mode or "n"
		map(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
	end

    -- Use `snacks` for LSP navigation
    -- stylua: ignore start
    lsp_map("gd", function() snacks.picker.lsp_definitions() end, "Goto Definition")
    lsp_map("gy", function() snacks.picker.lsp_type_definitions() end, "Type Definition")
    lsp_map("gR", function() snacks.picker.lsp_references() end, "Goto References")
    lsp_map("gI", function() snacks.picker.lsp_implementations() end, "Goto Implementation")
    lsp_map("gD", vim.lsp.buf.declaration, "Goto Declaration")
    lsp_map("<leader>cs", function() snacks.picker.lsp_symbols() end, "Document Symbols")
    lsp_map("<leader>cw", function() snacks.picker.lsp_symbols({ cwd = vim.fn.expand("%:p:h") }) end, "Workspace Symbols")
    lsp_map("<leader>cc", vim.lsp.buf.code_action, "Code Action", { "n", "x" })
    lsp_map("K", vim.lsp.buf.hover, "Buffer hover")
    lsp_map("<backspace>", vim.lsp.buf.rename, "Rename")
	-- stylua: ignore end
end

return M

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
--
--
--[[ LSP Autocommands]]
--
-- Utility functions shared between progress reports for LSP and DAP

--
local M = {}

function M.setup_lsp_autocommands()
	local augroup_lsp_attach = vim.api.nvim_create_augroup("lsp-attach", { clear = true })

	vim.api.nvim_create_autocmd("LspAttach", {
		group = augroup_lsp_attach,
		callback = function(event)
			-- Setup LSP-specific keymaps for this buffer
			local lsp_keymap = require("config.keymap")
			lsp_keymap.setup_lsp_keymaps(event.buf)

			-- Highlight references on hover if supported
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
				local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })

				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.document_highlight,
				})
				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					buffer = event.buf,
					group = highlight_augroup,
					callback = vim.lsp.buf.clear_references,
				})

				-- Cleanup highlights on LSP detach
				vim.api.nvim_create_autocmd("LspDetach", {
					group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
					callback = function(event2)
						vim.lsp.buf.clear_references()
						vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
					end,
				})
			end
		end,
	})
end

return M

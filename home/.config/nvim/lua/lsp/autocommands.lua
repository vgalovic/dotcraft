---@diagnostic disable: param-type-mismatch
---@diagnostic disable: undefined-field

local M = {}

-- Utility functions shared between progress reports for LSP and DAP
function M.setup_lsp_autocommands()
	local augroup_lsp_attach = vim.api.nvim_create_augroup("lsp-attach", {})
	local augroup_lsp_detach = vim.api.nvim_create_augroup("lsp-detach", {})

	vim.api.nvim_create_autocmd("LspAttach", {
		group = augroup_lsp_attach,
		callback = function(event)
			local lsp_keymap = require("plugins.coding.lspconfig")
			lsp_keymap.setup_lsp_keymaps(event.buf)

			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client and client.server_capabilities.documentHighlightProvider then
				local augroup_lsp_highlight = vim.api.nvim_create_augroup("lsp-highlight-" .. event.buf, {})

				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					buffer = event.buf,
					group = augroup_lsp_highlight,
					callback = vim.lsp.buf.document_highlight,
				})

				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					buffer = event.buf,
					group = augroup_lsp_highlight,
					callback = vim.lsp.buf.clear_references,
				})
			end
		end,
	})

	vim.api.nvim_create_autocmd("LspDetach", {
		group = augroup_lsp_detach,
		once = true, -- Runs only once per buffer
		callback = function(event)
			vim.lsp.buf.clear_references()
			vim.api.nvim_clear_autocmds({ group = "lsp-highlight-" .. event.buf, buffer = event.buf })
		end,
	})
end

-- LSP progress reporting through notifier
function M.setup_lsp_progress()
	---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
	local progress = vim.defaulttable()
	vim.api.nvim_create_autocmd("LspProgress", {
		---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
		callback = function(ev)
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
			if not client or type(value) ~= "table" then
				return
			end
			local p = progress[client.id]

			for i = 1, #p + 1 do
				if i == #p + 1 or p[i].token == ev.data.params.token then
					p[i] = {
						token = ev.data.params.token,
						msg = ("[%3d%%] %s%s"):format(
							value.kind == "end" and 100 or value.percentage or 100,
							value.title or "",
							value.message and (" **%s**"):format(value.message) or ""
						),
						done = value.kind == "end",
					}
					break
				end
			end

			local msg = {} ---@type string[]
			progress[client.id] = vim.tbl_filter(function(v)
				return table.insert(msg, v.msg) or not v.done
			end, p)

			local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
			vim.notify(table.concat(msg, "\n"), "info", {
				id = "lsp_progress",
				title = client.name,
				opts = function(notif)
					notif.icon = #progress[client.id] == 0 and " "
						or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
				end,
			})
		end,
	})
end

return M

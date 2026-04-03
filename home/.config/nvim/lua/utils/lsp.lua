---@diagnostic disable: param-type-mismatch, undefined-field, duplicate-set-field

local M = {}

--========================================================================
--                          Autocommands
--========================================================================

function M.setup_lsp_autocommands()
	local augroup_lsp_attach = vim.api.nvim_create_augroup("lsp-attach", { clear = true })
	local augroup_lsp_detach = vim.api.nvim_create_augroup("lsp-detach", { clear = true })

	-------------------------------------------------------------------------
	-- LSP ATTACH
	-------------------------------------------------------------------------
	vim.api.nvim_create_autocmd("LspAttach", {
		group = augroup_lsp_attach,
		callback = function(event)
			M.setup_lsp_keymaps(event.buf)

			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if not client then
				return
			end

			-- Setup document highlight if supported
			if client.server_capabilities.documentHighlightProvider then
				local group = vim.api.nvim_create_augroup("lsp-highlight-" .. event.buf, { clear = true })

				-- Store the numeric ID so LspDetach can clean it
				vim.b[event.buf].lsp_highlight_group = group

				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					group = group,
					buffer = event.buf,
					callback = vim.lsp.buf.document_highlight,
				})

				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					group = group,
					buffer = event.buf,
					callback = vim.lsp.buf.clear_references,
				})
			end
		end,
	})

	-------------------------------------------------------------------------
	-- LSP DETACH
	-------------------------------------------------------------------------
	vim.api.nvim_create_autocmd("LspDetach", {
		group = augroup_lsp_detach,
		callback = function(event)
			-- Always clear highlights
			pcall(vim.lsp.buf.clear_references)

			-- Clean up the highlight autocmd group
			local group = vim.b[event.buf].lsp_highlight_group
			if group then
				vim.api.nvim_clear_autocmds({ group = group })
				vim.b[event.buf].lsp_highlight_group = nil
			end
		end,
	})
end

--========================================================================
--                       LSP Progress Notifications
--========================================================================

function M.setup_lsp_progress()
	local progress = vim.defaulttable()

	vim.api.nvim_create_autocmd("LspProgress", {
		callback = function(ev)
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			if not client then
				return
			end

			local value = ev.data.params.value
			if type(value) ~= "table" then
				return
			end

			local p = progress[client.id]

			-- Update progress entries
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

			-- Filter & combine
			local msg = {}
			progress[client.id] = vim.tbl_filter(function(v)
				return table.insert(msg, v.msg) or not v.done
			end, p)

			local spinner = Icons.lsp.spinner
			vim.notify(table.concat(msg, "\n"), "info", {
				id = "lsp_progress",
				title = client.name,
				opts = function(notif)
					notif.icon = #progress[client.id] == 0 and Icons.lsp.done
						or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
				end,
			})
		end,
	})
end

--========================================================================
--                              Floating Preview
--========================================================================

function M.setup_floating_preview()
	local orig = vim.lsp.util.open_floating_preview

	function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = opts.border or "rounded"
		opts.max_height = opts.max_height or 40
		opts.max_width = opts.max_width or 100
		return orig(contents, syntax, opts, ...)
	end
end

--========================================================================
--                              Keymaps
--========================================================================

function M.setup_lsp_keymaps(bufnr)
	local map = vim.keymap.set
	local snacks = require("snacks")

	local function lsp_map(keys, fn, desc, mode)
		map(mode or "n", keys, fn, { buffer = bufnr, desc = "LSP: " .. desc })
	end

	-- Navigation (using Snacks)
	lsp_map("gd", function()
		snacks.picker.lsp_definitions()
	end, "Goto Definition")
	lsp_map("gy", function()
		snacks.picker.lsp_type_definitions()
	end, "Type Definition")
	lsp_map("gR", function()
		snacks.picker.lsp_references()
	end, "Goto References")
	lsp_map("gI", function()
		snacks.picker.lsp_implementations()
	end, "Goto Implementation")
	lsp_map("gD", vim.lsp.buf.declaration, "Goto Declaration")

	lsp_map("<leader>cs", function()
		snacks.picker.lsp_symbols()
	end, "Document Symbols")
	lsp_map("<leader>cw", function()
		snacks.picker.lsp_symbols({ cwd = vim.fn.expand("%:p:h") })
	end, "Workspace Symbols")

	lsp_map("<leader>cc", vim.lsp.buf.code_action, "Code Action", { "n", "x" })
	lsp_map("K", vim.lsp.buf.hover, "Hover")
	lsp_map("<backspace>", vim.lsp.buf.rename, "Rename")
end

return M

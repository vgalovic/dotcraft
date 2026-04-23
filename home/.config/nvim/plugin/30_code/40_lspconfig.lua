---@diagnostic disable: duplicate-set-field

-- ============================================================================
-- LSP Autocommands
-- ============================================================================

local function setup_lsp_autocommands()
	local attach_group = vim.api.nvim_create_augroup("lsp-attach", { clear = true })
	local detach_group = vim.api.nvim_create_augroup("lsp-detach", { clear = true })

	vim.api.nvim_create_autocmd("LspAttach", {
		group = attach_group,
		callback = function(event)
			local bufnr = event.buf

			-- Keymaps
			Map.map_lsp(bufnr, "<backspace>", vim.lsp.buf.rename, "Rename")

			Map.map_lsp(bufnr, "K", vim.lsp.buf.hover, "Hover")
			Map.map_lsp_leader(bufnr, "la", vim.lsp.buf.code_action, "Actions")
			Map.map_lsp_leader(bufnr, "ld", vim.diagnostic.open_float, "Diagnostic popup")
			Map.map_lsp_leader(bufnr, "li", vim.lsp.buf.implementation, "Implementation")
			Map.map_lsp_leader(bufnr, "ll", vim.lsp.codelens.run, "Lens")
			Map.map_lsp_leader(bufnr, "lr", vim.lsp.buf.references, "References")
			Map.map_lsp_leader(bufnr, "ls", vim.lsp.buf.definition, "Definition")
			Map.map_lsp_leader(bufnr, "lt", vim.lsp.buf.type_definition, "Type definition")

			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if not client then
				return
			end

			if client.server_capabilities.documentHighlightProvider then
				local group = vim.api.nvim_create_augroup("lsp-highlight-" .. bufnr, { clear = true })
				vim.b[bufnr].lsp_highlight_group = group

				vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
					group = group,
					buffer = bufnr,
					callback = vim.lsp.buf.document_highlight,
				})

				vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
					group = group,
					buffer = bufnr,
					callback = vim.lsp.buf.clear_references,
				})
			end
		end,
	})

	vim.api.nvim_create_autocmd("LspDetach", {
		group = detach_group,
		callback = function(event)
			pcall(vim.lsp.buf.clear_references)

			local group = vim.b[event.buf].lsp_highlight_group
			if group then
				vim.api.nvim_clear_autocmds({ group = group })
				vim.b[event.buf].lsp_highlight_group = nil
			end
		end,
	})
end

vim.api.nvim_create_user_command("LspInfo", "checkhealth vim.lsp", {
	desc = "Show LSP Info",
})

vim.api.nvim_create_user_command("LspLog", function(_)
	local state_path = vim.fn.stdpath("state")
	local log_path = vim.fs.joinpath(state_path, "lsp.log")

	vim.cmd(string.format("edit %s", log_path))
end, {
	desc = "Show LSP log",
})

vim.api.nvim_create_user_command("LspRestart", "lsp restart", {
	desc = "Restart LSP",
})

-- ============================================================================
-- Floating Preview
-- ============================================================================

local function setup_floating_preview()
	local orig = vim.lsp.util.open_floating_preview

	function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
		opts = opts or {}
		opts.border = opts.border or "rounded"
		opts.max_height = opts.max_height or 40
		opts.max_width = opts.max_width or 100
		return orig(contents, syntax, opts, ...)
	end
end

Config.now_if_args(function()
	vim.pack.add({ Repo.gh("neovim/nvim-lspconfig") })

	setup_lsp_autocommands()
	setup_floating_preview()

	local manual_servers = { "rust_analyzer" }

	for _, lsp_name in pairs(Servers.servers) do
		if lsp_name then
			local ok, err = pcall(vim.lsp.enable, lsp_name)
			if not ok then
				vim.notify("Failed to enable Mason server " .. lsp_name .. ": " .. tostring(err), vim.log.levels.WARN)
			end
		end
	end

	for _, lsp_name in ipairs(manual_servers) do
		local ok, err = pcall(vim.lsp.enable, lsp_name)
		if not ok then
			vim.notify("Failed to enable manual server " .. lsp_name .. ": " .. tostring(err), vim.log.levels.WARN)
		end
	end
end)

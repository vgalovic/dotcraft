---@diagnostic disable: undefined-global, param-type-mismatch, undefined-field, duplicate-set-field

local add = vim.pack.add
local now, now_if_args, later = Config.now, Config.now_if_args, Config.later
local Icons = require("config.icons")

-- ============================================================================
-- LSP + Formatter Definitions
-- ============================================================================

--stylua: ignore start
local servers = {
  ["arduino-language-server"]   = "arduino_language_server",
	-- ["asm_lsp"]                   = "asm_lsp",
  ["bash-language-server"]      = "bashls",
  ["clangd"]                    = "clangd",
	-- ["cmake"]                     = "cmake-language-server",
  ["lua-language-server"]       = "lua_ls",
  -- ["matlab-language-server"]    = "matlab_ls",
  ["marksman"]                  = "marksman",
  -- ["pyright"]                   = "pyright",
	-- ["ruff"]                      = "ruff",
	-- ["rust_analyzer"]             = "rust-analyzer", -- install with rustup component add rust-analyzer
  ["rust_hdl"]                  = "vhdl_ls",
  ["svlangserver"]              = "svlangserver",
  ["verible"]                   = "verible",
}

local formatters = {
	-- ["asmfmt"]      = "asmfmt",
	["beautysh"]    = "beautysh",
	["latexindent"] = "latexindent",
	-- ["mdformat"]    = "mdformat", -- install it with pipx install mdformat && pipx inject mdformat mdformat-myst
	-- ["rustfmt"]     = "rustfmt", -- install with rustup component add rustfmt
	["stylua"]      = "latexindent",
}
--stylua: ignore end

local mason_packages = vim.tbl_extend("force", servers, formatters)

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
			Map.map_lsp_leader(bufnr, "lR", vim.lsp.buf.references, "References")
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

-- ============================================================================
-- Plugins
-- ============================================================================
--
--++ Treesitter +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
now_if_args(function()
	-- Define hook to update tree-sitter parsers after plugin is updated
	local ts_update = function()
		vim.cmd("TSUpdate")
	end
	Config.on_packchanged("nvim-treesitter", { "update" }, ts_update, ":TSUpdate")

	add({ Repo.gh("nvim-treesitter/nvim-treesitter") })

	require("nvim-treesitter").setup({
		sync_install = false,
		modules = {},
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
			notify_on_error = true,
			disable = {},
		},
		indent = { enable = false },
		fold = { enable = false },
	})

	local languages = {
		"bash",
		"c",
		"cmake",
		"cpp",
		"lua",
		"make",
		"markdown",
		"markdown_inline",
		"regex",
		"rust",
		-- "verilog",
		"vhdl",
		"vim",
		"vimdoc",
	}
	local isnt_installed = function(lang)
		return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
	end
	local to_install = vim.tbl_filter(isnt_installed, languages)
	if #to_install > 0 then
		require("nvim-treesitter").install(to_install)
	end

	-- Enable tree-sitter after opening a file for a target language
	local filetypes = {}
	for _, lang in ipairs(languages) do
		for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
			table.insert(filetypes, ft)
		end
	end
	local ts_start = function(ev)
		vim.treesitter.start(ev.buf)
	end
	Config.new_autocmd("FileType", filetypes, ts_start, "Start tree-sitter")
end)
--
--++ Mason ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
now(function()
  --stylua: ignore
	local mason_update = function() vim.cmd("MasonUpdate") end
	Config.on_packchanged("mason.nvim", { "update" }, mason_update, ":MasonUpdate")

	add({ Repo.gh("mason-org/mason.nvim") })

	require("mason").setup({
		ui = {
			icons = {
				package_installed = Icons.mason.package_installed,
				package_pending = Icons.mason.package_pending,
				package_uninstalled = Icons.mason.package_uninstalled,
			},
		},
	})

	Map.map_leader("pm", "<cmd>Mason<cr>", "Mason")
end)
--
--++ Mason Tool Installer +++++++++++++++++++++++++++++++++++++++++++++++++++++
--
now(function()
	add({ Repo.gh("WhoIsSethDaniel/mason-tool-installer.nvim") })

	require("mason-tool-installer").setup({
		ensure_installed = vim.tbl_keys(mason_packages),
		run_on_start = true,
		auto_update = false,
	})
end)
--
--++ Lspconfig ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
now_if_args(function()
	add({ Repo.gh("neovim/nvim-lspconfig") })

	setup_lsp_autocommands()
	setup_floating_preview()

	local manual_servers = { "rust_analyzer" }

	for _, lsp_name in pairs(servers) do
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
--
--++ Friendly snippets ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
later(function()
	add({ Repo.gh("rafamadriz/friendly-snippets") })
end)
--
--++ Conform ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
later(function()
	add({ Repo.gh("stevearc/conform.nvim") })

	require("conform").setup({
		notify_on_error = false,

		format_on_save = function()
			return {
				timeout_ms = 3000,
				lsp_format = "fallback",
			}
		end,

		formatters_by_ft = {
			["bash"] = { "beautysh" },
			["latex"] = { "latexindent" },
			["lua"] = { "stylua" },
			["markdown"] = { "mdformat" },
			["markdown.mdx"] = { "mdformat" },
			-- ["python"] = { "ruff" },
			["rust"] = { "rustfmt" },
			["sh"] = { "beautysh" },
			["SystemVerilog"] = { "verible" },
			["verilog"] = { "verible" },
			["zsh"] = { "beautysh" },
		},

		formatters = {
			beautysh = {
				prepend_args = { "--indent-size", "2", "--force-function-style", "paronly" },
			},
		},
	})

	Map.map_leader(
		"F",
		'<cmd>lua require("conform").format({ async = true, lsp_format = "fallback" })<cr>',
		"Format buffer",
		{ "n", "x" }
	)
end)

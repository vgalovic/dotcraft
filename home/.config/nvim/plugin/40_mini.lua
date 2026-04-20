---@diagnostic disable: duplicate-set-field, undefined-global

local now, now_if_args, later, on_event = Config.now, Config.now_if_args, Config.later, Config.on_event
local Icons = require("config.icons")

-- =========================================================
-- CORE MINI SETUP (basics, icons, UI essentials)
-- =========================================================

-- mini.basics ------------------------------------------------
now(function()
	require("mini.basics").setup({
		options = { basic = false },
		mappings = {
			windows = true,
			move_with_alt = true,
			option_toggle_prefix = "<leader>\\",
		},
	})
end)

-- mini.icons -------------------------------------------------
now(function()
	local ext3_blocklist = { scm = true, txt = true, yml = true }
	local ext4_blocklist = { json = true, yaml = true }
	local icons = require("mini.icons")

	icons.setup({
		filetype = {
			["ghostty"] = { glyph = Icons.filetype.ghostty, hl = "MiniIconsAzure" },
			["kitty"] = { glyph = Icons.file.kitty, hl = "MiniIconsOrange" },
			["log"] = { glyph = Icons.filetype.log, hl = "MiniIconsGrey" },
			["mininotify-history"] = { glyph = Icons.file.history, hl = "MiniIconsGrey" },
			["nvim-pack"] = { glyph = Icons.filetype.nvim_pack, hl = "MiniIconsGrey" },
			["nvim-undotree"] = { glyph = Icons.filetype.undotree, hl = "MiniIconsGrey" },
			["pager"] = { glyph = Icons.filetype.pager, hl = "MiniIconsGrey" },
			["sh"] = { glyph = Icons.filetype.sh, hl = "MiniIconsAzure" },
			["toggleterm"] = { glyph = Icons.filetype.sh, hl = "MiniIconsGrey" },
			["verilog"] = { glyph = Icons.filetype.verilog, hl = "MiniIconsGreen" },
		},
		file = {
			["Brewfile"] = { glyph = Icons.file.brewfile, hl = "MiniIconsYellow" },
			["config"] = { glyph = Icons.file.config, hl = "MiniIconsGrey" },
			["config.ghostty"] = { glyph = Icons.filetype.ghostty, hl = "MiniIconsAzure" },
			["fish"] = { glyph = Icons.file.fish, hl = "MiniIconsAzure" },
			["history"] = { glyph = Icons.file.history, hl = "MiniIconsGrey" },
			["kitty.conf"] = { glyph = Icons.file.kitty, hl = "MiniIconsOrange" },
			["messages"] = { glyph = Icons.filetype.pager, hl = "MiniIconsGrey" },
		},
		use_file_extension = function(ext, _)
			return not (ext3_blocklist[ext:sub(-3)] or ext4_blocklist[ext:sub(-4)])
		end,
	})

	-- Pattern overrides
	local pattern_icons = {
		{ "%.conf$", { Icons.file.config, "MiniIconsAzure" } },
		{ "%.log$", { Icons.filetype.log, "MiniIconsGrey" } },
		{ "%.sh$", { Icons.filetype.sh, "MiniIconsGrey" } },
		{ "%.tmTheme$", { Icons.filetype.tmTheme, "MiniIconsAzure" } },
		{ "%.v$", { Icons.filetype.verilog, "MiniIconsGreen" } },
		{ "config%.ghostty$", { Icons.filetype.ghostty, "MiniIconsAzure" } },
		{ "confirm#%d+$", { Icons.filetype.nvim_pack, "MiniIconsGrey" } },
		{ "kitty%.conf$", { Icons.file.kitty, "MiniIconsOrange" } },
	}

	local get_icons = icons.get
	icons.get = function(category, name)
		if category == "file" then
			for _, entry in ipairs(pattern_icons) do
				local pattern, icon_data = entry[1], entry[2]
				if name:match(pattern) then
					return unpack(icon_data)
				end
			end
		end
		return get_icons(category, name)
	end

	later(MiniIcons.mock_nvim_web_devicons)
	later(MiniIcons.tweak_lsp_kind)
end)

-- mini.notify ------------------------------------------------
now(function()
	local win_config = function()
		local has_statusline = vim.o.laststatus > 0
		local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
		return { anchor = "SE", col = vim.o.columns, row = vim.o.lines - pad }
	end
	require("mini.notify").setup({ window = { config = win_config } })
end)

-- =========================================================
-- SESSION / UI
-- =========================================================

-- mini.sessions ---------------------------------------------
on_event("VimEnter", function()
	require("mini.sessions").setup()
end)

-- mini.starter (dashboard) ----------------------------------
now(function()
	local starter = require("mini.starter")
	local stats = Icons.starter.lightning_bolt .. " loading..."

	starter.setup({
		header = require("config.dashboard").get_random_header(),
		evaluate_single = true,
		content_hooks = {
			starter.gen_hook.adding_bullet(),
			starter.gen_hook.indexing("all", { "Builtin actions" }),
			starter.gen_hook.aligning("center", "center"),
		},
		footer = function()
			return stats
		end,
	})

	-- After UI is ready, compute plugin stats
	vim.api.nvim_create_autocmd("UIEnter", {
		once = true,
		callback = function()
			-- Defer to next event loop tick so we don't block startup
			vim.schedule(function()
				-- Get all plugins (fast: no extra git info)
				local plugins = vim.pack.get(nil, { info = false })

				local total = #plugins -- total managed plugins
				local active = 0 -- plugins loaded so far

				-- Count active plugins (added in this session)
				for _, p in ipairs(plugins) do
					if p.active then
						active = active + 1
					end
				end

				-- Time from start to UI ready (approx)
				local time = (vim.loop.hrtime() - _G.start_time) / 1e6

				-- Final footer text
				stats = string.format(
					Icons.starter.lightning_bolt .. " %d startup / %d total plugins  • %.2fms to UI ready",
					active,
					total,
					time
				)
				-- Refresh dashboard to show updated footer
				starter.refresh()
			end)
		end,
	})
end)

-- statusline / tabline --------------------------------------
now(function()
	local statusline = require("mini.statusline")
	statusline.setup()
	statusline.section_location = function()
		return "%2l:%-2v"
	end
end)

now(function()
	require("mini.tabline").setup()
end)

-- =========================================================
-- LSP / COMPLETION
-- =========================================================

now_if_args(function()
	local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }

	require("mini.completion").setup({
		lsp_completion = {
			source_func = "omnifunc",
			auto_setup = false,
			process_items = function(items, base)
				return MiniCompletion.default_process_items(items, base, process_items_opts)
			end,
		},
	})

	Config.new_autocmd("LspAttach", nil, function(ev)
		vim.bo[ev.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
	end, "Set omnifunc")

	vim.lsp.config("*", { capabilities = MiniCompletion.get_lsp_capabilities() })
end)

-- =========================================================
-- FILE EXPLORER (mini.files)
-- =========================================================

now_if_args(function()
	local show_dotfiles = false

	-- toggle dotfiles
	local toggle_dotfiles = function()
		show_dotfiles = not show_dotfiles
		MiniFiles.refresh({
			content = {
				filter = show_dotfiles and function()
					return true
				end or function(fs_entry)
					return not vim.startswith(fs_entry.name, ".")
				end,
			},
		})
	end

	require("mini.files").setup({
		windows = { preview = true, width_preview = 50 },
		mappings = { show_help = "?" },
		content = {
			filter = function(fs_entry)
				if show_dotfiles then
					return true
				end
				return not vim.startswith(fs_entry.name, ".")
			end,
		},
	})

	-- bookmarks
	Config.new_autocmd("User", "MiniFilesExplorerOpen", function()
		MiniFiles.set_bookmark("c", vim.fn.stdpath("config"), { desc = "Config" })
		MiniFiles.set_bookmark("w", vim.fn.getcwd, { desc = "Working directory" })
	end, "Add bookmarks")

	-- keymap per buffer
	vim.api.nvim_create_autocmd("User", {
		pattern = "MiniFilesBufferCreate",
		callback = function(args)
			local map_buf = function(lhs, rhs)
				vim.keymap.set("n", lhs, rhs, { buffer = args.data.buf_id })
			end
			map_buf(".", toggle_dotfiles)
			map_buf("\\", MiniFiles.close)
		end,
	})
end)

-- =========================================================
-- MISC CORE UTILITIES
-- =========================================================

now_if_args(function()
	require("mini.misc").setup()
	MiniMisc.setup_auto_root()
	MiniMisc.setup_restore_cursor()
	MiniMisc.setup_termbg_sync()
end)

-- =========================================================
-- EXTRA / TEXT OBJECTS / EDITING
-- =========================================================

later(function()
	require("mini.extra").setup()
end)

later(function()
	require("mini.ai").setup({
		custom_textobjects = {
			B = MiniExtra.gen_ai_spec.buffer(),
			F = require("mini.ai").gen_spec.treesitter({
				a = "@function.outer",
				i = "@function.inner",
			}),
		},
		search_method = "cover",
		n_lines = 500,
	})
end)

later(function()
	require("mini.align").setup()
end)
later(function()
	require("mini.bracketed").setup()
end)
later(function()
	require("mini.bufremove").setup()
end)

-- =========================================================
-- KEY HINTS (mini.clue)
-- =========================================================

later(function()
	require("mini.clue").setup({
		clues = {
			Config.leader_groups,
			require("mini.clue").gen_clues.builtin_completion(),
			require("mini.clue").gen_clues.g(),
			require("mini.clue").gen_clues.marks(),
			require("mini.clue").gen_clues.registers(),
			require("mini.clue").gen_clues.square_brackets(),
			require("mini.clue").gen_clues.windows({ submode_resize = true }),
			require("mini.clue").gen_clues.z(),
		},
		triggers = {
			{ mode = { "n", "x" }, keys = "<Leader>" },
			{ mode = "n", keys = "\\" },
			{ mode = { "n", "x" }, keys = "[" },
			{ mode = { "n", "x" }, keys = "]" },
			{ mode = "i", keys = "<C-x>" },
			{ mode = { "n", "x" }, keys = "g" },
			{ mode = { "n", "x" }, keys = "'" },
			{ mode = { "n", "x" }, keys = "`" },
			{ mode = { "n", "x" }, keys = '"' },
			{ mode = { "i", "c" }, keys = "<C-r>" },
			{ mode = "n", keys = "<C-w>" },
			{ mode = { "n", "x" }, keys = "s" },
			{ mode = { "n", "x" }, keys = "z" },
		},
		window = { delay = 0, config = { width = "auto" } },
	})
end)

-- =========================================================
-- SMALL UTILITIES
-- =========================================================

later(function()
	require("mini.diff").setup({
		view = {
			style = "sign", -- number | sign

			signs = {
				add = Icons.git.line_add,
				change = Icons.git.line_change,
				delete = Icons.git.line_delete,
			},
		},
	})
end)

later(function()
	require("mini.hipatterns").setup({
		highlighters = { hex_color = require("mini.hipatterns").gen_highlighter.hex_color() },
	})
end)

later(function()
	require("mini.jump2d").setup({
		hooks = {
			pre = function()
				vim.api.nvim_exec_autocmds("User", { pattern = "Jump2dPre" })
			end,
		},
	})
end)

later(function()
	local latex_patterns = { "latex/**/*.json", "**/latex.json" }
	local lang_patterns = {
		tex = latex_patterns,
		plaintex = latex_patterns,
		markdown_inline = { "markdown.json" },
	}

	local snippets = require("mini.snippets")
	local config_path = vim.fn.stdpath("config")
	snippets.setup({
		snippets = {
			snippets.gen_loader.from_file(config_path .. "/snippets/global.json"),
			snippets.gen_loader.from_lang({ lang_patterns = lang_patterns }),
		},
	})
end)

--stylua: ignore start
later(function() require("mini.cmdline").setup() end)
later(function() require("mini.comment").setup() end)
later(function() require("mini.git").setup() end)
later(function() require("mini.jump").setup() end)
later(function() require("mini.keymap").setup() end)
later(function() require("mini.move").setup() end)
later(function() require("mini.operators").setup() end)
later(function() require("mini.pairs").setup({ modes = { command = true } }) end)
later(function() require("mini.pick").setup() end)
later(function() require("mini.splitjoin").setup() end)
later(function() require("mini.surround").setup() end)
later(function() require("mini.trailspace").setup() end)
later(function() require("mini.visits").setup() end)
--stylua: ignore end

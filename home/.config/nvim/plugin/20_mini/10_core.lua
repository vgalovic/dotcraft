---@diagnostic disable:  undefined-global

-- =========================================================
-- CORE MINI SETUP (basics, icons, UI essentials)
-- =========================================================
local now, later = Config.now, Config.later
local Icons = require("config.icons")

-- mini.basics ------------------------------------------------
later(function()
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
	local icons = require("mini.icons")

	local ext3_blocklist = { scm = true, txt = true, yml = true }
	local ext4_blocklist = { json = true, yaml = true }

	-- base config
	icons.setup({
		filetype = {
			ghostty = { glyph = Icons.filetype.ghostty, hl = "MiniIconsAzure" },
			kitty = { glyph = Icons.file.kitty, hl = "MiniIconsOrange" },
			log = { glyph = Icons.filetype.log, hl = "MiniIconsGrey" },
			["mininotify-history"] = { glyph = Icons.file.history, hl = "MiniIconsGrey" },
			["nvim-pack"] = { glyph = Icons.filetype.nvim_pack, hl = "MiniIconsGrey" },
			["nvim-undotree"] = { glyph = Icons.filetype.undotree, hl = "MiniIconsGrey" },
			pager = { glyph = Icons.filetype.pager, hl = "MiniIconsGrey" },
			sh = { glyph = Icons.filetype.sh, hl = "MiniIconsAzure" },
			toggleterm = { glyph = Icons.filetype.sh, hl = "MiniIconsGrey" },
			verilog = { glyph = Icons.filetype.verilog, hl = "MiniIconsGreen" },
		},

		file = {
			Brewfile = { glyph = Icons.file.brewfile, hl = "MiniIconsYellow" },
			config = { glyph = Icons.file.config, hl = "MiniIconsGrey" },
			["config.ghostty"] = { glyph = Icons.filetype.ghostty, hl = "MiniIconsAzure" },
			fish = { glyph = Icons.file.fish, hl = "MiniIconsAzure" },
			history = { glyph = Icons.file.history, hl = "MiniIconsGrey" },
			["kitty.conf"] = { glyph = Icons.file.kitty, hl = "MiniIconsOrange" },
			messages = { glyph = Icons.filetype.pager, hl = "MiniIconsGrey" },
		},

		use_file_extension = function(ext)
			return not (ext3_blocklist[ext] or ext4_blocklist[ext])
		end,
	})

	local exact = {
		["kitty.conf"] = { Icons.file.kitty, "MiniIconsOrange" },
		["config.ghostty"] = { Icons.filetype.ghostty, "MiniIconsAzure" },
	}

	local extension = {
		conf = { Icons.file.config, "MiniIconsAzure" },
		log = { Icons.filetype.log, "MiniIconsGrey" },
		sh = { Icons.filetype.sh, "MiniIconsGrey" },
		tmTheme = { Icons.filetype.tmTheme, "MiniIconsAzure" },
		v = { Icons.filetype.verilog, "MiniIconsGreen" },
	}

	local get_icons = icons.get

	icons.get = function(category, name)
		if category == "file" then
			-- exact match (fastest)
			local ex = exact[name]
			if ex then
				return ex[1], ex[2]
			end

			-- extension match (fast)
			local ext = name:match("%.([^.]+)$")
			if ext then
				local ex2 = extension[ext]
				if ex2 then
					return ex2[1], ex2[2]
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

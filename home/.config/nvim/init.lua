------------------------------------------------------------------------------------------------
--
--      ███╗   ██╗██╗   ██╗██╗███╗   ███╗     ██████╗ ██████╗ ███╗   ██╗███████╗██╗ ██████╗
--      ████╗  ██║██║   ██║██║████╗ ████║    ██╔════╝██╔═══██╗████╗  ██║██╔════╝██║██╔════╝
--      ██╔██╗ ██║██║   ██║██║██╔████╔██║    ██║     ██║   ██║██╔██╗ ██║█████╗  ██║██║  ███╗
--      ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║    ██║     ██║   ██║██║╚██╗██║██╔══╝  ██║██║   ██║
--      ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║    ╚██████╗╚██████╔╝██║ ╚████║██║     ██║╚██████╔╝
--      ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝     ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝
--
------------------------------------------------------------------------------------------------

-- =========================================================
-- CORE PERFORMANCE
-- =========================================================

-- Enable Lua module caching (huge startup improvement)
vim.loader.enable()

-- =========================================================
-- GLOBAL OPTIONS / USER SETTINGS
-- =========================================================

-- Colorscheme (persisted by your theme picker)
-- Change the name of the theme by editing vim.g.colorscheme below.
-- To see and choose available themes, run :ThemesAvailable.
-- Selecting a theme will:
--   1. Persist your choice in this file (vim.g.colorscheme)
--   2. Ask you to restart Neovim to apply the new theme
-- Available themes are defined in plugin/70_clolorscheme.lua.
vim.g.colorscheme = "everforest"

-- Kitty terminal integration
vim.g.kitty_solid = true -- Enable solid background in Kitty when using Neovim

-- Default search engine (your search plugin uses this)
vim.g.default_search_engine = "duckduckgo"

-- =========================================================
-- REPOSITORY HELPERS (shortcuts for plugin URLs)
-- =========================================================

-- stylua: ignore start
_G.Repo = {
  cb = function(x) return 'https://codeberg.org/' .. x end,
  gh = function(x) return 'https://github.com/' .. x end,
  gl = function(x) return 'https://gitlab.com/' .. x end,
}
-- stylua: ignore end

-- =========================================================
-- GLOBAL CONFIG TABLE
-- =========================================================

_G.Config = {}

-- =========================================================
-- BASIC AUTOCOMMANDS
-- =========================================================

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- =========================================================
-- ENABLE UI2
-- =========================================================

require("vim._core.ui2").enable({
	enable = true,
	msg = {
		targets = "cmd",
		cmd = { height = 0.5 },
		dialog = { height = 0.5 },
		msg = {
			height = 0.5,
			timeout = 1000,
		},
		pager = { height = 4 },
	},
})

-- =========================================================
-- PACKAGE MANAGEMENT (vim.pack)
-- =========================================================

-- Load builtin undo tree and diff tool
vim.cmd("packadd nvim.undotree")
vim.cmd("packadd nvim.difftool")

-- Load mini.nvim
vim.pack.add({ Repo.gh("nvim-mini/mini.nvim") })

-- =========================================================
-- MINI.MISC (execution helpers)
-- =========================================================

local misc = require("mini.misc")

-- Run immediately
Config.now = function(f)
	misc.safely("now", f)
end

-- Run later
Config.later = function(f)
	misc.safely("later", f)
end

-- Run now only if files were passed as args (fast startup trick)
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later

-- =========================================================
-- EVENT / FILETYPE HELPERS
-- =========================================================

-- Run on specific events
Config.on_event = function(ev, f)
	vim.api.nvim_create_autocmd(ev, {
		callback = f,
	})
end

-- Run on specific filetypes
Config.on_filetype = function(ft, f)
	local ft_name = type(ft) == "table" and table.concat(ft, ",") or ft
	misc.safely("filetype:" .. ft_name, f)
end

-- =========================================================
-- AUTOCMD FRAMEWORK
-- =========================================================

local gr = vim.api.nvim_create_augroup("custom-config", {})

Config.new_autocmd = function(event, pattern, callback, desc)
	local opts = {
		group = gr,
		pattern = pattern,
		callback = callback,
		desc = desc,
	}
	vim.api.nvim_create_autocmd(event, opts)
end

-- =========================================================
-- PACKCHANGE HANDLER (hot-reload plugins)
-- =========================================================

Config.on_packchanged = function(plugin_name, kinds, callback, desc)
	local f = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind

		if not (name == plugin_name and vim.tbl_contains(kinds, kind)) then
			return
		end

		-- Ensure plugin is loaded
		if not ev.data.active then
			vim.cmd.packadd(plugin_name)
		end

		callback()
	end

	Config.new_autocmd("PackChanged", "*", f, desc)
end

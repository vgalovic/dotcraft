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

-- Record high-resolution start time (in nanoseconds) to measure Neovim startup duration
_G.start_time = vim.loop.hrtime()

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
-- Selecting a theme will persist your choice in this file (vim.g.colorscheme)
-- Available themes are defined in plugin/70_clolorscheme.lua.
vim.g.colorscheme = "github_dark_tritanopia"

-- Enable solid or transparent background
vim.g.transparency = true

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
-- vim.cmd("packadd nvim.undotree")
vim.cmd("packadd nvim.difftool")

-- Load mini.nvim
vim.pack.add({ Repo.gh("nvim-mini/mini.nvim") })

-- =========================================================
-- MINI.MISC (execution helpers)
-- =========================================================
-- stylua: ignore start

local misc = require("mini.misc")

-- Run immediately
Config.now = function(f) misc.safely("now", f) end

-- Run later
Config.later = function(f) misc.safely("later", f) end

-- Run now only if files were passed as args (fast startup trick)
Config.now_if_args = vim.fn.argc(-1) > 0 and Config.now or Config.later

-- =========================================================
-- EVENT / FILETYPE HELPERS
-- =========================================================

-- Run on specific events
Config.on_event = function(ev, f) misc.safely("event:" .. ev, f) end

-- Run on specific filetypes
Config.on_filetype = function(ft, f) misc.safely("filetype:" .. ft, f) end

-- stylua: ignore end
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
    -- stylua: ignore
		if not ev.data.active then vim.cmd.packadd(plugin_name) end

		callback()
	end

	Config.new_autocmd("PackChanged", "*", f, desc)
end

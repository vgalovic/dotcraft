-- General ====================================================================
vim.o.mouse = "a"
vim.o.mousescroll = "ver:25,hor:6"
vim.o.switchbuf = "usetab"
vim.o.undofile = true
vim.o.shada = "'100,<50,s10,:1000,/100,@100,h"
vim.opt.termguicolors = true

vim.cmd("filetype plugin indent on")
if vim.fn.exists("syntax_on") ~= 1 then
	vim.cmd("syntax enable")
end

-- UI =========================================================================
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.o.cursorlineopt = "screenline,number"

vim.o.signcolumn = "yes"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.splitkeep = "screen"

vim.o.wrap = false
vim.o.linebreak = true
vim.o.breakindent = true

vim.o.list = true

vim.opt.listchars = {
	tab = "» ",
	trail = "·",
	nbsp = "␣",
	extends = "…",
	precedes = "…",
}

vim.o.colorcolumn = "+1"
vim.o.laststatus = 3

-- Popup / floating UI
vim.o.pumheight = 10
vim.o.pummaxwidth = 100
vim.o.pumborder = "rounded"
vim.o.winborder = "rounded"

-- Command UI
vim.o.cmdheight = 1
vim.o.showmode = false
vim.o.ruler = false

-- Editing ====================================================================
local tab_size = 2

vim.o.expandtab = true
vim.o.tabstop = tab_size
vim.o.softtabstop = tab_size
vim.o.shiftwidth = tab_size
vim.o.smartindent = true

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true

vim.o.virtualedit = "block"

vim.o.complete = ".,w,b,kspell"
vim.o.completeopt = "menuone,noselect,fuzzy,nosort"
vim.o.completetimeout = 100

-- Performance / UX ============================================================
vim.opt.scrolloff = 10
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.swapfile = false
vim.opt.undofile = true

-- Disable providers ==========================================================
vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Disable built-in plugins ===================================================
vim.g.loaded_matchparen = 1
vim.g.loaded_matchit = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tutor_mode_plugin = 1

-- Folding ====================================================================
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldenable = false
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldtext = ""

-- Fillchars ==================================================================
local fillchars = vim.opt.fillchars:get()
fillchars.eob = " "
fillchars.fold = " "
vim.opt.fillchars = fillchars

-- [[ GUI Font Settings ]]
-- Set the GUI font and size for Neovide (and other GUI clients)
vim.o.guifont = "JetBrainsMono Nerd Font:h11"

-- Neovide ==================================================================

-- [[ Neovide Floating Window Effects ]]
vim.g.neovide_floating_shadow = true -- Enable floating shadows for windows
vim.g.neovide_floating_z_height = 10 -- Set z-height for floating windows
vim.g.neovide_light_angle_degrees = 45 -- Light source angle for shadows
vim.g.neovide_light_radius = 5 -- Light radius for shadow blur

-- [[ Floating Blur Amount ]]
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0

-- [[ Neovide Theme Behavior ]]
vim.g.neovide_theme = "auto" -- Automatically switch theme with system

-- [[ Neovide Window Behavior ]]
vim.g.neovide_remember_window_size = true -- Remember window size between sessions

-- [[ Neovide Cursor Effects ]]
vim.g.neovide_cursor_vfx_mode = "pixiedust" -- Enable pixiedust effect on the cursor

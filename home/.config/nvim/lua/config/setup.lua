-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set this to true if you're using Nerd Font, otherwise false
vim.g.have_nerd_font = true

-- Setup color scheme
vim.g.colorscheme = "catppuccin"

-- Load Icons from utils.icons
_G.Icons = require("utils.icons")

-- Enable expandtab for spaces instead of tabs
vim.cmd("set expandtab")
-- Set the number of spaces that a <Tab> counts for
vim.cmd("set tabstop=2")
-- Set the number of spaces that a <Tab> counts for while editing
vim.cmd("set softtabstop=2")
-- Set the number of spaces to use for each step of (auto)indent
vim.cmd("set shiftwidth=2")

-- Disable swap files
vim.opt.swapfile = false

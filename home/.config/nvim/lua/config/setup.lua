-- Set <space> as the leader key
-- See `:help mapleader`
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Setup color scheme
-- Change the name of the theme to the one you prefer.
-- Available colorschemes in this config can be found in plugins/colorschemes.
vim.g.colorscheme = "oldworld"

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

-- Disable unused providers
vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable providers
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0

-- Enable expandtab for spaces instead of tabs
vim.cmd("set expandtab")
-- Set the number of spaces that a <Tab> counts for
vim.cmd("set tabstop=4")
-- Set the number of spaces that a <Tab> counts for while editing
vim.cmd("set softtabstop=4")
-- Set the number of spaces to use for each step of (auto)indent
vim.cmd("set shiftwidth=4")

vim.opt.swapfile = false

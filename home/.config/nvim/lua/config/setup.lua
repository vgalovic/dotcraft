-- [[ Setup color scheme ]]
-- Change the name of the theme to the one you prefer.
-- Available colorschemes in this config can be found in plugins/colorschemes.
vim.g.colorscheme = "moonfly"

-- [[ Define local tab size variable ]]
local tab_size = 2

-- [[ Load Icons from utils.icons ]]
_G.Icons = require("utils.icons")

-- [[ Disable unused providers ]]
vim.g.loaded_python_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- [[ General settings ]]
vim.opt.mouse = "a" -- Enable mouse mode
vim.opt.swapfile = false -- Disable swap files
vim.opt.undofile = true -- Save undo history
vim.opt.scrolloff = 10 -- Minimal lines to keep above and below the cursor
vim.opt.updatetime = 250 -- Decrease update time
vim.opt.timeoutlen = 300 -- Decrease mapped sequence wait time

-- [[ Indentation settings ]]
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.tabstop = tab_size -- Number of spaces a <Tab> counts for
vim.opt.softtabstop = tab_size -- Number of spaces when editing
vim.opt.shiftwidth = tab_size -- Number of spaces for autoindent
vim.opt.autoindent = true -- Enable auto indentation
vim.opt.breakindent = true -- Enable break indent
vim.o.smartindent = true -- Enable smart indent

-- [[ Line numbers and cursor ]]
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.cursorline = true -- Enable cursorline

-- [[ Command line and statusline ]]
vim.opt.cmdheight = 1 -- Hide(0) or show(1) the command line when not in use
vim.opt.showmode = false -- Disable mode display
vim.opt.ruler = false -- Remove "All" and line/column info
vim.o.laststatus = 3 -- Statusline global display
-- vim.o.statusline = "%f %h%m%r%=%-14.(%l,%c%V%) %P" -- Optional statusline format

-- [[ Search settings ]]
vim.opt.ignorecase = true -- Case-insensitive search
vim.opt.smartcase = true -- Case-sensitive if uppercase used

-- [[ Clipboard integration ]]
-- vim.opt.clipboard = "unnamedplus" -- Sync clipboard between OS and Neovim

-- [[ Split behavior ]]
vim.opt.splitright = true -- Vertical splits open to the right
vim.opt.splitbelow = true -- Horizontal splits open below

-- [[ UI enhancements ]]
vim.opt.signcolumn = "yes" -- Keep signcolumn on
vim.opt.list = true -- Enable list mode for whitespace characters
vim.opt.listchars = Icons.listchars -- Configure listchars

-- [[ Live substitution preview ]]
vim.opt.inccommand = "split" -- Enable live substitution previews

-- [[ Folding configuration ]]
vim.o.foldmethod = "expr" -- Use expression folding
vim.o.foldexpr = "nvim_treesitter#foldexpr()" -- Tree-sitter fold expression
vim.o.foldtext = "" -- Disables fold text
vim.o.foldenable = false -- Optional: Start with all folds closed
vim.o.foldlevel = 99 -- Open most folds by default
vim.o.foldlevelstart = 99 -- Open most folds by default

-- [[ Fillchars customization ]]
local fillchars = vim.opt.fillchars:get() -- Get current fillchars
fillchars.eob = " " -- Hide ~ at buffer end
fillchars.fold = " " -- Hide fold dots (•••)
vim.opt.fillchars = fillchars -- Set updated fillchars

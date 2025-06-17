-- Enable mouse mode
vim.opt.mouse = "a"

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable cursorline
vim.opt.cursorline = true

-- Cmdline
vim.opt.cmdheight = 1 -- Hide(0) or show(1) the command line when not in use
vim.opt.showmode = false -- Disable mode display
vim.opt.ruler = false -- Remove "All" and line/column info

-- Statusline
vim.o.laststatus = 3
-- vim.o.statusline = "%f %h%m%r%=%-14.(%l,%c%V%) %P"

-- Sync clipboard between OS and Neovim
-- vim.opt.clipboard = "unnamedplus"

-- Enable auto indentation
vim.opt.autoindent = true

-- Enable break indent
vim.opt.breakindent = true

-- Enable smart ident
vim.o.smartindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching unless \C or capital letters
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Split configuration
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Configure listchars for displaying whitespace
vim.opt.list = true
vim.opt.listchars = Icons.listchars

-- Enable live substitution previews
vim.opt.inccommand = "split"

-- Minimal lines to keep above and below the cursor
vim.opt.scrolloff = 10

-- Enabele folding:
vim.o.foldmethod = "expr" -- Use expression folding
vim.o.foldexpr = "nvim_treesitter#foldexpr()" -- Tree-sitter's fold expression

--- Disables fold text.
vim.o.foldtext = ""

-- Optional: Start with all folds closed
vim.o.foldenable = false
vim.o.foldlevel = 99 -- Open most folds by default (set to lower for fewer open folds)
vim.o.foldlevelstart = 99

-- Append characters to fillchars for a cleaner look
local fillchars = vim.opt.fillchars:get() -- Get current fillchars
fillchars.eob = " " -- Hide ~ at buffer end
fillchars.fold = " " -- Hide fold dots (•••)
vim.opt.fillchars = fillchars -- Set updated fillchars

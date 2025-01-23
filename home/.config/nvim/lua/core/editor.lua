-- Append characters to fillchars for a cleaner look
vim.opt.fillchars:append({ eob = " " })

-- Enable mouse mode
vim.opt.mouse = "a"

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Don't show the mode, cursorline and cmdline
vim.opt.showmode = false
vim.opt.cursorline = false
vim.opt.cmdheight = 0

-- Sync clipboard between OS and Neovim
vim.opt.clipboard = "unnamedplus"

-- Enable break indent
vim.opt.breakindent = true

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
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Enable live substitution previews
vim.opt.inccommand = "split"

-- Minimal lines to keep above and below the cursor
vim.opt.scrolloff = 10

-- Setup color scheme
vim.cmd.colorscheme("catppuccin")

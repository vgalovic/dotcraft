-- Append characters to fillchars for a cleaner look
vim.opt.fillchars:append({ eob = " " })

-- Enable mouse mode
vim.opt.mouse = "a"

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable cursorline
vim.opt.cursorline = true

-- Cmdline
vim.opt.cmdheight = 0 -- Hide the command line when not in use
vim.opt.showmode = false -- Disable mode display
vim.opt.ruler = false -- Remove "All" and line/column info
vim.opt.shortmess:append("c") -- Suppress unnecessary messages

-- Sync clipboard between OS and Neovim
vim.opt.clipboard = "unnamedplus"

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
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Enable live substitution previews
vim.opt.inccommand = "split"

-- Minimal lines to keep above and below the cursor
vim.opt.scrolloff = 10

--- Removes the ••• part.
vim.o.fillchars = "fold: "

-- enabele folding:
vim.o.foldmethod = "expr" -- Use expression folding
vim.o.foldexpr = "nvim_treesitter#foldexpr()" -- Tree-sitter's fold expression

--- Disables fold text.
vim.o.foldtext = ""

-- Optional: Start with all folds closed
vim.o.foldenable = true
vim.o.foldlevel = 99 -- Open most folds by default (set to lower for fewer open folds)

-- Enable color scheme
vim.cmd.colorscheme(vim.g.colorscheme)

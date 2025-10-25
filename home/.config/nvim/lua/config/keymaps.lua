-- [[ Keymap Helper ]]
local map = vim.keymap.set
local default_opts = { noremap = true, silent = true }

-- [[ Helper: Generate keymap options with description ]]
local function get_opts(desc)
	return vim.tbl_extend("force", default_opts, { desc = desc })
end

-- [[ Leader keys ]]
vim.g.mapleader = " " -- Set <Space> as leader key
vim.g.maplocalleader = " " -- Set <Space> as local leader

-- [[ Disable arrow keys ]]
map({ "n", "v", "i" }, "<Up>", "<cmd>echo 'Use K key!'<CR>", { noremap = true })
map({ "n", "v", "i" }, "<Down>", "<cmd>echo 'Use J key!'<CR>", { noremap = true })
map({ "n", "v", "i" }, "<Left>", "<cmd>echo 'Use H key!'<CR>", { noremap = true })
map({ "n", "v", "i" }, "<Right>", "<cmd>echo 'Use L key!'<CR>", { noremap = true })

-- [[ Command mode with ";" key ]]
map({ "n", "v" }, "Č", ":") -- Serbian layout

-- [[ Quick quit ]]
map("n", "q1", ":q!", default_opts)

-- [[ Window navigation ]]
-- map({ "n", "t" }, "<C-h>", "<C-w>h", { desc = "Move focus to the left window" })
-- map({ "n", "t" }, "<C-l>", "<C-w>l", { desc = "Move focus to the right window" })
-- map({ "n", "t" }, "<C-j>", "<C-w>j", { desc = "Move focus to the lower window" })
-- map({ "n", "t" }, "<C-k>", "<C-w>k", { desc = "Move focus to the upper window" })

-- [[ Window splits ]]
map({ "n", "v" }, "<leader>h", "<C-w>s", { desc = "Horizontal split" })
map({ "n", "v" }, "<leader>v", "<C-w>v", { desc = "Vertical split" })

-- [[ Buffer navigation ]]
map({ "n", "v" }, "<M-[>", "<CMD>bprevious<CR>", { desc = "Go to previous buffer" })
map({ "n", "v" }, "<M-]>", "<CMD>bnext<CR>", { desc = "Go to next buffer" })
map({ "n", "v" }, "<M-'>", "<cmd>b#<cr>", { desc = "Go to last active buffer" })
map({ "n", "v" }, "<M-q>", "<Cmd>bd<CR>", { desc = "Quit current buffer" })

-- [[ Clear search highlight ]]
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Stop search highlight" })

-- [[ Open :messages ]]
map("n", "gm", "<cmd>messages<cr>", get_opts("Open messages"))

-- [[ Visual mode utilities ]]
map("v", "<M-s>", ":sort<CR>", { desc = "Sort highlighted text" })
map("v", "K", ":m '>-2<CR>gv=gv", { desc = "Move line up" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })

-- [[ Clipboard integration ]]
map({ "n", "v" }, ",", '"+', get_opts("Use system clipboard"))

-- [[ Select all ]]
vim.keymap.set("n", "<C-a>", function()
	vim.cmd("normal! ggVG")
end, get_opts("Select all"))

-- [[ Increment/Decrement numbers ]]
map("n", "+", "<C-a>", { noremap = true, silent = true, desc = "Increment number" })
map("n", "-", "<C-x>", { noremap = true, silent = true, desc = "Decrement number" })

-- [[ Terminal mode escape ]]
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- [[ Delete all marks ]]
map("n", "<C-m>", "<cmd>delmarks!<CR>", { desc = "Delete all buffer marks" })

-- [[ Diagnostic shortcuts ]]
map("n", "<C-q>", function()
	vim.diagnostic.setloclist()
end, { desc = "Open diagnostic Quickfix list" })

map("n", "Q", function()
	vim.diagnostic.open_float()
end, get_opts("Open diagnostic float under cursor"))

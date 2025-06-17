local map = vim.keymap.set

local default_opts = { noremap = true, silent = true }

-- Function to generate options with a custom description
local function get_opts(desc)
	return vim.tbl_extend("force", default_opts, { desc = desc })
end
--
-- [[ Disable arrow keys ] ]
--
map({ "n", "v", "i" }, "<Up>", "<cmd>echo 'Use K key!'<CR>", { noremap = true })
map({ "n", "v", "i" }, "<Down>", "<cmd>echo 'Use J key!'<CR>", { noremap = true })
map({ "n", "v", "i" }, "<Left>", "<cmd>echo 'Use H key!'<CR>", { noremap = true })
map({ "n", "v", "i" }, "<Right>", "<cmd>echo 'Use L key!'<CR>", { noremap = true })
--
-- [[ Enables ";" to call command ]]
--
map({ "n", "v" }, ";", ":")
--
-- On Serbian keyboard layout
--
map({ "n", "v" }, "č", ":")
map({ "n", "v" }, "Č", ":")
--
-- [[ Quit without saving ]]
--
map("n", "q1", ":q!", default_opts)
--
--
-- [[ Navigation ]]
--
-- map({ "n", "t" }, "<C-h>", "<C-w>h", { desc = "Move focus to the left window" })
-- map({ "n", "t" }, "<C-l>", "<C-w>l", { desc = "Move focus to the right window" })
-- map({ "n", "t" }, "<C-j>", "<C-w>j", { desc = "Move focus to the lower window" })
-- map({ "n", "t" }, "<C-k>", "<C-w>k", { desc = "Move focus to the upper window" })
--
-- [[ Split ]]
--
map({ "n", "v" }, "<leader>h", "<C-w>s", { desc = "Horizontal split" })
map({ "n", "v" }, "<leader>v", "<C-w>v", { desc = "Vertical split" })
--
-- [[ Buffers ]]
--
map({ "n", "v" }, "<M-[>", "<CMD>bprevious<CR>", { desc = "Go to previous buffer" })
map({ "n", "v" }, "<M-]>", "<CMD>bnext<CR>", { desc = "Go to next buffer" })
map({ "n", "v" }, "<M-'>", "<cmd>b#<cr>", { desc = "Go to last active buffer" })
map({ "n", "v" }, "<M-q>", "<Cmd>bd<CR>", { desc = "Quit current buffer" })
--
-- [[ Highlights ]]
--
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Stop the highlighting for the 'hlsearch' option." })
--
-- [[ Messages ]]
--
map("n", "gm", "<cmd>messages<cr>", get_opts("Open messages"))
--
-- [[ Visual Mode ]]
--
map("v", "<M-s>", ":sort<CR>", { desc = "Sort highlighted text" })
map("v", "K", ":m '>-2<CR>gv=gv", { desc = "Move current line up" })
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move current line down" })
--
-- [[Set register for system clipboard]]
--
map({ "n", "v" }, ",", '"+', get_opts("Set register for system clipboard"))
--
-- [[ Select all ]]
--
-- stylua: ignore
vim.keymap.set("n", "<C-a>", function() vim.cmd("normal! ggVG") end, get_opts("Select all" ))
--
-- [[ Increment and decrement numbers ]]
--
map("n", "+", "<C-a>", { noremap = true, silent = true, desc = "Increment number" })
map("n", "-", "<C-x>", { noremap = true, silent = true, desc = "Decrement number" })
--
-- [[ Terminal ]]
--
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
--
-- [[ Delete Marks ]]
--
map("n", "<C-m>", "<cmd>delmarks!<CR>", { desc = "Delete marks for current buffer" })
--
-- [[ Diagnostic ]]
--
-- stylua: ignore start
map("n", "<C-q>", function() vim.diagnostic.setloclist() end, { desc = "Open diagnostic Quickfix list" })
map("n", "Q", function ()  vim.diagnostic.open_float() end, get_opts("Open diagnostic Float under cursor"))

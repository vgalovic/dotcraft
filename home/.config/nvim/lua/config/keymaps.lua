local map = vim.keymap.set

local default_opts = { noremap = true, silent = true }

-- Function to generate options with a custom description
local function get_opts(desc)
	return vim.tbl_extend("force", default_opts, { desc = desc })
end

local buffer = require("utils.mapping_actions.buffer")
local find = require("utils.mapping_actions.find")
local search = require("utils.mapping_actions.search_tools")
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
-- stylua: ignore
map({ "n", "v" }, "<M-Q>", function() buffer.delete_other_buffers() end, { desc = 'Delete all buffers except the current one' })
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
--
-- [[ Save ]]
--
map({ "n", "v", "i" }, "<C-s>", function() buffer.save() end, get_opts("Save"))
--
-- [[ New File ]]
--
map("n", "<leader>+", "<cmd>NewFile<cr>", { desc = "New file" })
--
-- [[ Find and replace ]]
--
map({ "n", "v" }, "<leader>ra", function() find.FindAndReplaceAll() end, { desc = "Find and replace all occurrences" })
map({ "n", "v" }, "<leader>rc", function() find.FindAndReplaceConfirm() end, { desc = "Find and rename occurrences with confirmation" })
--
-- [[ Find and delete ]]
--
map({ "n", "v" }, "<leader>da", function() find.FindAndDeleteAll() end, { desc = "Find and delete all occurrences" })
map({ "n", "v" }, "<leader>dc", function() find.FindAndDeleteConfirm() end, { desc = "Find and delete occurrences with confirmation" })
--
-- [[ Search on diagnostic ]]
--
map({ "n", "v" }, "gq", function() search.search_diagnostic_under_cursor() end, { desc = "Search diagnostic under cursor" })
--
-- [[ Search selected text ]]
--
map({ "v" }, "gs", function() search.search_selected_text() end, { desc = "Search selected text" })
--
-- [[ Github repo ]]
--
-- Show keymap only in lua file
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function()
    map("n", "gP", function() search.open_plugin_repo()  end, { desc = "Open Plugin Repository", buffer = true })
  end,
})

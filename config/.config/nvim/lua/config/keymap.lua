-- To reduce the time it takes to invoke a function, set locals from the mapping keymaps
local map = vim.keymap.set
-- local nvim_map = vim.api.nvim_set_keymap
--
-- [[ Disable arow keys ]]
--
map({ "n", "v", "i" }, "<Up>", "<cmd>echo 'Use K key!'<CR>", { noremap = true })
map({ "n", "v", "i" }, "<Down>", "<cmd>echo 'Use J key!'<CR>", { noremap = true })
map({ "n", "v", "i" }, "<Left>", "<cmd>echo 'Use H key!'<CR>", { noremap = true })
map({ "n", "v", "i" }, "<Right>", "<cmd>echo 'Use L key!'<CR>", { noremap = true })
--
-- [[ Which-Key Groups ]]
--
local wk = require("which-key")
--
wk.add({
	{ "<leader>r", group = "Find and Replace", mode = { "n", "v" }, icon = "󰛔 " },
	{ "<leader>x", group = "Find and Delete", mode = { "n", "v" }, icon = "󰆴 " },
	{ "<leader>l", group = "LSP", mode = { "n", "v" }, icon = " " },
	{ "<leader>g", group = "Git", mode = { "n" }, icon = " " },
	{ "<leader>s", group = "Search", mode = { "n", "v" }, icon = " " },
})
--
-- [[ Enables ";" to call command ]]
--
map({ "n", "v" }, ";", ":")
map({ "n", "v" }, "č", ":")
map({ "n", "v" }, "Č", ":")
--
-- [[ navigation Keymaps ]]
--
map("n", "<C-h>", "<C-w>h", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move focus to the upper window" })
--
-- [[ Split Keymaps ]]
--
wk.add({
	{ "<leader>v", "<C-w>v", desc = "Vertical split", mode = { "n", "v" }, icon = "" }, -- Icon for vertical split
	{ "<leader>h", "<C-w>s", desc = "Horizontal split", mode = { "n", "v" }, icon = "" }, -- Icon for horizontal split
})
--
--[[ Buffer Keymaps ]]
--
map({ "n", "v" }, "<A-j>", "<CMD>bprevious<CR>", { desc = "Go to previous buffer" })
map({ "n", "v" }, "<A-k>", "<CMD>bnext<CR>", { desc = "Go to next buffer" })
map({ "n", "v" }, "<A-s>", "<cmd>b#<cr>", { desc = "Go to last active buffer" })
map({ "n", "v" }, "<A-q>", "<Cmd>bd<CR>", { desc = "Quit curetn buffer" })
--
-- [[ highlights keymap ]]
--
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Stop the highlighting for the 'hlsearch' option." })
--
-- [[ Visual keymaps ]]
--
map("v", "<C-s>", ":sort<CR>") -- Sort highlighted text in visual mode with Control+S
map("v", "K", ":m '>-2<CR>gv=gv") -- Move current line up
map("v", "J", ":m '>+1<CR>gv=gv") -- Move current line down
--
-- [[ Diagnostic keymap ]]
--
wk.add({
	"<leader>q",
	function()
		vim.diagnostic.setloclist()
	end,
	desc = "Open diagnostic Quickfix list",
	icon = "󱖫 ",
})
--
-- [[ Terminal keymap ]]
--
-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
--
-- [[ New File keymap ]]
--
wk.add({ "<leader>+", ":enew<CR>:lua SaveAs()<CR>", mode = { "n" }, desc = "new file", icon = " " })
--
-- [[ SaveAs() Keymaps ]]
--
local opts = { desc = "Save as", noremap = true, silent = true }
--
map("n", "<A-w>", ":lua SaveAs()<CR>", opts) -- normal mode
map("i", "<A-w>", "<Esc>:lua SaveAs()<CR>a", opts) -- Insert mode
map("v", "<A-w>", "<Esc>:lua SaveAs()<CR>", opts) -- Visual mode
--
-- [[ Find and .. ]]
--
wk.add({
	-- Find and Replace with confirmation
	{
		"<leader>rc",
		function()
			FindAndReplaceConfirm()
		end,
		mode = { "n", "v" },
		desc = "Find and rename occurrences with confirmation",
		icon = " ",
	},
	-- Find and Replace without confirmation
	{
		"<leader>ra",
		function()
			FindAndReplaceAll()
		end,
		mode = { "n", "v" },
		desc = "Find and replace all occurrences",
		icon = " ",
	},
})
wk.add({
	-- Find and Delete  with confirmation
	{
		"<leader>xc",
		function()
			FindAndDeleteConfirm()
		end,
		mode = { "n", "v" },
		desc = "Find and delete occurrences with confirmation",
		icon = "󰱢 ",
	},
	-- Find and Delete without confirmation
	{
		"<leader>xa",
		function()
			FindAndDeleteAll()
		end,
		mode = { "n", "v" },
		desc = "Find and delete all occurrences",
		icon = "󱂥 ",
	},
})
--
-- [[ Mini.nvim Keymaps ]]
--
MiniFiles = require("mini.files")
wk.add({
	{
		"-",
		function()
			MiniFiles.open(vim.api.nvim_buf_get_name(0))
		end,
		mode = { "n", "v" },
		desc = "Open Files",
	},
	{ "<leader>z", "<cmd>mksession<CR>", mode = { "n", "v" }, desc = "Save Session", icon = " " },
})
--
-- [[ Dropbar Keymaps ]]
--
local dropbar_api = require("dropbar.api")
wk.add({
	{ ".", dropbar_api.pick, mode = { "n" }, desc = "Pick symbols in winbar", icon = "" },
})
--
--[[ Snacks Keymap ]]
--
Snacks = require("snacks")
wk.add({
	{
		"<leader>sn",
		function()
			Snacks.notifier.show_history()
		end,
		desc = "Notification History",
		icon = "󰂚",
	},
	{
		"<leader>gf",
		function()
			Snacks.lazygit.log_file()
		end,
		desc = "Lazygit Current File History",
		icon = "",
	},
	{
		"<leader>gg",
		function()
			Snacks.lazygit()
		end,
		desc = "Lazygit",
		icon = "",
	},
	{
		"<leader>gl",
		function()
			Snacks.lazygit.log()
		end,
		desc = "Lazygit Log (cwd)",
		icon = "",
	},
	{
		"<c-/>",
		function()
			Snacks.terminal.toggle()
		end,
		desc = "Toggle Terminal",
		icon = "",
	},
	{
		"]]",
		function()
			Snacks.words.jump(vim.v.count1)
		end,
		desc = "Next Reference",
		mode = { "n", "t" },
		icon = "󰼧",
	},
	{
		"[[",
		function()
			Snacks.words.jump(-vim.v.count1)
		end,
		desc = "Prev Reference",
		mode = { "n", "t" },
		icon = "󰒮",
	},
})
--
-- [[ Gitsigns keymaps ]]
--
wk.add({
	{ "<leader>gp", "<cmd>Gitsigns preview_hunk<CR>", mode = { "n", "v" }, desc = "Preview git hunk", icon = "" },
	{
		"<leader>gb",
		"<cmd>Gitsigns toggle_current_line_blame<CR>",
		mode = { "n", "v" },
		desc = "Toggle curetn line blame",
		icon = "",
	},
	{
		"<leader>gd",
		"<cmd>Gitsigns toggle_deleted<CR>",
		mode = { "n", "v" },
		desc = "Toggle deleted lines from git",
		icon = "",
	},
})
--
-- [[ Telescope Keymaps ]]
--
-- See `:help telescope.builtin`
wk.add({
	{ "<leader>sh", "<cmd>Telescope help_tags<cr>", mode = { "n", "v" }, desc = "Search Help", icon = "󰋗 " },
	{ "<leader>sk", "<cmd>Telescope keymaps<cr>", mode = { "n", "v" }, desc = "Search Keymaps", icon = "󰌌 " },
	{ "<leader>sf", "<cmd>Telescope find_files<cr>", mode = { "n", "v" }, desc = "Search Files", icon = " " },
	{
		"<leader>ss",
		"<cmd>Telescope builtin<cr>",
		mode = { "n", "v" },
		desc = "Search Select Telescope",
		icon = "󰒅 ",
	},
	{
		"<leader>sw",
		"<cmd>Telescope grep_string<cr>",
		mode = { "n", "v" },
		desc = "Search current Word",
		icon = " ",
	},
	{ "<leader>sg", "<cmd>Telescope live_grep<cr>", mode = { "n", "v" }, desc = "Search by Grep", icon = "󰺄 " },
	{ "<leader>sd", "<cmd>Telescope diagnostics<cr>", mode = { "n", "v" }, desc = "Search Diagnostics", icon = " " },
	{ "<leader>sr", "<cmd>Telescope resume<cr>", mode = { "n", "v" }, desc = "Search Resume", icon = " " },
	{
		"<leader>s/",
		TelescopeKeymapFunctions.live_grep_open_files,
		mode = { "n", "v" },
		desc = "Search in Open Files",
		icon = "󰱼 ",
	},
	{
		"<leader>sv",
		TelescopeKeymapFunctions.find_neovim_files,
		mode = { "n", "v" },
		desc = "Search Neovim files",
		icon = " ",
	},
	{ "<leader>.", "<cmd>Telescope oldfiles<cr>", mode = "n", opts, desc = "Search Recent Files", icon = "󰥔 " },
	{
		"<leader><leader>",
		"<cmd>Telescope buffers<cr>",
		mode = "n",
		opts,
		desc = "Find existing buffers",
		icon = "󱦞 ",
	},
	{
		"<leader>/",
		TelescopeKeymapFunctions.fuzzy_search_current_buffer,
		mode = "n",
		opts,
		desc = "Fuzzily search in current buffer",
		icon = "󰺯 ",
	},
})
--
-- [[ Autoformat Keymaps ]]
--
wk.add({
	"<leader>f",
	function()
		require("conform").format({ async = true, lsp_format = "fallback" })
	end,
	mode = "n",
	desc = "Format buffer",
	icon = " ",
})
--
--
-- [[ LSP Keymaps ]]
--
--
local M = {}

function M.setup_lsp_keymaps(bufnr)
	local lsp_map = function(keys, func, desc, mode)
		mode = mode or "n"
		map(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
	end

	-- Define LSP-related key mappings
	lsp_map("gd", require("telescope.builtin").lsp_definitions, "Goto Definition")
	lsp_map("gr", require("telescope.builtin").lsp_references, "Goto References")
	lsp_map("gI", require("telescope.builtin").lsp_implementations, "Goto Implementation")
	lsp_map("gD", vim.lsp.buf.declaration, "Goto Declaration")

	lsp_map("<leader>lt", require("telescope.builtin").lsp_type_definitions, "Type Definition")
	lsp_map("<leader>ld", require("telescope.builtin").lsp_document_symbols, "Document Symbols")
	lsp_map("<leader>lw", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace Symbols")
	lsp_map("<leader>lc", vim.lsp.buf.code_action, "Code Action", { "n", "x" })

	lsp_map("<tab>", vim.lsp.buf.hover, "Buffer hover")
	lsp_map("<backspace>", vim.lsp.buf.rename, "Rename")
end

return M

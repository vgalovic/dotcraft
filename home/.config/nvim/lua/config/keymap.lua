-- To reduce the time it takes to invoke a function, set locals from the mapping keymaps
local map = vim.keymap.set
-- local nvim_map = vim.api.nvim_set_keymap
--
local opts = { noremap = true, silent = true }
--
-- variables used to reference plugins
--
local minifiles = require("mini.files")
local minidiff = require("mini.diff")
--
local wk = require("which-key")
local snacks = require("snacks")
--
-- custom functions
local utils = require("utils")
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
map({ "n", "t" }, "<C-h>", "<C-w>h", { desc = "Move focus to the left window" })
map({ "n", "t" }, "<C-l>", "<C-w>l", { desc = "Move focus to the right window" })
map({ "n", "t" }, "<C-j>", "<C-w>j", { desc = "Move focus to the lower window" })
map({ "n", "t" }, "<C-k>", "<C-w>k", { desc = "Move focus to the upper window" })
--
-- [[ Split Keymaps ]]
--
wk.add({
	{ "<leader>v", "<C-w>v", desc = "Vertical split", mode = { "n", "v" }, icon = "" },
	{ "<leader>h", "<C-w>s", desc = "Horizontal split", mode = { "n", "v" }, icon = "" },
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
-- [[ Delete marks keymap ]]
--
map("n", "<C-m>", "<cmd>delmarks!<CR>", { desc = "Delete marks for current buffer" })
--
-- [[ New File keymap ]]
--
wk.add({
	"<leader>+",
	function()
		vim.cmd("enew")
		utils.save_as.SaveAs()
	end,
	mode = { "n" },
	desc = "new file",
	icon = " ",
})
--
-- [[ SaveAs() Keymaps ]]
--
local save_opts = { desc = "Save as", noremap = true, silent = true }
--
map({ "n", "v" }, "<A-w>", function()
	utils.save_as.SaveAs()
end, save_opts)
--
map("i", "<A-w>", function()
	utils.save_as.SaveAs()
	vim.cmd("startinsert")
end, save_opts)
--
-- [[ Toggle Theme Keymaps ]]
--
wk.add({
	{
		"<leader>c",
		function()
			utils.theme.ToggleTheme()
		end,
		mode = { "n" },
		desc = "Toggle Theme",
		icon = " ",
	},
})
--
-- [[ Find and .. ]]
--
-- Replace ..
wk.add({
	-- with confirmation
	{
		"<leader>rc",
		function()
			utils.find.FindAndReplaceConfirm()
		end,
		mode = { "n", "v" },
		desc = "Find and rename occurrences with confirmation",
		icon = " ",
	},
	--  without confirmation
	{
		"<leader>ra",
		function()
			utils.find.FindAndReplaceAll()
		end,
		mode = { "n", "v" },
		desc = "Find and replace all occurrences",
		icon = " ",
	},
})
--
-- Delete ..
wk.add({
	-- with confirmation
	{
		"<leader>xc",
		function()
			utils.find.FindAndDeleteConfirm()
		end,
		mode = { "n", "v" },
		desc = "Find and delete occurrences with confirmation",
		icon = "󰱢 ",
	},
	-- without confirmation
	{
		"<leader>xa",
		function()
			utils.find.FindAndDeleteAll()
		end,
		mode = { "n", "v" },
		desc = "Find and delete all occurrences",
		icon = "󱂥 ",
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
-- [[ Todo-comments Keymap ]]
--
wk.add({
	{
		"]t",
		function()
			require("todo-comments").jump_next({ keywords = { "TODO", "FIX", "HACK", "WARNING" } })
		end,
		mode = "n",
		desc = "Next todo comment",
		icon = "󰧣 ",
	},

	{
		"[t",
		function()
			require("todo-comments").jump_prev({ keywords = { "TODO", "FIX", "HACK", "WARNING" } })
		end,
		mode = "n",
		desc = "Previous todo comment",
		icon = "󰧡 ",
	},
})
--
-- [[ Mini.files Keymaps ]]
--
wk.add({
	{
		"-",
		function()
			minifiles.open(vim.api.nvim_buf_get_name(0))
		end,
		mode = { "n", "v" },
		desc = "Open Files",
	},
})
--
-- [[ Mini.session Keymaps ]]
--
wk.add({
	{ "<leader>z", "<cmd>mksession<CR>", mode = { "n", "v" }, desc = "Save Session", icon = " " },
})
--
-- [[ Mini.diff Keymaps ]]
--
wk.add({
	{
		"<leader>gt",
		function()
			minidiff.toggle_overlay(vim.api.nvim_get_current_buf())
		end,
		mode = { "n", "v" },
		desc = "Toggle Diff Overlay",
		icon = "󰈚 ",
	},
})
--
--[[ Snacks.notifier Keymap ]]
--
wk.add({
	{
		"<leader>sn",
		function()
			snacks.notifier.show_history()
		end,
		desc = "Notification History",
		icon = "󰂚",
	},
})
--
-- [[ Snacks.lazygit Keymap ]]
--
wk.add({
	{
		"<leader>gf",
		function()
			snacks.lazygit.log_file()
		end,
		desc = "Lazygit Current File History",
		icon = " ",
	},
	{
		"<leader>gg",
		function()
			snacks.lazygit({ cwd = vim.fn.expand("%:p:h") })
		end,
		desc = "Lazygit",
		icon = " ",
	},
	{
		"<leader>gl",
		function()
			snacks.lazygit.log({ cwd = vim.fn.expand("%:p:h") })
		end,
		desc = "Lazygit Log (cwd)",
		icon = " ",
	},
})
--
-- [[ Snacks.git.blame_line Keymap ]]
--
wk.add({
	{
		"<leader>gb",
		function()
			snacks.git.blame_line()
		end,
		mode = { "n", "v" },
		desc = "Git Blame Line",
		icon = " ",
	},
})
--
-- [[ Snacks.gitbrowse Keymap ]]
--
wk.add({
	{
		"<leader>gB",
		function()
			snacks.gitbrowse()
		end,
		desc = "Git Browse",
		mode = { "n", "v" },
		icon = " ",
	},
})
--
-- [[ Snacks.terminal Keymap ]]
--
wk.add({
	{
		"<c-/>",
		function()
			snacks.terminal.toggle()
		end,
		desc = "Toggle Terminal",
		icon = " ",
	},
})
--
-- [[ Snacks.words Keymap ]]
--
wk.add({
	{
		"]]",
		function()
			snacks.words.jump(vim.v.count1)
		end,
		desc = "Next Reference",
		mode = { "n", "t" },
		icon = "󰼧 ",
	},
	{
		"[[",
		function()
			snacks.words.jump(-vim.v.count1)
		end,
		desc = "Prev Reference",
		mode = { "n", "t" },
		icon = "󰒮 ",
	},
})
--
-- [[ Snacks.picker.commands Keymap ]]
--
wk.add({
	{
		"<C-;>",
		function()
			snacks.picker.commands({ layout = { preset = "vscode" } })
		end,
		desc = "Command List",
		icon = " ",
	},
	{
		"<M-;>",
		function()
			snacks.picker.command_history()
		end,
		desc = "Command History",
		icon = " ",
	},

	-- <leader>
	{
		"<leader><leader>",
		function()
			snacks.picker.buffers({
				layout = {
					preset = function()
						return vim.o.columns >= 120 and "ivy" or "dropdown"
					end,
				},
			})
		end,
		mode = "n",
		opts,
		desc = "Find existing buffers",
		icon = "󱦞 ",
	},
	{
		"<leader>/",
		function()
			snacks.picker.lines({ layout = { preset = "select" } })
		end,
		mode = "n",
		opts,
		desc = "Fuzzily search in current buffer",
		icon = "󰺯 ",
	},
	---@diagnostic disable: undefined-field
	{
		"<leader>u",
		function()
			snacks.picker.undo()
		end,
		mode = "n",
		desc = "Search Undo History",
		icon = "󰅴 ",
	},
	{
		"<leader>.",
		function()
			snacks.picker.recent()
		end,
		mode = "n",
		opts,
		desc = "Search Recent Files",
		icon = "󰥔 ",
	},
	-- <leader>s
	{
		"<leader>sh",
		function()
			snacks.picker.help()
		end,
		mode = { "n", "v" },
		desc = "Search Help",
		icon = "󰋗 ",
	},
	{
		"<leader>sk",
		function()
			snacks.picker.keymaps({ layout = { preview = false, preset = "default" } })
		end,
		mode = { "n", "v" },
		desc = "Search Keymaps",
		icon = "󰌌 ",
	},
	{
		"<leader>sf",
		function()
			snacks.picker.files()
		end,
		mode = { "n", "v" },
		desc = "Search Files",
		icon = " ",
	},
	{
		"<leader>sg",
		function()
			snacks.picker.grep()
		end,
		mode = { "n", "v" },
		desc = "Search by Grep",
		icon = "󰺄 ",
	},
	{
		"<leader>sr",
		function()
			snacks.picker.resume()
		end,
		mode = { "n", "v" },
		desc = "Search Resume",
		icon = " ",
	},
	{
		"<leader>sd",
		function()
			snacks.picker.diagnostics({ layout = { preset = "vertical" } })
		end,
		mode = { "n", "v" },
		desc = "Workspace Diagnostics",
		icon = " ",
	},
	{
		"<leader>ss",
		function()
			snacks.picker.pickers()
		end,
		mode = { "n", "v" },
		desc = "Search Select",
		icon = "󰒅 ",
	},
	{
		"<leader>st",
		function()
			---@diagnostic disable: undefined-field
			snacks.picker.todo_comments({
				keywords = { "TODO", "FIX", "HACK", "WARNING" },
				layout = {
					preset = function()
						return vim.o.columns >= 120 and "ivy" or "dropdown"
					end,
				},
				cwd = vim.fn.expand("%:p:h"),
			})
		end,
		mode = "n",
		desc = "Search Todos",
		icon = " ",
	},
	{
		"<leader>sw",
		function()
			snacks.picker.grep_word({ cwd = vim.fn.expand("%:p:h") })
		end,
		mode = { "n", "x" },
		desc = "Search current Word",
		icon = " ",
	},
	{
		"<leader>s/",
		function()
			snacks.picker.grep_buffers()
		end,
		mode = { "n", "v" },
		desc = "Search in Open Files",
		icon = "󰱼 ",
	},
	{
		"<leader>sc",
		function()
			---@diagnostic disable: assign-type-mismatch
			snacks.picker.files({ cwd = vim.fn.stdpath("config") })
		end,
		mode = { "n", "v" },
		desc = "Search Neovim Config",
		icon = " ",
	},
	-- <leader>g
	{
		"<leader>gs",
		function()
			snacks.picker.git_status({ cwd = vim.fn.expand("%:p:h") })
		end,
		desc = "Git Status",
		icon = "󱖫 ",
	},
	{
		"<leader>gd",
		function()
			snacks.picker.git_diff({ cwd = vim.fn.expand("%:p:h") })
		end,
		desc = "Git Diff",
		icon = " ",
	},
})
--
-- [[ LSP Keymaps ]]
--
local M = {}

function M.setup_lsp_keymaps(bufnr)
	local lsp_map = function(keys, func, desc, mode)
		mode = mode or "n"
		map(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
	end

	lsp_map("gd", function()
		snacks.picker.lsp_definitions()
	end, "Goto Definition")
	lsp_map("gy", function()
		snacks.picker.lsp_type_definitions()
	end, "Type Definition")

	lsp_map("gr", function()
		snacks.picker.lsp_references()
	end, "Goto References")

	lsp_map("gI", function()
		snacks.picker.lsp_implementations()
	end, "Goto Implementation")

	lsp_map("gD", vim.lsp.buf.declaration, "Goto Declaration")

	lsp_map("<leader>ls", function()
		snacks.picker.lsp_symbols()
	end, "Document Symbols")
	lsp_map("<leader>lw", function()
		snacks.picker.lsp_symbols({ cwd = vim.fn.expand("%:p:h") })
	end, "Workspace Symbols")

	lsp_map("<leader>lc", vim.lsp.buf.code_action, "Code Action", { "n", "x" })

	lsp_map("<tab>", vim.lsp.buf.hover, "Buffer hover")
	lsp_map("<backspace>", vim.lsp.buf.rename, "Rename")
end

return M

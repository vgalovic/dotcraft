---@diagnostic disable: assign-type-mismatch
---@diagnostic disable: undefined-field
--
-- To reduce the time it takes to invoke a function, set locals from the mapping keymaps
local map = vim.keymap.set
-- local nvim_map = vim.api.nvim_set_keymap
--
-- Options for key mappings:
local opts = { noremap = true, silent = true }
local save_opts = { desc = "Save as", noremap = true, silent = true }
--
-- My custom functions:
local save_as = require("utils.mapping_actions.save_as")
local find = require("utils.mapping_actions.find")
--
-- Variables used to reference plugins:
local wk = require("which-key")
local todo = require("todo-comments")
local files = require("mini.files")
local diff = require("mini.diff")
local snacks = require("snacks")
--
return {
	--
	-- [[ Disable arrow keys ] ]
	--
	map({ "n", "v", "i" }, "<Up>", "<cmd>echo 'Use K key!'<CR>", { noremap = true }),
	map({ "n", "v", "i" }, "<Down>", "<cmd>echo 'Use J key!'<CR>", { noremap = true }),
	map({ "n", "v", "i" }, "<Left>", "<cmd>echo 'Use H key!'<CR>", { noremap = true }),
	map({ "n", "v", "i" }, "<Right>", "<cmd>echo 'Use L key!'<CR>", { noremap = true }),
	--
	-- [[ Enables ";" to call command ]]
	--
	map({ "n", "v" }, ";", ":"),
	--
	-- On Serbian keyboard layout
	--
	map({ "n", "v" }, "č", ":"),
	map({ "n", "v" }, "Č", ":"),
	--
	-- [[ Navigation ]]
	--
	map({ "n", "t" }, "<C-h>", "<C-w>h", { desc = "Move focus to the left window" }),
	map({ "n", "t" }, "<C-l>", "<C-w>l", { desc = "Move focus to the right window" }),
	map({ "n", "t" }, "<C-j>", "<C-w>j", { desc = "Move focus to the lower window" }),
	map({ "n", "t" }, "<C-k>", "<C-w>k", { desc = "Move focus to the upper window" }),
	--
	-- [[ Buffers ]]
	--
	map({ "n", "v" }, "<A-j>", "<CMD>bprevious<CR>", { desc = "Go to previous buffer" }),
	map({ "n", "v" }, "<A-k>", "<CMD>bnext<CR>", { desc = "Go to next buffer" }),
	map({ "n", "v" }, "<A-s>", "<cmd>b#<cr>", { desc = "Go to last active buffer" }),
	map({ "n", "v" }, "<A-q>", "<Cmd>bd<CR>", { desc = "Quit current buffer" }),
	--
	-- [[ Highlights ]]
	--
	map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Stop the highlighting for the 'hlsearch' option." }),
	--
	-- [[ Visual Mode ]]
	--
	map("v", "<C-s>", ":sort<CR>", { desc = "Sort highlighted text" }),
	map("v", "K", ":m '>-2<CR>gv=gv", { desc = "Move current line up" }),
	map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move current line down" }),
	--
	-- [[ Terminal ]]
	--
	map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" }),
	--
	-- [[ Delete Marks ]]
	--
	map("n", "<C-m>", "<cmd>delmarks!<CR>", { desc = "Delete marks for current buffer" }),
	--
	-- [[ Save As ]]
	--
	-- stylua: ignore start
	map({ "n", "v" }, "<A-w>", function() save_as.SaveAs() end, save_opts),
	map("i", "<A-w>", function() save_as.SaveAs() vim.cmd("startinsert") end, save_opts),
	-- stylua: ignore end
	--
	-- [[ LSP ]]
	--
	setup_lsp_keymaps = function(bufnr)
		local lsp_map = function(keys, func, desc, mode)
			mode = mode or "n"
			map(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
		end

		-- stylua: ignore start
		lsp_map("gd", function() snacks.picker.lsp_definitions() end, "Goto Definition")
		lsp_map("gy", function() snacks.picker.lsp_type_definitions() end, "Type Definition")
		lsp_map("gr", function() snacks.picker.lsp_references() end, "Goto References")
		lsp_map("gI", function() snacks.picker.lsp_implementations() end, "Goto Implementation")
		lsp_map("gD", vim.lsp.buf.declaration, "Goto Declaration")
		lsp_map("<leader>ls", function() snacks.picker.lsp_symbols() end, "Document Symbols")
		lsp_map("<leader>lw", function() snacks.picker.lsp_symbols({ cwd = vim.fn.expand("%:p:h") }) end, "Workspace Symbols")
		lsp_map("<leader>lc", vim.lsp.buf.code_action, "Code Action", { "n", "x" })
		lsp_map("<tab>", vim.lsp.buf.hover, "Buffer hover")
		lsp_map("<backspace>", vim.lsp.buf.rename, "Rename")
		-- stylua: ignore end
	end,
	--
	wk.add({
		-- stylua: ignore start
		--
		-- [[ Groups ]]
		--
		{ "<leader>g", group = "Git", mode = { "n" }, icon = " " },
		{ "<leader>l", group = "LSP", mode = { "n", "v" }, icon = " " },
		{ "<leader>r", group = "Find and Replace", mode = { "n", "v" }, icon = "󰛔 " },
		{ "<leader>s", group = "Search", mode = { "n", "v" }, icon = " " },
		{ "<leader>x", group = "Find and Delete", mode = { "n", "v" }, icon = "󰆴 " },
		{ "<leader>y", group = "Yazi", mode = { "n", "v" }, icon = "󰇥 " },
		--
		-- [[ Autoformat ]]
		--
		{ "<leader>f", function() require("conform").format({ async = true, lsp_format = "fallback" }) end, mode = "n", desc = "Format buffer", icon = " " },
		--
		-- [[ Diagnostic ]]
		--
		{ "<leader>q", function() vim.diagnostic.setloclist() end, desc = "Open diagnostic Quickfix list", icon = "󱖫 " },
		--
		-- [[ Find and .. ]]
		--
		-- replace
		{ "<leader>ra", function() find.FindAndReplaceAll() end, mode = { "n", "v" }, desc = "Find and replace all occurrences", icon = " " },
		{ "<leader>rc", function() find.FindAndReplaceConfirm() end, mode = { "n", "v" }, desc = "Find and rename occurrences with confirmation", icon = " " },
		--
		-- delete
		{ "<leader>xa", function() find.FindAndDeleteAll() end, mode = { "n", "v" }, desc = "Find and delete all occurrences", icon = "󱂥 " },
		{ "<leader>xc", function() find.FindAndDeleteConfirm() end, mode = { "n", "v" }, desc = "Find and delete occurrences with confirmation", icon = "󰱢 " },
		--
		-- [[ Mini.diff ]]
		--
		{ "<leader>gt", function() diff.toggle_overlay(vim.api.nvim_get_current_buf()) end, mode = { "n", "v" }, desc = "Toggle Diff Overlay", icon = "󰈚 " },
		--
		-- [[ Mini.files ]]
		--
		{ "-", function() files.open(vim.api.nvim_buf_get_name(0)) end, mode = { "n", "v" }, desc = "Open Files", icon= "󰙅 " },
		--
		-- [[ Mini.session ]]
		--
		{ "<leader>z", "<cmd>mksession<CR>", mode = { "n", "v" }, desc = "Save Session", icon = " " },
		--
		-- [[ New File ]]
		--
		{ "<leader>+", function() vim.cmd("enew") save_as.SaveAs() end, mode = { "n" }, desc = "New file", icon = " " },
		--
		-- [[ Snacks.git.blame_line ]]
		--
		{ "<leader>gb", function() snacks.git.blame_line() end, mode = { "n", "v" }, desc = "Git Blame Line", icon = " " },
		--
		-- [[ Snacks.gitbrowse ]]
		--
		{ "<leader>gB", function() snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" }, icon = " " },
		--
		-- [[ Snacks.lazygit ]]
		--
		{ "<leader>gf", function() snacks.lazygit.log_file() end, desc = "Lazygit Current File History", icon = " " },
		{ "<leader>gg", function() snacks.lazygit({ cwd = vim.fn.expand("%:p:h") }) end, desc = "Lazygit", icon = " " },
		{ "<leader>gl", function() snacks.lazygit.log({ cwd = vim.fn.expand("%:p:h") }) end, desc = "Lazygit Log (cwd)", icon = " " },
		--
		-- [[ Snacks.notifier ]]
		--
		{ "<leader>sn", function() snacks.notifier.show_history() end, desc = "Notification History", icon = "󰂚" },
		--
		-- [[ Snacks.picker ]]
		--
		{ "<C-;>", function() snacks.picker.commands({ layout = { preset = "vscode" } }) end, desc = "Command List", icon = " " },
		{ "<M-;>", function() snacks.picker.command_history() end, desc = "Command History", icon = " " },
		{ "<leader>/", function() snacks.picker.lines({ layout = { preset = "select" } }) end, mode = "n", opts, desc = "Fuzzily search in current buffer", icon = "󰺯 " },
		{ "<leader>.", function() snacks.picker.recent() end, mode = "n", opts, desc = "Search Recent Files", icon = "󰥔 " },
		-- stylua: ignore end
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
		-- stylua: ignore start
		{ "<leader>sh", function() snacks.picker.help() end, mode = { "n", "v" }, desc = "Search Help", icon = "󰋗 " },
		{ "<leader>sf", function() snacks.picker.files() end, mode = { "n", "v" }, desc = "Search Files", icon = " " },
		{ "<leader>sg", function() snacks.picker.grep() end, mode = { "n", "v" }, desc = "Search by Grep", icon = "󰺄 " },
		{ "<leader>sk", function() snacks.picker.keymaps({ layout = { preview = false, preset = "default" } }) end, mode = { "n", "v" }, desc = "Search Keymaps", icon = "󰌌 " },
		{ "<leader>sr", function() snacks.picker.resume() end, mode = { "n", "v" }, desc = "Search Resume", icon = " " },
		{ "<leader>sd", function() snacks.picker.diagnostics({ layout = { preset = "vertical" } }) end, mode = { "n", "v" }, desc = "Workspace Diagnostics", icon = " " },
		{ "<leader>ss", function() snacks.picker.pickers({ layout = { preset = "select" } }) end, mode = { "n", "v" }, desc = "Search Select", icon = "󰒅 " },
		{ "<leader>sw", function() snacks.picker.grep_word({ cwd = vim.fn.expand("%:p:h") }) end, mode = { "n", "x" }, desc = "Search current Word", icon = " " },
		{ "<leader>s/", function() snacks.picker.grep_buffers() end, mode = { "n", "v" }, desc = "Search in Open Files", icon = "󰱼 " },
		{ "<leader>sc", function() snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, mode = { "n", "v" }, desc = "Search Neovim Config", icon = " " },
		-- stylua: ignore end
		{
			"<leader>st",
			function()
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
		--
		-- [[ Snacks.terminal ]]
		--
		--stylua: ignore start
		{ "<c-/>", function() snacks.terminal.toggle() end, desc = "Toggle Terminal", icon = " " },
		--
		-- [[ Snacks.words ]]
		--
		{ "[[", function() snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" }, icon = "󰒮 " },
		{ "]]", function() snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" }, icon = "󰼧 " },
		--
		-- [[ Split ]]
		--
		{ "<leader>h", "<C-w>s", desc = "Horizontal split", mode = { "n", "v" }, icon = " " },
		{ "<leader>v", "<C-w>v", desc = "Vertical split", mode = { "n", "v" }, icon = " " },
		--
		-- [[ Todo-Comments ]]
		--
		{ "[t", function() todo.jump_prev({ keywords = { "TODO", "FIX", "HACK", "WARNING" } }) end, mode = "n", desc = "Previous todo comment", icon = "󰧡 " },
		{ "]t", function() todo.jump_next({ keywords = { "TODO", "FIX", "HACK", "WARNING" } }) end, mode = "n", desc = "Next todo comment", icon = "󰧣 " },
		--
		-- [[ Yazi ]]
		--
		{ "<leader>yf", mode = { "n", "v" }, "<cmd>Yazi<cr>", desc = "Open yazi at the current file", icon = " " },
		{ "<leader>yr", mode = { "n", "v" }, "<cmd>Yazi toggle<cr>", desc = "Resume the last yazi session", icon = " " },
		{ "<leader>yw", mode = { "n", "v" }, "<cmd>Yazi cwd<cr>", desc = "Open yazi in nvim's working directory", icon = " " },
		-- stylua: ignore end
	}),
}

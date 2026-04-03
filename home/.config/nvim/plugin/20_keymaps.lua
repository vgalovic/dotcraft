---@diagnostic disable: undefined-global

-- =========================================================
-- KEYMAP HELPER (wrapper API)
-- =========================================================

_G.Map = {}

local default_opts = { noremap = true, silent = true }
local map = vim.keymap.set

-- Basic map
Map.map = function(lhs, rhs, desc, mode)
	map(mode or "n", lhs, rhs, { desc = desc })
end

-- Map with default opts
Map.map_opts = function(lhs, rhs, desc, mode)
	map(mode or "n", lhs, rhs, vim.tbl_extend("force", default_opts, { desc = desc }))
end

-- Leader maps
Map.map_leader = function(suffix, rhs, desc, mode)
	map(mode or "n", "<Leader>" .. suffix, rhs, { desc = desc })
end

-- LSP maps
Map.map_lsp = function(bufnr, lhs, rhs, desc, mode)
	map(mode or "n", lhs, rhs, { buffer = bufnr, desc = "LSP: " .. desc })
end

Map.map_lsp_leader = function(bufnr, suffix, rhs, desc, mode)
	map(mode or "n", "<Leader>" .. suffix, rhs, { buffer = bufnr, desc = "LSP: " .. desc })
end

-- =========================================================
-- HELPER FUNCTIONS
-- =========================================================

-- Change working directory to current file
local cd = function()
	local path = vim.fn.expand("%:p:h")

	if path == "" then
		vim.notify("No file associated with this buffer", vim.log.levels.WARN, { title = "CWD Change" })
		return
	end

	vim.cmd("cd " .. path)
	vim.notify("CWD changed to: " .. path, vim.log.levels.INFO, { title = "CWD Change" })
end

-- Delete installed vim.pack package
local deletePackage = function()
	local packages = vim.pack.get()

	local items = vim.tbl_map(function(pkg)
		return pkg.spec.name
	end, packages)

	vim.ui.select(items, {
		prompt = "Delete package:",
	}, function(choice)
		if choice then
			local ok, err = pcall(vim.pack.del, { choice })

			if not ok then
				vim.notify(
					"Failed to delete: " .. choice .. "\n" .. tostring(err),
					vim.log.levels.ERROR,
					{ title = "Package manager" }
				)
			end
		end
	end)
end

-- =========================================================
-- LEADER CONFIG + GROUPS
-- =========================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

Config.leader_groups = {
	{ mode = { "n" }, keys = "<Leader>b", desc = "+Buffer" },
	{ mode = { "n" }, keys = "<Leader>e", desc = "+Explore/Edit" },
	{ mode = { "n", "v" }, keys = "<Leader>f", desc = "+Find" },
	{ mode = { "n", "x" }, keys = "<Leader>g", desc = "+Git" },
	{ mode = { "n", "x" }, keys = "<Leader>l", desc = "+Language" },
	{ mode = { "n" }, keys = "<Leader>o", desc = "+Other" },
	{ mode = { "n" }, keys = "<Leader>p", desc = "+Package manager" },
	{ mode = { "n" }, keys = "<Leader>s", desc = "+Session" },
	{ mode = { "n" }, keys = "<Leader>t", desc = "+Terminal" },
	{ mode = { "n" }, keys = "<Leader>v", desc = "+Visits" },
	{ mode = { "n" }, keys = "<Leader>w", desc = "+Window split" },
	{ mode = { "n" }, keys = "<Leader>\\", desc = "+Toggle" },
}

-- =========================================================
-- BASIC UX IMPROVEMENTS
-- =========================================================

-- Disable arrow keys (force hjkl usage)
map({ "n", "v", "i" }, "<Up>", "<cmd>echo 'Use K key!'<CR>", default_opts)
map({ "n", "v", "i" }, "<Down>", "<cmd>echo 'Use J key!'<CR>", default_opts)
map({ "n", "v", "i" }, "<Left>", "<cmd>echo 'Use H key!'<CR>", default_opts)
map({ "n", "v", "i" }, "<Right>", "<cmd>echo 'Use L key!'<CR>", default_opts)

-- Fast escape
map("i", "jk", "<Esc>", default_opts)

-- Clear search highlight
Map.map("<Esc>", "<cmd>nohlsearch<CR>", "Stop search highlight")

-- =========================================================
-- EDITING / TEXT
-- =========================================================

Map.map("+", "<C-a>", "Increment number")
Map.map("-", "<C-x>", "Decrement number")

Map.map("<M-s>", ":sort<CR>", "Sort highlighted text", "v")

Map.map_opts("<C-a>", "<cmd>normal! ggVG<cr>", "Select all")

Map.map("[p", '<Cmd>exe "iput! " . v:register<CR>', "Paste Above")
Map.map("]p", '<Cmd>exe "iput "  . v:register<CR>', "Paste Below")

-- Serbian layout ":" shortcut
Map.map("Č", ":", "Command mode (Serbian layout)", { "n", "v" })

Map.map_leader("u", "<cmd>Undotree<cr>", "Undo tree")
-- =========================================================
-- TERMINAL
-- =========================================================

Map.map("<Esc><Esc>", "<C-\\><C-n>", "Exit terminal mode", "t")

-- =========================================================
-- WINDOWS / SPLITS
-- =========================================================

Map.map_leader("wh", "<C-w>s", "Horizontal split", { "n", "v" })
Map.map_leader("wv", "<C-w>v", "Vertical split", { "n", "v" })

-- =========================================================
-- BUFFERS
-- =========================================================

Map.map("<M-[>", "<CMD>bprevious<CR>", "Previous buffer")
Map.map("<M-]>", "<CMD>bnext<CR>", "Next buffer", { "n", "v" })
Map.map("<M-'>", "<cmd>b#<cr>", "Last buffer", { "n", "v" })
Map.map("<M-q>", "<Cmd>bd<CR>", "Delete buffer", { "n", "v" })

-- =========================================================
-- SYSTEM / CLIPBOARD
-- =========================================================

Map.map_opts(",", '"+', "Use system clipboard", { "n", "v" })

-- =========================================================
-- NAVIGATION / UTILITIES
-- =========================================================

Map.map_leader("ep", "<cmd>messages<cr>", "Open messages")
Map.map_opts("gcd", cd, "Change CWD to buffer directory")
Map.map("<C-m>", "<cmd>delmarks!<CR>", "Delete all marks")

-- =========================================================
-- DIAGNOSTICS
-- =========================================================

Map.map("<C-q>", "<cmd>lua vim.diagnostic.setloclist()<cr>", "Diagnostics → loclist")
Map.map_opts("Q", "<cmd>lua vim.diagnostic.open_float()<cr>", "Diagnostic float")

-- =========================================================
-- PACKAGE MANAGER (vim.pack)
-- =========================================================

Map.map_leader("ps", "<cmd>lua vim.pack.update(nil, { offline = true })<cr>", "Show packages")
Map.map_leader("pu", "<cmd>lua vim.pack.update()<cr>", "Update packages")
Map.map_leader("pd", deletePackage, "Delete package")

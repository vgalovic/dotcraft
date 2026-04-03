-- [[ Bootstrap lazy.nvim ]]
-- Ensure that lazy.nvim is installed by cloning it if not present
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

---@diagnostic disable: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })

	-- Handle clone failure gracefully
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

-- Prepend lazy.nvim path to runtime path
vim.opt.rtp:prepend(lazypath)

-- [[ Setup lazy.nvim ]]
require("lazy").setup({
	spec = {
		-- Load metadata support for luvit APIs (used by lazydev)
		{ "Bilal2453/luvit-meta", lazy = true },

		-- Setup lazydev to improve Lua LSP experience for Neovim development
		{
			"folke/lazydev.nvim",
			ft = "lua", -- Only load for Lua files
			opts = {
				library = {
					-- Load luvit types when `vim.uv` is found
					{ path = "luvit-meta/library", words = { "vim%.uv" } },
				},
			},
		},

		-- Import all plugins from the `lua/plugin` directory
		{ import = "plugin" },
	},

	-- [[ Lazy.nvim options ]]
	install = {
		-- Fallback colorscheme used during initial install
		colorscheme = { "default" },
	},

	-- Enable automatic plugin update checks
	checker = { enabled = true },
})

-- [[ Apply colorscheme after plugins have loaded ]]
-- Colorscheme should be set in `lua/config/setup.lua`
local ok = pcall(vim.cmd.colorscheme, vim.g.colorscheme)
if not ok then
	vim.notify('Colorscheme "' .. vim.g.colorscheme .. '" not found!', vim.log.levels.WARN, { title = "Colorscheme" })
end

-- [[ Keymap to open Lazy plugin manager ]]
vim.keymap.set("n", "<leader>pl", "<cmd>Lazy<cr>", {
	noremap = true,
	silent = true,
	desc = "Lazy",
})

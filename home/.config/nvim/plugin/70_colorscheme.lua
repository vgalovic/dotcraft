-- THEMES_AVAILABLE:
--everforest
-- moonfly
-- oldworld
-- github_dark, github_light, github_dark_dimmed, github_dark_default,
-- github_light_default, github_dark_high_contrast, github_light_high_contrast,
-- github_dark_colorblind, github_light_colorblind,
-- github_dark_tritanopia, github_light_tritanopia

-- =========================================================
-- Colorscheme Setup
-- =========================================================

---@diagnostic disable: undefined-global

-- =========================================================
-- Everforest Theme
-- =========================================================
local function everforest()
	Config.now(function()
		vim.pack.add({ { src = Repo.gh("neanias/everforest-nvim"), name = "everforest" } })
		require("everforest").setup({
			background = "hard",
			transparent_background_level = 0,
			italics = true,
			disable_italic_comments = false,
			inlay_hints_background = "dimmed",
		})
	end)
end

-- =========================================================
-- Moonfly Theme
-- =========================================================
local function moonfly()
	Config.now(function()
		vim.pack.add({ { src = Repo.gh("bluz71/vim-moonfly-colors"), name = "moonfly" } })

		vim.g.moonflyCursorColor = true
		vim.g.moonflyVirtualTextColor = true
		vim.g.moonflyNormalFloat = true
		vim.g.moonflyWinSeparator = 2
	end)
end

-- =========================================================
-- Oldworld Theme
-- =========================================================
local function oldworld()
	Config.now(function()
		vim.pack.add({ { src = Repo.gh("dgox16/oldworld.nvim"), name = "oldworld" } })
		require("oldworld").setup({
			terminal_colors = true,
			variant = "cooler", -- default, oled, cooler
			styles = {
				comments = { italic = true },
				keywords = {},
				identifiers = {},
				functions = { bold = true },
				variables = {},
				booleans = {},
			},
			highlight_overrides = {
				MiniStatusLineInactive = { fg = "#c9c7cd" },
				MiniStatuslineFilename = { fg = "#c9c7cd" },
				MiniTablineModifiedHidden = { fg = "#ea83a5" },
				ModeMsg = { fg = "#c9c7cd" },
				SnacksPickerDimmed = { fg = "#57575f" },
				StatusLineNC = { fg = "#c9c7cd" },
			},
		})
	end)
end

-- =========================================================
-- Theme Selector
-- =========================================================
local theme_case = {
	["everforest"] = everforest,
	["moonfly"] = moonfly,
	["oldworld"] = oldworld,
}

-- =========================================================
-- Apply Current Theme
-- =========================================================
local current = vim.g.colorscheme or ""

if theme_case[current] then
	theme_case[current]() -- call the function
elseif current:find("^github_") then
	-- Handle all github_* themes generically
	Config.now(function()
		vim.pack.add({ { src = Repo.gh("projekt0n/github-nvim-theme"), name = "github_theme" } })
	end)
else
	current = "default"
end

-- Colorscheme should be applied after plugins load
local ok = pcall(vim.cmd.colorscheme, vim.g.colorscheme)
if not ok then
	vim.notify('Colorscheme "' .. current .. '" not found!', vim.log.levels.WARN, { title = "Colorscheme" })
end

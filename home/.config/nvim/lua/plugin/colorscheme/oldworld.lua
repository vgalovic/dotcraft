-- THEMES_AVAILABLE:
-- oldworld
return {
	"dgox16/oldworld.nvim",
	enabled = vim.g.colorscheme == "oldworld",
	lazy = false,
	priority = 1000,
	opts = {
		terminal_colors = true,
		variant = "cooler", -- default, oled, cooler
		styles = { -- You can pass the style using the format: style = true
			comments = { italic = true }, -- style for comments
			keywords = {}, -- style for keywords
			identifiers = {}, -- style for identifiers
			functions = { bold = true }, -- style for functions
			variables = {}, -- style for variables
			booleans = {}, -- style for booleans
		},
		highlight_overrides = {
			MiniStatusLineInactive = { fg = "#c9c7cd" },
			MiniStatuslineFilename = { fg = "#c9c7cd" },
			MiniTablineModifiedHidden = { fg = "#ea83a5" },
			ModeMsg = { fg = "#c9c7cd" },
			SnacksPickerDimmed = { fg = "#57575f" },
			StatusLineNC = { fg = "#c9c7cd" },
		},
	},
}

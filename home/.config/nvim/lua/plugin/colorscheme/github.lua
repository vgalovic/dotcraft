-- THEMES_AVAILABLE:
-- github_dark, github_light, github_dark_dimmed, github_dark_default,
-- github_light_default, github_dark_high_contrast, github_light_high_contrast,
-- github_dark_colorblind, github_light_colorblind,
-- github_dark_tritanopia, github_light_tritanopia
return {
	"projekt0n/github-nvim-theme",
	name = "github-theme",
	enabled = vim.g.colorscheme:find("^github_") ~= nil,
	lazy = false,
	priority = 1000,
}

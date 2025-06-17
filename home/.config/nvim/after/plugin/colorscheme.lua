-- NOTE:
-- Apply colorscheme here because plugins (including colorscheme plugins) are loaded only after the plugin manager setup.
-- Setting the colorscheme in the 'after/plugin' directory ensures the theme is available and applied properly.
-- To see which theme is applied, check the setting in lua.config.setup.
vim.cmd.colorscheme(vim.g.colorscheme)

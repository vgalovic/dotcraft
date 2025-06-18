-- [[ GUI Font Settings ]]
-- Set the GUI font and size for Neovide (and other GUI clients)
vim.o.guifont = "JetBrainsMono Nerd Font:h11"

-- [[ Neovide Floating Window Effects ]]
vim.g.neovide_floating_shadow = true -- Enable floating shadows for windows
vim.g.neovide_floating_z_height = 10 -- Set z-height for floating windows
vim.g.neovide_light_angle_degrees = 45 -- Light source angle for shadows
vim.g.neovide_light_radius = 5 -- Light radius for shadow blur

-- [[ Neovide Theme Behavior ]]
vim.g.neovide_theme = "auto" -- Automatically switch theme with system

-- [[ Neovide Window Behavior ]]
vim.g.neovide_remember_window_size = true -- Remember window size between sessions

-- [[ Neovide Cursor Effects ]]
vim.g.neovide_cursor_vfx_mode = "pixiedust" -- Enable pixiedust effect on the cursor

-- This adjusts Kitty’s background opacity when you open Neovim.
-- If you’re running inside Kitty and `vim.g.kitty_solid` is true,
-- it makes the background fully solid on start,
-- then restores transparency when you exit.
-- Just make sure `dynamic_background_opacity yes` is set in kitty.conf.
-- To turn this off, set `vim.g.kitty_solid = false` in your config.
-- If you have set a different opacity in kitty.conf than
-- `original_opacity`, you will need to update the variable accordingly.

-- If running inside Kitty terminal and solid background mode is enabled
if vim.env.TERM == "xterm-kitty" and vim.g.kitty_solid then
	local original_opacity = 0.9

	-- On Neovim start, set Kitty background to fully opaque
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			os.execute("kitten @ set-background-opacity 1.0")
		end,
	})

	-- On Neovim exit, restore Kitty background transparency
	vim.api.nvim_create_autocmd("VimLeave", {
		callback = function()
			os.execute("kitten @ set-background-opacity " .. original_opacity)
		end,
	})
end

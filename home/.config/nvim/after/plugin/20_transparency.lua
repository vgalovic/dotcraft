-- Controls Neovim + Kitty transparency state.
--
-- - On startup: applies initial transparency state without toggling
-- - Toggle (<leader>\t): switches between transparent and solid mode
--   → Neovim: updates highlight background
--   → Kitty: updates background opacity (xterm-kitty only)
--
-- - On exit: restores Kitty opacity to `background_opacity`
--
-- Requires in kitty.conf:
--   allow_remote_control yes
--   dynamic_background_opacity yes
--
-- Kitty commands are skipped if not running inside xterm-kitty.
--
-- NOTE: `background_opacity` should match value in Kitty configuration.
local background_opacity = 0.9
local solid = 1.0

local transparent = vim.g.transparency or false

local function set_kitty_opacity(value)
	if vim.env.TERM ~= "xterm-kitty" then
		return
	end

	vim.system({
		"kitten",
		"@",
		"set-background-opacity",
		tostring(value),
	}, { detach = true })
end

local function transparent_floats()
	local groups = {
		"Normal",
		"NormalSB",
		"NormalNC",
		"NormalFloat",
		"WinBar",
		"WinBarNC",
	}

	for _, group in ipairs(groups) do
		vim.api.nvim_set_hl(0, group, { bg = "none" })
	end
end

local function apply_transparency()
	if transparent then
		transparent_floats()
		set_kitty_opacity(background_opacity)
	else
		vim.cmd.colorscheme(vim.g.colorscheme or "default")
		set_kitty_opacity(solid)
	end
end

function ToggleTransparency()
	transparent = not transparent
	apply_transparency()

	vim.notify(
		"Background is " .. (transparent and "transparent" or "solid"),
		vim.log.levels.INFO,
		{ title = "Transparency" }
	)
end

Map.map_leader("\\t", ToggleTransparency, "Toggle 'transparency'")

-- initial apply (IMPORTANT: no toggle here)
vim.api.nvim_create_autocmd("UIEnter", {
	once = true,
	callback = function()
		apply_transparency()
	end,
})

if vim.env.TERM == "xterm-kitty" then
	vim.api.nvim_create_autocmd("VimLeavePre", {
		callback = function()
			set_kitty_opacity(background_opacity)
		end,
	})
end

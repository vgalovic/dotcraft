--- @diagnostic disable: undefined-global

-- Starship integration for Yazi (status/prompt customization)
require("starship"):setup({
	config_file = "$HOME/.config/yazi/starship_yazi.toml",
})

-- Disable default status line (for a cleaner look)
require("no-status"):setup()

-- Git integration (e.g., shows git info in previews or files)
require("git"):setup()

-- Adds a border to UI elements
require("full-border"):setup({
	-- Available border types: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
})

-- Eza-preview plugin: enhances directory tree/file previews
require("eza-preview"):setup({
	level = 3, -- Directory depth for tree preview
	follow_symlinks = true, -- Follow symbolic links when previewing directories
	dereference = true, -- Show target file info instead of symlink info
})

-- Conditional setup: only when running inside Neovim
if os.getenv("NVIM") then
	-- Toggle preview pane with minimal layout
	require("toggle-pane"):entry("min-preview")
end

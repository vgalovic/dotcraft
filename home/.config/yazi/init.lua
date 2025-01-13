require("starship"):setup({ config_file = "$HOME/.config/yazi/starship_yazi.toml" })
require("git"):setup()
require("full-border"):setup({
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
})
require("eza-preview"):setup({
	-- Determines the directory depth level to tree preview
	level = 3,
	-- Whether to follow symlinks when previewing directories
	follow_symlinks = true,
	-- Whether to show target file info instead of symlink info
	dereference = true,
})

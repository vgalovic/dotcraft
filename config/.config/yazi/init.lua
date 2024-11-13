require("starship"):setup({ config_file = "$HOME/.config/yazi/starship_yazi.toml" })
require("eza-preview"):setup()
require("git"):setup()
require("full-border"):setup({
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
})

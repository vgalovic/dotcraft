---@class config.icons

local icons = {
	diagnostics = {
		debug = " ",
		error = " ",
		hint = " ",
		info = " ",
		prefix = "●",
		trace = "󰴽 ",
		warn = " ",
	},
	git = {
		branch = "",

		line_add = "▕▏",
		line_change = "▕▏",
		line_delete = "▁▁",

		status_add = "+",
		status_change = "~",
		status_delete = "-",
	},
	mason = {
		package_installed = "",
		package_pending = "",
		package_uninstalled = "",
	},
	pack = {
		loaded = "●",
		not_loaded = "○",
		to_cleanup = "×",
	},
	file = {
		brewfile = "",
		config = "󱁻",
		history = "",
		kitty = "󰄛",
		fish = "",
	},
	filetype = {
		log = "",
		nvim_pack = "󰏖",
		pager = "",
		sh = "",
		tmTheme = "",
		undotree = "",
		verilog = "",
	},
	starter = {
		lightning_bolt = "󱐋",
	},
}
return icons

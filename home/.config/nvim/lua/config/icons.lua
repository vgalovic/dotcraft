---@class utils.icons

local icons = {
	diagnostics = {
		prefix = "●",
		error = " ",
		warn = " ",
		hint = " ",
		info = " ",
		debug = " ",
		trace = "󰴽 ",
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
	file = {
		brewfile = "",
		config = "󱁻",
		kitty = "󰄛",
		history = "",
	},
	filetype = {
		log = "",
		sh = "",
		tmTheme = "",
		verilog = "",
		nvim_pack = "󰏖",
		undotree = "",
		pager = "",
	},
	starter = {
		lightning_bolt = "󱐋",
	},
}
return icons

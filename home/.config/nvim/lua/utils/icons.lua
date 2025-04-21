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
	lsp = {
		done = "✓",
		icon = "",
		spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
	},
	mason = {
		package_installed = "",
		package_pending = "",
		package_uninstalled = "",
	},
	snacks = {
		keys_config = " ",
		keys_files = " ",
		keys_new_file = " ",
		keys_quit = " ",
		keys_recent = " ",
		keys_session = " ",
		keys_update = " ",
		files = " ",
		projects = " ",
	},
	statusline = {
		-- section_separators = { left = "", right = "" },
		-- section_separators = { left = "", right = "" },
		section_separators = { left = "", right = "" },

		component_separators = "",

		modeicon = "",

		modified = "●",
		readonly = "",
		newfile = "",
		alternate_file = "# ",
		directory = "",

		unix = "",
		dos = "",
		mac = "",
	},
}
return icons

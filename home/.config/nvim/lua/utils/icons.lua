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
	listchars = { tab = "» ", trail = "·", nbsp = "␣" },
	lsp = {
		done = "✓",
		icon = "",
		spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },

		ripgrep = "",
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
	file = {
		config = "󱁻",
		kitty = "󰄛",
	},
	filetype = {
		log = "",
		sh = "",
		dashboard = "󰕮",
		notification_history = "",
		picker_input = "",
		picker_list = "󰙅",
		picker_preview = "",
		terminal = "",
		tmTheme = "",
		verilog = "",
	},
}
return icons

return {
	"folke/which-key.nvim",
	event = "VimEnter",
	opts = {
		--- @default "classic"
		--- @options ["classic", "modern", "helix"]
		preset = "helix",

		delay = 0,

		icons = {
			mappings = false,
		},

		spec = {
			{ "<leader>d", group = "Find and Delete", mode = { "n", "v" } },
			{ "<leader>g", group = "Git", mode = { "n" } },
			{ "<leader>l", group = "LSP", mode = { "n", "v" } },
			{ "<leader>r", group = "Find and Replace", mode = { "n", "v" } },
			{ "<leader>p", group = "Packge manager", mode = { "n" } },
			{ "<leader>s", group = "Search", mode = { "n", "v" } },
			{ "<leader>t", group = "Toggle", mode = { "n" } },
		},
	},
}

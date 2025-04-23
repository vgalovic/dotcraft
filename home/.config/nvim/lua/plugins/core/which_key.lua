return {
	"folke/which-key.nvim",
	event = "VimEnter", -- Ensures the plugin loads when Vim starts
	opts = {
		--- @default "classic"
		--- @options ["classic", "modern", "helix"]
		preset = "helix", -- Optional style preset for which-key
		delay = 0, -- No delay in showing the hints
		icons = {
			-- mappings = vim.g.nerdfonts,
			mappings = false, -- Disable icons for mappings
		},
		spec = {
			{ "<leader>d", group = "Find and Delete", mode = { "n", "v" } },
			{ "<leader>c", group = "Code" },
			{ "<leader>g", group = "Git", mode = { "n" } },
			{ "<leader>m", group = "Markdown", mode = { "n" } },
			{ "<leader>r", group = "Find and Replace", mode = { "n", "v" } },
			{ "<leader>p", group = "Package Manager", mode = { "n" } },
			{ "<leader>s", group = "Search", mode = { "n", "v" } },
			{ "<leader>t", group = "Toggle", mode = { "n" } },
			{ "<leader>w", group = "Window", mode = { "n" } },
		},
	},
	keys = {
		{
			"<c-w><space>",
			function()
				require("which-key").show({ keys = "<c-w>", loop = true })
			end,
			desc = "Window Hydra Mode",
		},
	},
}

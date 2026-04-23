vim.pack.add({ Repo.gh("OXY2DEV/markview.nvim") })

local presets = require("markview.presets")

require("markview").setup({
	preview = {
		icon_provider = "mini",
	},
	markdown = {
		headings = presets.headings.marker,
		tables = presets.tables.rounded,
	},
})

Map.map("<leader>m", "<cmd>Markview toggle<cr>", "Toggle Markview")

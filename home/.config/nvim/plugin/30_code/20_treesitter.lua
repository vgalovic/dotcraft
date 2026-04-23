Config.now_if_args(function()
	-- Define hook to update tree-sitter parsers after plugin is updated
	local ts_update = function()
		vim.cmd("TSUpdate")
	end
	Config.on_packchanged("nvim-treesitter", { "update" }, ts_update, ":TSUpdate")

	vim.pack.add({ Repo.gh("nvim-treesitter/nvim-treesitter") })

	require("nvim-treesitter").setup({
		sync_install = false,
		modules = {},
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = false,
			notify_on_error = true,
			disable = {},
		},
		indent = { enable = false },
		fold = { enable = false },
	})

	local languages = {
		"bash",
		"c",
		"cmake",
		"cpp",
		"html",
		"latex",
		"lua",
		"make",
		"markdown",
		"markdown_inline",
		"regex",
		"rust",
		"typst",
		-- "verilog",
		"vhdl",
		"vim",
		"vimdoc",
		"yaml",
	}
	local isnt_installed = function(lang)
		return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
	end
	local to_install = vim.tbl_filter(isnt_installed, languages)
	if #to_install > 0 then
		require("nvim-treesitter").install(to_install)
	end

	-- Enable tree-sitter after opening a file for a target language
	local filetypes = {}
	for _, lang in ipairs(languages) do
		for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
			table.insert(filetypes, ft)
		end
	end
	local ts_start = function(ev)
		vim.treesitter.start(ev.buf)
	end
	Config.new_autocmd("FileType", filetypes, ts_start, "Start tree-sitter")
end)

---@diagnostic disable:  undefined-global

-- =========================================================
--  COMPLETION / SNIPPETS
-- =========================================================
local now_if_args, later = Config.now_if_args, Config.later

now_if_args(function()
	local process_items_opts = { kind_priority = { Text = -1, Snippet = 99 } }

	require("mini.completion").setup({
		lsp_completion = {
			source_func = "omnifunc",
			auto_setup = false,
			process_items = function(items, base)
				return MiniCompletion.default_process_items(items, base, process_items_opts)
			end,
		},
	})

	Config.new_autocmd("LspAttach", nil, function(ev)
		vim.bo[ev.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
	end, "Set omnifunc")

	vim.lsp.config("*", { capabilities = MiniCompletion.get_lsp_capabilities() })
end)

later(function()
	local latex_patterns = { "latex/**/*.json", "**/latex.json" }
	local lang_patterns = {
		tex = latex_patterns,
		plaintex = latex_patterns,
		markdown_inline = { "markdown.json" },
	}

	local snippets = require("mini.snippets")
	local config_path = vim.fn.stdpath("config")
	snippets.setup({
		snippets = {
			snippets.gen_loader.from_file(config_path .. "/snippets/global.json"),
			snippets.gen_loader.from_lang({ lang_patterns = lang_patterns }),
		},
	})
end)

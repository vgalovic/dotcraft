-- =========================================================
-- HIGHLIGHTS
-- =========================================================

Config.later(function()
	local hipatterns = require("mini.hipatterns")

	-- helpers
	local function get_hl(hl_name)
		local hl_info = vim.api.nvim_get_hl(0, { name = hl_name, link = false })
		return not vim.tbl_isempty(hl_info) and hl_info or nil
	end

	local function setup_todo_hl_groups()
		for _, keyword in ipairs({ "Fixme", "Hack", "Todo", "Note" }) do
			local name = "MiniHipatterns" .. keyword
			local info = get_hl(name) or {}
			local bg = info.bg or (info.reverse and info.fg)

			vim.api.nvim_set_hl(0, name .. "Colon", { fg = bg, bg = bg })
			vim.api.nvim_set_hl(0, name .. "Body", { fg = bg })
		end
	end

	hipatterns.setup({
		highlighters = {
			-- Hex colors
			hex_color = hipatterns.gen_highlighter.hex_color(),

			-- TODO/FIXME/HACK/NOTE
			-- stylua: ignore start
			fixme       = { pattern = "() FIXME():",   group = "MiniHipatternsFixme" },
			hack        = { pattern = "() HACK():",    group = "MiniHipatternsHack" },
			todo        = { pattern = "() TODO():",    group = "MiniHipatternsTodo" },
			note        = { pattern = "() NOTE():",    group = "MiniHipatternsNote" },
			fixme_colon = { pattern = " FIXME():()",   group = "MiniHipatternsFixmeColon" },
			hack_colon  = { pattern = " HACK():()",    group = "MiniHipatternsHackColon" },
			todo_colon  = { pattern = " TODO():()",    group = "MiniHipatternsTodoColon" },
			note_colon  = { pattern = " NOTE():()",    group = "MiniHipatternsNoteColon" },
			fixme_body  = { pattern = " FIXME:().*()", group = "MiniHipatternsFixmeBody" },
			hack_body   = { pattern = " HACK:().*()",  group = "MiniHipatternsHackBody" },
			todo_body   = { pattern = " TODO:().*()",  group = "MiniHipatternsTodoBody" },
			note_body   = { pattern = " NOTE:().*()",  group = "MiniHipatternsNoteBody" },
			-- stylua: ignore end
		},
	})

	setup_todo_hl_groups()
	Config.new_autocmd("Colorscheme", nil, setup_todo_hl_groups, "Setup todo hl groups for mini.hipatterns.")
end)

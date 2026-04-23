-- =========================================================
-- SESSION / UI
-- =========================================================

local now = Config.now
local Icons = require("config.icons")

-- mini.sessions ---------------------------------------------
Config.on_event("VimEnter", function()
	require("mini.sessions").setup()
end)

-- mini.starter (dashboard) ----------------------------------
now(function()
	local starter = require("mini.starter")
	local stats = Icons.starter.lightning_bolt .. " loading..."

	starter.setup({
		header = require("config.dashboard").get_random_header(),
		evaluate_single = true,
		content_hooks = {
			starter.gen_hook.adding_bullet(),
			starter.gen_hook.indexing("all", { "Builtin actions" }),
			starter.gen_hook.aligning("center", "center"),
		},
		footer = function()
			return stats
		end,
	})

	-- After UI is ready, compute plugin stats
	vim.api.nvim_create_autocmd("UIEnter", {
		once = true,
		callback = function()
			-- Defer to next event loop tick so we don't block startup
			vim.schedule(function()
				-- Get all plugins (fast: no extra git info)
				local plugins = vim.pack.get(nil, { info = false })

				local total = #plugins -- total managed plugins
				local active = 0 -- plugins loaded so far

				-- Count active plugins (added in this session)
				for _, p in ipairs(plugins) do
					if p.active then
						active = active + 1
					end
				end

				-- Time from start to UI ready (approx)
				local time = (vim.loop.hrtime() - _G.start_time) / 1e6

				-- Final footer text
				stats = string.format(
					Icons.starter.lightning_bolt .. " %d startup / %d total plugins  • %.2fms to UI ready",
					active,
					total,
					time
				)
				-- Refresh dashboard to show updated footer
				starter.refresh()
			end)
		end,
	})
end)

-- statusline / tabline --------------------------------------
now(function()
	local statusline = require("mini.statusline")
	statusline.setup()
	statusline.section_location = function()
		return "%2l:%-2v"
	end
end)

now(function()
	require("mini.tabline").setup()
end)

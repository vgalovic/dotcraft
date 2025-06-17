-- Commands that you can be run in commnadline: Search, SearchWith, Wikipedia, StackOverflow, YouTube, SetSearchEngine
-- Functions than you can be set with keybind: search_diagnostic_under_cursor, search_selected_text, open_plugin_repo

local search_engines = {
	duckduckgo = "https://duckduckgo.com/?q=%s",
	brave = "https://search.brave.com/search?q=%s&source=web&summary",
	ecosia = "https://www.ecosia.org/search?method=index&q=%s",
	google = "https://www.google.com/search?q=%s",
	github = "https://github.com/search?q=%s&type=repositories",
	startpage = "https://www.startpage.com/do/dsearch?query=%s",
	reddit = "https://www.reddit.com/search/?q=%s&restrict_sr=on",
	stackoverflow = "https://stackoverflow.com/search?q=%s",
	wikipedia = "https://www.wikipedia.org/search-redirect.php?language=en&go=Go&search=%s",
	youtube = "https://www.youtube.com/results?search_query=%s",
}

local current_search_engine = "brave"
local browser_class = "zen" -- e.g., use `xprop | grep WM_CLASS` to find your browser class

local function open_in_browser(url)
	vim.fn.jobstart({ "xdg-open", url }, { detach = true })
	vim.defer_fn(function()
		vim.fn.jobstart({ "wmctrl", "-a", browser_class }, { detach = true })
	end, 1500)
end

local function web_search(query, engine)
	if not query or query == "" then
		vim.notify("Empty query", vim.log.levels.WARN, { title = "Web Search" })
		return
	end
	local engine_to_use = engine or current_search_engine
	local search_url = search_engines[engine_to_use]

	if not search_url then
		vim.notify(
			"Unknown search engine: " .. (engine or current_search_engine),
			vim.log.levels.ERROR,
			{ title = "Web Search" }
		)
		return
	end

	local encoded = query:gsub("[^%w%-_.~]", function(c)
		return c == " " and "%20" or string.format("%%%02X", string.byte(c))
	end)

	open_in_browser(search_url:format(encoded))
end

-- User commands
vim.api.nvim_create_user_command("Search", function(o)
	local query = table.concat(o.fargs, " ")
	vim.notify(
		"Searching using " .. current_search_engine .. ": " .. query,
		vim.log.levels.INFO,
		{ title = "Web Search" }
	)
	web_search(query)
end, { nargs = "+", desc = "Search the web" })

vim.api.nvim_create_user_command("Wikipedia", function(o)
	local query = table.concat(o.fargs, " ")
	vim.notify("Searching Wikipedia: " .. query, vim.log.levels.INFO)
	web_search(query, "wikipedia")
end, { nargs = "+", desc = "Search Wikipedia" })

vim.api.nvim_create_user_command("StackOverflow", function(o)
	local query = table.concat(o.fargs, " ")
	vim.notify("Searching StackOverflow: " .. query, vim.log.levels.INFO)
	web_search(query, "stackoverflow")
end, { nargs = "+", desc = "Search StackOverflow" })

vim.api.nvim_create_user_command("YouTube", function(o)
	local query = table.concat(o.fargs, " ")
	vim.notify("Searching YouTube: " .. query, vim.log.levels.INFO)
	web_search(query, "youtube")
end, { nargs = "+", desc = "Search YouTube" })

vim.api.nvim_create_user_command("SearchWith", function(opts)
	local engine = opts.fargs[1]
	local query = table.concat(vim.list_slice(opts.fargs, 2), " ")

	if not search_engines[engine] then
		vim.notify("Unknown engine: " .. engine .. ", using default", vim.log.levels.WARN)
		web_search(query)
	else
		vim.notify("Searching using " .. engine .. ": " .. query, vim.log.levels.INFO)
		web_search(query, engine)
	end
end, {
	nargs = "+",
	desc = "Search with a specific engine",
	complete = function(_, line, _)
		local args = vim.split(line, "%s+")
		if #args == 2 then
			local partial = args[2] or ""
			local matches = {}
			for engine in pairs(search_engines) do
				if engine:find(partial) == 1 then
					table.insert(matches, engine)
				end
			end
			return matches
		end
		return {}
	end,
})

vim.api.nvim_create_user_command("SetSearchEngine", function(o)
	local engine = o.fargs[1]
	if search_engines[engine] then
		current_search_engine = engine
		vim.notify("Search engine set to: " .. engine, vim.log.levels.INFO)
	else
		vim.notify("Unknown engine: " .. engine, vim.log.levels.ERROR)
	end
end, {
	nargs = 1,
	desc = "Set the default search engine",
	complete = function(_, line, _)
		local partial = vim.split(line, "%s+")[2] or ""
		local matches = {}
		for engine in pairs(search_engines) do
			if engine:find(partial) == 1 then
				table.insert(matches, engine)
			end
		end
		return matches
	end,
})

-- Keymaps
local function map(mode, lhs, rhs, opts)
	opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
	vim.keymap.set(mode, lhs, rhs, opts)
end

map({ "n", "v" }, "gq", function()
	local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
	if #diagnostics == 0 then
		vim.notify("No diagnostic under cursor", vim.log.levels.INFO)
		return
	end
	local message = diagnostics[1].message
	local ext = vim.fn.expand("%:e")
	local context = vim.bo.filetype ~= "" and vim.bo.filetype or ext
	web_search(message .. " " .. context)
end, { desc = "Search diagnostic under cursor" })

map("v", "g<leader>", function()
	vim.cmd('silent normal! "xy')
	local selected_text = vim.fn.getreg("x")
	if selected_text == "" then
		vim.notify("No text selected", vim.log.levels.WARN)
		return
	end
	local query = selected_text:gsub("[\n\t]+", " "):gsub("%s+", " ")
	web_search(query)
end, { desc = "Search selected text" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		map("n", "gP", function()
			local word = vim.fn.expand("<cWORD>")
			local repo = word:match('([^"%s]+/[^"%s]+)')
			if repo then
				local url = "https://github.com/" .. repo
				vim.notify("Opening GitHub: " .. url, vim.log.levels.INFO)
				open_in_browser(url)
			else
				vim.notify("Not a valid GitHub repo", vim.log.levels.WARN)
			end
		end, { desc = "Open plugin repo", buffer = true })
	end,
})

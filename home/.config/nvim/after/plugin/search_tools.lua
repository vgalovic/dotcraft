-- ===============================
-- Web Search Configuration
-- ===============================

-- List of search engines
local search_engines = {
	chatgpt = "https://chat.openai.com/?prompt=%s",
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

local current_search_engine = vim.g.default_search_engine or "google"

-- Function to prepare and open search URL
local function web_search(query, engine, notif_body, notif_level)
	if not query or query == "" then
		vim.notify("Empty query", vim.log.levels.WARN, { title = "Web Search" })
		return
	end

	local engine_to_use = engine or current_search_engine
	local search_url = search_engines[engine_to_use]

	if not search_url then
		vim.notify("Unknown search engine: " .. engine_to_use, vim.log.levels.ERROR, { title = "Web Search" })
		return
	end

	local encoded = query:gsub("[^%w%-_.~]", function(c)
		return c == " " and "%20" or string.format("%%%02X", string.byte(c))
	end)

	if notif_body and notif_body:match("%S") then
		vim.notify(notif_body, notif_level or vim.log.levels.INFO, { title = "Web Search" })
	end

	vim.fn.jobstart({ "xdg-open", search_url:format(encoded) }, { detach = true })
end

-- ===============================
-- User Commands
-- ===============================

-- General search using default engine
vim.api.nvim_create_user_command("Search", function(o)
	local query = table.concat(o.fargs, " ")
	web_search(query, nil, "Searching using " .. current_search_engine .. ": " .. query)
end, { nargs = "+", desc = "Search the web" })

-- Specific engines shortcuts
vim.api.nvim_create_user_command("Chatgpt", function(o)
	local query = table.concat(o.fargs, " ")
	web_search(query, "chatgpt", "Searching Chatgpt: " .. query)
end, { nargs = "+", desc = "Search Chatgpt" })

vim.api.nvim_create_user_command("Wikipedia", function(o)
	local query = table.concat(o.fargs, " ")
	web_search(query, "wikipedia", "Searching Wikipedia: " .. query)
end, { nargs = "+", desc = "Search Wikipedia" })

vim.api.nvim_create_user_command("StackOverflow", function(o)
	local query = table.concat(o.fargs, " ")
	web_search(query, "stackoverflow", "Searching StackOverflow: " .. query)
end, { nargs = "+", desc = "Search StackOverflow" })

vim.api.nvim_create_user_command("YouTube", function(o)
	local query = table.concat(o.fargs, " ")
	web_search(query, "youtube", "Searching YouTube: " .. query)
end, { nargs = "+", desc = "Search YouTube" })

-- Search with a specific engine
vim.api.nvim_create_user_command("SearchWith", function(opts)
	local engine = opts.fargs[1]
	local query = table.concat(vim.list_slice(opts.fargs, 2), " ")

	if not search_engines[engine] then
		web_search(query, nil, "Unknown engine: " .. engine .. ", using default", vim.log.levels.WARN)
	else
		web_search(query, engine, "Searching using " .. engine .. ": " .. query)
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

-- List all available search engines
vim.api.nvim_create_user_command("SearchEnginesList", function()
	local names = {}
	for name in pairs(search_engines) do
		table.insert(names, name)
	end
	table.sort(names)
	vim.notify(
		"Search engines:\n• " .. table.concat(names, "\n• "),
		vim.log.levels.INFO,
		{ title = "Search Engines List" }
	)
end, {})

-- Set default search engine
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

-- ===============================
-- Keymaps Helper
-- ===============================
local function map(mode, lhs, rhs, opts)
	opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
	vim.keymap.set(mode, lhs, rhs, opts)
end

-- ===============================
-- Keymaps: Diagnostic Search
-- ===============================

-- Search diagnostic under cursor using default engine
map({ "n", "v" }, "gq", function()
	local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
	if #diagnostics == 0 then
		vim.notify("No diagnostic under cursor", vim.log.levels.INFO, { title = "Web Search" })
		return
	end

	local message = diagnostics[1].message
	local context = vim.bo.filetype ~= "" and vim.bo.filetype or vim.fn.expand("%:e")
	web_search(message .. " " .. context)
end, { desc = "Search diagnostic under cursor (default: " .. current_search_engine .. ")" })

-- Search diagnostic under cursor with chosen engine
map({ "n", "v" }, "gQ", function()
	local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
	if #diagnostics == 0 then
		vim.notify("No diagnostic under cursor", vim.log.levels.INFO, { title = "Web Search" })
		return
	end

	local message = diagnostics[1].message
	local context = vim.bo.filetype ~= "" and vim.bo.filetype or vim.fn.expand("%:e")
	local query = message .. " " .. context

	-- Prompt user for engine
	local engines = {}
	for name in pairs(search_engines) do
		table.insert(engines, name)
	end
	table.sort(engines)

	vim.ui.select(engines, {
		prompt = "Choose search engine for diagnostic:",
	}, function(choice)
		if choice then
			web_search(query, choice, "Searching using " .. choice .. ": " .. query, vim.log.levels.INFO)
		else
			vim.notify("Search canceled", vim.log.levels.INFO)
		end
	end)
end, { desc = "Search diagnostic under cursor with chosen engine" })

-- ===============================
-- Keymaps: Visual Selection Search
-- ===============================

-- Search selected text with default engine
map("v", "gv", function()
	vim.cmd('silent normal! "xy')
	local selected_text = vim.fn.getreg("x")
	if selected_text == "" then
		vim.notify("No text selected", vim.log.levels.WARN)
		return
	end
	local query = selected_text:gsub("[\n\t]+", " "):gsub("%s+", " ")
	web_search(query)
end, { desc = "Search selected text (default: " .. current_search_engine .. ")" })

-- Search selected text with chosen engine
map("v", "gV", function()
	vim.cmd('silent normal! "xy') -- copy selection to register x
	local selected_text = vim.fn.getreg("x")
	if not selected_text or selected_text:match("^%s*$") then
		vim.notify("No text selected", vim.log.levels.WARN, { title = "Web Search" })
		return
	end

	local query = selected_text:gsub("[\n\t]+", " "):gsub("%s+", " ")

	-- Prompt user for engine
	local engines = {}
	for name in pairs(search_engines) do
		table.insert(engines, name)
	end
	table.sort(engines)

	vim.ui.select(engines, {
		prompt = "Choose search engine:",
	}, function(choice)
		if choice then
			web_search(query, choice, "Searching using " .. choice .. ": " .. query)
		else
			vim.notify("Search canceled", vim.log.levels.INFO, { title = "Web Search" })
		end
	end)
end, { desc = "Search selected text with chosen engine" })

-- ===============================
-- GitHub Repo Shortcut for Lua Files
-- ===============================
vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		map("n", "gP", function()
			local word = vim.fn.expand("<cWORD>")
			local repo = word:match('([^"%s]+/[^"%s]+)')
			if repo then
				local url = "https://github.com/" .. repo
				vim.notify("Opening GitHub: " .. url, vim.log.levels.INFO, { title = "Neovim plugin" })
				vim.fn.jobstart({ "xdg-open", url }, { detach = true })
			else
				vim.notify("Not a valid GitHub repo", vim.log.levels.WARN, { title = "Neovim plugin" })
			end
		end, { desc = "Open plugin repo", buffer = true })
	end,
})

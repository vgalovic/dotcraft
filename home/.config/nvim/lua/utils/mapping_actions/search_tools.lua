---@class utils.mapping_actions.search_tools

-- Commands that you can be run in commnadline: Search, SearchWith, Wikipedia, StackOverflow, YouTube, SetSearchEngine
-- Functions than you can be set with keybind: search_diagnostic_under_cursor, search_selected_text, open_plugin_repo

local M = {}

-- Search Engine URLs: Define the search engines and their respective URLs
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

-- Current search engine (can be changed to any engine from the search_engines table)
local current_search_engine = "brave"

-- Default web browser class (e.g., "zen" for Zen browser)
-- You can find the class of your browser with command: xprop | grep WM_CLASS
local browser_class = "zen"

-- Function to open URL in a web browser
local function open_in_browser(url)
	-- Open the URL using xdg-open
	vim.fn.jobstart({ "xdg-open", url }, { detach = true })

	-- Optionally bring the browser to focus after a short delay
	vim.defer_fn(function()
		vim.fn.jobstart({ "wmctrl", "-a", browser_class }, { detach = true })
	end, 1500)
end

-- Web Search: Perform a search using an external browser
local function web_search(query, engine)
	if not query or query == "" then
		vim.notify("Empty query.", vim.log.levels.WARN, { title = "Web Search" })
		return
	end

	-- Use the provided engine, or fallback to the current_search_engine
	local engine_to_use = engine or current_search_engine
	local search_url = search_engines[engine_to_use]

	-- If no valid engine is found, notify the user
	if not search_url then
		vim.notify(
			"Unknown search engine: " .. (engine or current_search_engine),
			vim.log.levels.ERROR,
			{ title = "Web Search" }
		)
		return
	end

	-- Encode the query to URL-safe format
	local encoded = query:gsub("[^%w%-_.~]", function(c)
		if c == " " then
			return "%20" -- Encode spaces as %20
		else
			return string.format("%%%02X", string.byte(c)) -- Encode other special characters
		end
	end)

	-- Open the formatted search URL in the browser
	open_in_browser((search_url):format(encoded))
end

-- ============================
--  Web Search Commands
-- ============================

-- General Web Search Command
vim.api.nvim_create_user_command("Search", function(o)
	local query = table.concat(o.fargs, " ") -- Combine all arguments into a single string
	vim.notify(
		"Searching on web using " .. current_search_engine .. ": " .. query,
		vim.log.levels.INFO,
		{ title = "Web Search" }
	)
	web_search(query) -- Perform the web search
end, {
	nargs = "+", -- Accepts one or more arguments
	desc = "Search on web", -- Description for the command
})

-- Wikipedia Search Command
vim.api.nvim_create_user_command("Wikipedia", function(o)
	local query = table.concat(o.fargs, " ")
	vim.notify("Searching on Wikipedia: " .. query, vim.log.levels.INFO, { title = "Web Search" })
	web_search(query, "wikipedia") -- Use Wikipedia search engine
end, {
	nargs = "+", -- Accepts one or more arguments
	desc = "Search on Wikipedia", -- Description for the command
})

-- StackOverflow Search Command
vim.api.nvim_create_user_command("StackOverflow", function(o)
	local query = table.concat(o.fargs, " ")
	vim.notify("Searching on StackOverflow: " .. query, vim.log.levels.INFO, { title = "Web Search" })
	web_search(query, "stackoverflow") -- Use StackOverflow search engine
end, {
	nargs = "+", -- Accepts one or more arguments
	desc = "Search on StackOverflow", -- Description for the command
})

-- YouTube Search Command
vim.api.nvim_create_user_command("YouTube", function(o)
	local query = table.concat(o.fargs, " ")
	vim.notify("Searching on YouTube: " .. query, vim.log.levels.INFO, { title = "Web Search" })
	web_search(query, "youtube") -- Use youtube search engine
end, {
	nargs = "+", -- Accepts one or more arguments
	desc = "Search on YouTube", -- Description for the command
})

-- Search with a specified engine
vim.api.nvim_create_user_command("SearchWith", function(opts)
	local engine = opts.fargs[1]
	local query = table.concat(vim.list_slice(opts.fargs, 2), " ")

	if not search_engines[engine] then
		vim.notify(
			"Unknown search engine: " .. engine .. ", using default",
			vim.log.levels.ERROR,
			{ title = "Web Search" }
		)
		vim.notify(
			"Searching on web using " .. current_search_engine .. ": " .. query,
			vim.log.levels.INFO,
			{ title = "Web Search" }
		)
		web_search(query)
		return
	end

	vim.notify("Searching on web using " .. engine .. ": " .. query, vim.log.levels.INFO, { title = "Web Search" })
	web_search(query, engine)
end, {
	nargs = "+",
	desc = "Search with a specific engine",
	complete = function(_, line, _)
		-- Split the full command line into words using whitespace
		local args = vim.split(line, "%s+")

		-- Only proceed if there are exactly two arguments:
		-- 1. The command name
		-- 2. The partial engine name
		if #args == 2 then
			local partial = args[2] or "" -- Get the second argument (the user's input so far)

			local matches = {} -- Table to collect matching engine names

			-- Loop through all search engine names
			for engine in pairs(search_engines) do
				-- If the engine name starts with the partial input
				if engine:find(partial) == 1 then
					table.insert(matches, engine) -- Add it to the list of matches
				end
			end

			return matches -- Return the list of matching engines for autocomplete
		end

		return {} -- If not exactly one argument after the command, return nothing
	end,
})

-- =========================================
--  Diagnostic and Selection Based Search
-- =========================================

-- Grabs the diagnostic under cursor and searches it with language context
function M.search_diagnostic_under_cursor()
	local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
	if #diagnostics == 0 then
		vim.notify("No diagnostic under cursor", vim.log.levels.INFO, { title = "Search on diagnostic" })
		return
	end

	local message = diagnostics[1].message

	-- Append filetype or file extension to give language context
	local ext = vim.fn.expand("%:e")
	local filetype = vim.bo.filetype
	local context = filetype ~= "" and filetype or ext

	local search_query = message .. " " .. context
	vim.notify("Searching on diagnostic: " .. search_query, vim.log.levels.INFO, { title = "Search on diagnostic" })
	web_search(search_query) -- Perform search with diagnostic message and context
end

-- Searches the visually selected text after yanking it
function M.search_selected_text()
	vim.cmd('silent normal! "xy') -- Yank visual selection into register x silently

	local selected_text = vim.fn.getreg("x")
	if selected_text == "" then
		vim.notify("No text selected", vim.log.levels.WARN, { title = "Search selected text" })
		return
	end

	-- Remove newlines, tabs, and reduce multiple spaces to one
	local single_line_text = selected_text:gsub("[\n\t]+", " "):gsub("%s+", " ")

	vim.notify("Searching selected text: " .. single_line_text, vim.log.levels.INFO, { title = "Search selected text" })
	web_search(single_line_text) -- Perform search with selected text
end

-- ============================
--  GitHub Repository Search
-- ============================

-- Opens the GitHub repository based on 'user/repo' under the cursor
function M.open_plugin_repo()
	local word = vim.fn.expand("<cWORD>")
	local repo = word:match('([^"%s]+/[^"%s]+)') -- Match user/repo

	if repo then
		local url = "https://github.com/" .. repo
		vim.notify("Opening GitHub repository: " .. url, vim.log.levels.INFO, { title = "Plugin repository" })
		open_in_browser(url) -- Open GitHub repo in the browser
	else
		vim.notify("Not a valid GitHub repository name", vim.log.levels.WARN, { title = "Plugin repository" })
	end
end

-- ============================
--  Search Engine Management
-- ============================

-- Change the search engine
vim.api.nvim_create_user_command("SetSearchEngine", function(o)
	local engine = o.fargs[1] -- Get the engine name from the argument

	if search_engines[engine] then
		current_search_engine = engine -- Set the current search engine
		vim.notify("Search engine set to: " .. engine, vim.log.levels.INFO, { title = "Search Engine" })
	else
		vim.notify("Unknown search engine: " .. engine, vim.log.levels.ERROR, { title = "Search Engine" })
	end
end, {
	nargs = 1,
	desc = "Set search engine",
	complete = function(_, line, _)
		local input = vim.split(line, "%s+")
		local partial = input[#input] or ""
		local matches = {}
		for engine in pairs(search_engines) do
			if engine:find(partial) == 1 then
				table.insert(matches, engine)
			end
		end
		return matches
	end,
})

return M

-- =========================================================
-- Web Search Plugin (Single File)
-- =========================================================

-- ===============================
-- CONFIG: Search Engines
-- ===============================

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

local current_engine = vim.g.default_search_engine or "google"
local engines_table = nil

-- ===============================
-- CORE: Utilities
-- ===============================

local function get_engines()
	if not engines_table then
		engines_table = vim.tbl_keys(search_engines)
		table.sort(engines_table)
	end
	return engines_table
end

local function encode(query)
	return query:gsub("[^%w%-_.~]", function(c)
		return c == " " and "%20" or string.format("%%%02X", string.byte(c))
	end)
end

local function open_search(query, engine, notify_msg, level)
	if not query or query == "" then
		vim.notify("Empty query", vim.log.levels.WARN, { title = "Web Search" })
		return
	end

	engine = engine or current_engine
	local url = search_engines[engine]

	if not url then
		vim.notify("Unknown engine: " .. tostring(engine), vim.log.levels.ERROR, { title = "Web Search" })
		return
	end

	if notify_msg then
		vim.notify(notify_msg, level or vim.log.levels.INFO, { title = "Web Search" })
	end

	vim.fn.jobstart({ "xdg-open", url:format(encode(query)) }, { detach = true })
end

-- ===============================
-- INPUT HELPERS
-- ===============================

local function get_visual()
	vim.cmd('silent normal! "xy')
	local text = vim.fn.getreg("x")
	if text == "" then
		return nil
	end
	return text:gsub("[\n\t]+", " "):gsub("%s+", " ")
end

local function get_diagnostic()
	local d = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
	if #d == 0 then
		return nil
	end
	return d[1].message
end

local function pick_engine(cb)
	vim.ui.select(get_engines(), {
		prompt = "Choose search engine:",
	}, cb)
end

-- ===============================
-- COMMAND FACTORY
-- ===============================

local function create_search_command(name, engine, desc)
	vim.api.nvim_create_user_command(name, function(o)
		local query = table.concat(o.fargs, " ")
		open_search(query, engine, "Searching " .. name .. ": " .. query)
	end, { nargs = "+", desc = desc })
end

-- ===============================
-- USER COMMANDS
-- ===============================

create_search_command("Search", nil, "Search web (default: " .. current_engine .. ")")
create_search_command("Chatgpt", "chatgpt", "Search ChatGPT")
create_search_command("Wikipedia", "wikipedia", "Search Wikipedia")
create_search_command("StackOverflow", "stackoverflow", "Search StackOverflow")
create_search_command("YouTube", "youtube", "Search YouTube")

vim.api.nvim_create_user_command("SearchWith", function(o)
	local engine = o.fargs[1]
	local query = table.concat(vim.list_slice(o.fargs, 2), " ")

	if not search_engines[engine] then
		vim.notify("Unknown engine, using default", vim.log.levels.WARN)
		engine = current_engine
	end

	open_search(query, engine, "Searching with " .. tostring(engine))
end, {
	nargs = "+",
	complete = function(_, line)
		local args = vim.split(line, "%s+")
		if #args == 2 then
			return get_engines()
		end
	end,
})

vim.api.nvim_create_user_command("SearchEnginesList", function()
	vim.notify("Search engines:\n• " .. table.concat(get_engines(), "\n• "))
end, {})

vim.api.nvim_create_user_command("SetSearchEngine", function(o)
	local engine = o.fargs[1]
	if search_engines[engine] then
		current_engine = engine
		vim.notify("Search engine set to: " .. engine)
	else
		vim.notify("Unknown engine: " .. engine, vim.log.levels.ERROR)
	end
end, {
	nargs = 1,
	complete = function(_, line)
		local partial = vim.split(line, "%s+")[2] or ""
		local matches = {}
		for _, e in ipairs(get_engines()) do
			if e:find(partial, 1, true) == 1 then
				table.insert(matches, e)
			end
		end
		return matches
	end,
})

-- ===============================
-- KEYMAPS: Diagnostic Search
-- ===============================

vim.keymap.set({ "n", "v" }, "gq", function()
	local msg = get_diagnostic()
	if not msg then
		return vim.notify("No diagnostic under cursor")
	end

	local ctx = vim.bo.filetype ~= "" and vim.bo.filetype or vim.fn.expand("%:e")
	open_search(msg .. " " .. ctx)
end, { desc = "Search diagnostic (default: " .. current_engine .. ")" })

vim.keymap.set({ "n", "v" }, "gQ", function()
	local msg = get_diagnostic()
	if not msg then
		return vim.notify("No diagnostic under cursor")
	end

	local ctx = vim.bo.filetype ~= "" and vim.bo.filetype or vim.fn.expand("%:e")
	local query = msg .. " " .. ctx

	pick_engine(function(choice)
		if choice then
			open_search(query, choice)
		end
	end)
end, { desc = "Search diagnostic (choose engine)" })

-- ===============================
-- KEYMAPS: Visual Selection Search
-- ===============================

vim.keymap.set("v", "gv", function()
	local text = get_visual()
	if not text then
		return vim.notify("No selection")
	end
	open_search(text)
end, { desc = "Search selection (default: " .. current_engine .. ")" })

vim.keymap.set("v", "gV", function()
	local text = get_visual()
	if not text then
		return vim.notify("No selection")
	end

	pick_engine(function(choice)
		if choice then
			open_search(text, choice)
		end
	end)
end, { desc = "Search selection (choose engine)" })

-- ===============================
-- GITHUB SHORTCUT (Lua files)
-- ===============================

vim.api.nvim_create_autocmd("FileType", {
	pattern = "lua",
	callback = function()
		vim.keymap.set("n", "gP", function()
			local word = vim.fn.expand("<cWORD>")

			local repo = word:match("[\"']([^\"']+/[^\"']+)[\"']") or word:match("([^%s]+/[^%s]+)")

			if repo then
				local url = "https://github.com/" .. repo
				vim.notify("Opening " .. url)
				vim.fn.jobstart({ "xdg-open", url }, { detach = true })
			else
				vim.notify("Not a valid GitHub repo", vim.log.levels.WARN)
			end
		end, { buffer = true, desc = "Open GitHub repo" })
	end,
})

local M = {}

-- Open the GitHub repo of the current file
function M.open_plugin_repo()
	local word = vim.fn.expand("<cWORD>") -- Get the word under the cursor
	local repo = word:match('([^"%s]+/[^"%s]+)') -- Ensure it follows 'user/repo' pattern

	if repo then
		local url = "https://github.com/" .. repo
		vim.notify("Opening GitHub repository: " .. url, vim.log.levels.INFO, { title = "Plugin repository" })
		vim.fn.jobstart({ "xdg-open", url }, { detach = true }) -- Open in browser
	else
		vim.notify("Not a valid GitHub repository name", vim.log.levels.WARN, { title = "Plugin repository" })
	end
end

return M

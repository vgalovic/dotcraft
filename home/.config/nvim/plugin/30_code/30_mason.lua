---@diagnostic disable: undefined-global, param-type-mismatch, undefined-field, duplicate-set-field

local add = vim.pack.add
local now = Config.now
local Icons = require("config.icons")

local mason_packages = vim.tbl_extend("force", Servers.servers, Servers.formatters)

now(function()
  --stylua: ignore
	local mason_update = function() vim.cmd("MasonUpdate") end
	Config.on_packchanged("mason.nvim", { "update" }, mason_update, ":MasonUpdate")

	add({ Repo.gh("mason-org/mason.nvim") })

	require("mason").setup({
		ui = {
			icons = {
				package_installed = Icons.mason.package_installed,
				package_pending = Icons.mason.package_pending,
				package_uninstalled = Icons.mason.package_uninstalled,
			},
		},
	})

	Map.map_leader("pm", "<cmd>Mason<cr>", "Mason")
end)

now(function()
	add({ Repo.gh("WhoIsSethDaniel/mason-tool-installer.nvim") })

	require("mason-tool-installer").setup({
		ensure_installed = vim.tbl_keys(mason_packages),
		run_on_start = true,
		auto_update = false,
	})
end)

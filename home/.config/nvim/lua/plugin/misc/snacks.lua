---@diagnostic disable: assign-type-mismatch
---@diagnostic disable: undefined-global
---@diagnostic disable: undefined-field

local dashboard_utils = require("utils.dashboard")

local random_header = dashboard_utils.get_random_header()
local random_hl = dashboard_utils.get_random_hl()

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,

	opts = {
		bigfile = { enabled = true },
		input = { enabled = true },
		scope = { enabled = true },
		lazygit = { configure = false },
		quickfile = { enabled = true },

		dashboard = {
			preset = {
				header = random_header,
			},
			width = 72,
			formats = {
				header = { hl = random_hl[1] },

				key = function(item)
					return { { "(", hl = "special" }, { item.key, hl = "key" }, { ")", hl = "special" } }
				end,
			},
			sections = {
				{ section = "header", padding = 2 },

				{
					align = "center",
					padding = 2,
					text = {
						{ " " .. Icons.snacks.keys_update .. "Update ", hl = random_hl[2] },
						{ " " .. Icons.snacks.keys_session .. "Sessions ", hl = random_hl[3] },
						{ " " .. Icons.snacks.keys_config .. "Config ", hl = random_hl[3] },
						{ " " .. Icons.snacks.keys_new_file .. "New File ", hl = random_hl[5] },
						{ " " .. Icons.snacks.keys_files .. "Files ", hl = random_hl[6] },
						{ " " .. Icons.snacks.keys_recent .. "Recent ", hl = random_hl[7] },
						{ " " .. Icons.snacks.keys_quit .. "Quit", hl = random_hl[8] },
					},
				},
        --stylua: ignore
				{ icon = Icons.snacks.files, title = "Recent Files", section = "recent_files", indent = 2, padding = 1, },
				{ icon = Icons.snacks.projects, title = "Projects", section = "projects", indent = 2, padding = 1 },

				{ text = "", action = ":Lazy update", key = "u" },
				{ text = "", section = "session", key = "s" },
        --stylua: ignore
				{ text = "", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})", key = "c", },
				{ text = "", action = "<cmd>NewFile<cr>", key = "n" },
				{ text = "", action = "<cmd>lua Snacks.dashboard.pick('files')<cr>", key = "f" },
				{ text = "", action = "<cmd>lua Snacks.dashboard.pick('oldfiles')<cr>", key = "r" },
				{ text = "", action = "<cmd>qa<cr>", key = "q" },

				{ section = "startup", padding = 1 },
			},
		},
		image = {
			doc = {
				float = true,
				inline = false,
				max_width = 60,
				max_height = 30,
			},
		},
		indent = {
			scope = {
				hl = {
					random_hl[1],
					random_hl[2],
					random_hl[3],
					random_hl[4],
					random_hl[5],
					random_hl[6],
					random_hl[7],
					random_hl[8],
				},
			},
		},
		picker = {
			layout = {
				cycle = true,
				---@comment Use the default layout or dropdown if the window is too narrow
				--- @default "default"
				--- @options ["default", "dropdown", "ivy", "select", "telescope", "vertical", "vscode"]
				preset = function()
					return vim.o.columns >= 120 and "default" or "dropdown"
				end,
			},
			icons = {
				diagnostics = {
					Error = Icons.diagnostics.error,
					Warn = Icons.diagnostics.warn,
					Info = Icons.diagnostics.info,
					Hint = Icons.diagnostics.hint,
				},
			},
			sources = {
				commands = { layout = { preset = "vscode" } },
				diagnostics = { layout = { preset = "vertical" } },
				diagnostics_buffer = { layout = { preset = "vertical" } },
				keymaps = {
					layout = { preview = false, preset = "default" },
				},
				notifications = { layout = { preset = "ivy" } },
				buffers = {
					layout = {
						preset = function()
							return vim.o.columns >= 120 and "ivy_split" or "dropdown"
						end,
					},
				},
				lines = { layout = { preset = "vertical" } },
				projects = {
					dev = { "~/Documents/", "~/Projects", "~/.dotfiles" },
					patterns = {
						".bzr",
						".git",
						".hg",
						".rules.verible_lint",
						".svn",
						".vscode",
						"Cargo.toml",
						"Makefile",
						"_darcs",
						"compile_commands.json",
						"package.json",
						"pyproject.toml",
						"pyvenv.cfg",
						"sketch.yaml",
					},
					recent = false,
				},
				pickers = { layout = { preset = "select" } },
				todo_comments = {
					layout = {
						preset = function()
							return vim.o.columns >= 120 and "ivy" or "dropdown"
						end,
					},
				},
			},
		},
		explorer = {
			replace_netrw = false,
		},
		notifier = {
			timeout = 2000,
			--- @default "compact"
			--- @options [ "compact", "fancy", "minimal" ]
			style = "compact",
			top_down = false,
			margin = { top = 0, right = 1, bottom = 2 },
			icons = {
				error = Icons.diagnostics.error,
				warn = Icons.diagnostics.warn,
				info = Icons.diagnostics.hint,
				debug = Icons.diagnostics.debug,
				trace = Icons.diagnostics.trace,
			},
			lsp_utils = require("utils.lsp").setup_lsp_progress(),
		},
		statuscolumn = {
			left = { "mark", "sign" },
			right = { "fold", "git" },
			folds = {
				open = true,
				git_hl = true,
			},
			git = {
				patterns = { "MiniDiffSign" },
			},
			refresh = 50,
		},
		words = {
			enabled = true,
			notify_jump = true,
		},
		terminal = {
			win = {
				wo = {
					winbar = "",
				},
			},
		},
		scroll = {
			enabled = true,
			-- FIX: for bug https://github.com/folke/snacks.nvim/issues/1687
			-- Workaround found in https://github.com/Saghen/blink.cmp/issues/1446#issuecomment-2728738325
			filter = function(buf)
				return vim.g.snacks_scroll ~= false
					and vim.b[buf].snacks_scroll ~= false
					and vim.bo[buf].buftype ~= "terminal"
					and vim.bo[buf].filetype ~= "blink-cmp-menu"
			end,
		},
		zen = {
			toggles = {
				dim = true,
				mini_diff_signs = false,
				diagnostics = false,
				inlay_hints = false,
			},
		},
	},

	keys = {
		--stylua: ignore start

		-- Git commands
		{ "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
		{ "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse" },
		{ "<leader>gf", function() Snacks.lazygit.log_file() end, desc = "Lazygit Current File History" },
		{ "<leader>gg", function() Snacks.lazygit({ cwd = vim.fn.expand("%:p:h") }) end, desc = "Lazygit" },
		{ "<leader>gl", function() Snacks.lazygit.log({ cwd = vim.fn.expand("%:p:h") }) end, desc = "Lazygit Log (cwd)" },
    { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
    { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
    { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
    { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },

		-- Notification history
		-- { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
		{ "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },

		-- Picker
		{ "<C-;>", function() Snacks.picker.commands() end, desc = "Command List" },
		{ "<M-;>", function() Snacks.picker.command_history() end, desc = "Command History" },
		{ "<M-\\>", function() Snacks.explorer({ cwd = vim.fn.expand("%:p:h"), auto_close = true }) end, desc = "Snacks Explorer" },
		{ "<leader>u", function() Snacks.picker.undo() end, desc = "Undo History" },
		{ "<leader>/", function() Snacks.picker.lines() end, desc = "Fuzzily search in current buffer" },
    { "<leader>,", function() Snacks.picker.smart() end, desc = "Smart find files" },
		{ "<leader>.", function() Snacks.picker.recent() end, desc = "Search Recent Files" },
		{ "<leader><leader>", function() Snacks.picker.buffers() end, desc = "Find existing buffers" },

		-- Search
		{ "<leader>sh", function() Snacks.picker.help() end, desc = "Search Help" },
		{ "<leader>sf", function() Snacks.picker.files() end, desc = "Search Files" },
		{ "<leader>sg", function() Snacks.picker.grep() end, desc = "Search by Grep" },
		{ "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Search Keymaps" },
		{ "<leader>sr", function() Snacks.picker.resume() end, desc = "Search Resume" },
		{ "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Workspace Diagnostics" },
		{ "<leader>ss", function() Snacks.picker.pickers() end, desc = "Search Select" },
		{ "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Search current Word" },
		{ "<leader>sc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Search Neovim Config" },
		{ "<leader>st", function() Snacks.picker.todo_comments({cwd = vim.fn.expand("%:p:h")}) end, desc = "Search Todos" },
		{ "<leader>sp", function() Snacks.picker.projects() end, desc = "Search Project" },
		{ "<leader>s/", function() Snacks.picker.grep_buffers() end, desc = "Search in Open Files" },

		-- Terminal
		{ "<C-/>", function() Snacks.terminal.toggle() end, mode = {"n", "t"}, desc = "Toggle Terminal" },

		-- Words navigation
		{ "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference" },
		{ "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference" },

		-- Zen mode
    { "<leader>Z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
    { "<leader>z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },

		--stylua: ignore end
	},

	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- Setup some globals for debugging (lazy-loaded)
				_G.dd = function(...)
					Snacks.debug.inspect(...)
				end
				_G.bt = function()
					Snacks.debug.backtrace()
				end
				vim.print = _G.dd -- Override print to use snacks for `:=` command

				-- Create some toggle mappings
				Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>ts")
				Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
				Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>tr")
				Snacks.toggle.diagnostics():map("<leader>tD")
				Snacks.toggle.line_number():map("<leader>tn")
				Snacks.toggle
					.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
					:map("<leader>tc")
				Snacks.toggle.treesitter():map("<leader>tt")
				Snacks.toggle
					.option("background", { off = "light", on = "dark", name = "Dark Background" })
					:map("<leader>tb")
				Snacks.toggle.inlay_hints():map("<leader>th")
				Snacks.toggle.indent():map("<leader>tg")
				Snacks.toggle.dim():map("<leader>td")
			end,
		})
	end,
}

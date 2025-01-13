return { -- Fuzzy Finder (files, lsp, etc)
	"nvim-telescope/telescope.nvim",
	lazy = false, -- Ensure telescope loads early
	event = "VimEnter",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ -- If encountering errors, see telescope-fzf-native README for installation instructions
			"nvim-telescope/telescope-fzf-native.nvim",

			-- `build` is used to run some command when the plugin is installed/updated.
			-- This is only run then, not every time Neovim starts up.
			build = "make",

			-- `cond` is a condition used to determine whether this plugin should be
			-- installed and loaded.
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },

		-- Useful for getting pretty icons, but requires a Nerd Font.
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		-- Telescope is a fuzzy finder that comes with a lot of different things that
		-- it can fuzzy find! It's more than just a "file finder", it can search
		-- many different aspects of Neovim, your workspace, LSP, and more!
		--
		-- The easiest way to use Telescope, is to start by doing something like:
		--  :Telescope help_tags
		--
		-- After running this command, a window will open up and you're able to
		-- type in the prompt window. You'll see a list of `help_tags` options and
		-- a corresponding preview of the help.
		--
		-- Two important keymaps to use while in Telescope are:
		--  - Insert mode: <c-/>
		--  - Normal mode: ?
		--
		-- This opens a window that shows you all of the keymaps for the current
		-- Telescope picker. This is really useful to discover what Telescope can
		-- do as well as how to actually do it!

		-- [[ Configure Telescope ]]
		-- See `:help telescope` and `:help telescope.setup()`

		require("telescope").setup({
			-- You can put your default mappings / updates / etc. in here
			--  All the info you're looking for is in `:help telescope.setup()`
			defaults = {
				file_ignore_patterns = {
					-- Ignore specific folders
					"node_modules/",
					"vendor/",
					".git/",
					"build/",
					"dist/",
					"tmp/",
					"temp/",
					"$RECYCLE.BIN/",
					"memorycache/",
					".data/",
					"Git/",
					"Games/",
					"Music/",
					"Pictures/",
					"Videos/",
					"Tamplates/",
					"Public/",
					-- Ignore common audio files
					".*%.mp3$",
					".*%.wav$",
					".*%.flac$",
					".*%.aac$",
					".*%.ogg$",
					".*%.m4a$",
					-- Ignore common video files
					".*%.mp4$",
					".*%.avi$",
					".*%.mkv$",
					".*%.mov$",
					".*%.wmv$",
					-- Ignore common image files
					".*%JPG$",
					".*%.jpg$",
					".*%.jpeg$",
					".*%.PNG$",
					".*%.png$",
					".*%.gif$",
					".*%.bmp$",
					".%.webp$",
					".*%.tiff$",
					-- Ignore common compressed files
					".*%.zip$",
					".*%.tar$",
					".*%.gz$",
					".*%.bz2$",
					".*%.rar$",
					".*%.7z$",
					-- Ignore common executable files
					".*%.dll$",
					".*%.iso$",
					".*%.exe$",
					".*%.bin$",
					".*%.app$",
					".*%.run$",
					".*%.deb$",
					".*%.appimage$",
					".*%.AppImage$",
					-- Ignore common office and word processing files
					".*%.doc$",
					".*%.docx$", -- Microsoft Word
					".*%.xls$",
					".*%.xlsx$", -- Microsoft Excel
					".*%.ppt$",
					".*%.pptx$", -- Microsoft PowerPoint
					".*%.odt$",
					".*%.ods$",
					".*%.odp$", -- OpenDocument Format
					".*%.rtf$",
					".*%.txt$", -- Rich Text Format and plain text
					".*%.pdf$",
				},
			},
			find_files = {

				hidden = true,
			},
			--
			-- defaults = {
			--   mappings = {
			--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
			--   },
			-- },
			-- pickers = {}
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		-- Enable Telescope extensions if they are installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")

		-- Define global table if it doesn't exist
		_G.TelescopeKeymapFunctions = {}

		-- Function to search within the current buffer with a theme
		TelescopeKeymapFunctions.fuzzy_search_current_buffer = function()
			require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 20,
				previewer = false,
			}))
		end

		-- Function to search in open files
		TelescopeKeymapFunctions.live_grep_open_files = function()
			require("telescope.builtin").live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end

		-- Function to search Neovim config files
		TelescopeKeymapFunctions.find_neovim_files = function()
			require("telescope.builtin").find_files({
				prompt_title = "Find Neovim Config Files",
				cwd = vim.fn.stdpath("config"),
			})
		end
	end,
}

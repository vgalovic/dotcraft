---@diagnostic disable:  undefined-global

-- =========================================================
-- FILE EXPLORER (mini.files)
-- =========================================================

local now_if_args = Config.now_if_args

now_if_args(function()
	local show_dotfiles = false

	-- toggle dotfiles
	local toggle_dotfiles = function()
		show_dotfiles = not show_dotfiles
		MiniFiles.refresh({
			content = {
				filter = show_dotfiles and function()
					return true
				end or function(fs_entry)
					return not vim.startswith(fs_entry.name, ".")
				end,
			},
		})
	end

	require("mini.files").setup({
		windows = { preview = true, width_preview = 50 },
		mappings = { show_help = "?" },
		content = {
			filter = function(fs_entry)
				if show_dotfiles then
					return true
				end
				return not vim.startswith(fs_entry.name, ".")
			end,
		},
	})

	-- bookmarks
	Config.new_autocmd("User", "MiniFilesExplorerOpen", function()
		MiniFiles.set_bookmark("c", vim.fn.stdpath("config"), { desc = "Config" })
		MiniFiles.set_bookmark("w", vim.fn.getcwd, { desc = "Working directory" })
	end, "Add bookmarks")

	-- keymap per buffer
	vim.api.nvim_create_autocmd("User", {
		pattern = "MiniFilesBufferCreate",
		callback = function(args)
			local map_buf = function(lhs, rhs)
				vim.keymap.set("n", lhs, rhs, { buffer = args.data.buf_id })
			end
			map_buf(".", toggle_dotfiles)
			map_buf("\\", MiniFiles.close)
		end,
	})
end)

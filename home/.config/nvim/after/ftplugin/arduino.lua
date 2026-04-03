-- =============================================================================
-- Arduino ftplugin
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Check if arduino-cli exists
-- -----------------------------------------------------------------------------
if vim.fn.executable("arduino-cli") == 0 then
	vim.notify("arduino-cli not found. Arduino integration disabled.", vim.log.levels.WARN, { title = "Arduino" })
	return
end

-- -----------------------------------------------------------------------------
-- Buffer-local state (single source of truth)
-- -----------------------------------------------------------------------------
local buf = vim.api.nvim_get_current_buf()
local sketch_dir = vim.fn.expand("%:p:h")

vim.b.arduino_fqbn = nil
vim.b.arduino_port = nil
vim.b.arduino_baud = nil

-- =============================================================================
-- Helpers
-- =============================================================================

-- -----------------------------------------------------------------------------
-- [Function] get_fqbn_from_sketch
-- Reads default_fqbn from sketch.yaml
-- Returns: fqbn string or nil
-- -----------------------------------------------------------------------------
local function get_fqbn_from_sketch()
	if vim.b.arduino_fqbn then
		return vim.b.arduino_fqbn
	end

	local path = sketch_dir .. "/sketch.yaml"
	if vim.fn.filereadable(path) == 0 then
		vim.notify(
			"sketch.yaml not found.\nAdd `default_fqbn: arduino:avr:uno`",
			vim.log.levels.WARN,
			{ title = "Arduino" }
		)
		return nil
	end

	for _, line in ipairs(vim.fn.readfile(path)) do
		local fqbn = line:match("^%s*default_fqbn:%s*(.+)")
		if fqbn then
			vim.b.arduino_fqbn = vim.trim(fqbn)
			return vim.b.arduino_fqbn
		end
	end

	vim.notify("`default_fqbn` not found in sketch.yaml", vim.log.levels.WARN, { title = "Arduino" })
	return nil
end

-- -----------------------------------------------------------------------------
-- [Function] detect_board
-- Detects board asynchronously by matching FQBN against arduino-cli board list
-- callback: function(success:boolean)
-- -----------------------------------------------------------------------------
local function detect_board(callback)
	local fqbn = get_fqbn_from_sketch()
	if not fqbn then
		callback(false)
		return
	end

	vim.fn.jobstart("arduino-cli board list", {
		stdout_buffered = true,
		on_exit = function(_, code)
			if code ~= 0 then
				vim.schedule(function()
					vim.notify("arduino-cli exited with code " .. code, vim.log.levels.ERROR, { title = "Arduino" })
					callback(false)
				end)
				return
			end
		end,
		on_stdout = function(_, lines)
			vim.schedule(function()
				local found = false
				for i, line in ipairs(lines) do
					if i > 1 and line:match("^/dev/") then
						local cols = vim.split(line, "%s+", { trimempty = true })
						local port = cols[1]
						local board_fqbn = cols[#cols - 1]
						if board_fqbn == fqbn then
							vim.b.arduino_port = port
							found = true
							break
						end
					end
				end

				if found then
					callback(true)
				else
					vim.notify("No connected board matches FQBN: " .. fqbn, vim.log.levels.WARN, { title = "Arduino" })
					callback(false)
				end
			end)
		end,
	})
end

-- -----------------------------------------------------------------------------
-- [Function] run
-- Runs a shell command in a terminal split
-- -----------------------------------------------------------------------------
local function run(cmd)
	local shell = vim.o.shell or "sh"
	vim.cmd("botright split | resize 15 | terminal " .. shell .. " -c " .. vim.fn.shellescape(cmd))
	vim.cmd("startinsert")
end

-- =============================================================================
-- User Commands
-- =============================================================================

-- -----------------------------------------------------------------------------
-- ArduinoBuild
-- Compile current sketch
-- -----------------------------------------------------------------------------
vim.api.nvim_buf_create_user_command(buf, "ArduinoBuild", function()
	if not vim.b.arduino_fqbn then
		vim.notify("FQBN not resolved", vim.log.levels.ERROR, { title = "Arduino" })
		return
	end
	run(string.format("arduino-cli compile --fqbn %s %s", vim.b.arduino_fqbn, sketch_dir))
end, { desc = "Compile Arduino sketch" })

-- -----------------------------------------------------------------------------
-- ArduinoGenCompileDB
-- Generate clangd compilation database and clean build artifacts
-- -----------------------------------------------------------------------------
vim.api.nvim_buf_create_user_command(buf, "ArduinoGenCompileDB", function()
	if not vim.b.arduino_fqbn then
		vim.notify("FQBN not resolved", vim.log.levels.ERROR, { title = "Arduino" })
		return
	end

	local build_dir = sketch_dir .. "/.build"
	local ccdb_src = build_dir .. "/compile_commands.json"
	local ccdb_dst = sketch_dir .. "/compile_commands.json"

	local cmd = table.concat({
		"rm -rf " .. build_dir,
		string.format(
			"arduino-cli compile --fqbn %s --build-path %s --only-compilation-database %s",
			vim.b.arduino_fqbn,
			build_dir,
			sketch_dir
		),
		"test -f " .. ccdb_src,
		"cp " .. ccdb_src .. " " .. ccdb_dst,
		"rm -rf " .. build_dir,
	}, " && ")

	local ok, result = pcall(vim.fn.system, cmd)
	if not ok then
    -- stylua: ignore
		vim.notify( "Failed to generate `compile_commands.json`:\n" .. result, vim.log.levels.ERROR, { title = "Arduino" })
	else
		vim.notify("`compile_commands.json` generated successfully", vim.log.levels.INFO, { title = "Arduino" })
	end
end, { desc = "Generate `compile_commands.json` and clean build dir" })

-- -----------------------------------------------------------------------------
-- ArduinoUpload
-- Upload sketch to connected board
-- -----------------------------------------------------------------------------
vim.api.nvim_buf_create_user_command(buf, "ArduinoUpload", function()
	if not vim.b.arduino_port or not vim.b.arduino_fqbn then
		vim.notify("Board not resolved", vim.log.levels.ERROR, { title = "Arduino" })
		return
	end
	run(string.format("arduino-cli upload -p %s --fqbn %s %s", vim.b.arduino_port, vim.b.arduino_fqbn, sketch_dir))
end, { desc = "Upload sketch to board" })

-- -----------------------------------------------------------------------------
-- ArduinoClean
-- Clean sketch build
-- -----------------------------------------------------------------------------
vim.api.nvim_buf_create_user_command(buf, "ArduinoClean", function()
	if not vim.b.arduino_fqbn then
		vim.notify("FQBN not resolved", vim.log.levels.ERROR, { title = "Arduino" })
		return
	end
	run(string.format("arduino-cli compile --clean --fqbn %s %s", vim.b.arduino_fqbn, sketch_dir))
end, { desc = "Clean build" })

-- -----------------------------------------------------------------------------
-- ArduinoMonitor
-- Open serial monitor with configurable baudrate
-- -----------------------------------------------------------------------------
vim.api.nvim_buf_create_user_command(buf, "ArduinoMonitor", function()
	if not vim.b.arduino_port then
		vim.notify("Port not resolved", vim.log.levels.ERROR, { title = "Arduino" })
		return
	end

	vim.b.arduino_baud = vim.b.arduino_baud or "9600"
	vim.ui.input({ prompt = "Baudrate: ", default = vim.b.arduino_baud }, function(baud)
		if not baud or baud == "" then
			return
		end
		vim.b.arduino_baud = baud
		run(string.format("arduino-cli monitor -p %s -c baudrate=%s", vim.b.arduino_port, baud))
	end)
end, { desc = "Open serial monitor" })

-- -----------------------------------------------------------------------------
-- ArduinoLoadBoard
-- Load or reload board info asynchronously
-- Available globally
-- -----------------------------------------------------------------------------
vim.api.nvim_create_user_command("ArduinoLoadBoard", function()
	vim.b.arduino_fqbn = nil
	vim.b.arduino_port = nil

	detect_board(function(success)
		if success then
			vim.notify(
				string.format(
					"Board detected asynchronously:\nFQBN: `%s`\nPort: `%s`",
					vim.b.arduino_fqbn,
					vim.b.arduino_port
				),
				vim.log.levels.INFO,
				{ title = "Arduino" }
			)
		end
	end)
end, { desc = "Load board info from sketch.yaml" })

-- =============================================================================
-- Autocommands
-- =============================================================================

-- Automatically load board info
vim.cmd("ArduinoLoadBoard")

-- Reload board info when sketch.yaml is saved
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "sketch.yaml",
	callback = function()
		vim.cmd("ArduinoLoadBoard")
	end,
})

-- =============================================================================
-- Keymaps
-- =============================================================================

table.insert(Config.leader_groups, { mode = { "n" }, keys = "<Leader>a", desc = "+Arduino" })

vim.keymap.set("n", "<leader>ab", "<cmd>ArduinoBuild<CR>", { buffer = true, desc = "Build" })
vim.keymap.set("n", "<leader>ac", "<cmd>ArduinoClean<CR>", { buffer = true, desc = "Clean" })
vim.keymap.set("n", "<leader>am", "<cmd>ArduinoMonitor<CR>", { buffer = true, desc = "Monitor" })
vim.keymap.set("n", "<leader>ar", "<cmd>ArduinoLoadBoard<CR>", { buffer = true, desc = "Reload Board" })
vim.keymap.set("n", "<leader>au", "<cmd>ArduinoUpload<CR>", { buffer = true, desc = "Upload" })

vim.keymap.set(
	"n",
	"<leader>ag",
	"<cmd>ArduinoGenCompileDB<CR>",
	{ buffer = true, desc = "Generate compile_commands.json (clangd)" }
)

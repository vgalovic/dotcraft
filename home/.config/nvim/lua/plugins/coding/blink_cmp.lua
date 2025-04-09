return {
	{
		"saghen/blink.compat",
		version = "*",
		lazy = true,
		opts = {},
	},
	{
		"saghen/blink.cmp",
		event = { "InsertEnter", "CmdlineEnter", "CmdlineEnter /,?" },
		dependencies = {
			{ "rafamadriz/friendly-snippets" },
			{ "huijiro/blink-cmp-supermaven" },
		},

		version = "*",

		opts = {
			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
			},

			cmdline = {
				enabled = true,
				keymap = {
					["<Tab>"] = {
						function(cmp)
							if cmp.is_ghost_text_visible() and not cmp.is_menu_visible() then
								return cmp.accept()
							end
						end,
						"show_and_insert",
						"select_next",
					},
        -- stylua: ignore start
        ["<A-1>"] = { function(cmp) cmp.accept({ index = 1 }) end, },
        ["<A-2>"] = { function(cmp) cmp.accept({ index = 2 }) end, },
        ["<A-3>"] = { function(cmp) cmp.accept({ index = 3 }) end, },
        ["<A-4>"] = { function(cmp) cmp.accept({ index = 4 }) end, },
        ["<A-5>"] = { function(cmp) cmp.accept({ index = 5 }) end, },
        ["<A-6>"] = { function(cmp) cmp.accept({ index = 6 }) end, },
        ["<A-7>"] = { function(cmp) cmp.accept({ index = 7 }) end, },
        ["<A-8>"] = { function(cmp) cmp.accept({ index = 8 }) end, },
        ["<A-9>"] = { function(cmp) cmp.accept({ index = 9 }) end, },
        ["<A-0>"] = { function(cmp) cmp.accept({ index = 10 }) end, },
					-- stylua: ignore end
				},
				completion = {
					menu = {
						auto_show = function()
							return vim.fn.getcmdtype() == ":"
						end,
					},
					ghost_text = { enabled = true },
				},
			},

			completion = {
				ghost_text = { enabled = true },

				keyword = { range = "full" },

				accept = { auto_brackets = { enabled = true } },

				list = {
					selection = {
						preselect = function()
							return not require("blink.cmp").snippet_active({ direction = 1 })
						end,
					},
				},

				trigger = {
					show_in_snippet = true,
				},

				menu = {
					-- Show menu unless in cmdline with "/" or "?"
					-- auto_show = function(ctx)
					-- return ctx.mode ~= "cmdline" or not vim.tbl_contains({ "/", "?" }, vim.fn.getcmdtype())
					-- end,

					border = "rounded",

					draw = {
						columns = {
							{ "item_idx" },
							{ "label", "label_description", gap = 2 },
							{ "kind_icon", gap = 1, "kind" },
						},

						components = {
							--Recipes: Select Nth item from the list
							item_idx = {
								text = function(ctx)
									return ctx.idx == 10 and "0" or ctx.idx >= 10 and " " or tostring(ctx.idx)
								end,
							},

							kind_icon = {
								-- Optionally, you may also use the icons from mini.icons
								ellipsis = false,
								text = function(ctx)
									-- Handle cmdline and search cases
									local cmd_type = vim.fn.getcmdtype()
									if ctx.item.source_id == "cmdline" or cmd_type == "/" or cmd_type == "?" then
										return ""
									end

									-- Use mini.icons for LSP kinds
									local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
									return kind_icon
								end,

								-- Optionally, you may also use the highlights from mini.icons
								highlight = function(ctx)
									-- Handle cmdline and search cases (if needed for highlight)
									local cmd_type = vim.fn.getcmdtype()
									if ctx.item.source_id == "cmdline" or cmd_type == "/" or cmd_type == "?" then
										return ""
									end

									-- Use mini.icons for LSP highlights
									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},

							kind = {
								text = function(ctx)
									local cmd_type = vim.fn.getcmdtype()
									if ctx.item.source_id == "cmdline" or cmd_type == "/" or cmd_type == "?" then
										return ""
									end
									return ctx.kind
								end,
							},
						},
						gap = 2,
						treesitter = { "lsp" },
					},
					winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
				},

				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
					window = {
						border = "rounded",
						winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
					},
				},
			},

			signature = {
				enabled = false,
			},

			keymap = {
				--- @default "default"
				--- @options ["default", "super-tab", "enter"]
				preset = "super-tab",

      -- stylua: ignore start
			["<A-1>"] = { function(cmp) cmp.accept({ index = 1 }) end, },
			["<A-2>"] = { function(cmp) cmp.accept({ index = 2 }) end, },
			["<A-3>"] = { function(cmp) cmp.accept({ index = 3 }) end, },
			["<A-4>"] = { function(cmp) cmp.accept({ index = 4 }) end, },
			["<A-5>"] = { function(cmp) cmp.accept({ index = 5 }) end, },
			["<A-6>"] = { function(cmp) cmp.accept({ index = 6 }) end, },
			["<A-7>"] = { function(cmp) cmp.accept({ index = 7 }) end, },
			["<A-8>"] = { function(cmp) cmp.accept({ index = 8 }) end, },
			["<A-9>"] = { function(cmp) cmp.accept({ index = 9 }) end, },
			["<A-0>"] = { function(cmp) cmp.accept({ index = 10 }) end, },
				-- stylua: ignore end
			},

			sources = {
				-- default = {"lsp", "path", "snippets", "buffer" },

				-- Determine default sources based on filetype or Treesitter node
				default = function()
					local success, node = pcall(vim.treesitter.get_node)
					if vim.bo.filetype == "lua" then
						return { "lazydev", "lsp", "path", "supermaven" }
					elseif
						success
						and node
						and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type())
					then
						return { "buffer" }
					else
						return { "lsp", "path", "supermaven", "snippets" } --, 'buffer' }
					end
				end,

				providers = {
					-- Recipes: Hide snippets after trigger character
					snippets = {
						should_show_items = function(ctx)
							return ctx.trigger.initial_kind ~= "trigger_character"
						end,
					},
					-- Use lazydev insted of lua_ls for completion
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
					supermaven = {
						name = "supermaven",
						module = "blink-cmp-supermaven",
						async = true,
						transform_items = function(_, items)
							for _, item in ipairs(items) do
								item.kind_name = "SuperMaven"
								item.kind_hl = "MiniIconsAzure"
							end
							return items
						end,
					},
				},
			},
		},

		opts_extend = { "sources.default" },
	},
}

return {
	"saghen/blink.cmp",
	dependencies = { "rafamadriz/friendly-snippets" },

	version = "*",

	opts = {
		appearance = {
			use_nvim_cmp_as_default = false,
			nerd_font_variant = "mono",
		},

		completion = {
			ghost_text = { enabled = false },

			keyword = { range = "full" },

			accept = { auto_brackets = { enabled = true } },

			list = {
				selection = {
					preselect = function(ctx)
						return ctx.mode ~= "cmdline"
					end,
					auto_insert = function(ctx)
						return ctx.mode ~= "cmdline"
					end,
				},
			},

			trigger = {
				show_in_snippet = false,
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

						-- no icons and descriptions for cmdline, search ("/"), or backward search ("?")
						kind_icon = {
							text = function(ctx)
								local cmd_type = vim.fn.getcmdtype()
								if ctx.item.source_id == "cmdline" or cmd_type == "/" or cmd_type == "?" then
									return ""
								end
								return ctx.kind_icon
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
					winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
				},
			},
		},

		signature = {
			window = {
				border = "rounded",
			},
			enabled = true,
		},

		keymap = {
			preset = "default", -- default | super-tab | enter

			-- cmdline = {
			-- 	preset = "super-tab",
			-- },

			["<A-1>"] = {
				function(cmp)
					cmp.accept({ index = 1 })
				end,
			},
			["<A-2>"] = {
				function(cmp)
					cmp.accept({ index = 2 })
				end,
			},
			["<A-3>"] = {
				function(cmp)
					cmp.accept({ index = 3 })
				end,
			},
			["<A-4>"] = {
				function(cmp)
					cmp.accept({ index = 4 })
				end,
			},
			["<A-5>"] = {
				function(cmp)
					cmp.accept({ index = 5 })
				end,
			},
			["<A-6>"] = {
				function(cmp)
					cmp.accept({ index = 6 })
				end,
			},
			["<A-7>"] = {
				function(cmp)
					cmp.accept({ index = 7 })
				end,
			},
			["<A-8>"] = {
				function(cmp)
					cmp.accept({ index = 8 })
				end,
			},
			["<A-9>"] = {
				function(cmp)
					cmp.accept({ index = 9 })
				end,
			},
			["<A-0>"] = {
				function(cmp)
					cmp.accept({ index = 10 })
				end,
			},
		},

		sources = {
			-- default = {"lsp", "path", "snippets", "buffer" },
			--
			-- Determine default sources based on filetype or Treesitter node
			default = function()
				local success, node = pcall(vim.treesitter.get_node)
				if vim.bo.filetype == "lua" then
					return { "lazydev", "lsp", "path" }
				elseif vim.bo.filetype == "markdown" then
					return { "markdown", "lsp", "path", "snippets" }
				elseif
					success
					and node
					and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type())
				then
					return { "buffer" }
				else
					return { "lsp", "path", "snippets" } --, 'buffer' }
				end
			end,

			-- Sources for command-line completion
			cmdline = function()
				local type = vim.fn.getcmdtype()
				-- Search forward and backward
				if type == "/" or type == "?" then
					return { "buffer" }
				-- Commands
				elseif type == ":" or type == "@" then
					return { "cmdline" }
				else
					return {}
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
				lsp = { fallbacks = { "lazydev" } },
				lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },

				-- Use render-markdown for completion
				markdown = {
					name = "RenderMarkdown",
					module = "render-markdown.integ.blink",
					fallbacks = { "lsp" },
				},
			},
		},
	},

	opts_extend = { "sources.default" },
}

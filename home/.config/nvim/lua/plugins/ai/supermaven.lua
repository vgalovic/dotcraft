return {
	"supermaven-inc/supermaven-nvim",
	event = "InsertEnter",
	opts = {
		keymaps = {
			accept_suggestion = "<C-a>",
			clear_suggestion = "<C-Esc>",
			accept_word = "<C-.>",
		},
		ignore_filetypes = { "bigfile", "snacks_input", "snacks_notif" },
		color = {
			suggestion_color = "#626880",
			cterm = 244,
		},
		--- @default "off"
		--- @options ["off", "info"]
		log_level = "off",
		disable_inline_completion = true, -- disables inline completion for use with cmp
		disable_keymaps = true, -- disables built in keymaps for more manual control
		condition = function()
			return false
		end, -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
	},
}

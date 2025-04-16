---@diagnostic disable: undefined-field, deprecated

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    { require("mini.icons").mock_nvim_web_devicons() },
  },

  opts = {
    options = {
      theme = vim.g.colorscheme,
      component_separators = "",
      section_separators = { left = Icons.lualine.left_separator, right = Icons.lualine.right_separator },
      disabled_filetypes = {
        statusline = { "snacks_dashboard" },
        winbar = {},
      },
    },
    sections = {
      lualine_a = {
        { "mode", separator = { right = Icons.lualine.left_separator }, left_padding = 2, right_padding = 2 },
      },
      lualine_b = {
        "branch",
        "diff",
        {
          "diagnostics",
          symbols = {
            error = Icons.diagnostics.error,
            warn = Icons.diagnostics.warn,
            info = Icons.diagnostics.info,
            hint = Icons.diagnostics.hint,
          },
        },
      },
      lualine_c = { "buffers" },
      lualine_x = {
        {
          require("noice").api.statusline.mode.get,
          cond = require("noice").api.statusline.mode.has,
        },
        "searchcount",
        "selectioncount",
        "encoding",
        "fileformat",
      },
      lualine_y = { "progress" },
      lualine_z = {
        { "location", separator = { left = Icons.lualine.right_separator }, left_padding = 2, right_padding = 2 },
      },
    },
    inactive_sections = {
      lualine_a = { "filename" },
      lualine_b = {},
      lualine_c = {},
      lualine_x = { "encoding", "fileformat" },
      lualine_y = {},
      lualine_z = { "location" },
    },
    tabline = {},
    winbar = {},
    extensions = { "lazy", "mason" },
  },
}

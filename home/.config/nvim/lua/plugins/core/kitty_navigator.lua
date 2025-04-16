return {
  "knubie/vim-kitty-navigator",
  keys = {
    { "<C-h>", "<cmd>KittyNavigateLeft<cr>",  desc = "Move to panel Left" },
    { "<C-j>", "<cmd>KittyNavigateDown<cr>",  desc = "Move to panel Downd" },
    { "<C-k>", "<cmd>KittyNavigateUp<cr>",    desc = "Move to panel Up" },
    { "<C-l>", "<cmd>KittyNavigateRight<cr>", desc = "Move to panel Right" },
  },
  build = {
    "mkdir -p ~/.config/kitty/kitty_navigator",
    "cp ./*.py ~/.config/kitty/kitty_navigator",
  },
  config = function()
    vim.g.kitty_navigator_no_mappings = 1
  end,
}

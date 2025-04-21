# dotcraft/home/.config/nvim

<a href="https://dotfyle.com/vgalovic/dotcraft-home-config-nvim"><img src="https://dotfyle.com/vgalovic/dotcraft-home-config-nvim/badges/plugins?style=flat" /></a>
<a href="https://dotfyle.com/vgalovic/dotcraft-home-config-nvim"><img src="https://dotfyle.com/vgalovic/dotcraft-home-config-nvim/badges/leaderkey?style=flat" /></a>
<a href="https://dotfyle.com/vgalovic/dotcraft-home-config-nvim"><img src="https://dotfyle.com/vgalovic/dotcraft-home-config-nvim/badges/plugin-manager?style=flat" /></a>

## Install Instructions

> Install requires Neovim 0.9+. Always review the code before installing a configuration.

Clone the repository and install the plugins:

```sh
git clone git@github.com:vgalovic/dotcraft ~/.config/vgalovic/dotcraft
```

Open Neovim with this config:

```sh
NVIM_APPNAME=vgalovic/dotcraft/home/.config/nvim nvim
```

## Plugins

### autocomplete

- [saghen/blink.cmp](https://github.com/saghen/blink.cmp)

### colorscheme

- [catppuccin/nvim](https://dotfyle.com/plugins/catppuccin/nvim)
- [folke/tokyonight.nvim](https://dotfyle.com/plugins/folke/tokyonight.nvim)

### comment

- [folke/todo-comments.nvim](https://dotfyle.com/plugins/folke/todo-comments.nvim)

### formatting

- [stevearc/conform.nvim](https://dotfyle.com/plugins/stevearc/conform.nvim)

### game

- [ThePrimeagen/vim-be-good](https://dotfyle.com/plugins/ThePrimeagen/vim-be-good)

### keybinding

- [folke/which-key.nvim](https://dotfyle.com/plugins/folke/which-key.nvim)

### lsp

- [mfussenegger/nvim-lint](https://dotfyle.com/plugins/mfussenegger/nvim-lint)
- [neovim/nvim-lspconfig](https://dotfyle.com/plugins/neovim/nvim-lspconfig)
- [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim)

### lsp-installer

- [williamboman/mason.nvim](https://dotfyle.com/plugins/williamboman/mason.nvim)
  - [williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)
  - [WhoIsSethDaniel/mason-tool-installer.nvim](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim)

### log files

- [mtdl9/vim-log-highlighting](https://github.com/mtdl9/vim-log-highlighting)

### markdown-and-latex

- [MeanderingProgrammer/render-markdown.nvim](https://dotfyle.com/plugins/MeanderingProgrammer/render-markdown.nvim)
- [iamcco/markdown-preview.nvim](https://dotfyle.com/plugins/iamcco/markdown-preview.nvim)

### nvim-dev

- [MunifTanjim/nui.nvim](https://dotfyle.com/plugins/MunifTanjim/nui.nvim)
- [nvim-lua/plenary.nvim](https://dotfyle.com/plugins/nvim-lua/plenary.nvim)
- [folke/lazydev.nvim](https://dotfyle.com/plugins/folke/lazydev.nvim)
- [Bilal2453/luvit-meta](https://github.com/Bilal2453/luvit-meta)

### plugin-manager

- [folke/lazy.nvim](https://dotfyle.com/plugins/folke/lazy.nvim)

### snippet

- [rafamadriz/friendly-snippets](https://dotfyle.com/plugins/rafamadriz/friendly-snippets)

### statusline

- [nvim-lualine/lualine.nvim](https://dotfyle.com/plugins/nvim-lualine/lualine.nvim)

### syntax

- [nvim-treesitter/nvim-treesitter](https://dotfyle.com/plugins/nvim-treesitter/nvim-treesitter)

### navigation

- [knubie/vim-kitty-navigator](https://github.com/knubie/vim-kitty-navigator)

### utility

- [echasnovski/mini.nvim](https://dotfyle.com/plugins/echasnovski/mini.nvim)
  - [mini.ai](https://github.com/echasnovski/mini.ai)
  - [mini.comment](https://github.com/echasnovski/mini.comment)
  - [mini.diff](https://github.com/echasnovski/mini.diff)
  - [mini.files](https://github.com/echasnovski/mini.files)
  - [mini.git](https://github.com/echasnovski/mini.git)
  - [mini.hipatterns](https://github.com/echasnovski/mini.hipatterns)
  - [mini.icons](https://github.com/echasnovski/mini.icons)
  - [mini.jump2d](https://github.com/echasnovski/mini.jump2d)
  - [mini.jump](https://github.com/echasnovski/mini.jump)
  - [mini.pairs](https://github.com/echasnovski/mini.pairs)
  - [mini.sessions](https://github.com/echasnovski/mini.sessions)
  <!-- - [mini.statusline](https://github.com/echasnovski/mini.statusline) -->
  - [mini.surround](https://github.com/echasnovski/mini.surround)
  - [mini.tabline](https://github.com/echasnovski/mini.tabline)
- [folke/snacks.nvim](https://dotfyle.com/plugins/folke/snacks.nvim)

## Installed Language Servers, Formatters, and Linters

| Language Server         | Linter  | Formatter    |
| ----------------------- | ------- | ------------ |
| arduino-language-server | ruff    | beautysh     |
| bashls                  | verible | latexindent  |
| clangd                  |         | markdown-toc |
| cmake                   |         | prettier     |
| ltex                    |         | ruff         |
| lua_ls                  |         | rustfmt      |
| marksman                |         | shfmt        |
| pyright                 |         | stylua       |
| ruff                    |         | verible      |
| rust_analyzer           |         | yamlfmt      |
| svlangserver            |         |              |
| verible                 |         |              |
| vhdl_ls                 |         |              |

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

- [saghen/blink.cmp](https://dotfyle.com/plugins/Saghen/blink.cmp)
  - [mikavilpas/blink-ripgrep.nvim](https://dotfyle.com/plugins/mikavilpas/blink-ripgrep.nvim)

### colorscheme

- [bluz71/vim-moonfly-colors](https://dotfyle.com/plugins/bluz71/vim-moonfly-colors)
- [catppuccin/nvim](https://dotfyle.com/plugins/catppuccin/nvim)
- [dgox16/oldworld.nvim](https://dotfyle.com/plugins/dgox16/oldworld.nvim)
- [folke/tokyonight.nvim](https://dotfyle.com/plugins/folke/tokyonight.nvim)
- [projekt0n/github-nvim-theme](https://dotfyle.com/plugins/projekt0n/github-nvim-theme)

### comment

- [folke/todo-comments.nvim](https://dotfyle.com/plugins/folke/todo-comments.nvim)

### editing-enhancements

- [AndrewRadev/switch.vim](https://github.com/AndrewRadev/switch.vim)

### formatting

- [stevearc/conform.nvim](https://dotfyle.com/plugins/stevearc/conform.nvim)

### file explorer

- [stevearc/oil.nvim](https://dotfyle.com/plugins/stevearc/oil.nvim)

### game

- [ThePrimeagen/vim-be-good](https://dotfyle.com/plugins/ThePrimeagen/vim-be-good)

### keybinding

- [folke/which-key.nvim](https://dotfyle.com/plugins/folke/which-key.nvim)

### lsp

- [mfussenegger/nvim-lint](https://dotfyle.com/plugins/mfussenegger/nvim-lint)
- [neovim/nvim-lspconfig](https://dotfyle.com/plugins/neovim/nvim-lspconfig)
- [stevearc/conform.nvim](https://dotfyle.com/plugins/stevearc/conform.nvim)

### lsp-installer

- [williamboman/mason.nvim](https://dotfyle.com/plugins/williamboman/mason.nvim)
  - [williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)
  - [WhoIsSethDaniel/mason-tool-installer.nvim](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim)

### markdown-and-latex

- [MeanderingProgrammer/render-markdown.nvim](https://dotfyle.com/plugins/MeanderingProgrammer/render-markdown.nvim)
- [iamcco/markdown-preview.nvim](https://dotfyle.com/plugins/iamcco/markdown-preview.nvim)

### nvim-dev

- [nvim-lua/plenary.nvim](https://dotfyle.com/plugins/nvim-lua/plenary.nvim)
- [folke/lazydev.nvim](https://dotfyle.com/plugins/folke/lazydev.nvim)
- [Bilal2453/luvit-meta](https://github.com/Bilal2453/luvit-meta)

### plugin-manager

- [folke/lazy.nvim](https://dotfyle.com/plugins/folke/lazy.nvim)

### snippet

- [rafamadriz/friendly-snippets](https://dotfyle.com/plugins/rafamadriz/friendly-snippets)

### split-and-window

- [mrjones2014/smart-splits.nvim](https://dotfyle.com/plugins/mrjones2014/smart-splits.nvim)

### syntax

- [fladson/vim-kitty](https://github.com/fladson/vim-kitty)
- [mtdl9/vim-log-highlighting](https://github.com/mtdl9/vim-log-highlighting)
- [nvim-treesitter/nvim-treesitter](https://dotfyle.com/plugins/nvim-treesitter/nvim-treesitter)

### utility

- [echasnovski/mini.nvim](https://dotfyle.com/plugins/echasnovski/mini.nvim)
  - [mini.ai](https://dotfyle.com/plugins/echasnovski/mini.ai)
  - [mini.comment](https://dotfyle.com/plugins/echasnovski/mini.comment)
  - [mini.diff](https://dotfyle.com/plugins/echasnovski/mini.diff)
  - [mini.hipatterns](https://dotfyle.com/plugins/echasnovski/mini.hipatterns)
  - [mini.icons](https://dotfyle.com/plugins/echasnovski/mini.icons)
  - [mini.jump2d](https://dotfyle.com/plugins/echasnovski/mini.jump2d)
  - [mini.jump](https://dotfyle.com/plugins/echasnovski/mini.jump)
  - [mini.pairs](https://dotfyle.com/plugins/echasnovski/mini.pairs)
  - [mini.sessions](https://dotfyle.com/plugins/echasnovski/mini.sessions)
  - [mini.statusline](https://dotfyle.com/plugins/echasnovski/mini.statusline)
  - [mini.surround](https://dotfyle.com/plugins/echasnovski/mini.surround)
  - [mini.tabline](https://dotfyle.com/plugins/echasnovski/mini.tabline)
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
| rust_analyzer           |         |              |
| svlangserver            |         |              |
| verible                 |         |              |
| vhdl_ls                 |         |              |

---

> This readme was generated by [Dotfyle](https://dotfyle.com)
> For plugins not listed on Dotfyle, links will point directly to their respective GitHub repositories.

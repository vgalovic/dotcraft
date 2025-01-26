"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"               ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
"               ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
"               ██║   ██║██║██╔████╔██║██████╔╝██║
"               ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║
"                ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"                 ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable syntax highlighting
syntax on

" Disable compatibility with old versions of Vim
set nocompatible

" Enable filetype detection and plugins
filetype on
filetype plugin on
filetype indent on

" Set file format and encoding
set fileformat=unix
set encoding=UTF-8

" Set indentation options
set expandtab        " Use spaces instead of tabs
set tabstop=4        " Number of spaces for a tab
set softtabstop=4    " Number of spaces for a soft tab
set shiftwidth=4     " Indentation width

" Disable backup and swap files
set nobackup
set noswapfile

" Line numbers and cursor settings
set number          " Show line numbers
set relativenumber  " Show relative line numbers

" Configure fillchars (e.g., no end-of-buffer marker)
set fillchars+=eob:\ 

" Scrolling settings
set scrolloff=10    " Keep 10 lines above and below the cursor
set nowrap          " Disable line wrapping

" Search settings
set incsearch       " Incremental search
set ignorecase      " Case-insensitive searching
set smartcase       " Use case-sensitive searching if a capital letter is used

" Command and mode settings
set showcmd         " Show command in the status line
set showmode        " Show current mode (insert, normal, etc.)
set showmatch       " Highlight matching parentheses/brackets

" Search highlighting and history
set hlsearch        " Highlight search results
set history=1000    " Keep a history of 1000 commands

" Enable mouse mode
set mouse=a

" Set background color
set background=dark

" Clipboard settings (sync clipboard with OS)
set clipboard=unnamedplus

" Enable break indent
set breakindent

" Save undo history
set undofile

" Keep signcolumn always visible
set signcolumn=yes

" Performance settings
set updatetime=250  " Faster update time
set timeoutlen=300  " Shorter wait time for mapped sequences

" Split window behavior
set splitright       " Split windows open to the right
set splitbelow       " Split windows open below

" Configure whitespace display
set list
set listchars=tab:»\ ,trail:·,nbsp:␣

" Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

" Enable statusline
set laststatus=2
set statusline=%f\ %y\ %m\ %r\ %=%l/%L\ %c\ %p%%

" Leader key settings
let mapleader = " "         " Leader key: space
let maplocalleader = " "    " Local leader key: space

" Enables ";" to call command
nnoremap ; :

" When Serbian keyboard is used
nnoremap č :
nnoremap Č :

" Set navigation keys
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

noremap <c-up> <c-w>+
noremap <c-down> <c-w>-
noremap <c-left> <c-w>>
noremap <c-right> <c-w><

nnoremap <M-j> :bprevious<CR>
nnoremap <M-k> :bnext<CR>
nnoremap <M-s> :b#<CR>
nnoremap <M-q> :bd<CR>

nnoremap <leader>v <C-w>v
nnoremap <leader>h <C-w>s

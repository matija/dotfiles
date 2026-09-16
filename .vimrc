set nocompatible
syntax on
filetype plugin indent on

set termguicolors
set background=dark
colorscheme polar-aurora

set clipboard^=unnamedplus,unnamed
set encoding=utf-8
set nobackup nowritebackup noswapfile
set undofile undodir=~/.vim/undo
set hlsearch ignorecase smartcase
set mouse=a
set expandtab shiftwidth=2 tabstop=2 softtabstop=2 shiftround autoindent smartindent
set number relativenumber numberwidth=2
set cursorline nowrap
set scrolloff=8 sidescrolloff=8
set splitbelow splitright
set timeoutlen=500 updatetime=50
set laststatus=0
set lazyredraw

let mapleader = " "
let maplocalleader = " "
nnoremap <Space> <Nop>

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

nnoremap <S-l> :bnext<CR>
nnoremap <S-h> :bprevious<CR>

inoremap jk <ESC>
inoremap jj <ESC>

vnoremap < <gv
vnoremap > >gv

nnoremap x "_x
nnoremap <leader>p "_dP
nnoremap <leader>h :nohl<CR>
nnoremap <leader>w :w!<CR>
nnoremap <leader>q :q!<CR>
nnoremap <leader>c :bprevious<bar>bdelete #<CR>

let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 25
nnoremap <leader>e :Lexplore<CR>

nnoremap <leader>f :find *
nnoremap <leader>bf :buffers<CR>:buffer<Space>
set path+=**
set wildmenu

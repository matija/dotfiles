set nocompatible
filetype on
syntax on
filetype indent on
filetype plugin on

colorscheme monokai
set guifont=Fira\ Code:h12
set antialias
set background=dark
set clipboard^=unnamedplus,unnamed
" let g:syntastic_ruby_exec = '/Users/matija/.rbenv/versions/2.3.4/bin/ruby'
"let g:syntastic_ruby_mri_exec = '/Users/matija/.rbenv/versions/2.3.4/bin/ruby'
"let g:syntastic_check_on_wq = 0
"let g:syntastic_check_on_open = 0
"let g:syntastic_ruby_checkers=['mri', 'rubocop']
"let g:indent_guides_enable_on_vim_startup = 1
"let g:airline_theme='spacevim'
set wrap
set shiftwidth=2
set tabstop=2
set expandtab
set softtabstop=2
set shiftround
set autoindent
set laststatus=2
set guioptions-=L
set number
set cursorline
set lazyredraw

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'dkprice/vim-easygrep'
Plugin 'junegunn/fzf.vim'
"Plugin 'scrooloose/syntastic'
"Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
"Plugin 'wincent/command-t'
"Plugin 'tpope/vim-rails'
Plugin 'vim-ruby/vim-ruby'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'nathanaelkane/vim-indent-guides'
call vundle#end()

set rtp+=/usr/local/opt/fzf

"autocmd vimenter * NERDTree

"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" start nerdtree when vim is launched with folder as arg
autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif


nmap ; :Buffers<CR>
nmap <Leader>t :Files<CR>
nmap <Leader>r :Tags<CR>
"nmap <Leader>sc :SyntasticCheck<CR>


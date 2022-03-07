if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

set backspace=indent,eol,start

set incsearch
set hlsearch
set ignorecase

set number

" Indentation
set smartindent
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab

silent! nmap <Tab> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" vim-plug stuffs
" auto install vim plug if not exists
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'altercation/vim-colors-solarized'
Plug 'elzr/vim-json'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'kien/ctrlp.vim'
Plug 'rust-lang/rust.vim'

call plug#end()

syntax enable
set background=dark
"colorscheme solarized

set wildignore+=*/node_modules/*,*/.git/*,*.so,*.swp,*.zip,*.exe,*.dll
set wildignore+=*\\tmp\\*,*.swo,.cabal-sandbox,\#*\#
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn|node_modules|dist)$'
" ctrlp don't open files in plugins/other windows
let g:ctrlp_dont_split = 'NERD\|help\|quickfix'

" Cursor shape to vertical bar while in insert mode
let &t_SI = "\<Esc>[5 q"
let &t_EI = "\<Esc>[0 q"

" Eliminates delay when pressing <ESC> in Insert mode to go to normal mode
set ttimeoutlen=0

" show groovy syntax highlighting for Jenkinsfile
au BufNewFile,BufRead Jenkinsfile setf groovy

" press jk instead of Esc to exit insert mode
:imap jk <Esc>

nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" I found out what leader is
:let mapleader = " "

:map <Leader>o o<Esc>k
:map <Leader>O O<Esc>j

" change js require to import
:map <Leader>im 0cwimport<Esc>f=ct'from <Esc>f)x
" change js import to require
:map <Leader>re 0cwconst<Esc>/from<CR>ct'= require(<Esc>f'f'a)<Esc>


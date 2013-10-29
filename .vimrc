execute pathogen#infect()
call pathogen#helptags()
filetype plugin indent on

runtime! debian.vim

syntax on

set background=dark

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

if has("autocmd")
  filetype plugin indent on
endif

set showcmd        " Show (partial) command in status line.
set showmatch      " Show matching brackets.
set ignorecase     " Do case insensitive matching
set smartcase      " Do smart case matching
set incsearch      " Incremental search
set autowrite      " Automatically save before commands like :next and :make
set hidden             " Hide buffers when they are abandoned
set mouse=a        " Enable mouse usage (all modes)

if filereadable("/etc/vim/vimrc.local")
  source /etc/vim/vimrc.local
endif

autocmd FileType python set tabstop=4|set shiftwidth=2|set expandtab
autocmd FileType ruby set tabstop=2|set shiftwidth=2|set expandtab

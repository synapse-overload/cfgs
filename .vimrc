" In order for this configuration to work we need powerline fonts
" I retrieved mine from https://github.com/powerline/fonts
" and I'm using DejaVu Sans Mono in my putty configuration so that
" I can get the right > characters in the expressed tabline.
set nocompatible              " be iMproved, required
set termguicolors
call plug#begin()
	"Multi-entry selection UI.
	Plug 'junegunn/fzf'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'Valloric/YouCompleteMe'
	Plug 'sheerun/vim-polyglot'
	Plug 'phanviet/vim-monokai-pro'
call plug#end() 
filetype plugin indent on    " required
set number
"highlight ColorColumn ctermbg=darkgray
colorscheme monokai_pro
"addsource ~/.vim/BufOnly.vim
"let g:ycm_show_diagnostics_ui = 0
set nowrap
"let g:ycm_confirm_extra_conf = 0
"nmap <silent> <F2> :YcmCompleter GoToDeclaration <CR>
nmap <silent> <F12> :YcmCompleter GoToDefinitionElseDeclaration<CR>
set wildmenu wildmode=full
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
set ruler
set backspace=eol,start,indent
set incsearch
" Don't redraw while executing macros (good performance config)
set lazyredraw 
" " For regular expressions turn magic on
set magic
" " Show matching brackets when text indicator is over them
" set showmatch 
" " How many tenths of a second to blink when matching brackets
set mat=2
" " No annoying sound on errors
set noerrorbells
set novisualbell
syntax enable
set smarttab
" "1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
" """""""""""""""""""""""""""""""""""""""""""""""""
" "=> Manual Status line if you don't like airline
" """"""""""""""""""""""""""""""""""""""""""""""""
" " Always show the status line
"set laststatus=2
" " Format the status line
"set statusline=\ F%m%r%h\ %w\ \ FILE:\ %F%h\ \ CWD:\ %r%{getcwd()}\ \ Line:\
" %l\ \ Column:\ %c
" " Remaps for insert mode home row
" might not work so great it's been a while since I used them
" inoremap <C-k> <C-o>gk
" inoremap <C-h> <Left>
" inoremap <C-l> <Right>
" inoremap <C-j> <C-o>gj
" inoremap <C-E> <C-o>$
" inoremap <C-A> <C-o>^
set hlsearch
set ic
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'
let g:airline_powerline_fonts = 1
let g:airline_theme='angr'
let g:deoplete#enable_at_startup = 1
let g:ycm_clangd_uses_ycmd_caching = 0
let g:ycm_clangd_binary_path = exepath("clangd")
let g:ycm_add_preview_to_completeopt=0
let g:ycm_autoclose_preview_window_after_insertion = 1
set completeopt-=preview
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1

set nocompatible
set termguicolors
call plug#begin()
	"Multi-entry selection UI
	Plug 'junegunn/fzf'
	Plug 'sheerun/vim-polyglot'
	Plug 'phanviet/vim-monokai-pro'
	Plug 'preservim/tagbar'
	Plug 'scrooloose/nerdtree'
	Plug 'kien/ctrlp.vim'
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()
set number
colorscheme onedark
set nowrap
set incsearch
set magic
set novisualbell
set shiftwidth=4
set tabstop=4
set hlsearch
set ic
set completeopt-=preview
set wildmenu
let g:airline_powerline_fonts = 1
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1
let g:airline_theme='base16_flat'
let g:airline#extensions#tabline#enabled = 1 " Enable the list of buffers
let g:airline#extensions#tabline#fnamemod = ':t' " Show just the filename
set hidden
let mapleader = ","
" ------- Buffer Management ---------
" move to next buffer
nmap <leader>l :bnext<CR>
" move to previous buffer
nmap <leader>h :bprevious<CR>
" delete buffer and move to previous
nmap <leader>q :bp <BAR> bd #<CR>
" list buffers
nmap <leader>bl :ls<CR>


" ctrl-p
let g:ctrlp_custom_ignore = {
  \ 'dir': '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg)$',
\}

" Use the nearest .git|.svn|.hg|.bzr directory as the cwd
let g:ctrlp_working_path_mode = 'r'
nmap <leader>p :CtrlP<cr>  " enter file search mode

" Nerdtree
" autocmd vimenter * NERDTree
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <C-n> :NERDTreeToggle<CR>  " open and close file tree
nmap <leader>n :NERDTreeFind<CR>  " open current buffer in file tree

" YouCompleteMe ----------------------------------------------------------------------------------------------------
"
" nmap <silent> <F12> :YcmCompleter GoToDefinitionElseDeclaration<CR>
" let g:ycm_semantic_triggers =  {
"   \   'c' : ['->', '.'],
"   \   'objc' : ['->', '.'],
"   \   'cpp,objcpp' : ['->', '.', '::'],
"   \   'perl' : ['->'],
"   \ }
" 
" let g:ycm_complete_in_comments_and_strings=1
" let g:ycm_key_list_select_completion=['<C-n>', '<Down>']
" let g:ycm_key_list_previous_completion=['<C-p>', '<Up>']
" let g:ycm_autoclose_preview_window_after_completion = 1
" 
" "let g:ycm_global_ycm_extra_conf = '<path/to/your/ycm_extra_conf'
" 
" "set completeopt-=preview
" let g:ycm_auto_hover=''
" nmap <silent> <leader>d <plug>(YCMHover)
" " let g:ycm_disable_signature_help=1
" "let g:ycm_add_preview_to_completeopt = 1
" let g:ycm_show_diagnostics_ui = 0
" let g:airline#extensions#tagbar#flags = 'f'
" let g:airline#extensions#whitespace#enabled = 0
" let g:ycm_language_server =
"   \ [{
"   \   'name': 'ccls',
"   \   'cmdline': [ 'ccls' ],
"   \   'filetypes': [ 'c',  'cc', 'h', 'hxx', 'hpp', 'cxx', 'cpp', 'cuda', 'objc', 'objcpp' ],
"   \   'project_root_files': [ '.ccls-root', 'compile_commands.json' ]
"   \ }]
"
"
" End YouComepleteMe -----------------------------------------------------------------------------------------------
" ------------------------------------------------------------------------------------------------------------------
" Taken from [iandling.io](https://ianding.io/2019/07/29/configure-coc-nvim-for-c-c++-development/)
" COC.VIM
" if hidden is not set, TextEdit might fail.
set hidden

" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" ------------------------------------------------------------------------------------------------------------------

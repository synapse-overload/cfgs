set nocompatible
set termguicolors
call plug#begin()
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'junegunn/fzf'
	Plug 'sheerun/vim-polyglot'
	Plug 'phanviet/vim-monokai-pro'
	Plug 'preservim/tagbar'
	Plug 'scrooloose/nerdtree'
	Plug 'airblade/vim-rooter'
	Plug 'ctrlpvim/ctrlp.vim'
	Plug 'ycm-core/YouCompleteMe'
	Plug 'ddrscott/vim-side-search'
	Plug 'will133/vim-dirdiff'
	Plug 'rhysd/vim-clang-format'
  Plug 'sainnhe/sonokai'
	Plug 'bfrg/vim-cpp-modern'
  Plug 'NLKNguyen/papercolor-theme'
call plug#end()
set noea
set number
"colorscheme onedark
set nowrap
set incsearch
set magic
set novisualbell
"set shiftwidth=4
"set tabstop=4
set hlsearch
set ic
set completeopt-=preview
set wildmenu
set background=dark
if has('termguicolors')
  set termguicolors
endif

" The configuration options should be placed before `colorscheme sonokai`.
"let g:sonokai_style = 'andromeda'
"let g:sonokai_better_performance = 1
"let g:sonokai_transparent_background = 1
"let g:sonokai_diagnostic_text_highlight = 1
"colorscheme sonokai
" Fix the separator line cause it was really annoying to not see it
hi VertSplit guifg=#5c6773
let g:airline_powerline_fonts = 1
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1
let g:airline_theme='sonokai'
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
  \ 'file': '\v\.(mod|ko|o|d|exe|so|dll|class|png|jpg|jpeg)$',
\}

" Use the nearest .git|.svn|.hg|.bzr directory as the cwd
let g:ctrlp_working_path_mode = 'r'
let g:ctrlp_root_markers = ['pom.xml', '.git', 'Makefile', 'compile_commands.json', '.svn' ]
nmap <leader>p :CtrlP<cr>  " enter file search mode

" Nerdtree
" autocmd vimenter * NERDTree
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map <C-n> :NERDTreeToggle<CR>  " open and close file tree
nmap <leader>n :NERDTreeFind<CR>  " open current buffer in file tree

" YouCompleteMe ----------------------------------------------------------------------------------------------------
 nmap <leader>yfw <Plug>(YCMFindSymbolInWorkspace)
 nmap <leader>yfd <Plug>(YCMFindSymbolInDocument)
 nmap <leader>ygr :YcmCompleter GoToReferences<CR>
 nmap <silent> <F12> :YcmCompleter GoToDefinitionElseDeclaration<CR>
 nmap <silent> <C-F11> :YcmCompleter GoToReferences<CR>

 let g:ycm_semantic_triggers =  {
   \   'c' : ['->', '.'],
   \   'objc' : ['->', '.'],
   \   'cpp,objcpp' : ['->', '.', '::'],
   \   'perl' : ['->'],
   \ }
 
 let g:ycm_complete_in_comments_and_strings=1
 let g:ycm_key_list_select_completion=['<C-n>', '<Down>']
 let g:ycm_key_list_previous_completion=['<C-p>', '<Up>']
 let g:ycm_autoclose_preview_window_after_completion = 1
 
 "let g:ycm_global_ycm_extra_conf = '<path/to/your/ycm_extra_conf'
 
 "set completeopt-=preview
 let g:ycm_auto_hover=''
 nmap <silent> <leader>d <plug>(YCMHover)
 " let g:ycm_disable_signature_help=1
 "let g:ycm_add_preview_to_completeopt = 1
 let g:ycm_show_diagnostics_ui = 0
 let g:airline#extensions#tagbar#flags = 'f'
 let g:airline#extensions#whitespace#enabled = 0
" let g:ycm_language_server =
"   \ [{
"   \   'name': 'ccls',
"   \   'cmdline': [ 'ccls' ],
"   \   'filetypes': [ 'c',  'cc', 'h', 'hxx', 'hpp', 'cxx', 'cpp', 'cuda', 'objc', 'objcpp' ],
"   \   'project_root_files': [ '.ccls-root', 'compile_commands.json' ]
"   \ }]


" End YouComepleteMe -----------------------------------------------------------------------------------------------
" ------------------------------------------------------------------------------------------------------------------
" Taken from [iandling.io](https://ianding.io/2019/07/29/configure-coc-nvim-for-c-c++-development/)
" COC.VIM
" if hidden is not set, TextEdit might fail.
" set hidden
" 
" " Some servers have issues with backup files, see #649
" set nobackup
" set nowritebackup
" 
" " Better display for messages
" set cmdheight=2
" 
" " You will have bad experience for diagnostic messages when it's default 4000.
" set updatetime=300
" 
" " don't give |ins-completion-menu| messages.
" set shortmess+=c
" 
" " always show signcolumns
" set signcolumn=yes
" 
" " Use tab for trigger completion with characters ahead and navigate.
" " Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ coc#refresh()
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
" 
" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~# '\s'
" endfunction
" 
" " Use <c-space> to trigger completion.
" inoremap <silent><expr> <c-space> coc#refresh()
" 
" " Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" " Coc only does snippet and additional edit on confirm.
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" 
" " Use `[c` and `]c` to navigate diagnostics
" nmap <silent> [c <Plug>(coc-diagnostic-prev)
" nmap <silent> ]c <Plug>(coc-diagnostic-next)
" 
" " Remap keys for gotos
" nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
" nmap <silent> gr <Plug>(coc-references)
" 
" " Use K to show documentation in preview window
" nnoremap <silent> K :call <SID>show_documentation()<CR>
" 
" function! s:show_documentation()
"   if (index(['vim','help'], &filetype) >= 0)
"     execute 'h '.expand('<cword>')
"   else
"     call CocAction('doHover')
"   endif
" endfunction
" 
" " Highlight symbol under cursor on CursorHold
" autocmd CursorHold * silent call CocActionAsync('highlight')
" 
" " Remap for rename current word
" nmap <leader>rn <Plug>(coc-rename)
" 
" " Remap for format selected region
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)
" 
" augroup mygroup
"   autocmd!
"   " Setup formatexpr specified filetype(s).
"   autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
"   " Update signature help on jump placeholder
"   autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" augroup end
" 
" " Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
" xmap <leader>a  <Plug>(coc-codeaction-selected)
" nmap <leader>a  <Plug>(coc-codeaction-selected)
" 
" " Remap for do codeAction of current line
" nmap <leader>ac  <Plug>(coc-codeaction)
" " Fix autofix problem of current line
" nmap <leader>qf  <Plug>(coc-fix-current)
" 
" " Use <tab> for select selections ranges, needs server support, like: coc-tsserver, coc-python
" "nmap <silent> <TAB> <Plug>(coc-range-select)
" "xmap <silent> <TAB> <Plug>(coc-range-select)
" "xmap <silent> <S-TAB> <Plug>(coc-range-select-backword)
" 
" " Use `:Format` to format current buffer
" command! -nargs=0 Format :call CocAction('format')
" 
" " Use `:Fold` to fold current buffer
" command! -nargs=? Fold :call     CocAction('fold', <f-args>)
" 
" " use `:OR` for organize import of current buffer
" command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')
" 
" " Add status line support, for integration with other plugin, checkout `:h coc-status`
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
" 
" " Using CocList
" " Show all diagnostics
" nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" " Manage extensions
" nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" " Show commands
" nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" " Find symbol of current document
" nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" " Search workspace symbols
" nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" " Do default action for next item.
" nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item.
" nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list
" nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" 
" ------------------------------------------------------------------------------------------------------------------

" How should we execute the search?
" --heading and --stats are required!
let g:side_search_prg = 'rg --word-regexp'
  \. " --no-ignore"
  \. " --no-config"
  \. " --glob='\\\!*tags'"
  \. " --glob='\\\!*\.ccls-cache*'"
  \. " --glob='\\\!*\.cache*'"
  \. " --glob='\\\!*\Changelog*'"
  \. " --heading --stats -B 3 -A 3"
  \. " --line-number"
  \. " -tc -tcpp -tasm -tcmake -tmake -tamake -tmeson -tsh"
  "\. " --case-sensitive"

" Can use `vnew` or `new`
let g:side_search_splitter = 'vnew'

" I like 40% splits, change it if you don't
let g:side_search_split_pct = 0.35
"au BufReadPost quickfix setlocal modifiable
"au FileType qf wincmd L | vertical resize 55

" SideSearch current word and return to original window
"nnoremap <Leader>ss :SideSearch <C-r><C-w><CR> | vert resize 80 | wincmd p
nnoremap <Leader>ss :SideSearch <C-r><C-w><CR>

" Create an shorter `SS` command
command! -complete=file -nargs=+ SS execute 'SideSearch <args>'

" or command abbreviation
cabbrev SS SideSearch
"set makeprg=cmake\ --build\ build\ -j\ 9
set makeprg=/home/razvan/.vim_cmake_build.sh
"let g:ycm_server_keep_logfiles = 1
"let g:ycm_server_log_level = 'debug'
"let g:termdebug_config = { 'wide':150 , 'use_prompt': 1 }
au User TermdebugStartPost vertical resize 50
let g:termdebug_wide=1
" to disable the annoying sidesearch close when in termdebug
set noequalalways
let g:ctrlp_match_window = 'min:4,max:999'
let g:ctrlp_use_caching = 1

" clang-format stuff
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
" Toggle auto formatting:
nmap <Leader>C :ClangFormatAutoToggle<CR>
let g:rooter_patterns = [ 'compile_commands.json', '.git', "Makefile" ]
let g:cpp_attributes_highlight=1
let g:cpp_member_highlight=1
let g:cpp_function_highlight=1


" FOR LIGHT COLORSCHEMES
set background=light
" PaperColor theme
let g:PaperColor_Theme_Options = {
  \   'language': {
  \     'python': {
  \       'highlight_builtins' : 1
  \     },
  \     'cpp': {
  \       'highlight_standard_library': 1
  \     },
  \     'c': {
  \       'highlight_builtins' : 1
  \     }
  \   },
  \   'theme': {
  \     'default.light': {
  \       'transparent_background': 1
  \     }
  \   }
  \ }
colorscheme PaperColor

" Redirect command output of vim to new buffer, usage: Redir <command>
" [source](https://vi.stackexchange.com/a/8379)
command! -nargs=+ -complete=command Redir let s:reg = @@ | redir @"> | silent execute <q-args> | redir END | new | pu | 1,2d_ | let @@ = s:reg
